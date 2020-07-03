#!/bin/bash

usoScript(){
        echo "Uso: $0 -d search_dir [-h] "
        echo "\t-d: directorio donde estan los datos a procesar.\n"
        echo "\t-h: muestra este mensaje y termina.\n"
        exit
}

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




#problema 1

executionSummaryFiles=(`find . -name 'executionSummary*.txt' -print |sort |grep -v '._'`)

printf "tsimTotal:promedio:min:max\n" >> metrics.txt
printf "memUsed:promedio:min:max\n" >> metrics.txt

for i in ${executionSummaryFiles[*]};

 do
         cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$6+$7+$8;}END{print sum}'>>suma.txt;       


         totalsim=$(cat suma.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
             if($1>max){max=$1};\
                total+=$1; count+=1;\
             } \
             END { print total":"total/count":"min":"max}')


         cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$9;}END{print sum}'>>memoria.txt;          

         memoria=$(cat memoria.txt | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
            if($1>max){max=$1};\
                 total+=$1; count+=1;\
            } \
            END { print total":"total/count":"min":"max}')

 done
rm -f suma.txt memoria.txt

echo $totalsim >>metrics.txt
echo $memoria >>metrics.txt

#problema 2

printf "alls:promedio:min:max\n" >> evacuation.txt
printf "residents:promedio:min:max\n" >> evacuation.txt
printf "visitorsI:promedio:min:max\n" >> evacuation.txt
printf "residents-G0:promedio:min:max\n" >> evacuation.txt
printf "residents-G1:promedio:min:max\n" >> evacuation.txt
printf "residents-G2:promedio:min:max\n" >> evacuation.txt
printf "residents-G3:promedio:min:max\n" >> evacuation.txt
printf "visitorsI-G0:promedio:min:max\n" >> evacuation.txt
printf "visitorsI-G1:promedio:min:max\n" >> evacuation.txt
printf "visitorsI-G2:promedio:min:max\n" >> evacuation.txt
printf "visitorsI-G3:promedio:min:max\n" >> evacuation.txt



summaryFiles=(`find . -name 'summary*.txt' -print |sort |grep -v '._'`)

for i in ${summaryFiles[*]}; do cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum+=$7;}END{print sum}'>>suma.txt; done

evac=$(cat suma.txt | awk 'BEGIN { min=2**63-1; max=0}{ if($1<min){min=$1};\
        if($1>max){max=$1};\
                total+=$1; count+=1;\
        } \
        END { print total":"total/count":"min":"max}')

rm -f suma.txt
echo $evac >>evacuation.txt


for j in $(seq 0 1);
    do
        for i in ${summaryFiles[*]};
        do
            cat $i | tail -n+2 | awk -F ':' '$3 == '$j' {sum=0;sum+=$7;print sum};'>>suma.txt;

        done

evac=$(cat suma.txt | awk 'BEGIN { min=2**63-1; max=0}{ if($1<min){min=$1};\
        if($1>max){max=$1};\
                total+=$1; count+=1;\
        } \
        END { print total":"total/count":"min":"max}')

rm -f suma.txt
echo $evac >>evacuation.txt
  done



for k in $(seq 0 3);
    do
        for j in $(seq 0 1);
        do
            for i in ${summaryFiles[*]};
            do
                cat $i | tail -n+2 | awk -F ':' '{if ($3=='$j' && $4=='$k') {sum=0;sum+=$7;print sum}};'>>suma.txt;
            done

            evac=$(cat suma.txt | awk 'BEGIN { min=2**63-1; max=0}{ if($1<min){min=$1};\
        if($1>max){max=$1};\
                total+=$1; count+=1;\
        } \
        END { print total":"total/count":"min":"max}')

rm -f suma.txt
echo $evac >>evacuation.txt

        done
    done

#problema 3

usePhoneFiles=(`find . -name 'usePhone*.txt' -print |sort |grep -v '._'`)

printf "timestamp:promedio:min:max\n" >> usePhone-stats.txt


for i in ${usePhoneFiles[*]}; do

        echo  $i; tiempos=(`cat $i |tail -n+3 |cut -d ":" -f 3`);

        for i in ${tiempos[*]}; do

                echo -n $i":" >> suma.txt;

        done; echo "" >> suma.txt;

done


for i in $(seq 1 360); do

                phone=$(cat suma.txt | cut -d ':' -f $i | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
             if($1>max){max=$1};\
                total+=$1; count+=1;\
             } \
             END { print  total/count":"min":"max}')



        echo $i"0:"$phone  >> usePhone-stats.txt

done

rm -f suma.txt









 
