#!/bin/bash
function PrintUsers
{
	cut -d: -f 1,6 /etc/passwd |tr ":" " " |sort
}

function PrintProcesses
{
	ps -aux | sort -g -k 2
}

function PrintHelp
{
	echo "-u, --users - Displays a list of users and their home directories, sorted alphabetically"
	echo "-p, --processes - Dispays a list of running processes sorted by their identifier"
	echo "-h, --help Displays a list and descriprion of arguments and stops work"
	echo "-l PATH, --log PATH Replaces the output to the file at the specified path PATH"
	echo "-e PATH, --errors PATH Replaces the error output from the stderr stream to the file at the path PATH"
	exit
}

function log
{
	path=$1
	if [ -f $path ]; then
		if [ -w $path ]; then
			exec 1> $path
		else
			echo " There is not permission to write in the $path" >&2
		fi
	else
		echo " The $path is not a file or it doesn't exist" >&2
	fi
}

function erorrs
{
	path=$1
	if [ -f $path ]; then
		if [ -w $path ]; then
			exec 2> $path
		else
			echo " There is not permission to write in the $path" >&2
		fi
	else
		echo " The $path is not a file or it doesn't exist" >&2
	fi
}


OPTS=$(getopt -n Unexpected -o uphl:e: -l users,processes,help,log:,errors: -- "$@")

if [ $# -eq 0 ]; then
	echo "There are no arguments, try to call utility with -h or --help to see more" >&2
	exit
fi

eval set -- "$OPTS"

while true ; do
	case "$1" in
		-u | --users)
		       	PrintUsers
		       	shift ;;
		-p | --processes)
			PrintProcesses
			shift ;;
		-h | --help)
			PrintHelp
			shift ;;
		-l | --log)
			log $2
			shift 2 ;;
		-e | -errors)
			errors $2
			shift 2 ;;
		--)
			shift
			break ;;
	esac
done