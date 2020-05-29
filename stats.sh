#!/bin/bash

ficheros=(`find . -name '*.txt' -print | sort | grep execution | grep -v '._'`)

ficheros1=(`find . -name '*.txt' -print | sort | grep summary | grep -v '._'`)

ficheros2=(`find . -name '*.txt' -print | sort | grep usePhone | grep -v '._'`)


#problema 1 
for i in ${ficheros[]}; do cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$6+$7+$8;}END{print sum}'>>suma.txt; done      

cmd=$(cat suma.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                                                                                  if($1>max){max=$1};\
                                                                                                  total+=$1; count+=1;\
                                                                                            } \
                                                                                                END { print"tsimTotal\n" total":","Promedio\n" total/count":","min\n" min":","max\n" max}')

echo $cmd >>metrics.txt

for i in ${ficheros[]}; do cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$6+$7+$8;}END{print sum}'>>suma.txt; done      

cmd=$(cat suma.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                                                                                  if($1>max){max=$1};\
                                                                                                  total+=$1; count+=1;\
                                                                                            } \
                                                                                                END { print"memoria\n" total":","Promedio\n" total/count":","min\n" min":","max\n" max}')

echo $cmd >>metrics.txt

rm suma.txt


#Problema 2 

#Alls es similar a lo que se hizo en problema 1 
for i in ${ficheros1[*]}; do cat $i | tail -n+2 | awk -F ':' '$3 == 0 {sum=0;sum+=$7;print sum};'>>suma.txt; done

cmd=$(cat suma.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                                                                                  if($1>max){max=$1};\
                                                                                                  total+=$1; count+=1;\
                                                                                            } \
                                                                                                END { print"Residente\n" total":","Promedio\n" total/count":","min\n" min":","max\n" max}')

echo $cmd >>evacuation.txt

rm suma.txt

for i in ${ficheros1[*]}; do cat $i | tail -n+2 | awk -F ':' '{if ($3==0 && $4==0) {sum=0;sum+=$7;print sum}};'>>suma.txt; done

cmd=$(cat suma.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                                                                                  if($1>max){max=$1};\
                                                                                                  total+=$1; count+=1;\
                                                                                            } \
                                                                                                END { print"Residente-G0\n" total":","Promedio\n" total/count":","min\n" min":","max\n" max}')

echo $cmd >>evacuation.txt

rm suma.txt

#Problema 3 

for (( j= 0 ; j<=3600; j+=10))
 do
	for i in ${ficheros2[*]}; do cat $i | tail -n+3 | awk -F ':' ' $2 == $j {sum=0;sum+=$3;print sum};'>>suma.txt; done

	cmd=$(cat suma.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                                                                                  if($1>max){max=$1};\

                                                                                                  total+=$1; count+=1;\
                                                                                            } \
                                                                                                END {print"Residentes\n" $j":","Promedio\n" total/count":","min\n" min":","max\n" max}')
	echo $cmd >>phone.txt
	rm suma.txt
 done
