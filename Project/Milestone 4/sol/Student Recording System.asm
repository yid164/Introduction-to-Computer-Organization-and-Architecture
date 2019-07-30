# CMPT215 Group Project
# Group Name: CMPT 215
# Group Member: Yinsheng Dong, Hao Li, Jinyang Liu, Yanzhao Lu, Zhihao Lin
# This should be the final version of our project

.data

	#These options are menu option, user needs to use these options to make a decision
	addOption:		.asciiz "1. Add A Student Information To the System\n"
	searchOption:		.asciiz "2. Search A Student Information\n"
	removeOption:		.asciiz "3. Remove A Student Information\n"
	printAllOption1:	.asciiz "4. Print All Student Information\n"
	averageOption:		.asciiz "5. Calulate The Total Average\n"
	quitOption:		.asciiz "6. Quit\n"
	askOption:		.asciiz "Please Choose The Number For The Options:\n"
	
	# These two messages for create a student information
	addStudentNoMessage:	.asciiz "Please enter the student number: "
	addStudentGradeMessage:	.asciiz "Please enter the student's grade: "
	addStudentfinished:	.asciiz "The student has been added! "
	
	# These 3 messages for search a student information
	searchMessage:		.asciiz "Please enter the student number to search for a student: "
	foundMessage:		.asciiz "We've found this student. Press 3 to remove this student: "
	notFoundMessage:	.asciiz "Sorry, we did found this student!\n"
	
	# These 3 messages for remove a student information by found the student info, if not, will be run exception
	removeMessage:		.asciiz "Will Remove Last Searched Student in the list\n"
	removeFinishedMsg:	.asciiz "This student has been removed in the list successfully\n"
	removeErrorMsg:		.asciiz "Can not remove this student for didn't find this student\n"
	
	# The message for print out all student informations
	printbyNoMessage:	.asciiz "All Student Informations by student number:\n"
	printbyGradeMessage:	.asciiz "All Student Informations by student grade:\n"
	
	# average message
	averageMessage:		.asciiz "The Total average is: "
	
	# The message for quit option
	quitMessage:		.asciiz "The System has been quited, see you!\n"
	
	# The exception if user put wrong option number to system
	exceptionMessage:	.asciiz "Sorry, Please choice the correct option!\n"
	
	# Blank Space
	blankSpace:		.asciiz " "
	
	colon:			.asciiz ":  "
	
	printOutMsg:		.asciiz "Student Number: Student's Grade\n"
	
	# New Line
	newLine:		.asciiz "\n"
	
	# The number that count student information
	studentCountNumber:	.word 0
	
	# When user remove a student information, and the the array has 1 or more student information in the list
	removeIndex:		.word -1
	
	# It will has 60 slot for storing student's number
	studentNumberArray:	.word 0 : 60
	
	# It will has 60 slot for stroing student's grade
	studentGradeArray:	.word 0 : 60
	
.text
	# the main function for main user interface
	main: 
		# display all options that user can choose
		jal	new_line
		la	$a0, addOption
		jal	displayMessage
		la	$a0, searchOption
		jal	displayMessage
		la	$a0, removeOption
		jal	displayMessage
		la	$a0, printAllOption1
		jal	displayMessage
		la	$a0, averageOption
		jal	displayMessage
		la	$a0, quitOption
		jal	displayMessage
		
		# menu loop when ended up
		menu:
			la	$a0, askOption
			jal	displayMessage
			jal	fetchNumber
			bne	$v0, $zero, option1
			j	quitSystem
		
		# jump to add student function
		option1:
			addi	$v0, $v0, -1
			bne	$v0, $zero, option2
			jal	addStudent
			j	main
		
		# jump to search student function
		option2:
			addi	$v0, $v0, -1
			bne	$v0, $zero, option3
			jal	searchStudent
			j	main
		# jump to remove student function (after search)
		option3:
			addi	$v0, $v0, -1
			bne	$v0, $zero, option4
			jal	removeStudent
			jal	main
		# jump to print all function
		option4:
			addi	$v0, $v0, -1
			bne	$v0, $zero, option5
			jal	printAll
			j	main
		
		# jump to calculate average function
		option5:
			addi	$v0, $v0, -1
			bne	$v0, $zero, option6
			jal	average
			j	main
		
		# jump to quit system function
		option6:
			addi	$v0, $v0, -1
			bne	$v0, $zero, option7
			jal	quitSystem
		
		# when user input wrong message
		option7:
			la	$a0, exceptionMessage
			jal	displayMessage
			j   	main
			
			
	# function for calculate the overall average
	average:
	
		# push these registers  
		add	$sp, $sp, -28
		sw	$s2, 24($sp)
		sw	$s1, 20($sp)
		sw	$s0, 16($sp)
		sw	$t1, 12($sp)
		sw	$t0, 8($sp)
		sw	$v0, 4($sp)
		sw	$a0, 0($sp)
		
		# display the average message
		la	$a0, averageMessage
		addi	$v0, $zero, 4
		syscall
		
		# load out the student count number for calulate, and then run the loop
		lw	$s0, studentCountNumber($zero)
		beq	$s0, $zero, exit
		add	$t0, $zero, $s0
		addi	$t1, $zero, 0
		
		# cal loop to get all student's grade, and then added them to s1
		cal:	
			lw	$a0, studentGradeArray($t1)
			add	$s1, $s1, $a0
			addi	$t1, $t1, 4
			addi	$t0, $t0, -1
			bne	$t0, $zero, cal
		# translate all  integer to float point, and then get the result
		cal1:
			li	$v0, 2
			mtc1	$s0, $f1
			mtc1 	$s1, $f2
			cvt.s.w $f1, $f1
			cvt.s.w $f2, $f2
			div.s 	$f12 $f2, $f1
			syscall
		# exit the function and pop oout all register that used
		exit:
			la	$a0, newLine
			addi	$v0, $zero, 4
			syscall
			
			lw	$s2, 24($sp)
			lw	$s1, 20($sp)
			lw	$s0, 16($sp)
			lw	$t1, 12($sp)
			lw	$t0, 8($sp)
			lw	$v0, 4($sp)
			lw	$a0, 0($sp)	
			addi	$sp, $sp, 28
			jr	$ra
	
	
	# add student function when user chose add student option
	addStudent:
	
		# push stack
		add 	$sp, $sp, -28
		
		# index of the arrays
		sw	$t0, 24($sp)
		sw	$ra, 20($sp)
		sw	$a0, 16($sp)
		sw	$v0, 12($sp)
		
		# the size of arrays
		sw	$s0, 8($sp)
		
		# the student number index
		sw	$s1, 4($sp)
		
		# the student grade variable
		sw	$s2, ($sp)
		
		# enter the student number and store it in $s1
		la	$a0, addStudentNoMessage
		jal	displayMessage
		addi	$v0, $zero, 5 
		syscall
		add	$s1, $zero, $v0
		
		# enter the student grade, and store it in $s2
		la	$a0, addStudentGradeMessage
		jal	displayMessage
		addi 	$v0, $zero, 5
		syscall
		add 	$s2, $zero, $v0
		
		# load out the how many student in the system
		lw 	$s0, studentCountNumber($zero) 
		sll 	$t0, $s0, 2
		
		# store the stuent number to its array
		sw 	$s1, studentNumberArray($t0)
		
		# store the stuent grade to its array
		sw 	$s2, studentGradeArray($t0)
		
		# increase these 2 array's size, and then store it
		addi 	$s0, $s0, 1
		sw 	$s0, studentCountNumber($zero)
		
		la	$a0, addStudentfinished
		jal 	displayMessage
		
		# pop the stack pointer
		lw 	$s2, ($sp)
		lw 	$s1, 4($sp)
		lw 	$s0, 8($sp)
		lw 	$v0, 12($sp)
		lw	$a0, 16($sp)
		lw	$ra, 20($sp)
		lw	$t0, 24($sp)
		add	$sp, $sp, 28
		jr	$ra 
		
	# search student function when user choose the search function
	searchStudent:
		# push stack
		add 	$sp, $sp, -28
		# the index of array
		sw	$t0, 24($sp)
		sw	$ra, 20($sp)
		# the student number that searched
		sw	$s1, 16($sp)
		# the temp register to do the compare
		sw	$s2, 12($sp)
		# the counter for loops
		sw	$t1, 8($sp)
		# save the removedIndex
		sw	$t2, 4($sp)
		
		sw	$s0, ($sp)
		
		# display the search message
		la 	$a0, searchMessage
		jal 	displayMessage
		
		# let user input the student number
		addi	$v0, $zero, 5
		syscall
		add 	$s1, $zero, $v0
		
		# go searching
		lw 	$s0, studentCountNumber($zero)
		addi 	$t0, $zero, 0
		add 	$t1, $zero, $0
		
		searchLoop:
				# if there are no this number, go not find
				bgt	$t1, $s0, notFind
				lw	$s2, studentNumberArray($t0)
				beq	$s1, $s2, gotIt
				addi	$t0, $t0, 4
				addi	$t1, $t1, 1
				j	searchLoop
		gotIt:
				# if got it, save the word the the remove index for preparing to remove it, and display we have got it
				sw	$t0, removeIndex($zero)
				
				la 	$a0, foundMessage
				jal	displayMessage
				
				
				
				##add	$a0, $zero, $t0
				#addi	$v0, $zero, 1
				#syscall
				
				la	$a0, newLine
				jal	displayMessage
				j	finishSearch
		
		notFind:
				# if didn't got it, then run exception
				la	$a0, notFoundMessage
				addi	$s6, $zero, -1
				sw	$s6, removeIndex($zero)
				jal 	displayMessage
				
		finishSearch:
				# pop the stack pointer
				lw 	$s0, ($sp)
				lw 	$t2, 4($sp)
				lw 	$t1, 8($sp)
				lw 	$s2, 12($sp)
				lw	$s1, 16($sp)
				lw	$ra, 20($sp)
				lw	$t0, 24($sp)
				add	$sp, $sp, 28
				jr	$ra 
				
	# remove function when user choose remove a student information
	removeStudent:
		# push stack
		add 	$sp, $sp, -28
		
		# index of student number array, every time goes 4 times
		sw	$t0, 24($sp)
		
		sw	$ra, 20($sp)
		
		# removedIndex
		sw	$t1, 16($sp)
		
		# more than t1 be 4
		sw	$t2, 12($sp)
		
		# number of students
		sw	$t3, 8($sp)
		
		# be the negative 1 to compare removedIndex
		sw	$t4, 4($sp)
		sw	$s0, ($sp)
		
		# display the message
		la	$a0, removeMessage
		jal 	displayMessage
		
		# $t4 = -1 to determine the removeIndex is less than 0, if it is equal to -1, then run exception
		addi 	$t4, $zero, -1
		lw	$t1, removeIndex($zero)
		beq	$t1, $t4, removeError
		
		# go removing
		lw	$s0, studentCountNumber
		sll	$t0, $s0, 2
		lw	$t3, studentCountNumber($zero)
		addi	$t2, $t1, 4
		
		# remove then re-orgenize the array
		removeLoop:
				# if finally $t2 euqals $t0, then the removing is success
				beq	$t2, $t0, removeSuccessed
				lw	$s1, studentNumberArray($t2)
				sw	$s1, studentNumberArray($t1)
				lw	$s1, studentGradeArray($t2)
				sw	$s1, studentGradeArray($t1)
				
				addi	$t1, $t1, 4
				addi	$t2, $t2, 4
				j	removeLoop
		
		# when the removeIndex is -1, then show the error exception		
		removeError:
				la	$a0, removeErrorMsg
				jal	displayMessage
				j	removeFinished
		
		# show the student information has been removed successfully
		removeSuccessed:
				# student count number needs to minus 1
				addi	$t3, $t3, -1
				sw	$t3, studentCountNumber
				la	$a0, removeFinishedMsg
				sw	$t3, removeIndex
				jal	displayMessage
				j	removeFinished
			
		# the final remove finished up	
		removeFinished:	
				# pop the stack pointer
				lw 	$s0, ($sp)
				lw 	$t4, 4($sp)
				lw 	$t3, 8($sp)
				lw 	$t2, 12($sp)
				lw	$t1, 16($sp)
				lw	$ra, 20($sp)
				lw	$t0, 24($sp)
				add	$sp, $sp, 28
				jr	$ra 
				
	# print all student's number and thier grades
	printAll:
		# push these register out
		addi	$sp, $sp, -20
		sw	$s0, 16($sp)
		sw	$t1, 12($sp)
		sw	$t0, 8($sp)
		sw	$v0, 4($sp)
		sw	$a0, 0($sp)
		
		# print out message display
		la	$a0, printOutMsg
		addi	$v0, $zero, 4
		syscall
		
		# load out the student count number
		lw	$s0, studentCountNumber($zero)
		beq	$s0, $zero, printExit
		add	$t0, $zero,$s0
		addi	$t1, $zero, 0
		
		# first loop to load out the every student number and student grades, and use colon to connect them
		print1:
			lw	$a0, studentNumberArray($t1)
			addi	$v0, $zero, 1
			syscall
			la	$a0, colon
			addi	$v0, $zero, 4
			syscall
			lw	$a0, studentGradeArray($t1)
			addi	$v0, $zero, 1
			syscall
			la	$a0, newLine
			addi	$v0, $zero, 4
			syscall
			addi	$t1, $t1, 4
			addi	$t0, $t0, -1
			bne	$t0, $zero, print1
			add	$t0, $zero, $s0
			addi	$t1, $zero,0
		
		# print exit when finished or exception, and then pop out then registers
		printExit:
			la	$a0, newLine
			addi	$v0, $zero, 4
			syscall
			
			lw	$s0, 16($sp)
			lw	$t1, 12($sp)
			lw	$t0, 8($sp)
			lw	$v0, 4($sp)
			lw	$a0, 0($sp)
			addi	$sp, $sp, 20
			jr	$ra
			

	# quit the system, and print out the quit message
	quitSystem:
		la	$a0, quitMessage
		jal	displayMessage
		addi	$v0, $zero, 10
		syscall
	
	# this function to get user's input
	fetchNumber:
		addi	$v0, $zero, 5
		syscall
		jr	$ra
	
	
	# this function use for display string data
	displayMessage: 
		addi	$sp, $sp, -4
		sw	$v0, ($sp)
		addi	$v0, $zero, 4
		syscall
		lw	$v0, ($sp)
		addi	$sp, $sp, 4
		jr	$ra
	
	# printout a new line
	new_line:
		addi	$sp, $sp, 8
		sw	$ra, ($sp)
		sw	$a0, 4($sp)
		la	$a0, newLine
		jal	displayMessage
		lw	$ra, ($sp)
		lw	$a0, 4($sp)
		addi	$sp, $sp, 8
		jr	$ra
		
		
	
	 
	
	
