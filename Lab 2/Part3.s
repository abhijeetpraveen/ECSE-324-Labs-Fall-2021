.section .vectors, "ax"
B _start
B SERVICE_UND       // undefined instruction vector
B SERVICE_SVC       // software interrupt vector
B SERVICE_ABT_INST  // aborted prefetch vector
B SERVICE_ABT_DATA  // aborted data vector
.word 0 // unused vector
B SERVICE_IRQ       // IRQ interrupt vector
B SERVICE_FIQ       // FIQ interrupt vector

.text
.global _start
PB_int_flag : .word 0x0
tim_int_flag :.word 0x0

_start:
    /* Set up stack pointers for IRQ and SVC processor modes */
    MOV        R1, #0b11010010      // interrupts masked, MODE = IRQ
    MSR        CPSR_c, R1           // change to IRQ mode
    LDR        SP, =0xFFFFFFFF - 3  // set IRQ stack to A9 onchip memory
    /* Change to SVC (supervisor) mode with interrupts disabled */
    MOV        R1, #0b11010011      // interrupts masked, MODE = SVC
    MSR        CPSR, R1             // change to supervisor mode
    LDR        SP, =0x3FFFFFFF - 3  // set SVC stack to top of DDR3 memory
    BL     CONFIG_GIC           // configure the ARM GIC
    // To DO: write to the pushbutton KEY interrupt mask register
    // Or, you can call enable_PB_INT_ASM subroutine from previous task
    // to enable interrupt for ARM A9 private timer, use ARM_TIM_config_ASM subroutine
    LDR        R0, =0xFF200050      // pushbutton KEY base address
    MOV        R1, #0xF             // set interrupt mask bits
    STR        R1, [R0, #0x8]       // interrupt mask register (base + 8)
    // enable IRQ interrupts in the processor
    MOV        R0, #0b01010011      // IRQ unmasked, MODE = SVC
    MSR        CPSR_c, R0
	LDR        R0,=#2000000
	BL         ARM_TIM_config_ASM
	MOV        R0,#0x7
	BL         enable_PB_INT_ASM
IDLE:
	PUSH {R5,LR}
	MOV R5,#0
	BL isolating_bits
stop_stopwatch:
	LDR R0,=PB_int_flag
	LDR R0,[R0]
	CMP R0,#1
	BEQ start_stopwatch
	CMP R0,#4
	BEQ reset_stopwatch
	B stop_stopwatch
	

start_stopwatch:
	PUSH {R6,LR}
	LDR R0,=PB_int_flag
	LDR R0,[R0]
	CMP R0,#2
	BEQ stop_stopwatch
	CMP R0,#4
	BEQ reset_stopwatch
	LDR R4,=tim_int_flag
	LDR R2,[R4]
	MOV R3,#0
	STR R3,[R4]
	CMP R2,#1
	POP {R6,LR}
	BLT start_stopwatch
	PUSH {R6,LR}
	ADDEQ R5,R5,#1
	AND R6,R5,#0xF
	CMP R6,#9
	ADDGT R5,#6
	AND R6,R5,#0xF0
	CMP R6,#0x90
	ADDGT R5,#96
	AND R6,R5,#0xF00
	CMP R6,#0x900
	ADDGT R5,#1536
	AND R6,R5,#0xF000
	CMP R6,#0x5000
	ADDGT R5,#40960
	AND R6,R5,#0xF0000
	CMP R6,#0x90000
	ADDGT R5,#0x60000
	AND R6,R5,#0xF00000
	CMP R6,#0x500000
	MOVGT R5,#0
	BL isolating_bits
	POP {R6,LR}
	B start_stopwatch

reset_stopwatch:
	MOV R5, #0
	MOV R0,#1
	BL isolating_bits
	B stop_stopwatch

isolating_bits:
	PUSH {R0,R1,LR}
	AND R1,R5,#0xF
	MOV R0,#1
	BL HEX_write_ASM
	AND R1,R5,#0xF0
	LSR R1,#4
	MOV R0,#2
	BL HEX_write_ASM
	AND R1,R5,#0xF00
	LSR R1,#8
	MOV R0,#4
	BL HEX_write_ASM
	AND R1,R5,#0xF000
	LSR R1,#12
	MOV R0,#8
	BL HEX_write_ASM
	AND R1,R5,#0xF0000
	LSR R1,#16
	MOV R0,#16
	BL HEX_write_ASM
	AND R1,R5,#0xF00000
	LSR R1,#20
	MOV R0,#32
	BL HEX_write_ASM
	POP {R0,R1,LR}
	BX LR
	
HEX_write_ASM:
	PUSH {R2,R3,LR}
	LDR R2, =0xFF200020
	LDR R3,=0xFF200030 
	TST R0,#1
	BLNE Loop
	TST R0,#2
	ADDNE R2,R2,#1
	BLNE Loop
	TST R0,#2
	SUBNE R2,R2,#1
	TST R0,#4
	ADDNE R2,R2,#2
	BLNE Loop
	TST R0,#4
	SUBNE R2,R2,#2
	TST R0,#8
	ADDNE R2,R2,#3
	BLNE Loop
	TST R0,#8
	SUBNE R2,R2,#3
	TST R0,#16
	MOVNE R2,R3
	BLNE Loop
	TST R0,#32
	ADDNE R3,R3,#1
	MOVNE R2,R3
	BLNE Loop
	POP {R2,R3,LR}
	BX LR
	
Loop:
	PUSH {R2,R4,LR}
	CMP R1,#0
	MOVEQ R4,#0x3F
	STREQB R4,[R2]
	CMP R1,#1
	MOVEQ R4,#0x6
	STREQB R4,[R2]
	CMP R1,#2
	MOVEQ R4,#0x5B
	STREQB R4,[R2]
	CMP R1,#3
	MOVEQ R4,#0x4F
	STREQB R4,[R2]
	CMP R1,#4
	MOVEQ R4,#0x66
	STREQB R4,[R2]
	CMP R1,#5
	MOVEQ R4,#0x6D
	STREQB R4,[R2]
	CMP R1,#6
	MOVEQ R4,#0x7D
	STREQB R4,[R2]
	CMP R1,#7
	MOVEQ R4,#0x07
	STREQB R4,[R2]
	CMP R1,#8
	MOVEQ R4,#0x7F
	STREQB R4,[R2]
	CMP R1,#9
	MOVEQ R4,#0x6F
	STREQB R4,[R2]
	CMP R1,#10
	MOVEQ R4,#0x77
	STREQB R4,[R2]
	CMP R1,#11
	MOVEQ R4,#0x7c
	STREQB R4,[R2]
	CMP R1,#12
	MOVEQ R4,#0x39
	STREQB R4,[R2]
	CMP R1,#13
	MOVEQ R4,#0x5E
	STREQB R4,[R2]
	CMP R1,#14
	MOVEQ R4,#0x79
	STREQB R4,[R2]
	CMP R1,#15
	MOVEQ R4,#0x71
	STREQB R4,[R2]
	POP {R2,R4,LR}
	BX LR
	POP {R5,LR}
	BX LR
	B IDLE


/*--- Undefined instructions ---------------------------------------- */
SERVICE_UND:
    B SERVICE_UND
/*--- Software interrupts ------------------------------------------- */
SERVICE_SVC:
    B SERVICE_SVC
/*--- Aborted data reads -------------------------------------------- */
SERVICE_ABT_DATA:
    B SERVICE_ABT_DATA
/*--- Aborted instruction fetch ------------------------------------- */
SERVICE_ABT_INST:
    B SERVICE_ABT_INST
/*--- IRQ ----------------------------------------------------------- */
SERVICE_IRQ:
    PUSH {R0-R7, LR}
/* Read the ICCIAR from the CPU Interface */
    LDR R4, =0xFFFEC100
    LDR R5, [R4, #0x0C] // read from ICCIAR

/* To Do: Check which interrupt has occurred (check interrupt IDs)
   Then call the corresponding ISR
   If the ID is not recognized, branch to UNEXPECTED
   See the assembly example provided in the De1-SoC Computer_Manual on page 46 */
Pushbutton_check:
    CMP R5, #73
	BLEQ KEY_ISR
Timer_check:
	CMP R5, #29
	BLEQ ARM_TIM_ISR
UNEXPECTED:
	CMP R5, #29
	CMPNE R5, #73
    BNE UNEXPECTED      // if not recognized, stop here
EXIT_IRQ:
/* Write to the End of Interrupt Register (ICCEOIR) */
    STR R5, [R4, #0x10] // write to ICCEOIR
    POP {R0-R7, LR}
SUBS PC, LR, #4
/*--- FIQ ----------------------------------------------------------- */
SERVICE_FIQ:
    B SERVICE_FIQ

CONFIG_GIC:
    PUSH {LR}
/* To configure the FPGA KEYS interrupt (ID 73):
* 1. set the target to cpu0 in the ICDIPTRn register
* 2. enable the interrupt in the ICDISERn register */
/* CONFIG_INTERRUPT (int_ID (R0), CPU_target (R1)); */
/* To Do: you can configure different interrupts
   by passing their IDs to R0 and repeating the next 3 lines */
    MOV R0, #73            // KEY port (Interrupt ID = 73)
    MOV R1, #1             // this field is a bit-mask; bit 0 targets cpu0
    BL CONFIG_INTERRUPT
	
	MOV R0, #29            // Timer port (Interrupt ID = 29)       
    MOV R1, #1          
    BL CONFIG_INTERRUPT
	
	

/* configure the GIC CPU Interface */
    LDR R0, =0xFFFEC100    // base address of CPU Interface
/* Set Interrupt Priority Mask Register (ICCPMR) */
    LDR R1, =0xFFFF        // enable interrupts of all priorities levels
    STR R1, [R0, #0x04]
/* Set the enable bit in the CPU Interface Control Register (ICCICR).
* This allows interrupts to be forwarded to the CPU(s) */
    MOV R1, #1
    STR R1, [R0]
/* Set the enable bit in the Distributor Control Register (ICDDCR).
* This enables forwarding of interrupts to the CPU Interface(s) */
    LDR R0, =0xFFFED000
    STR R1, [R0]
    POP {PC}

/*
* Configure registers in the GIC for an individual Interrupt ID
* We configure only the Interrupt Set Enable Registers (ICDISERn) and
* Interrupt Processor Target Registers (ICDIPTRn). The default (reset)
* values are used for other registers in the GIC
* Arguments: R0 = Interrupt ID, N
* R1 = CPU target
*/
CONFIG_INTERRUPT:
    PUSH {R4-R5, LR}
/* Configure Interrupt Set-Enable Registers (ICDISERn).
* reg_offset = (integer_div(N / 32) * 4
* value = 1 << (N mod 32) */
    LSR R4, R0, #3    // calculate reg_offset
    BIC R4, R4, #3    // R4 = reg_offset
    LDR R2, =0xFFFED100
    ADD R4, R2, R4    // R4 = address of ICDISER
    AND R2, R0, #0x1F // N mod 32
    MOV R5, #1        // enable
    LSL R2, R5, R2    // R2 = value
/* Using the register address in R4 and the value in R2 set the
* correct bit in the GIC register */
    LDR R3, [R4]      // read current register value
    ORR R3, R3, R2    // set the enable bit
    STR R3, [R4]      // store the new register value
/* Configure Interrupt Processor Targets Register (ICDIPTRn)
* reg_offset = integer_div(N / 4) * 4
* index = N mod 4 */
    BIC R4, R0, #3    // R4 = reg_offset
    LDR R2, =0xFFFED800
    ADD R4, R2, R4    // R4 = word address of ICDIPTR
    AND R2, R0, #0x3  // N mod 4
    ADD R4, R2, R4    // R4 = byte address in ICDIPTR
/* Using register address in R4 and the value in R2 write to
* (only) the appropriate byte */
    STRB R1, [R4]
    POP {R4-R5, PC}
	
KEY_ISR:
   PUSH {R0,R1,LR}
   BL read_PB_edgecp_ASM
   LDR R1,=PB_int_flag
   STR R0,[R1]
   BL PB_clear_edgecp_ASM
   POP {R0,R1,LR}
END_KEY_ISR:
    BX LR
ARM_TIM_ISR:
	PUSH {R1,R2,LR}
	BL ARM_TIM_read_INT_ASM
	LDR R1,=tim_int_flag
	STR R2,[R1]
	BL ARM_TIM_clear_INT_ASM
	POP {R1,R2,LR}
END_ARM_TIM_ISR:
	BX LR

ARM_TIM_config_ASM:
	PUSH {R2-R3,LR}
	LDR R2,=0xFFFEC600
	STR R0,[R2]
	LDR R3,=0xFFFEC608
	LDR R1,=0x7
	STRB R1,[R3]
	POP {R2-R3, LR}
	BX LR
enable_PB_INT_ASM:
	PUSH {R7,R8,LR}
	LDR R7, =0xFF200058
	TST R0,#1
	ORRNE R8,R0,#1
	STRNEB R8, [R7]
	TST R0,#2
	ORRNE R8,R0,#1
	STRNEB R8,[R7,#1]
	TST R0,#4
	ORRNE R8,R0,#1
	STRNEB R8,[R7,#2]
	TST R0,#8
	ORRNE R8,R0,#1
	STRNEB R8,[R7,#3]
	POP {R7,R8,LR}
	BX LR

read_PB_edgecp_ASM:
	PUSH {R7, LR}
	LDR R7,=0xFF20005C
	LDR R0, [R7]
	POP {R7,LR}
	BX LR
	
PB_clear_edgecp_ASM:
	PUSH {R7,LR}
	LDR R7, =0xFF20005C
	STR R0, [R7]
	POP {R7,LR}
	BX LR
	
ARM_TIM_read_INT_ASM: 
	PUSH {R4,LR}
	LDR R4,=0xFFFEC60C
	LDR R2,[R4]
	POP {R4,LR}
	BX LR
	
ARM_TIM_clear_INT_ASM:
	PUSH {R2,R4,LR}
	LDR R4,=0xFFFEC60C
	STR R2,[R4]
	POP {R2,R4,LR}
	BX LR

	