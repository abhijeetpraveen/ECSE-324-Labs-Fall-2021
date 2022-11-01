.global _start
_start:
        bl      input_loop
end:
        b       end

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
	

read_PS2_data_ASM:
	PUSH {R1,R2,LR}
	LDR R1,=0xFF200100
	LDR R1,[R1]
	LSR R2,R1,#15
	AND R2,#1
	CMP R2,#1
	STREQB R1,[R0]
	MOVEQ R0,#1
	MOVNE R0,#0
	POP {R1,R2,LR}
	BX LR

write_hex_digit:
        push    {r4, lr}
        cmp     r2, #9
        addhi   r2, r2, #55
        addls   r2, r2, #48
        and     r2, r2, #255
        bl      VGA_write_char_ASM
        pop     {r4, pc}
write_byte:
        push    {r4, r5, r6, lr}
        mov     r5, r0
        mov     r6, r1
        mov     r4, r2
        lsr     r2, r2, #4
        bl      write_hex_digit
        and     r2, r4, #15
        mov     r1, r6
        add     r0, r5, #1
        bl      write_hex_digit
        pop     {r4, r5, r6, pc}
input_loop:
        push    {r4, r5, lr}
        sub     sp, sp, #12
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r4, #0
        mov     r5, r4
        b       .input_loop_L9
.input_loop_L13:
        ldrb    r2, [sp, #7]
        mov     r1, r4
        mov     r0, r5
        bl      write_byte
        add     r5, r5, #3
        cmp     r5, #79
        addgt   r4, r4, #1
        movgt   r5, #0
.input_loop_L8:
        cmp     r4, #59
        bgt     .input_loop_L12
.input_loop_L9:
        add     r0, sp, #7
        bl      read_PS2_data_ASM
        cmp     r0, #0
        beq     .input_loop_L8
        b       .input_loop_L13
.input_loop_L12:
        add     sp, sp, #12
        pop     {r4, r5, pc}

	
	