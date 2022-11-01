.global _start
_start:

.equ SW_MEMORY, 0xFF200040
.equ LED_MEMORY, 0xFF200000
.equ HEX4_HEX5, 0xFF200030
.equ HEX0_HEX3, 0xFF200020
.equ PUSH_BUTTON, 0xFF200050
.equ INTERRUPTMASK_REGISTER, 0xFF200058
.equ EDGECAPTURE_REGISTER, 0xFF20005C


main:
	BL read_PB_edgecp_ASM //see which hex we must display to
	BL read_slider_switches_ASM //see what value we must display
	BL write_LEDs_ASM //turn on the LEDs from sliders
	CMP R1,#0x200 //see if slider switch 9 has been pressed
	PUSH {R0} //save our R0 value
	MOVGE R0,#63 //move this value to R0, in order to clear every hex
	BLGE HEX_clear_ASM //branch and link to clear display
	MOVLT R0,#48 //if we are not clearing, then we flood the first two hex
	BLLT HEX_flood_ASM
	POP {R0}
	BL HEX_write_ASM //now we go into write 
	BL PB_clear_edgecp_ASM //we clear the push buttons
	B main

//given code in lab instructions 
read_slider_switches_ASM:
	PUSH {R8,LR}
    LDR R8, =SW_MEMORY
    LDR R1, [R8]
	POP {R8,LR}
    BX  LR

//given code in lab instructions 
write_LEDs_ASM:
	PUSH {R9,LR}
    LDR R9, =LED_MEMORY
    STR R1, [R9]
	POP {R9,LR}
    BX  LR

@using bit clear to turn everything on the hex to 0 
HEX_clear_ASM:
	PUSH {R1,R2,R3,LR}
	LDR R1,=HEX0_HEX3
	LDR R3, =HEX4_HEX5
	TST R0,#1
	LDRNEB R2, [R1]
	BICNE R2,R2,#0xFF
	STRNEB R2,[R1]
	TST R0,#2
	LDRNEB R2, [R1,#1]
	BICNE R2,R2,#0xFF
	STRNEB R2,[R1,#1]
	TST R0,#4
	LDRNEB R2, [R1,#2]
	BICNE R2,R2,#0xFF
	STRNEB R2,[R1,#2]
	TST R0,#8
	LDRNEB R2,[R1,#3]
	BICNE R2,R2,#0xFF
	STRNEB R2,[R1,#3]
	TST R0,#16
	LDRNEB R2,[R3]
	BICNE R2,R2,#0XFF
	STRNEB R2,[R3]
	TST R0,#32
	LDRNEB R2,[R3,#1]
	BICNE R2,R2,#0xFF
	STRNEB R2, [R3,#1]
	POP {R1,R2,R3,LR}
	BX LR

@moving all 1s in order to flood display
HEX_flood_ASM: 
	PUSH {R1,R2,R3,LR}
	LDR R1, =HEX4_HEX5
	LDR R2, =HEX0_HEX3
	LDR R3, =0xFF
	TST R0,#1
	STRNEB R3,[R2]
	TST R0,#2
	STRNEB R3,[R2,#1]
	TST R0,#4
	STRNEB R3,[R2,#2]
	TST R0,#8
	STRNEB R3,[R2,#3]
	TST R0,#16
	STRNEB R3,[R1]
	TST R0,#32
	STRNEB R3,[R1,#1]
	POP {R1,R2,R3,LR}
	BX LR
@in this subroutine, we implement our write
@after we figure out which hex we must write, we branch to our loop subroutine
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
	
@we check which value must be written on the display
@based on the value, we store the corresponding value into the display
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

@read which push button has been pressed
read_PB_data_ASM:
	PUSH {R7,LR}
	LDR R7, =PUSH_BUTTON
    LDR R0, [R7]
	POP {R7,LR}
    BX  LR
	
@read which push button has been declicked	
read_PB_edgecp_ASM:
	PUSH {R7, LR}
	LDR R7, =EDGECAPTURE_REGISTER
	LDR R0, [R7]
	POP {R7,LR}
	BX LR
	
@clearing the edgecapture for push button
PB_clear_edgecp_ASM:
	PUSH {R7,LR}
	LDR R7, =EDGECAPTURE_REGISTER
	STR R0, [R7]
	POP {R7,LR}
	BX LR
	
@enable pushbutton, this will be used in part 3
enable_PB_INT_ASM:
	PUSH {R7,R8,LR}
	LDR R7, =INTERRUPTMASK_REGISTER
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
@disable the pushbutton interrupt
disable_PB_INT_ASM:
	PUSH {R7,R8,LR}
	LDR R7, =INTERRUPTMASK_REGISTER
	TST R0,#1
	BICNE R8,R0,#1
	STRNEB R8, [R7]
	TST R0,#2
	BICNE R8,R0,#1
	STRNEB R8,[R7,#1]
	TST R0,#4
	BICNE R8,R0,#1
	STRNEB R8,[R7,#2]
	TST R0,#8
	BICNE R8,R0,#1
	STRNEB R8,[R7,#3]
	POP {R7,R8,LR}
	BX LR

	