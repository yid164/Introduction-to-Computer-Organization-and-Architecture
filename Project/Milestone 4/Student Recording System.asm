.data 
	# Greeding message for welcome display and let them to make choice to store or remove a student
	welcomeMessage: 		.asciiz "Welcome to System:\n Press 1 to Create A Student File \n Press 2 to Remove A Student File \n"
	
	# Ask user to input student name to add to system
	nameMessage: 			.asciiz "Please enter the Student Name you want to add:"
	
	# Ask user to input student number to add to the system
	studentNoMessage:		.asciiz "Please enter the Student Number you want to add:"
	
	# Display after user input student name and number shows the adding is complete
	finalNameMessage:		.asciiz "Stored Student Name:"
	
	# Display after user input student name and number shows the adding is complete
	finalStudentNoMessage:		.asciiz "Stored Student Number:"
	
	# Ask user to input student name if they want to remove the student
	removeNameMessage:		.asciiz "Please enter the Student Name you want to remove:"
	
	# Ask user to input student number if they want to remove the student
	removeStudentNoMessage:		.asciiz "Please enter the Student Number you want to remvoe:"
	
	# Display after user input student name and number shows the removing is complete
	removedName:			.asciiz "Removed Student Name:"
	
	# Display after user input student name and number shows the removing is complete
	removedStudentNo:		.asciiz "Removed Student Number:"
	
	# The added student name 
	userInput0: 			.space 20
	
	# The added student number 
	userInput1: 			.space 20
	
	# The removed student name 
	userInput2:			.space 20
	
	# The removed student number 
	userInput3:			.space 20
	
	# The number user input to choose option
	number1:			.word 1
	number2:			.word 2



.text 
	# the main function
	main:
		# load the 1, and 2 to $t1 and $t2, and show up the greeding message
		li $v0, 4
		lw $t1, number1
		la $a0, welcomeMessage
		lw $t2, number2
		syscall 
		
		# get user's input
		li $v0, 5
		syscall
		# move the user's input to the $t0
		move $t0, $v0
	
		# if user's input is 1, go to creat a student file
		beq $t0, $t1, storeStudent		
		# if user's input is 2, go ot remove a student file
		beq $t0, $t2, removeStudent
	
		syscall
		


	
	# the function for removing a student file
	removeStudent:
			# load the message 
			li $v0, 4
			la $a0, removeNameMessage
			syscall
			
			# user input the student name that wants to remove
			li $v0, 8
			la $a0, userInput2
			li $a1, 20
			move $s0, $a0
			syscall
			li $v0, 4
			# load the message
			la $a0, removeStudentNoMessage
			syscall
			li $v0, 8
			# user input the student number that wants to remove
			la $a0, userInput3
			li $a1, 20
			move $s1, $a0
			syscall
			# display the name and student number that wants to remove
			li $v0, 4
			la $a0,removedName
			syscall
			li $v0, 4
			la $a0, userInput2
			syscall
			li $v0, 4
			la $a0, removedStudentNo
			syscall
			li $v0, 4
			la $a0, userInput3
			syscall
	
	# the function for removing a student file		
	storeStudent: 
			# load the message
			li $v0, 4
			la $a0, nameMessage
			syscall
			# user input the student name that wants to add
			li $v0, 8
			la $a0, userInput0
			li $a1, 20
			move $s0, $a0
			syscall
			li $v0, 4
			la $a0, studentNoMessage
			syscall
			# user input the student number that wants to add
			li $v0, 8
			la $a0, userInput1
			li $a1, 20
			move $s1, $a0
			syscall
			# display the name and student number that wants to add
			li $v0, 4
			la $a0,finalNameMessage
			syscall
			li $v0, 4
			la $a0, userInput0
			syscall
			li $v0, 4
			la $a0, finalStudentNoMessage
			syscall
			li $v0, 4
			la $a0, userInput1
			syscall
	
