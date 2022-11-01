.global _start
_start:
n: .word 3

   ldr r0, n
   BL FIB 
   B end 

FIB:
   push {r1,r2,LR} //pushing as many registers we will need
   mov r1, r0      //move the value of n into another register
   CMP r0, #1      //this is the first if statement in the 'c' code
   BLE FIRST_IF  
   sub r0, r1, #1  //if not less than or equal to 1, we calculate FIB(n-1)
   BL FIB          // now recursively calling FIB on n-1
   mov r2 ,r0      //we reach this statement after we have stopped recursively doing n-1
   sub r0, r1, #2  // we now will calculate FIB(n-2)
   BL FIB          //now recursively calling FIB on n-2
   add r0, r2,r0   //now we add our values that we have stored from the previous recursions into r0, which will be added to recursively again
   POP {r1,r2,LR}
   BX LR
FIRST_IF:        
//if we reach this branch, means we are at the end of the recursion, 
//so we pop and exit the subroutine
   POP {r1,r2,LR}
   BX LR
end:
    B end


