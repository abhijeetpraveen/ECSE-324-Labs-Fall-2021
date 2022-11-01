.global _start
_start:
n:  .word 5  ////this will be the nth value that we wish to find
	mov r0, #0 //first number in the fib sequence
	mov r1, #1 //second number in the fib sequence
	ldr r2, n 
	sub r3,r2,#1
	BL FIB
	B end
//[0,1,1,2,3,5,8,13,21,34,55,89]--> fib sequence of 12 elements
//[0,1,1,2,3,5,8,d,15,22,37,59]--> fib sequence of 12 elements (hex)
	

FIB:
	push {r4,LR} //will be using R4 in this subroutine so we push onto stack
	CMP r2,#0 //if we want the 0th element, we will just return 0
	BEQ ZERO
	CMP r2,#1 //if we want the 1st element, we will return 1
	BEQ return_ONE
LOOP:
	ADD r4, r0, r1 //store sum of two registers into another register
	mov r0,r1      //move the second value into the first register
	mov r1,r4      //move the calculated sum into second register
	SUBS r3,r3,#1  //decrementing the i and setting the condition
	BGT LOOP       //if we have still not reached 0, we loop again
	MOV r0, r4     //move the final fib into r0
	pop {r4,LR}    //pop since we can exit the subroutine 
	BX LR
ZERO: //returning 0 if n=0
	mov r0,#0      //move final fib (0 in this case) into r0
	pop {r4,LR}    //pop since we can exit the subroutine
	BX LR		   
return_ONE: //returning 1 if n=1
	mov r0,#1      //move final fib (1 in this case) into r0
	pop {r4,LR}	   //pop since we can exit the subroutine
	BX LR
	
end:
	B end
	