#!/bin/csh

#define FileList as the first input value
set FileList = $1

#set the input directory
set InputDir = $2

#define N_Parts as the second input value
set N_Parts = $3

#define N_Part as the third input value
set N_Part = $4

#define OutputFile as the fourth input value
set OutputFile = $5

#set the number of lines in the file
set N_Lines = `wc -l $FileList | awk '{print $1}'`

#set the number of lines per part
set N_Lines_Per_Part = `echo "scale=0; $N_Lines / $N_Parts" | bc`

#set the starting line
set Start_Line = `echo "scale=0; ($N_Part - 1) * $N_Lines_Per_Part + 1" | bc`

#set the ending line
set End_Line = `echo "scale=0; $N_Part * $N_Lines_Per_Part" | bc`

#output variables above into one line
echo "FileList = $FileList"
echo "InputDir = $InputDir"
echo "N_Parts = $N_Parts"
echo "N_Part = $N_Part"
echo "OutputFile = $OutputFile"
echo "N_Lines = $N_Lines"
echo "N_Lines_Per_Part = $N_Lines_Per_Part"
echo "Start_Line = $Start_Line"
echo "End_Line = $End_Line"

#read file in FileList from Start_Line to End_Line, check the file in the InputDir using IsRootFileGood(cpp return value:0 good, 1 bad), generate the command to merge all good files into OutputFile_N_Part.root. print the command to the screen and execute it.
set Command_Merge = "hadd -f $OutputFile\_$N_Part.root"
set Command_Check = "IsRootFileGood"
foreach File (`sed -n "$Start_Line,$End_Line p" $FileList`)
    $Command_Check $InputDir/$File
    if ($status == 0) then
        set Command_Merge = "$Command_Merge $InputDir/$File"
    endif
end
echo "================================================="
echo $Command_Merge
echo "================================================="
eval $Command_Merge

#end of the script

