#!/bin/bash
if [ $(id -u) -eq 0 ]; then
	read -p "Nome do usuario: " username
	read -p "Senha: " password
	read -p "Dias para expirar: " dias
	final=$(date "+%Y-%m-%d" -d "+$dias days")
	gui=$(date "+%d/%m/%Y" -d "+$dias days")
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "O usuario $username ja existe!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -e $final -M -s /bin/false -p $pass $username
		[ $? -eq 0 ] && echo "Usuario $username criado com sucesso. Ele ira expirar dia $gui!" || echo "Nao foi possivel criar o usuario!"
		fi
	else
	echo "Este script devera ser executado atraves do usuario root"
	exit 2
fi