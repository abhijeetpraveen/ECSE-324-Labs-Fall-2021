.global _start
_start:

.equ LOAD, 0xFFFEC600
.equ CONTROL, 0xFFFEC608
.equ INTERRUPT_STATUS, 0xFFFEC60C
.equ HEX0_HEX3, 0xFF200020
.equ HEX4_HEX5, 0xFF200030 
.equ EDGECAPTURE_REGISTER, 0xFF20005C

LDR R0, =#2000000 //new load value as we increment by 10 miliseconds
MOV R5,#0 //the display value
Bl isolating_bits
BL ARM_TIM_config_ASM
@at the beginning of the program the stopwatch is in stop mode
stop_stopwatch:
	BL read_PB_edgecp_ASM //read the push button edcapture
	BL PB_clear_edgecp_ASM //clear the push button edgecapture 
	CMP R0,#1 //if the first push button is declicked, then we start the stopwatch
	BEQ start_stopwatch
	CMP R0,#4 //if the third pushbutton is declicked, then we reset the stopwatch
	BEQ reset_stopwatch
	B stop_stopwatch //else we stay in stop mode
	

start_stopwatch:
	PUSH {R6,LR}
	BL read_PB_edgecp_ASM //we read the push button edgecapture
	BL PB_clear_edgecp_ASM //we clear the push button edgecapture
	CMP R0,#2 //if the second push button is declicked, we go to stop mode
	BEQ stop_stopwatch
	CMP R0,#4 //if the third pushbutton is declicked, then we reset the stopwatch
	BEQ reset_stopwatch
	@else we stay in start mode
	BL ARM_TIM_read_INT_ASM //read timer interrupt f-bit 
	BL ARM_TIM_clear_INT_ASM //clear timer interrupt f-bit 
	CMP R2,#1 //comparing the f-bit
	POP {R6,LR}
	BLT start_stopwatch //if its less than 1, then we go to beginning of start again
	PUSH {R6,LR}
	ADDEQ R5,R5,#1 //if f is 1, then we increment our display value
	AND R6,R5,#0xF 
	CMP R6,#9 //see if our last bit is 9, if it is then we add 6 to it to make it 16
	ADDGT R5,#6 //we do this because 16 on the hex display, is actually 10
	AND R6,R5,#0xF0 //we're doing the same thing as above for the 2nd hex display and so on below as well
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
	//in order to display the value on the hex
	//we need to isolate the bits from our value register in order 
	//to display them on a corresponding hex
	POP {R6,LR}
	B start_stopwatch

reset_stopwatch:
	MOV R5, #0
	MOV R0,#1
	BL isolating_bits
	B stop_stopwatch

isolating_bits:
	//we use the AND instruction to isolate each bit
	//after they have been isolated, we branch to our driver to write
	//onto the hex
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

//all these drivers below are equivalent to ones in the previous section
ARM_TIM_config_ASM:
	PUSH {R2-R3,LR}
	LDR R2,=LOAD
	STR R0,[R2]
	LDR R3,=CONTROL
	LDR R1,=0x3
	STRB R1,[R3]
	POP {R2-R3, LR}
	BX LR
ARM_TIM_read_INT_ASM: 
	PUSH {R4,LR}
	LDR R4,=INTERRUPT_STATUS
	LDR R2,[R4]
	POP {R4,LR}
	BX LR
ARM_TIM_clear_INT_ASM:
	PUSH {R2,R4,LR}
	LDR R4,=INTERRUPT_STATUS
	STR R2,[R4]
	POP {R2,R4,LR}
	BX LR
HEX_write_ASM:
	PUSH {R2,R3,LR}
	LDR R2, =HEX0_HEX3
	LDR R3,=HEX4_HEX5
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


read_PB_edgecp_ASM:
	PUSH {R7, LR}
	LDR R7, =EDGECAPTURE_REGISTER
	LDR R0, [R7]
	POP {R7,LR}
	BX LR

PB_clear_edgecp_ASM:
	PUSH {R7,LR}
	LDR R7, =EDGECAPTURE_REGISTER
	STR R0, [R7]
	POP {R7,LR}
	BX LR