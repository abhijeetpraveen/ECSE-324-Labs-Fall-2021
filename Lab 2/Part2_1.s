.global _start
_start:

.equ LOAD, 0xFFFEC600
.equ CONTROL, 0xFFFEC608
.equ INTERRUPT_STATUS, 0xFFFEC60C
.equ HEX0_HEX3, 0xFF200020
.equ HEX4_HEX5, 0xFF200030
.equ LED_MEMORY, 0xFF200000

LDR R0, =#200000000 //loading the load value for configuration
MOV R5,#0 //the count value that will be displayed
BL ARM_TIM_config_ASM //now we branch in order to configure the timer

main:
	BL ARM_TIM_read_INT_ASM //read the timer interrupt
	CMP R2,#1
	BLEQ ARM_TIM_clear_INT_ASM //if we read that it is 1, then we clear it
	ADDEQ R5,R5,#1 //add 1 to the display
	CMP R5,#16 //if it has become 16, we must loop back to 0
	MOVEQ R5,#0
	MOV R1,R5 //mov r5 to r1 as r1 is the argument for the write subroutine
	MOV R0,#1 //moving 1 to r0 as we are only using the first hex
	BL HEX_write_ASM //now we branch and link to write
	BL LED_SWITCH
	B main

ARM_TIM_config_ASM: //configuring the timer
	PUSH {R2-R3,LR}
	LDR R2,=LOAD
	STR R0,[R2]
	LDR R3,=CONTROL
	LDR R1,=0x3
	STRB R1,[R3]
	POP {R2-R3, LR}
	BX LR
ARM_TIM_read_INT_ASM: //reading the f bit
	PUSH {R4,LR}
	LDR R4,=INTERRUPT_STATUS
	LDR R2,[R4]
	POP {R4,LR}
	BX LR
ARM_TIM_clear_INT_ASM: //clearing the f bit
	PUSH {R4,LR}
	LDR R4,=INTERRUPT_STATUS
	MOV R2,#0x00000001
	STR R2,[R4]
	POP {R4,LR}
	BX LR
@same driver as previous section
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


@turning on the leds that correspond to the value being displayed
LED_SWITCH:
	PUSH {R8,LR}
    LDR R8, =LED_MEMORY
    STR R5, [R8]
	POP {R8,LR}
    BX  LR
	
	