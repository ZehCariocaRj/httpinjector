#!/bin/sh
lsusers="/tmp/users"
delay=5
echo $$ > /tmp/pids
if [ ! -f "$lsusers" ]
then
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /tmp/users
fi
while true
do
	while read usline
	do
		user="$(echo $usline | cut -d' ' -f1)"
		s2ssh="$(echo $usline | cut -d' ' -f2)"
		ps x | grep $user | grep -v grep | grep -v pts > /tmp/tmp2
		s1ssh="$(cat /tmp/tmp2 | wc -l)"
		echo "Usuario: $user - $s1ssh/$s2ssh"
		if [ "$s1ssh" -gt "$s2ssh" ]; then
			echo 'Desconectando conexoes SSH simultaneas'
			while read line
			do
				tmp="$(echo $line | cut -d' ' -f1)"
				echo "Desconectando conexao SSH com ID $tmp"
				kill $tmp
			done < /tmp/tmp2
			rm /tmp/tmp2
		fi
		awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /tmp/users
	done < "$lsusers"
	echo "Aguardando $delay segundos para verificar novamente..."
	sleep $delay
done