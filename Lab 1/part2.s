.global _start
gx: .space 400
iw: .word 10
ih: .word 10
kw: .word 5
kh: .word 5
ksw: .word 2
khw: .word 2
fx: .word 183, 207, 128, 30, 109, 0, 14, 52, 15, 210, 228, 76, 48, 82, 179, 194, 22, 168, 58, 116, 228, 217, 180, 181, 243, 65, 24, 127, 216, 118,64, 210, 138, 104, 80, 137, 212, 196, 150, 139, 155, 154, 36, 254, 218, 65, 3, 11, 91, 95, 219, 10, 45, 193, 204, 196, 25, 177, 188, 170, 189, 241, 102, 237, 251, 223, 10, 24, 171, 71, 0, 4, 81, 158, 59, 232, 155, 217, 181, 19, 25, 12, 80, 244, 227, 101, 250, 103, 68, 46, 136, 152, 144, 2, 97, 250, 47, 58, 214, 51
kx: .word 1,   1,  0,  -1,  -1, 0,   1,  0,  -1,   0, 0,   0,  1,   0,   0, 0,  -1,  0,   1,   0, -1, -1,  0,   1,   1

_start:
	mov r0,#0 //the first loop is governed by y, so we initiliaze it to 0
	push {r0} //we push our y variable onto the stack
FIRST_FOR_LOOP:
	LDR r1,ih //going through the first loop we have to compare with ih, so we load it onto a register
	pop {r0} //we need our y-variable for comparison so we pop
	CMP r0,r1 //compare to see if loop ends (y<ih)
	BGE end   //if we see its greater than or equal to, we exit the loop
	push {r0} //now our y variable is saved onto the stack
	mov r0,#0 //we initialize the x variable to 0, as we enter the second for loop
	push {r0} //we push our x variable onto the stack
SECOND_FOR_LOOP: //same structure as first for loop, but we also initialize our sum
	LDR r1,iw //going through the second loop we have to compare with iw, so we load it onto a register
	pop {r0}  //we pop the x variable from our stack since we need it for comparison
	CMP r0,r1 //compare to see if we meet the conditions for the second for loop
	BGE increment_y //if not then we branch to increment_y as that is the outer loop
	push {r0} //then we push x back onto the stack again
	MOV r8,#0 //this represents the sum variable which is set to 0 at the beginning
	mov r0,#0 //now we have to initialize our i for the third for loop
	push {r0} //now we push our i variable onto the stack
THIRD_FOR_LOOP:
	LDR r1,kw //since in this for loop, we compare with kw, we load it into a register
	pop {r0}  //now we can pop our i variable again since we need it for comparison
	CMP r0,r1 //compare to see if the for loop conditions are met 
	BGE increment_x //if not then we branch to increment_x as that is the outer loop for this loop
	push {r0} //now we can push our i back onto the stack again
	mov r0,#0 //this initialzes our j variable for the last for loop
	push {r0} //we push our j variable onto the stack
FOURTH_FOR_LOOP:
	LDR r1,kh//since in this loop, we compare with kh, then we load into a register
	pop {r0} //pop our j variable since we need it for comparison
	CMP r0,r1 //compare to see if the conditions for the last loop is met
	BGE increment_i //if not then we branch to increment_i as that is the outer loop
	pop {r1-r3} //popping our variables i,x,y
	ADD r4,r2,r0 //we are adding x+j and loading into register r4
	ADD r5,r1,r3 //we are adding y+i and loading into register r5
	LDR r6,ksw   //since we need this to compute our temp1, we load it into a register
	LDR r7,khw   //since we need this to compute our temp2, we load it into a register
	SUB r4,r4,r6 //we are performing x+j-ksw, r4 is temp1
	SUB r5,r5,r7 //we are performing y+i-khw, r5 is temp2
	push {r1-r3} //now we can push our variables onto the stack again
	//the next 8 lines represent are the big if statement we see in the code snippet
	CMP R4,#0    
	BLT increment_j
	CMP r4,#9
	BGT increment_j
	CMP r5,#0
	BLT increment_j
	CMP r5,#9
	BGT increment_j
	pop {r1} //we need the i variable so we pop
	LDR r2,kw 
	MLA r2,r0,r2,r1
	LDR r3,=kx //loading the address so we need equals
	LDR r3, [r3, r2, LSL#2]
	LDR r2,iw
	MLA r2,r4,r2,r5
	LDR r6,=fx
	LDR r6, [r6,r2,LSL#2]
	MLA r8,r3,r6,r8 //updating our sum after finishing the calculations
	push {r1} // now we push i back onto the stack
	B increment_j
increment_y://we are taking the y variable and incrementing it
	pop {r0}
	ADD r0,r0,#1
	push {r0}
	B FIRST_FOR_LOOP
increment_x:
	//pop x,y from our stack since we need to do sum = gx[x][y]
	pop {r0,r1}
	LDR r2,iw 
	MLA r2,r0,r2,r1
	LDR r3,=gx
	STR r8, [r3, r2, LSL#2]
	ADD r0,r0,#1 //incrementing the x variable
	push {r0,r1} //push them back
	B SECOND_FOR_LOOP
increment_i://we are taking the i variable an incrementing it
	pop {r0}
	ADD r0,r0,#1
	push {r0}
	B THIRD_FOR_LOOP
increment_j://we are taking the j variable an incrementing it
	ADD r0,r0,#1
	push {r0}
	B FOURTH_FOR_LOOP
	
	

end:
	B end
	
	