#!/bin/csh

#the first input: rootfile directory
set rootfiledir = $1

#the second input: list directory
set listdir = $2

#the third input: tag string
set tag = $3

#judge the number of input, if 3 or 5, exit
if ($#argv == 3) then
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
        echo "File $rootfile does not exist in the directory $rootfiledir"
        set killedlist = "$killedlist $list"
    endif
end

#echo all the killed lists line by line
foreach list ($killedlist)
    echo $list
end

#merge all the killed lists into one file
cat $killedlist > Killed_$tag.list

else if ($#argv == 5) then
    #the fourth input: the number of jobs
    set njobs = $4

    #the fifth input: the output directory
    set njob = $5

    #define a variable to store the killed lists
    set killedlist = ""

    #calculate the range of the lists that be processed by this shell
    set nlists = `ls $listdir | grep $tag | wc -w`
    set nlistsperjob = `echo "scale=0; $nlists/$njobs" | bc`
    set nlistsleft = `echo "scale=0; $nlists%$njobs" | bc`
    set nlistsstart = `echo "scale=0; ($njob-1)*$nlistsperjob+1" | bc`
    set nlistsend = `echo "scale=0; $njob*$nlistsperjob" | bc`
    set nlisttemp = `echo "scale=0; $nlistsend-$nlistsstart+1" | bc`
    if ($njob == $njobs) then
        set nlistsend = `echo "scale=0; $nlistsend+$nlistsleft" | bc`
    endif

    #generate the name of the output root file from the tagged list name from the list directory
    foreach list (`ls $listdir | grep $tag | head -n $nlistsend | tail -n $nlisttemp`)
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
            echo "File $rootfile does not exist in the directory $rootfiledir"
            set killedlist = "$killedlist $list"
        endif
    end
    #echo all the killed lists line by line
    foreach list ($killedlist)
        echo $list
    end

    #merge all the killed lists into one file
    cat $killedlist > Killed_$tag\_job$njob.list
endif
else
    echo "The number of input is wrong. The number of input should be 3 or 5."
    exit 1
endif
