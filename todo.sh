#!/bin/bash

# Created by : Neem Chhetri
# This is my take on the to do list program. I have tried my best make this
# program error free and very user friendly.
# I have used different functions for menu-driven interface and command line
# driven interface and seperated thohse by comments in the code. 

# The error message in the menu interface uses 2 second sleep so please do not
# type anything in that 2 second. It does not break the code but whatever typed
# in the 2 second sleep still counts as an input which might give another error.

# Functions for menu interface---------------------------

# Start of the code, initiallizing varaibles.
# This is the main page for menu interface.
show_case() {
clear
count=0
echo "Welcome to the to-do list manager!"
if [ -d todo ]; then
	echo
	echo "Here are your current items."
	cd todo
	for file in *.txt; do
		count=$((count+1))
		echo "$count) $(head -n 1 $file)"
	done
	cd ..
fi
echo
echo
echo "What would you like to do?"
if [ $count -gt 0 ]; then
	echo "1-${count}) See more information on this item" 
	echo "A) Mark an item as completed"
fi
echo "B) Add a new item"
echo "C) See completed items"
echo 
echo "Q) Quit"
echo
}

# this one adds the item in the list.
add() {
	read -p "Please enter the item title: " item
	if ! [ -d todo ]; then
		mkdir todo
		chmod u=rwx,g=,o= ./todo
	fi
	cd ./todo
	count=$((count+1))
	echo "$item" > ${count}.txt
	read -p "Please enter the item description: " des
	echo "$des" >> ${count}.txt
	chmod 700 ./${count}.txt
	cd ..
	main
}

# This is for checking the description of a given item.
check_description() {
	clear
	cd todo
	for file in *.txt; do
		ans=$((ans-1))
		if [ $ans -eq 0 ]; then
			head -n 1 $file
			echo --------
			tail -n +2 $file
		fi
	done
	cd ..
	
	echo
	read -p "Press 'Enter' to get back to main page: " check
	main
}

# Marks the item as completed.
check_off() {
	number=1
	read -p "Enter the item number you want to check off: " item
        if [ $item -ge 1 -a $item -le $count ]; then
	# Craetes a new directory if it does not exist already.
	if [ -d completed ]; then
		cd completed
		for file in *.txt; do
			number=$((number+1))		
		done
		cd ..
	else
		mkdir completed
		chmod u=rwx,g=,o= ./completed
	fi

	cd todo
	# file count is to move the number backwards.
	filecount=1
	transfered=0
	lastfile=$(find ./ -type f | wc -l)
	for file in *.txt; do
		if [ $transfered -eq 1 ]; then

			mv ${filecount}.txt $((filecount-1)).txt
		fi

		item=$((item-1))
		
		if [ $item -eq 0 ]; then
			mv $file ./../completed/${number}.txt
			transfered=1
		fi
		filecount=$((filecount+1))
	done
	cd ..
	# removes the folder if it is the last file.
	if [ $lastfile -eq 1 ]; then
		rmdir todo
	fi
	else
		echo "Please chose a valid item number."
		sleep 1
	fi
	main
}

# Shows the completed items.
show_completed() {
	clear
	if [ -d completed ]; then	
		cd completed
		counting=1
		for file in *.txt; do
			echo "$counting) $( head -n 1 $file)"
			counting=$((counting+1))
		done	
		cd ..
		echo
		read -p "Press 'Enter' to go back to main page: " some
	else
		echo "You have not completed any items yet."
		sleep 1
	fi
	main
}

# this quits the program.
go_on() {
	exit
}

# main function for the menu-driven interface.
main() {
	show_case
	read ans
	var="$(echo $ans | grep -E '^[0-9a-zA-Z]*$')"
	if [ -z "$var" ]; then
		echo "You have a invalid character in your entry. Maybe space or any other non numeric character."
		sleep 1
		main
	else
		if [ "$ans" == 'B' -o "$ans" == 'b' ]; then
			add
		elif [ "$ans" == 'A' -o "$ans" == 'a' ]; then	
			if [ -d "todo" ]; then
				check_off
			else
				echo "Please choose a valid option"
				sleep 1
				main
			fi
		elif [ "$ans" == 'C' -o "$ans" == 'c' ]; then
			show_completed
		elif [ "$ans" == 'q' -o "$ans" == 'Q' ]; then
			go_on = 1
		elif [ $((ans)) == $ans ]; then
			if [ $ans -ge 1 -a $ans -le $count ]; then
				check_description
			else
				echo
				echo "Please enter a valid item number."
				sleep 1
			fi
			main
		else
			echo
			echo "Please enter something from the options."
			sleep 1
			main
		fi
	fi
}

# Functions for command line interface----------------

# This is for the command line interface that lists the uncompleted things.
show_uncompleted() {
if [ -d todo ]; then
	echo "These are the items in your to do list: "
	echo
	cd todo
	for file in *.txt; do
		count=$((count+1))
		echo "$count) $(head -n 1 $file)"
	done
	cd ..
else
	echo "You don't have anything on the to do list yet."
fi
}

show_completed_two() {
	if [ -d completed ]; then	
		echo "These are the items you have completed."
		cd completed
		counting=1
		for file in *.txt; do
			echo "$counting) $( head -n 1 $file)"
			counting=$((counting+1))
		done	
		cd ..
		echo
	else
		echo "You have not completed any items yet."
	fi
}

complete_two() {
	counter=0
	read_ans="$2"
	reminder="$2"
	if [ $((read_ans)) == $read_ans ]; then
		if [ -d todo ]; then
			cd todo
			for file in *.txt; do
				counter=$((counter+1))	
			done
			cd ..	
			if [ $read_ans -ge 1 -a $read_ans -le $counter ]; then
				number=1
			       	# Craetes a new directory if it does not exist already.
				if [ -d completed ]; then
					cd completed
					for file in *.txt; do
						number=$((number+1))		
					done
					cd ..
				else
					mkdir completed
					chmod u=rwx,g=,o= ./completed
				fi

				cd todo
				# file count is to move the number backwards.
				filecount=1
				transfered=0
				lastfile=$(find ./ -type f | wc -l)
				for file in *.txt; do
					if [ $transfered -eq 1 ]; then
						mv ${filecount}.txt $((filecount-1)).txt
					fi

					read_ans=$((read_ans-1))
		
					if [ $read_ans -eq 0 ]; then
						mv $file ./../completed/${number}.txt
						transfered=1
					fi
					filecount=$((filecount+1))
				done
				cd ..
				# removes the folder if it is the last file.
				if [ $lastfile -eq 1 ]; then
					rmdir todo
				fi
				echo "${reminder}) $(head -n 1 ./completed/${number}.txt) - has been marked as checked."

			else
				clear
				echo "You did not input a valid item number."
				echo
				echo
				list
			fi
		else 
			echo "You don't have any todo list right now."
		fi
	else
		clear	
		echo "You did not input a number after complete."
		echo
		echo
		list
	fi	
}

add_two() {
	count=1
	if [ -d todo ]; then
		cd todo
		for file in *.txt; do
			count=$((count+1))
		done
		cd ..
	else 
		mkdir todo
		chmod u=rwx,g=,o= ./todo
	fi
	cd ./todo
	echo "$2" > ${count}.txt
	chmod 700 ${count}.txt
	read -p "Please enter the item description: " des
	echo "$des" >> ${count}.txt
	cd ..	
}

list() {
	echo "These command line commands can be used with this program:"
	echo
	echo "help -- displays a help message listing usable commands"
	echo
	echo "list -- lists the uncompleted items with numbers"
	echo
	echo "complete (number) -- complete is followed by a number. THis commands marks the item with the given number as complete."
	echo
	echo "list completed -- lists the completed items."
	echo
	echo "add (title) -- add is followed by the desired title inside \" \" unless your title is one word. This command adds a new title in the to-do list."
}

# Command line interface code.
if [ $# -gt 0 ]; then
	if [ ${1,,} == 'help' ]; then
		if [ $# -lt 2 ]; then
			list
		else 
			clear
			echo "Too many command line arguments."
			echo
			echo
			list
		fi
	elif [ ${1,,} == 'list' ]; then
		if [ -z "$2" ]; then
			show_uncompleted
		elif [ ${2,,} == 'completed' ]; then
			if [ $# -gt 2 ]; then
				clear
				echo "too many command line arguments."
				echo
				echo
				list
			else
				show_completed_two
			fi
		else 
			clear
			echo "Not a valid command for list."
			echo
			echo
			list
		fi
	elif [ ${1,,} == 'complete' ]; then
		if [ -z "$2" ]; then
			clear
	       		echo "Complete must be followed by a number."
			echo
			echo 
			list
		elif [ $# -gt 2 ]; then
			clear
			echo "Too many command line argumnets for complete."
			echo
			echo
			list
		else
			complete_two "$1", "$2"
		fi
	elif [ ${1,,} == 'add' ]; then
		if [ -z "$2" ]; then
			clear
			echo "Add must be followed by a title. Title must be inside \" \" unless your title is just one word"
			echo
			echo
			list
		elif [ $# -gt 2 ]; then
			clear
			echo "Too many arguments in the command line. Maybe you forgot the \" \" after add."
			echo
			echo
			list
		else
			add_two "$1", "$2"
		fi	
	else
		clear
		echo "It is invalid command."
 		echo
		echo
		list		
	fi	
else
	main
fi
