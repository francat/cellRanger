#run as bash createConfig_CR.sh in working directory that includes all sample fastq file you want to include. 
#code as is assumes all fastq file are in the same directory, see last line for other cases. 
#!/bin/bash

fastqs=(`find ~+ -type f -name "*I1_001.f*"`)
SamNameArray=()
DirNameArray=()
for i in "${fastqs[@]}"
do
        sampleName=${i##*/}
        fastqdir=${i%/*}
        fullSampleName=(`cut -d '_' -f1 <<< "${i##*/}"`)
        idName=${fullSampleName[0]}
        SamNameArray+="'"$idName"', "
        DirNameArray+="'"$fastqdir"', "
done


#transcriptome reference
echo "ref_path:/global/scratch/fran_catalan/References/refdata-gex-GRCh38-and-mm10-2020-A ," > configFile

echo "Samples:{" $SamNameArray "}~" |sed 's/,\([^,]*\)$/ \1/' |  sed 's/\x27/\"/ g' | sed 's/~/,/'  >> configFile

echo "'data_path:'" $fastqdir "'," | sed 's/\x27/\"/ g'  >> configFile 

#use if fastqs are spread out in various directories
#echo "data_path:{" $DirNameArray "}~" |sed 's/,\([^,]*\)$/ \1/' |  sed 's/\x27/\"/ g' | sed 's/~/,/' >> configFile                                                                                       │

