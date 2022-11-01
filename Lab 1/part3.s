I.global _start
size: .word 5
array: .word -1,23,0,12,-7
output: .space 20
_start:
	ldr r0,=array //the first index of the array initially
	ldr r1,size   //the size argument given as input to the program
	mov r2,#0     //this will be the step we are at, which is 0 at the beginning

	
FIRST_FOR_LOOP:
	sub r3,r1,#1  //represents the final step we iterate to which is size - 1
	CMP r2,r3     //comparing the step we are at to size-1
	BGE end       //if we get greater than, than we exit the loop and end the program
	mov r4,#0    //represents the value of i in the iteration
	
SECOND_FOR_LOOP:
	CMP r4,r3 //comparing i to our step
	BGE increment_step //if we get greater means we have to exit the loop and increment step
	LDR r5, [r0,r4,LSL#2] //getting the value at array index i (r4)
	ADD r6,r4,#1          //add 1 to i to 
	LDR r7, [r0,r6,LSL#2] //getting the value at array index i+1 (r6)
	CMP r5,r7             //compare the two values we see in the array
	BLT increment_i       //if it is less than, then no need to swap and we just increment i
	STR r5, [r0,r6,LSL#2] //if not less than we need to swap the values at the two indexes
	STR r7, [r0,r4,LSL#2] //r5 becomes r7 and vice versa
increment_i: //incrementing the i
	add r4,r4,#1
	B SECOND_FOR_LOOP
increment_step: //incrementing step
	add r2,r2,#1
	B FIRST_FOR_LOOP
end:
	ldr r0,=array //r0 will have the address of our final output array
	B end

	
	
