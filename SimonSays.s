.data
sequence:  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
count:     .word 20
delay_val: .word 500

red: .word 0xff0000
black: .word 0x000000
blue: .word 0x0000ff
green: .word 0x00ff00
yellow: .word 0xffff00

prompt: .string "Do you want to play again (1 for yes, 0 for no)?\n"
round_str: .string "Round: "
new_line: .string "\n"
win: .string "You Win!"
lose: .string "You Lose!"
score: .string "Your score is: "

# Echancments made: First enhancment is increasing the sequence size. 
# Which is done by increasing the sequence length in the start
# Second enhancment is the delay speed decreases by 30ms after every round
# This is done at the end of stop_loop2 when each round is ended and going
# onto the next one. 

.globl main
.text

main:
    
    # Load the address of the sequence variable into t5
    # Set s11 to 1000 for delay funtion
    la t5 sequence
    li s11 1000
    # Load the address of the count variable into t6
    la t6 count
    lw t2 0(t6)
    
    # Initialize t3 to 0
    li t3 0
    
    # Loop to generate random numbers and store them in sequence array
    seq_loop:
        # Check if we have generated enough random numbers
        beq t3 t2 seq_loop_exit
        
        # Call the rand function to generate a random number
        li a0 4
        jal rand
        
        # Store the random number in the sequence array
        sb a0 0(t5)
        
        # Increment t3 and t5
        addi t3 t3 1
        addi t5 t5 1
        
        # Jump back to the beginning of the loop
        j seq_loop
    
    seq_loop_exit:

    li s10 1
    la t6 count
    lw t4 0(t6)
    
    round:
        bgt s10 t4 stop_round
        la a0 round_str
        li a7 4
        ecall
        
        li a7 1
        mv a0 s10
        ecall
        
        la a0 new_line
        li a7 4
        ecall
        
        la t5 sequence
        li t3 0
    
    replay:
        beq t3 s10 replay_exit
        lb a0 0(t5)   
        mv a4 s11
        # call function
        call setColour 

        addi t5 t5 1
        addi t3 t3 1
    
        j replay
    
    replay_exit:
    
        la t5 sequence
        li t3 0

    loop2:
        beq t3 s10 stop_loop2
        #lb a0 0(t5)
        
        addi sp, sp, -16   
        sw t2 0(sp)              
        sw t3 4(sp)
        sw t5 8(sp)
        sw t6 12(sp)
        
        jal pollDpad
        
        lw t2 0(sp)              
        lw t3 4(sp)
        lw t5 8(sp)
        lw t6 12(sp)
          
        addi sp sp 16
        lb s9 0(t5)
        bne s9 a0 end_game_lose
        
        li s1 0 # Red
        li s2 1 # Blue
        li s3 2 # Yellow
        li s4 3 # Green
    
        # Check for the UP case
        beq a0 s1 UP_correct
    
        # Check for the DOWN case
        beq a0 s2 DOWN_correct
    
        # Check for the LEFT case
        beq a0 s3 LEFT_correct
    
        # Check for the RIGHT case
        beq a0 s4 RIGHT_correct
    
        j end_game_lose
    
    UP_correct:
        addi sp, sp, -16   
        sw t2 0(sp)              
        sw t3 4(sp)
        sw t5 8(sp)
        sw t6 12(sp)
        
        li a4 1000
        jal setColour
        
        lw t2 0(sp)              
        lw t3 4(sp)
        lw t5 8(sp)
        lw t6 12(sp)
          
        addi sp sp 16   
    
        addi t3, t3, 1
        addi t5, t5, 1
        j loop2
    
    DOWN_correct:
        addi sp, sp, -16   
        sw t2 0(sp)              
        sw t3 4(sp)
        sw t5 8(sp)
        sw t6 12(sp)
        
        li a4 1000
        jal setColour
        
        lw t2 0(sp)              
        lw t3 4(sp)
        lw t5 8(sp)
        lw t6 12(sp)
    
        addi t3, t3, 1
        addi t5, t5, 1
        j loop2
    
    LEFT_correct:
        addi sp, sp, -16   
        sw t2 0(sp)              
        sw t3 4(sp)
        sw t5 8(sp)
        sw t6 12(sp)
        
        li a4 1000
        jal setColour
        
        lw t2 0(sp)              
        lw t3 4(sp)
        lw t5 8(sp)
        lw t6 12(sp)
    
        addi t3, t3, 1
        addi t5, t5, 1
        j loop2
    
    RIGHT_correct:
        addi sp, sp, -16   
        sw t2 0(sp)              
        sw t3 4(sp)
        sw t5 8(sp)
        sw t6 12(sp)
        
        li a4 1000
        jal setColour
        
        lw t2 0(sp)              
        lw t3 4(sp)
        lw t5 8(sp)
        lw t6 12(sp)
    
        addi t3, t3, 1
        addi t5, t5, 1
        j loop2

    stop_loop2: 
        addi s10 s10 1
        addi s11 s11 -30
        j round
        
    stop_round:   
    
    end_game_win:
        li a7 4
        la a0 win
        ecall
        
        la a0 new_line
        li a7 4
        ecall
        
        la a0 score
        li a7 4
        ecall
        
        la a0 new_line
        li a7 4
        ecall
        
        la a0 new_line
        li a7 4
        ecall
        
        li a7 1
        mv a0 s10
        ecall
        
        la a0 new_line
        li a7 4
        ecall
        
        la a0 prompt
        li a7 4
        ecall
        
        call readInt
        li t0 0
        li t1 1
        
        beq a0 t0 end_game_complete
        beq a0 t1 main
    
        li a7 10
        ecall
        
    end_game_lose:
        li a7 4
        la a0 lose
        ecall
        
        la a0 new_line
        li a7 4
        ecall
        
        la a0 score
        li a7 4
        ecall
        
        la a0 new_line
        li a7 4
        ecall
        
        li a7 1
        mv a0 s10
        ecall
        
        la a0 new_line
        li a7 4
        ecall
        
        la a0 prompt
        li a7 4
        ecall
        
        call readInt
        li t0 0
        li t1 1
        
        beq a0 t0 end_game_complete
        beq a0 t1 main
    
        li a7 10
        ecall
        
end_game_complete:
     li a7 10
     ecall
    
    
#Helper Functions

setColour:
    # Turns on the LED passed on in register a0
    
    li s1 0 # Red
    li s2 1 # Blue
    li s3 2 # Yellow
    li s4 3 # Green
    
    # Check for the UP case
    beq a0 s1 UP
    
    # Check for the DOWN case
    beq a0 s2 DOWN
    
    # Check for the LEFT case
    beq a0 s3 LEFT
    
    # Check for the RIGHT case
    beq a0 s4 RIGHT
    
    # If none of the cases matched, return without doing anything
    jr ra

UP:
    li a1 0
    li a2 0
    
    mv tp a0

    addi sp sp -4
    sw ra (0)sp 
    
    lw a0 red
    jal setLED

    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp 
    
    lw a0 delay_val 
    jal delay

    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp 
    
    li a1 0
    li a2 0

    lw a0 black
    jal setLED

    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp 

    mv a0 a4
    jal delay

    lw ra (0)sp
    addi sp sp 4
    
    mv a0 tp

    jr ra

DOWN: 
    li a1 1
    li a2 1
    
    mv tp a0

    addi sp sp -4
    sw ra (0)sp

    lw a0 blue
    jal setLED

    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp 

    lw a0 delay_val 
    jal delay

    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp 
    
    li a1 1
    li a2 1

    lw a0 black
    jal setLED

    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp 

    mv a0 a4 
    jal delay

    lw ra (0)sp
    addi sp sp 4
    
    mv a0 tp

    jr ra

LEFT:
    li a1 0
    li a2 1
    
    mv tp a0

    addi sp sp -4
    sw ra (0)sp

    lw a0 green
    jal setLED

    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp 

    lw a0 delay_val 
    jal delay

    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp 
    
    li a1 0
    li a2 1

    lw a0 black
    jal setLED

    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp 

    mv a0 a4
    jal delay

    lw ra (0)sp
    addi sp sp 4
    
    mv a0 tp

    jr ra

RIGHT:
    li a1 1
    li a2 0
    
    mv tp a0

    addi sp sp -4
    sw ra (0)sp

    lw a0 yellow
    jal setLED
    
    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp 

    lw a0 delay_val
    jal delay

    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp
    
    li a1 1
    li a2 0 

    lw a0 black
    jal setLED

    lw ra (0)sp
    addi sp sp 4
    
    addi sp sp -4
    sw ra (0)sp 

    mv a0 a4 
    jal delay

    lw ra (0)sp
    addi sp sp 4
    
    mv a0 tp

    jr ra

     
# Takes in the number of milliseconds to wait (in a0) before returning
delay:
    mv t0, a0
    li a7, 30
    ecall
    mv t1, a0
delayLoop:
    ecall
    sub t2, a0, t1
    bgez t2, delayIfEnd
    addi t2, t2, -1
delayIfEnd:
    bltu t2, t0, delayLoop
    jr ra

# Takes in a number in a0, and returns a (sort of) random number from 0 to
# 4 (exclusive)
rand:
    mv t0, a0
    li a7, 30
    ecall
    remu a0, a0, t0
    jr ra
    
# Takes in an RGB color in a0, an x-coordinate in a1, and a y-coordinate
# in a2. Then it sets the led at (x, y) to the given color.
setLED:
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
    
# Polls the d-pad input until a button is pressed, then returns a number
# representing the button that was pressed in a0.
# The possible return values are:
# 0: UP
# 1: DOWN
# 2: LEFT
# 3: RIGHT
pollDpad:
    mv a0, zero
    li t1, 4
pollLoop:
    bge a0, t1, pollLoopEnd
    li t2, D_PAD_0_BASE
    slli t3, a0, 2
    add t2, t2, t3
    lw t3, (0)t2
    bnez t3, pollRelease
    addi a0, a0, 1
    j pollLoop
pollLoopEnd:
    j pollDpad
pollRelease:
    lw t3, (0)t2
    bnez t3, pollRelease
pollExit:
    jr ra
    
readInt:
    addi sp, sp, -12
    li a0, 0
    mv a1, sp
    li a2, 12
    li a7, 63
    ecall
    li a1, 1
    add a2, sp, a0
    addi a2, a2, -2
    mv a0, zero
parse:
    blt a2, sp, parseEnd
    lb a7, 0(a2)
    addi a7, a7, -48
    li a3, 9
    bltu a3, a7, error
    mul a7, a7, a1
    add a0, a0, a7
    li a3, 10
    mul a1, a1, a3
    addi a2, a2, -1
    j parse
parseEnd:
    addi sp, sp, 12
    ret

error:
    li a7, 93
    li a0, 1
    ecall


