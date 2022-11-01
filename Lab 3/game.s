.global _start
key_pressed: .word 0
check_block_placed: .word 0
pattern1: .word 21
pattern2: .word 1344
pattern3: .word 86016
pattern4: .word 4161
pattern5: .word 16644
pattern6: .word 66576
pattern7: .word 65793
pattern8: .word 4368
_start:
BL VGA_clear_charbuff_ASM
BL VGA_clear_pixelbuff_ASM
BL draw_grid_ASM
main:
LDR R0,=key_pressed
MOV R1,#0
STR R1,[R0]
LDR R0,=check_block_placed
MOV R1,#0
STR R1,[R0]

CHECK_FOR_INPUT:
	LDR R0,=key_pressed
	BL read_PS2_data_ASM
	CMP R0,#1
	BNE CHECK_FOR_INPUT
	LDR R0,=key_pressed
	LDR R0,[R0]
	CMP R0,#0x45
	BNE CHECK_FOR_INPUT
	BL VGA_clear_pixelbuff_ASM
	BL draw_grid_ASM
	LDR R0,=key_pressed
	BL read_PS2_data_ASM
	LDR R0,=key_pressed
	BL read_PS2_data_ASM
game:
	MOV R5,#49
	BL WRITE_PLAYER_TURN
	BL CHECK_PLAYER_1_PLACEMENT
	CMP R0,#0x45
	BEQ main
	BL CHECK_PLAYER_1_WIN
	CMP R2,#1
	BEQ main
	BL CHECK_DRAW
	CMP R0,#1
	BEQ main
	MOV R5,#50
	BL WRITE_PLAYER_TURN
	BL CHECK_PLAYER_2_PLACEMENT
	CMP R0,#0x45
	BEQ main
	BL CHECK_PLAYER_2_WIN
	CMP R2,#1
	BEQ main
	B game
	
	

CHECK_DRAW:
	PUSH {R1,LR}
	LDR R0,=check_block_placed
	LDR R0,[R0]
	AND R1,R0,#0b11
	CMP R1,#0
	BEQ NOT_DRAWN
	AND R1,R0,#0b1100
	CMP R1,#0
	BEQ NOT_DRAWN
	AND R1,R0,#0b110000
	CMP R1,#0
	BEQ NOT_DRAWN
	AND R1,R0,#0b11000000
	CMP R1,#0
	BEQ NOT_DRAWN
	AND R1,R0,#0b1100000000
	CMP R1,#0
	BEQ NOT_DRAWN
	AND R1,R0,#0b110000000000
	CMP R1,#0
	BEQ NOT_DRAWN
	AND R1,R0,#0b11000000000000
	CMP R1,#0
	BEQ NOT_DRAWN
	AND R1,R0,#0b1100000000000000
	CMP R1,#0
	BEQ NOT_DRAWN
	AND R1,R0,#0b110000000000000000
	CMP R1,#0
	BEQ NOT_DRAWN
	BL WRITE_DRAW_RESULT
	MOV R0,#1
	POP {R1,LR}
	BX LR
NOT_DRAWN:
	MOV R0,#0
	POP {R1,LR}
	BX LR
	
	
CHECK_PLAYER_1_PLACEMENT:
	PUSH {R0,R1,LR}
	LDR R0,=key_pressed
	BL read_PS2_data_ASM
	CMP R0,#1
	POPNE {R0,R1,LR}
	BNE CHECK_PLAYER_1_PLACEMENT
	LDR R0,=key_pressed
	LDR R0,[R0]
	CMP R0,#0x45
	POPEQ {R0,R1,LR}
	BEQ main
	CMP R0,#0x16
	BLEQ draw_plus_first_grid_ASM
	CMP R0,#0x1E
	BLEQ draw_plus_second_grid_ASM
	CMP R0,#0x26
	BLEQ draw_plus_third_grid_ASM
	CMP R0,#0x25
	BLEQ draw_plus_fourth_grid_ASM
	CMP R0,#0x2E
	BLEQ draw_plus_fifth_grid_ASM
	CMP R0,#0x36
	BLEQ draw_plus_sixth_grid_ASM
	CMP R0,#0x3d
	BLEQ draw_plus_seventh_grid_ASM
	CMP R0,#0x3e
	BLEQ draw_plus_eighth_grid_ASM
	CMP R0,#0x46
	BLEQ draw_plus_ninth_grid_ASM
	CMP R0,#1
	POPNE {R0,R1,LR}
	BNE CHECK_PLAYER_1_PLACEMENT
	POP {R0,R1,LR}
	BX LR

CHECK_PLAYER_1_WIN:
	PUSH {R1,LR}
	MOV R5,#49
	MOV R2,#0
	LDR R0,=check_block_placed
	LDR R0,[R0]
	LDR R1,=pattern1
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern2
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern3
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern4
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern5
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern6
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern7
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern8
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	POP {R1,LR}
	BX LR


CHECK_PLAYER_2_PLACEMENT:
	PUSH {R0,R1,LR}
	LDR R0,=key_pressed
	BL read_PS2_data_ASM
	CMP R0,#1
	POPNE {R0,R1,LR}
	BNE CHECK_PLAYER_2_PLACEMENT
	LDR R0,=key_pressed
	LDR R0,[R0]
	CMP R0,#0x45
	POPEQ {R0,R1,LR}
	BEQ main
	CMP R0,#0x16
	BLEQ draw_square_first_grid_ASM
	CMP R0,#0x1E
	BLEQ draw_square_second_grid_ASM
	CMP R0,#0x26
	BLEQ draw_square_third_grid_ASM
	CMP R0,#0x25
	BLEQ draw_square_fourth_grid_ASM
	CMP R0,#0x2E
	BLEQ draw_square_fifth_grid_ASM
	CMP R0,#0x36
	BLEQ draw_square_sixth_grid_ASM
	CMP R0,#0x3d
	BLEQ draw_square_seventh_grid_ASM
	CMP R0,#0x3e
	BLEQ draw_square_eighth_grid_ASM
	CMP R0,#0x46
	BLEQ draw_square_ninth_grid_ASM
	CMP R0,#1
	POPNE {R0,R1,LR}
	BNE CHECK_PLAYER_2_PLACEMENT
	POP {R0,R1,LR}
	BX LR
	
CHECK_PLAYER_2_WIN:
	PUSH {R0,R1,LR}
	MOV R5,#50
	MOV R2,#0
	LDR R0,=check_block_placed
	LDR R0,[R0]
	LSR R0,#1
	LDR R1,=pattern1
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern2
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern3
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern4
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern5
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern6
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern7
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	LDR R1,=pattern8
	LDR R1,[R1]
	AND R3,R0,R1
	CMP R3,R1
	BLEQ WRITE_PLAYER_WIN
	CMP R3,R1
	MOVEQ R2,#1
	POP {R0,R1,LR}
	BX LR
	
read_PS2_data_ASM:
	PUSH {R1,R2,LR}
	LDR R1,=0xFF200100
	LDR R1,[R1]
	LSR R2,R1,#15
	AND R2,#1
	CMP R2,#1
	AND R1,R1,#0xFF
	STREQ R1,[R0]
	MOVEQ R0,#1
	MOVNE R0,#0
	POP {R1,R2,LR}
	BX LR	

WRITE_PLAYER_TURN:
	PUSH {R0,R1,R2,LR}
	BL VGA_clear_charbuff_ASM
	MOV R0,#33
	MOV R1,#1
	MOV R2,#80
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#108
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#97
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#121
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#101
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#114
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#32
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,R5
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#39
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#115
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#32
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#116
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#117
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#114
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#110
	BL VGA_write_char_ASM
	POP {R0,R1,R2,LR}
	BX LR


WRITE_PLAYER_WIN:
	PUSH {R0,R1,R2,LR}
	BL VGA_clear_charbuff_ASM
	MOV R0,#33
	MOV R1,#1
	MOV R2,#80
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#108
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#97
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#121
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#101
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#114
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#32
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,R5
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#32
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#119
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#105
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#110
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#115
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#33
	BL VGA_write_char_ASM
	POP {R0,R1,R2,LR}
	BX LR

WRITE_DRAW_RESULT:
	PUSH {R0,R1,R2,LR}
	BL VGA_clear_charbuff_ASM
	MOV R0,#34
	MOV R1,#1
	MOV R2,#73
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#116
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#39
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#115
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#32
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#97
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#32
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#68
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#114
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#97
	BL VGA_write_char_ASM
	ADD R0,#1
	MOV R2,#119
	BL VGA_write_char_ASM
	POP {R0,R1,R2,LR}
	BX LR
	
draw_grid_ASM:
		PUSH {R0-R3,R11,LR}
	    ldr     r11, .colors
        mov     r3, #207
        mov     r2, #2
        mov     r1, #16
        mov     r0, #125
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #207
        mov     r2, #2
        mov     r1, #16
        mov     r0, #194
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #2
        mov     r2, #207
        mov     r1, #85
        mov     r0, #56
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #2
        mov     r2, #207
        mov     r1, #154
        mov     r0, #56
        bl      draw_rectangle
		POP {R0-R3,R11, LR}
		BX LR

draw_square_first_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b11
		CMP R1,#0
		MOVNE R0,#0
		BNE end_square_first_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b10
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #35
        mov     r1, #33
        mov     r0, #73
        bl      draw_rectangle
		ldr     r11, .colors+4
        mov     r3, #33
        mov     r2, #33
        mov     r1, #34
        mov     r0, #74
        bl      draw_rectangle
		MOV R0,#1
end_square_first_grid:
		POP {R1-R3,R11, LR}
		BX LR

draw_square_second_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b1100
		CMP R1,#0
		MOVNE R0,#0
		BNE end_square_second_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b1000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #35
        mov     r1, #33
        mov     r0, #142
        bl      draw_rectangle
		ldr     r11, .colors+4
        mov     r3, #33
        mov     r2, #33
        mov     r1, #34
        mov     r0, #143
        bl      draw_rectangle
		MOV R0,#1
end_square_second_grid:
		POP {R1-R3,R11, LR}
		BX LR

draw_square_third_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b110000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_square_third_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b100000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #35
        mov     r1, #33
        mov     r0, #211
        bl      draw_rectangle
		ldr     r11, .colors+4
        mov     r3, #33
        mov     r2, #33
        mov     r1, #34
        mov     r0, #212
        bl      draw_rectangle
		MOV R0,#1
end_square_third_grid:
		POP {R1-R3,R11, LR}
		BX LR

draw_square_fourth_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b11000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_square_fourth_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b10000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #35
        mov     r1, #102
        mov     r0, #73
        bl      draw_rectangle
		ldr     r11, .colors+4
        mov     r3, #33
        mov     r2, #33
        mov     r1, #103
        mov     r0, #74
        bl      draw_rectangle
		MOV R0,#1
end_square_fourth_grid:
		POP {R1-R3,R11, LR}
		BX LR

draw_square_fifth_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b1100000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_square_fifth_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b1000000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #35
        mov     r1, #102
        mov     r0, #142
        bl      draw_rectangle
		ldr     r11, .colors+4
        mov     r3, #33
        mov     r2, #33
        mov     r1, #103
        mov     r0, #143
        bl      draw_rectangle
		MOV R0,#1
end_square_fifth_grid:
		POP {R1-R3,R11, LR}
		BX LR
		
draw_square_sixth_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b110000000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_square_sixth_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b100000000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #35
        mov     r1, #102
        mov     r0, #211
        bl      draw_rectangle
		ldr     r11, .colors+4
        mov     r3, #33
        mov     r2, #33
        mov     r1, #103
        mov     r0, #212
        bl      draw_rectangle
		MOV R0,#1
end_square_sixth_grid:
		POP {R1-R3,R11, LR}
		BX LR

draw_square_seventh_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b11000000000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_square_seventh_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b10000000000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #35
        mov     r1, #171
        mov     r0, #73
        bl      draw_rectangle
		ldr     r11, .colors+4
        mov     r3, #33
        mov     r2, #33
        mov     r1, #172
        mov     r0, #74
        bl      draw_rectangle
		MOV R0,#1
end_square_seventh_grid:
		POP {R1-R3,R11, LR}
		BX LR

draw_square_eighth_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b1100000000000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_square_eighth_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b1000000000000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #35
        mov     r1, #171
        mov     r0, #142
        bl      draw_rectangle
		ldr     r11, .colors+4
        mov     r3, #33
        mov     r2, #33
        mov     r1, #172
        mov     r0, #143
        bl      draw_rectangle
		MOV R0,#1
end_square_eighth_grid:
		POP {R1-R3,R11, LR}
		BX LR

draw_square_ninth_grid_ASM:
		PUSH {R1-R3,R11,LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b110000000000000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_square_ninth_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b100000000000000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #35
        mov     r1, #171
        mov     r0, #211
        bl      draw_rectangle
		ldr     r11, .colors+4
        mov     r3, #33
        mov     r2, #33
        mov     r1, #172
        mov     r0, #212
        bl      draw_rectangle
		MOV R0,#1
end_square_ninth_grid:
		POP {R1-R3,R11, LR}
		BX LR
		
draw_plus_first_grid_ASM:
		PUSH {R1-R3,R11,LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b11
		CMP R1,#0
		MOVNE R0,#0
		BNE end_plus_first_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#1
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #2
        mov     r1, #33
        mov     r0, #91
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #2
        mov     r2, #35
        mov     r1, #51
        mov     r0, #73
        bl      draw_rectangle
		MOV R0,#1
end_plus_first_grid:
		POP {R1-R3,R11, LR}
		BX LR

draw_plus_second_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b1100
		CMP R1,#0
		MOVNE R0,#0
		BNE end_plus_second_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b100
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #2
        mov     r1, #33
        mov     r0, #160
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #2
        mov     r2, #35
        mov     r1, #51
        mov     r0, #142
        bl      draw_rectangle
		MOV R0,#1
end_plus_second_grid:
		POP {R1-R3,R11, LR}
		BX LR
		
draw_plus_third_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b110000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_plus_third_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b10000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #2
        mov     r1, #33
        mov     r0, #229
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #2
        mov     r2, #35
        mov     r1, #51
        mov     r0, #211
        bl      draw_rectangle
		MOV R0,#1
end_plus_third_grid:
		POP {R1-R3,R11, LR}
		BX LR

draw_plus_fourth_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b11000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_plus_fourth_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b1000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #2
        mov     r1, #102
        mov     r0, #91
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #2
        mov     r2, #35
        mov     r1, #120
        mov     r0, #73
        bl      draw_rectangle
		MOV R0,#1
end_plus_fourth_grid:
		POP {R1-R3,R11, LR}
		BX LR

draw_plus_fifth_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b1100000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_plus_fifth_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b100000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #2
        mov     r1, #102
        mov     r0, #160
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #2
        mov     r2, #35
        mov     r1, #120
        mov     r0, #142
        bl      draw_rectangle
		MOV R0,#1
end_plus_fifth_grid:
		POP {R1-R3,R11, LR}
		BX LR

draw_plus_sixth_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b110000000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_plus_sixth_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b10000000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #2
        mov     r1, #102
        mov     r0, #229
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #2
        mov     r2, #35
        mov     r1, #120
        mov     r0, #211
        bl      draw_rectangle
		MOV R0,#1
end_plus_sixth_grid:
		POP {R1-R3,R11, LR}
		BX LR
	
draw_plus_seventh_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b11000000000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_plus_sixth_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b1000000000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #2
        mov     r1, #171
        mov     r0, #91
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #2
        mov     r2, #35
        mov     r1, #189
        mov     r0, #73
        bl      draw_rectangle
		MOV R0,#1
end_plus_seventh_grid:
		POP {R1-R3,R11, LR}
		BX LR
		
draw_plus_eighth_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b1100000000000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_plus_eighth_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b100000000000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #2
        mov     r1, #171
        mov     r0, #160
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #2
        mov     r2, #35
        mov     r1, #189
        mov     r0, #142
        bl      draw_rectangle
		MOV R0,#1
end_plus_eighth_grid:
		POP {R1-R3,R11, LR}
		BX LR

		
draw_plus_ninth_grid_ASM:
		PUSH {R1-R3,R11, LR}
		LDR R1,=check_block_placed
		LDR R1,[R1]
		AND R1,#0b110000000000000000
		CMP R1,#0
		MOVNE R0,#0
		BNE end_plus_ninth_grid
		LDR R1,=check_block_placed
		LDR R1,[R1]
		ORR R1,#0b10000000000000000
		LDR R2,=check_block_placed
		STR R1,[R2]
		ldr     r11, .colors
        mov     r3, #35
        mov     r2, #2
        mov     r1, #171
        mov     r0, #229
        bl      draw_rectangle
		ldr     r11, .colors
        mov     r3, #2
        mov     r2, #35
        mov     r1, #189
        mov     r0, #211
        bl      draw_rectangle
		MOV R0,#1
end_plus_ninth_grid:
		POP {R1-R3,R11, LR}
		BX LR

VGA_draw_point_ASM:
	PUSH {R0,R1,R2,R3,R4,LR}
	CMP R0,#0
	BLT break2
	CMP R0,#320
	BGT break2
	CMP R1,#0
	BLT break2
	CMP R1,#240
	BGT break2
	LDR R3,=0xC8000000 //loading base address
	LSL R0,R0,#1
	LSL R1,R1,#10
	ORR R4,R0,R1
	ORR R3,R3,R4
	STRH R2,[R3]
break2:
	POP {R0,R1,R2,R3,R4,LR}
	BX LR
VGA_clear_pixelbuff_ASM:
	PUSH {R0,R1,R2,LR}
	MOV R0,#0
	MOV R1,#0
	MOV R2,#0
clearing_loop:
	BL VGA_draw_point_ASM
	ADD R0,#1
	CMP R0,#320
	BLT clearing_loop
	ADD R1,#1
	MOV R0,#0
	CMP R1,#240
	BLT clearing_loop
	POP {R0,R1,R2,LR}
	BX LR
	
	
VGA_write_char_ASM:
	PUSH {R0-R4,LR}
	CMP R0,#0
	BLT break
	CMP R0,#80
	BGT break
	CMP R1,#0
	BLT break
	CMP R1,#60
	BGT break
	LDR R3,=0xC9000000 //loading base address
	LSL R1,R1,#7
	ORR R4,R0,R1
	ORR R3,R3,R4
	STRB R2,[R3]
break:
	POP {R0-R4,LR}
	BX LR
	
VGA_clear_charbuff_ASM:
	PUSH {R0-R4,LR}
	MOV R0,#0
	MOV R1,#0
	MOV R2,#0
clearing_loop2:
	BL VGA_write_char_ASM
	ADD R0,#1
	CMP R0,#80
	BLT clearing_loop2
	ADD R1,#1
	MOV R0,#0
	CMP R1,#60
	BLT clearing_loop2
	POP {R0-R4,LR}
	BX LR
	


.colors:
        .word   65535
		.word 	0

draw_rectangle:
        push    {r4, r5, r6, r7, r8, r9, r10, lr}
       	mov 	r7,r11
        add     r9, r1, r3
        cmp     r1, r9
        popge   {r4, r5, r6, r7, r8, r9, r10, pc}
        mov     r8, r0
        mov     r5, r1
        add     r6, r0, r2
        b       .line_L2
.line_L5:
        add     r5, r5, #1
        cmp     r5, r9
        popeq   {r4, r5, r6, r7, r8, r9, r10, pc}
.line_L2:
        cmp     r8, r6
        movlt   r4, r8
        bge     .line_L5
.line_L4:
        mov     r2, r7
        mov     r1, r5
        mov     r0, r4
        bl      VGA_draw_point_ASM
        add     r4, r4, #1
        cmp     r4, r6
        bne     .line_L4
        b       .line_L5