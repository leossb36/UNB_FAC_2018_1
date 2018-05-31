#A raiz cubica é ZZ. O erro estimado eh de YY
#the numb is (0 < x < 1) 

.data
	error: .asciiz "Out of Range"
	
	numb: .float 0.0  #the value
	result_numb: .float 0.0 # the cubic root of 'numb'
	estimate: .float 0.0  #estimate error
	
	constant1: .float 0.0
	constant2: .float 1.0
	constant3: .float 3.0
	
	result1: .asciiz "A raiz cubica é "
	result2: .asciiz ". O erro estimado eh de "
	result3: .asciiz "\n"
.text
	
main:
	
	jal le_float 
	s.s $f0, numb # save return in 'numb'
	
	lwc1 $f0, numb # pass n as arg check_float
	jal check_float
	jal calc_raiz
	jal imprime_saida
	
	
check_float:
	# if (x > 0) return float
	# if (x < 1) return float
	
	l.s $f1, constant1 # 0
	l.s $f2, constant2 # 1
	
	greater_than_zero:
		c.lt.s $f1,$f0 # check if x > 0 
		bc1t less_than_one # if true jump next test
		bc1f not_in_range #if false jump not_in_range
	
	less_than_one:
		c.lt.s $f0, $f2 # check if x < 1
		bc1t in_range # if true jump in_range
		bc1f not_in_range # if false jump not_in_range
	
		not_in_range:
			la $a0, error
			li $v0, 4
			syscall
		
			j exit_prog
	
		in_range:
			mov.s $f0, $f0
			jr $ra #return var
					
	
le_float:
	li $v0, 6 # syscall to read float
	syscall
	
	jr $ra

calc_raiz:
	# the reverse of power function is the root
	# we need to do cubic root
	# the reverse of cubic root is N ^ (1/3)
	# 1/3 is constant
		
	l.s $f4, constant2 # 1.0
	l.s $f5, constant3 # 3.0
	lwc1 $f0, numb
	l.s $f6, constant1 # i = 0
	
	div.s $f3, $f4, $f5 # e = 1.0/3.0
	
	# for i = 0; i <= f3; i++
		
		loop_exp:
		#mul.s $f0, $f0, $f3 # return numb = return numb *  f3
		#add.s $f6, $f6, $f4 # i++
		#c.le.s $f6, $f5 # i <= 3 ? i++
		#bc1t loop_exp
		
		#not solved
		
	s.s $f0, result_numb
	
	jr $ra
calc_erro:

imprime_saida:
	
	la $a0, result1
	
	li $v0, 4 # syscall to print string 
	syscall
	
	lwc1 $f12, result_numb
	
	li $v0, 2 # syscall to print float
	syscall
	
	la $a0, result2
	
	li $v0, 4 # syscall to print string
	syscall
	
	lwc1 $f12, estimate
	
	li $v0, 2 # syscall to print float
	syscall
	
	la $a0, result3
	
	li $v0, 4 # syscall to print string
	syscall
	
	jr $ra
	

exit_prog:
	li $v0, 10
	syscall # exit program

