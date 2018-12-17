.data
  first:  .space 80
  last:  .space 80
  jedi:  .space 7  #5 letters + 1 null byte + new line
  first_str:  .asciiz "Please enter first name:  "
  last_str:  .asciiz "Please enter last name:  "
  invalid_str: .asciiz "Your input is invalid"
.text

main:
#print first name promt
  la $a0, first_str
  addi $v0, $0, 4
  syscall

#get input of first name read string
  addi $v0, $0, 8
  la $a0, first
  addi $a1, $0, 80
  syscall

#print last name promt
  la $a0, last_str
  addi $v0, $0, 4
  syscall

#get input of last name read string
  addi $v0, $0, 8
  la $a0, last
  addi $a1, $0, 80
  syscall
#count length of first name
  la $t0, first
  addi $t2, $0, -1   # $t2 first name accumulator
first_loop:
  lb $t1, 0($t0)
  beq $t1, $0, to_last
  addi $t0, $t0, 1
  addi $t2, $t2, 1
  j    first_loop

#count length of last name
to_last:
  la $t3, last
  addi $t4, $0, -1  #t4 last name accumulator
last_loop:
  lb $t1,0($t3)
  beq $t1, $0, check
  addi $t3, $t3,1
  addi $t4, $t4, 1
  j    last_loop


check:
  addi $t0, $0, 2
  addi $t1, $0, 3
  addi $t3, $0, 1
#check first name avaliability 2 letters
  slt $t5, $t2, $t0
  beq $t5, $t3, error
#check last name avaliability 3 letters
  slt $t5, $t4, $t1
  beq $t5, $t3, error


# jedi name
# last name first 3 letters
  la $t0, jedi
  la $t1, last
  add $t2, $0, $0  #max num is 3
  addi $t3, $0, 3
last_three:
  beq $t2, $t3, first_name
  lb $t4, 0($t1)
  sb $t4, 0($t0)
  addi $t2, $t2, 1
  addi $t0, $t0, 1
  addi $t1, $t1, 1
  j    last_three

#first name first 2 letters
first_name:
  la $t1, first
  add $t2, $0, $0
  addi $t3, $0, 2

first_two:
  beq $t2, $t3, print_jedi
  lb $t4, 0($t1)
  sb $t4, 0($t0)
  addi $t2, $t2, 1
  addi $t0, $t0, 1
  addi $t1, $t1, 1
  j    first_two

#pring the jedi name
print_jedi:
  addi $t5,$0,10
  sb $t5, 0($t0)
  sb $0, 1($t0)
  addi $v0, $0, 4
  la $a0, jedi
  syscall

# add all the jedi values
  add $t0, $0, $0
  addi $t3, $0, 5
  la $t1, jedi
add_value:
  beq $t3, $0, print_num
  lb $t2, 0($t1)
  add $t0, $t0, $t2
  addi $t1, $t1, 1 # add 1 to the position
  addi $t3, $t3, -1
  j    add_value

print_num:
#print the power number
  addi $v0, $0, 1
  add  $a0, $0, $t0
  syscall
  j done

  #shows invalid input
error:
  la $a0, invalid_str
  addi $v0, $0, 4
  syscall

done:
  addi $v0, $0, 10
  syscall
