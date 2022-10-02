#!/bin/csh

#the first input: rootfile directory
set rootfiledir = $1

#the second input: list directory
set listdir = $2

#the third input: tag string
set tag = $3

#define a variable to store the killed lists
set killedlist = ""

#generate the name of the output root file from the tagged list name from the list directory
foreach list (`ls $listdir | grep $tag`)
    set rootfile = `echo $list | sed 's/.list/.root/g'`
    set rootfile = `echo $rootfile | sed 's/sched/result_/g'`
    #check if the root file exists in the rootfile directory. if it does not, add it to the killed list. If so, check if the root file is good.
    if (-e $rootfiledir/$rootfile) then
        #check if the root file is good 
        IsRootFileGood $rootfiledir/$rootfile
        #if the root file is bad, add the list name to the killed list
        if ($status != 0) then
            set killedlist = "$killedlist $list"
        endif
    else
        set killedlist = "$killedlist $list"
end

#echo all the killed lists line by line
foreach list ($killedlist)
    echo $list
end

#merge all the killed lists into one file
cat $killedlist > Killed_$tag.list