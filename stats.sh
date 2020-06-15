#!/bin/bash

OUTFILE="usePhone-stats.txt"


#
# Funciones
#

#
# USO SCRIPT
#
usoScript(){
	echo "Uso: $0 -d search_dir [-h] "
	exit
}




problema1(){

	executionSummaryFiles=(`find $searchDir -name '*executionSummary-*.txt' -print | sort `)
	printf "#tsimTotal:promedio:min:max\n" >> metrics.txt
	printf "#memUsed:promedio:min:max\n" >> metrics.txt
	for i in ${executionSummaryFiles[*]}; 
		do cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$6+$7+$8;}END{print sum}'>>suma.txt; 
	done      

	operaciones1=$(cat suma.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                    if($1>max){max=$1};\
                                    total+=$1; count+=1;\
                                    } \
                                    END { print total":",total/count":",min":",max}')

	echo $operaciones1  >>metrics.txt
	rm suma.txt

	for i in ${executionSummaryFile[*]}; 
		do cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$9;}END{print sum}'>>suma.txt; 
	done      

	operaciones12=$(cat suma.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                    if($1>max){max=$1};\
                                    total+=$1; count+=1;\
                                    } \
                                    END { printtotal":",total/count":",min":",max}')

	echo $operaciones12  >>metrics.txt
	rm suma.txt

}

problema2(){

	printf "#alls:promedio:min:max\n" >> evacuation.txt
	printf "#residents:promedio:min:max\n" >> evacuation.txt
	printf "#visitorsI:promedio:min:max\n" >> evacuation.txt
	printf "#residents-G0:promedio:min:max\n" >> evacuation.txt
	printf "#residents-G1:promedio:min:max\n" >> evacuation.txt
	printf "#residents-G2:promedio:min:max\n" >> evacuation.txt
	printf "#residents-G3:promedio:min:max\n" >> evacuation.txt
	printf "#visitorsI-G0:promedio:min:max\n" >> evacuation.txt
	printf "#visitorsI-G1:promedio:min:max\n" >> evacuation.txt
	printf "#visitorsI-G2:promedio:min:max\n" >> evacuation.txt
	printf "#visitorsI-G3:promedio:min:max\n" >> evacuation.txt
	
	summaryFiles=(`find $searchDir -name '*summary-*.txt' -print | sort `)

	for i in ${summaryFiles[*]};
	do 
		cat $i | tail -n+2 | awk -F ':' '$3 == '$j' {sum=0;sum+=$7;print sum};'>>suma.txt; 
	done
  	
  	operaciones21=$(cat suma.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                    if($1>max){max=$1};\
                                    total+=$1; count+=1;\
                                    } \
                                    END { print total":",total/count":",min":",max}')

	echo $cmd >>evacuation.txt
	rm suma.txt




	for j in $(seq 0 1); 
	do
		for i in ${summaryFiles[*]};
 		do 
 			cat $i | tail -n+2 | awk -F ':' '$3 == '$j' {sum=0;sum+=$7;print sum};'>>suma.txt; 
 		done
  
  		operaciones22=$(cat suma.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                        if($1>max){max=$1};\
                                        total+=$1; count+=1;\
                                        } \
                                        END { print total":",total/count":",min":",max}')


		echo $operaciones >>evacuation.txt
		rm suma.txt

	done

	for k in $(seq 0 1); 
	do
		for j in $(seq 0 1); 
		do
			for i in ${summaryFiles[*]}; 
			do 
				cat $i | tail -n+2 | awk -F ':' '{if ($3=='$j' && $4=='$k') {sum=0;sum+=$7;print sum}};'>>suma.txt; 
			done

			operaciones23=$(cat suma.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                            if($1>max){max=$1};\
                                            total+=$1; count+=1;\
                                            } \
                                            END { print total":",total/count":",min":",max}')

		echo $operaciones >>evacuation.txt

		rm suma.txt
		done
	done
}
problema3(){
	
	usePhoneFiles=(`find $searchDir -name '*usePhone-*.txt' -print | sort `)


	
	tmpFile="suma.txt"
	> $tmpFile

	for i in ${usePhoneFiles[*]}; 
	do	
		printf "> %s\n" $i
		tiempos=(`cat $i | tail -n+3 | cut -d ':' -f 3`)
		for i in ${tiempos[*]};
		do
			printf "%d:" $i >> $tmpFile
		done
		printf "\n" >> $tmpFile
	done 

	
	totalFields=$(head -1 $tmpFile | sed 's/.$//' | tr ':' '\n'| wc -l)             

	> $OUTFILE
	
	
	printf "#timestamp:promedio:min:max\n" >> $OUTFILE
	for i in $(seq 1 $totalFields); do
		out=$(cat $tmpFile | cut -d ':' -f $i |\
			awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max){max=$1};total+=$1; count+=1;}\
				END {print total/count":"max":"min}')
		printf "$i:$out\n" >> $OUTFILE
	done

	rm $tmpFile
}



#
# MAIN
#
while getopts "d:h" opt; do
  case ${opt} in
    d ) 
		searchDir=$OPTARG
      ;;
    h )
		usoScript
      ;;
    \? ) 
		usoScript
      ;;
  esac
done
shift $((OPTIND -1))

if [ -z $searchDir ]; then
	usoScript
fi

if [ ! -d $searchDir ]; then
        echo "$searchDir no es un directorio"
        exit
fi

printf "Directorio busqueda: %s\n" $searchDir


#Determinar el proedio tiempo de la simulacion total y memoria
problema1
#Determinar el promedio de evacuacion
problema2
#Determinar promedio de uso de teléfonos móviles
problema3


 
