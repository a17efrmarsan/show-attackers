#!/bin/bash
#Metemos todas las ips en el total.txt
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $1 > total.txt


#Contadores
 
contadorwcips=0;
contadorwcsyslog=0;
file=$1;

wcips=$(sort -u total.txt | wc -l)


wcsyslog=$(cat syslog-sample | wc -l)

echo "Contador,IP,Localizacion"

while [ $contadorwcips -lt $wcips ]; do

       	total=($(sort -u total.txt))
	ip=${total[$contadorwcips]}

	contadoripsfailed=$(grep -o -c "Failed password for root from $ip" $file)
	contadorips=$(grep -o -c "$ip" syslog-sample)

	var1=$(geoiplookup $ip)
	var2=$(echo "$var1" | cut -b 28-40 )


	echo "PUBLIC IP: $ip"
	echo ""
	echo " Aparece $contadorips veces en el archivo"
	echo " Fallos al introducir la contraseña: $contadoripsfailed"
	echo "Localización: $var2"
	if [ $contadoripsfailed -ge 10 ]; then
	echo "$contadoripsfailed,$ip,$var2" >> ips
	fi
	contadorwcips=$[$contadorwcips+1];

done
clear 
	echo "Contador,Ip,Localizacion"

	sort -nr ips
	rm ips
