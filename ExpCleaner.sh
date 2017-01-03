#!/bin/bash
datenow=$(date +%s)
for user in $(awk -F: '{print $1}' /etc/passwd); do

  expdate=$(chage -l $user|awk -F: '/Account expires/{print $2}')
  echo $expdate|grep -q never && continue
  echo -n "Usuario \`$user' expira em $expdate = "
  expsec=$(date +%s --date="$expdate")
  diff=$(echo $datenow - $expsec|bc -l)
  echo $diff|grep -q ^\- && echo OK && continue
  echo Conta removida!
  userdel $user
done