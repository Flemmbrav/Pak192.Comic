#!/bin/bash

#set -e

#general functions that don't have a single purpose

trim() {
	#removes unintentional white spaces
	#returns the string to the command line
	#acts recursive, in case there is a white space at the beginning or the end of the string it will remove that and run itself again
	local String=$1

	if [ ${#String} -gt 0 ]
	then
		if [ ${String:0:1} == ' ' ]
		then
			String=${String:1:${#String}}
			String="$(trim $String)"
		fi
		if [ ${String: (( ${#String} - 1 )) :${#String}} == ' ' ]
		then
			String=${String:0: (( ${#String} - 1 )) }
			String="$(trim $String)"
		fi
	fi
	echo "$String"
}



#functions related to reading the goods from the goods file

readgoods() {
	#opens the goods.dat file
	#creates a new GoodArray including all the parameters of a single good
	#runs readgoodline for each line in the file
	#saves the good to an array when it's fully read
	local GoodsFile=`cat Goods_Pak128Britain.dat | tr -d '\r'`

	declare -A GoodArray
	IFS='
	'
	for Line in $GoodsFile; do
  	PosMin=`expr index "$Line" '-'`
		if [ $PosMin -eq 1 ]
		then
			savegoodtoram
			unset GoodArray
			declare -A GoodArray
		else 
			readgoodline $Line
		fi
	done
	savegoodtoram
	unset GoodArray
}

readgoodline() {
	#reads a line and adds it to the ObjectArray
	local Line="$1"
	shift
	local PosHash=`expr index "$Line" '#'`
	local PosEq=`expr index "$Line" '='`

	if [ $PosHash -gt 0 ]
	then
		Line=${Line:1:${#Line}}
		PosEq=$(($PosEq - 1))
		if [ $PosEq -gt 0 ] && [ `expr index "$Line" '#'` == 0 ]
		then
			Name=${Line:0:$((PosEq - 1))}
			Name="$(trim $Name)"
			Value=${Line:PosEq}
			Value="$(trim $Value)"
			GoodArray[$Name]=$Value
		fi
		Line=${Line:0:$((PosHash - 1))}
	else
		if [ $PosEq -gt 0 -a ${#Line} -gt 0 ]
		then
			Name=${Line:0:$((PosEq - 1))}
			Name="$(trim $Name)"
			Value=${Line:PosEq}
			Value="$(trim $Value)"
			GoodArray[$Name]=$Value
		fi
	fi
}

savegoodtoram() {
	#echo ${GoodArray[@]}
	if [[ ${GoodArray[name]} == "" ]]
	then
		return
	fi
	if [ ${GoodArray[catg]} -eq 0 ];then
		GoodsValueArray[${GoodArray[name]}]="${GoodArray[value]}"
		GoodsSpeedBonusArray[${GoodArray[name]}]="${GoodArray[speed_bonus]}"
		GoodsWeigthArray[${GoodArray[name]}]="${GoodArray[weight_per_unit]}"
	else
		if [ "${GoodArray[name]}" == "catg${GoodArray[catg]}" ];then
			GoodsValueArray[${GoodArray[name]}]=${GoodArray[value]}
			GoodsSpeedBonusArray[${GoodArray[name]}]=${GoodArray[speed_bonus]}
			GoodsWeigthArray[${GoodArray[name]}]=${GoodArray[weight_per_unit]}
		else
			GoodsValueArray[${GoodArray[name]}]=${GoodsValueArray[catg${GoodArray[catg]}]}
			GoodsSpeedBonusArray[${GoodArray[name]}]=${GoodsSpeedBonusArray[catg${GoodArray[catg]}]}
			GoodsWeigthArray[${GoodArray[name]}]=${GoodsWeigthArray[catg${GoodArray[catg]}]}
		fi
	fi
}










getspeedbonus() {
	local Waytype=$1
	local Year=$2
	local IFS='
	'
	local Year1=0
	local Year2=0
	local Value1=0
	local Value2=0
	local Counter=0
	local Speedbonus=0

	for Line in $SpeedBonusFile; do
 		local PosHash=`expr index "$Line" '#'`
		if [ $PosHash -gt 0 ]
		then
			Line=${Line:0:$((PosHash - 1))}
		fi		
		if [ "${Line:0:${#Waytype}}" == "${Waytype}" ]
		then
			Line=${Line:$((${#Waytype} + 1)):${#Line}}
			local IFS=','

			for Number in $Line
			do
				if [ $Counter -eq 0 ];then
					Year2=$Year1
					Year1=$Number
					if [ $Year1 -eq $Year ] || [ $Year1 -gt $Year ] ;then
						Counter=2
					else
						Counter=1
					fi
				else	
					if [ $Counter -eq 1 ];then
						Counter=0
						Value2=$Value1
						Value1=$Number
						else
						if [ $Counter -eq 2 ];then
							Counter=3
							Value2=$Value1
							Value1=$Number
							Speedbonus=$(( Value2 + ( Value1 - Value2 ) * ( Year - Year2 ) / ( Year1 - Year2 ) ))
						fi
					fi
				fi
			done
			local IFS='
			'
		fi
	done
	if [[ $Speedbonus -eq 0 ]];then
		Speedbonus=$Value1
	fi
	echo $Speedbonus
}


getincome() {
	#returns the income multiplied by 1.000
	local Good=$1
	local Payload=$2
	local Waytype=$3
	local Year=$4
	local Speed=$5
	local SpeedBonus="$(getspeedbonus $Waytype $Year)"
	local GoodSpeedBonus=${GoodsSpeedBonusArray[$Good]}
	local GoodValue=${GoodsValueArray[$Good]}
	local Income=0
	GoodSpeedBonus=$(( GoodSpeedBonus + 2 ))
	#echo "Speed: "$Speed" ; GoodSpeedBonus: "$GoodSpeedBonus" ; SpeedBonus: "$SpeedBonus;
	#calculate the speedbonus multiplied by 10.000
	if [ $SpeedBonus -eq 0 ];then
		Income=10000
	else
		Income=$(( (( Speed * 1000 / SpeedBonus ) - 1000 ) * ( GoodSpeedBonus ) + 10000 ))
		#(( 13/3 Speed <= SpeedBonus )
	fi
	#calculate the income
	Income=$(( Income * Payload * GoodValue / 3 ))
	#lowering the multiplyer to times 10
	Income=$(( Income / 10 ))

	if [ 0 -gt $Income ];then
		Income=0
	fi
	
	echo $Income
}













readallfiles() {
	local directionary=$1
	local AddOnFolder=0
	for arg in "$@"; do
		if [[ $arg == "-a" ]];then
			AddOnFolder=1
			echo "- -a AddOn folder"
		fi
	done
	IFS='
	'
	if [ ${#directionary[@]} -gt 0 ] ; then

	  	for dat in $directionary ; do

	  		if [ -f "$dat" ] ; then
				echo "-- Performing Work At: $dat "
				readfile $dat $AddOnFolder
			fi
		done
	fi
}


readfile() {
	#opens a file
	#creates a new ObjectArray
	#runs readline for each line in the file
	local Filename=$1
	local AddOnFolder=$2
	echo "nutze cat";
	local File=`cat $Filename | tr -d '\r'`

	`rm -f calculated/$Filename`
	declare -A ObjectArray
	local IFS='
'
	for Line in $File; do
  	PosMin=`expr index "$Line" '-'`
		if [ $PosMin -eq 1 ]
		then
			writeobject $Filename $AddOnFolder
			unset ObjectArray
			declare -A ObjectArray
		else 
			readline $Line
		fi
	done
	if [[ ! -z ${ObjectArray[obj]} ]] ;then
		writeobject $Filename $AddOnFolder
	fi
	unset ObjectArray
}


readline() {
	#reads a line and adds it to the ObjectArray
	local Line="$1"
	if [[ ! -z $Line ]];then
		shift
		local PosHash=`expr index "$Line" '#'`
		local PosEq=`expr index "$Line" '='`

		if [ $PosHash -gt 0 ]
		then
			Line=${Line:0:$((PosHash - 1))}
		fi
		if [ $PosEq -gt 0 -a ${#Line} -gt 0 ]
		then
			Name=${Line:0:$((PosEq - 1))}
			Name="$(trim $Name)"
			Name=${Name,,}
			Value=${Line:PosEq}
			Value="$(trim $Value)"
			ObjectArray[$Name]=$Value
		fi
	fi
}


calculatecosts(){
	local dat=$1
	local calculatedfile=$2
	#get the income of the vehicle by 1000 times
	local Income="$(getincome ${ObjectArray[freight]} ${ObjectArray[payload]} ${ObjectArray[waytype]} ${ObjectArray[intro_year]} ${ObjectArray[speed]})"
	#get the value of the power installed, this is essentially the income of 
	local PowerValue=0
	if [[ ! -z ${ObjectArray[power]} ]] ;then
		local EffectivePower=${ObjectArray[power]}
		if [[ ! -z ${ObjectArray[gear]} ]] ;then
			local Gear=${ObjectArray[gear]}
			EffectivePower=$(( EffectivePower * Gear ))
		else
			EffectivePower=$(( EffectivePower * 100 ))
		fi
		PowerValue="$(getincome "None" $EffectivePower ${ObjectArray[waytype]} ${ObjectArray[intro_year]} ${ObjectArray[speed]})"
		
		if [[ ! -z ${ObjectArray[engine_type]} ]] ;then
			if [[ ${ObjectArray[engine_type]} == "electric" ]] ;then
				PowerValue=$(( PowerValue  / 100 * 70 ))
			fi
		fi
		PowerValue=$(( PowerValue / 1000 ))
	fi
	#malus for passenger trains as they usually get higher average payload
	if [[ ${ObjectArray[freight]} == "Passagiere" ]] ;then
		Income=$(( Income * 100 / 110 ))
	fi
	#calculate the runningcosts
	local Cost=$(( Income + 10 * PowerValue ))
	local RunningCost=$(( Income + PowerValue ))
	RunningCost=$(( RunningCost / 4000 ))
	local LoadingTime=$(( Income / 300 ))
	
	#the next two lines are for the experimental implementation of fix costs. The running costs will be reduced to 10%, while the fix costs are a nice guess on what they should look like. I did some short math on them, but it's very vague.
	#local FixCost=$(( RunningCost * 240 ))
	local speed=${ObjectArray[speed]}
	#speed=$(( speed - 10 ))
	local FixCost=$(( RunningCost * speed * 5 / 3 ))
	#speed=$(( speed + 150 ))
	if [[ $speed -gt 160 ]] ;then
		speed=160
	fi
	FixCost=$(( FixCost * speed / 160 ))
	RunningCost=$(( RunningCost / 10 ))
	if [[ $ForcingNewValues == 1 ]];then
		echo "loading_time=$LoadingTime" >> $calculatedfile
		echo "runningcost=$RunningCost" >> $calculatedfile
		echo "cost=$Cost" >> $calculatedfile
		#echo "fixed_cost=$FixCost" >> $calculatedfile
	else
		if [[ ! -z ${ObjectArray[loading_time]} ]] ;then
			echo "loading_time=${ObjectArray[loading_time]}" >> $calculatedfile
		else
			echo "loading_time=$LoadingTime" >> $calculatedfile	
		fi
		if [[ ! -z ${ObjectArray[runningcost]} ]] ;then
			echo "runningcost=${ObjectArray[runningcost]}" >> $calculatedfile
		else
			echo "runningcost=$RunningCost" >> $calculatedfile	
		fi
		if [[ ! -z ${ObjectArray[cost]} ]] ;then
			echo "cost=${ObjectArray[cost]}" >> $calculatedfile
		else
			echo "cost=$Cost" >> $calculatedfile
		fi
		if [[ ! -z ${ObjectArray[fixed_cost]} ]] ;then
			echo "fixed_cost=$FixCost" >> $calculatedfile
			#echo "fixed_cost=${ObjectArray[fixed_cost]}" >> calculated/$dat
		else
			echo "fixed_cost=$FixCost" >> $calculatedfile
		fi
		
		
	fi
}


writeconstraints() {
	Direction=$1
	local calculatedfile=$2
	local CounterBefore=0
	local CounterAfter=0
	local HasToBeRemade=0
	while [[ ! -z ${ObjectArray[constraint\[$Direction\]\[$CounterBefore\]]} ]] ;do

		if [[ ${ObjectArray[constraint\[$Direction\]\[$CounterBefore\]]:0:1} == "!" ]] ;then
			if [[ $ReConvert == 0 ]];then
				if [[ $Direction == "next" ]];then	
					local Path="calculated/ConstraintGroupprev"${ObjectArray[constraint\[$Direction\]\[$CounterBefore\]]:1:${#ObjectArray["constraint[$Direction][$CounterBefore]"]}}".txt"
					echo "${ObjectArray[name]}" >> $Path
				else
					local Path="calculated/ConstraintGroupnext"${ObjectArray[constraint\[$Direction\]\[$CounterBefore\]]:1:${#ObjectArray["constraint[$Direction][$CounterBefore]"]}}".txt"
					echo "${ObjectArray[name]}" >> $Path
				fi
			else
				local File=`cat $"calculated/ConstraintGroup"$Direction${ObjectArray[constraint\[$Direction\]\[$CounterBefore\]]:1:${#ObjectArray["constraint[$Direction][$CounterBefore]"]}}".txt"`
				local IFS='
'
				if [[ $Direction == "next" ]];then	
					for Line in $File; do
						echo "constraint[$Direction][$CounterAfter]=$Line" >> $calculatedfile
						CounterAfter=$(( CounterAfter + 1 ))						
					done
				else
					for Line in $File; do
						echo "constraint[$Direction][$CounterAfter]=$Line" >> $calculatedfile
						CounterAfter=$(( CounterAfter + 1 ))						
					done
				fi
			fi
			HasToBeRemade=1
			CounterBefore=$(( CounterBefore + 1 ))
			CounterAfter=$(( CounterAfter + 1 ))
		else
			echo "constraint[$Direction][$CounterAfter]=${ObjectArray["constraint[$Direction][$CounterBefore]"]}" >> $calculatedfile
			CounterBefore=$(( CounterBefore + 1 ))
			CounterAfter=$(( CounterAfter + 1 ))
		fi
	done
	if [[ $HasToBeRemade -eq 1 ]];then
		ReConvertList[$dat]=$dat
	fi
}


writeimages() {
	local calculatedfile=$1
	for Key in "${!ObjectArray[@]}"; do
		if [[ $Key =~ "image" ]];then
			if [[ ${ObjectArray[$Key]:0:2} == './' ]]; then
				ObjectArray[$Key]=${ObjectArray[$Key]:2:${#ObjectArray[$Key]}}
			fi
			echo "$Key=${ObjectArray[$Key]}" >> $calculatedfile
		fi
	done
}


writevehicle() {
	local dat=$1
	local calculateddir=$2
	local calculatedfile="$calculateddir/$(basename "$dat")"
	#echo "$dat"
#Object
	#the object being a vehicle is given by running this function
	echo "obj=vehicle" >> $calculatedfile
	#the name of the vehicle has to be given
	echo "name=${ObjectArray[name]}" >> $calculatedfile
	#only write the name of the author if it is given
	if [[ ! -z ${ObjectArray[copyright]} ]] ;then
		echo "copyright=${ObjectArray[copyright]}" >> $calculatedfile
	fi
	echo >> $calculatedfile
#Dates
	#the intro year of the vehicle has to be given
	echo "intro_year=${ObjectArray[intro_year]}" >> $calculatedfile
	#only write in the intro month if it is given
	if [[ ! -z ${ObjectArray[intro_month]} ]] ;then
		echo "intro_month=${ObjectArray[intro_month]}" >> $calculatedfile
	fi
	#only write in the outro year if it is given
	if [[ ! -z ${ObjectArray[retire_year]} ]] ;then
		echo "retire_year=${ObjectArray[retire_year]}" >> $calculatedfile
	fi
	#only write in the outro month if it is given
	if [[ ! -z ${ObjectArray[retire_month]} ]] ;then
		echo "retire_month=${ObjectArray[retire_month]}" >> $calculatedfile
	fi
	echo >> $calculatedfile
#Parameters
	#the waytype of the vehicle has to be given
	if [[ ${ObjectArray[waytype]} == "track" ]] ;then
		echo "waytype=track" >> $calculatedfile
	else
		if [[ ${ObjectArray[waytype]} == "narrowgauge_track" ]] ;then
			echo "waytype=track" >> $calculatedfile
		else
			echo "waytype=${ObjectArray[waytype]}" >> $calculatedfile
		fi
	fi
	#write the speed if given, else write the speed used in the speedbonus
	if [[ ! -z ${ObjectArray[speed]} ]] ;then
		echo "speed=${ObjectArray[speed]}" >> $calculatedfile
	else
		local SpeedBonus="$(getspeedbonus ${ObjectArray[waytype]} ${ObjectArray[intro_month]} )"
		echo "speed=$SpeedBonus" >> $calculatedfile
	fi
	#write the weigth if given, else write the 2t for every length
	if [[ ! -z ${ObjectArray[weight]} ]] ;then
		echo "weight=${ObjectArray[weight]}" >> $calculatedfile
	else
		local Weigth=${ObjectArray[length]}
		Weigth=$(( 2 * Weigth ))
		echo "weight=$Weigth" >> $calculatedfile
	fi
	#only write in the length if it is given
	if [[ ! -z ${ObjectArray[length]} ]] ;then
		echo "length=${ObjectArray[length]}" >> $calculatedfile
	fi
	#only write in the engine type if it is given
	if [[ ! -z ${ObjectArray[engine_type]} ]] ;then
		echo "engine_type=${ObjectArray[engine_type]}" >> $calculatedfile
	fi
	#only write in the power if it is given
	if [[ ! -z ${ObjectArray[power]} ]] ;then
		echo "power=${ObjectArray[power]}" >> $calculatedfile
	fi
	#only write in the gear if it is given
	if [[ ! -z ${ObjectArray[gear]} ]] ;then
		echo "gear=${ObjectArray[gear]}" >> $calculatedfile
	fi
	echo >> $calculatedfile
#Freigth
	#only write in the freigth if it is given
	if [[ ! -z ${ObjectArray[freight]} ]] ;then
		echo "freight=${ObjectArray[freight]}" >> $calculatedfile
	fi
	#only write in the payload if it is given
	if [[ ! -z ${ObjectArray[payload]} ]] ;then
		echo "payload=${ObjectArray[payload]}" >> $calculatedfile
	fi
	#calculate the costs and loading time
	calculatecosts $dat $calculatedfile
	echo >> $calculatedfile
	writeconstraints "prev" $calculatedfile
	writeconstraints "next" $calculatedfile
	echo >> $calculatedfile
	#only write in the smoke if it is given
	if [[ ! -z ${ObjectArray[smoke]} ]] ;then
		echo "smoke=${ObjectArray[smoke]}" >> $calculatedfile
	fi
	#only write in the sound if it is given
	if [[ ! -z ${ObjectArray[sound]} ]] ;then
		echo "sound=${ObjectArray[sound]}" >> $calculatedfile
	fi
	#return images
	writeimages $calculatedfile
	#echo "---" >> $calculatedfile
}


copyobject() {
	local FileName=$1
	`cp -f $Filename calculated/$Filename`
}


writeobject() { 
	local FileName=$1
	local AddOnFolder=$2
	#echo $AddOnFolder
	if [[ ! -z ${ObjectArray[obj]} ]] ;then
		if [[ ${ObjectArray[obj]} == "vehicle" || ${ObjectArray[obj]} == "Vehicle" ]];	then
			if [[ ${ObjectArray[freight]} == "Passagiere" || ${ObjectArray[freight]} == "passagiere"  || ${ObjectArray[freight]} == "Post"  || ${ObjectArray[freight]} == "post"  || ${ObjectArray[freight]} == "None"  || ${ObjectArray[freight]} == "none" || -z ${ObjectArray[freight]} ]];	then
				#`rm -f calculated/$Filename`
				echo "--- Writing Object: ${ObjectArray[name]} "

				# get directory where the dat file is located
				if [[ $AddOnFolder == 1 ]] ;then
					local calculateddir=../Pak/AddOn/$(dirname "$dat")/
				else
					local calculateddir=../Pak/$(dirname "$dat")/
				fi
				local calculatedextendeddir=calculatedextended/$(dirname "$dat")/
				# Create folder for *.dat or delete all old dats if folder already exists
				if [ ! -d $calculateddir ]; then
						mkdir -p $calculateddir
				fi
				if [ ! -d $calculatedextendeddir ]; then
						mkdir -p $calculatedextendeddir
				fi
				if [[ $AddOnFolder == "1" ]] ;then
					calculateddir="../Pak/AddOn"
					#echo "true"
				else
					calculateddir="../Pak"
					#echo "false"
				fi
				writevehicle $FileName $calculateddir
				echo >> $calculateddir/$(basename "$1")
				echo "---" >> $calculateddir/$(basename "$1")
			fi
		fi
	fi
}


echohelp() {
	echo "DatConverter Beta Version
Copies the pakset-directionary to a new location and dds not given values to dat files
Features:
!    constraint-groups: use exclamation marks in front of constraints to refer to a group
Commands:
-h   displays the help and stopp the program after that
-f   forcing new prices on vehicles
-a   converting the whole directionary
-v   converting all vehicles"
}



#main
	echo "==== Dat Converter ===="
	#reading the arguments
	ForcingNewValues=0
	ReadAll=0
	AllVehicles=0
	Help=0
	ReConvert=0
	for arg in "$@"; do
		if [[ $arg == "-f" ]];then
			ForcingNewValues=1
			echo "- -f Forcing New Prices"
		fi
		if [[ $arg == "-a" ]];then
			ReadAll=1
			echo "- -a Converting All Files"
		fi
		if [[ $arg == "-v" ]];then
			AllVehicles=1
			echo "- -v Converting All Vehicles"
		fi
		if [[ $arg == "-h" ]];then
			Help=1
			echo "- -h Display Help"
		fi
	done

	if [[ $Help == 1 ]];then
		echohelp
	else

		declare -A ReConvertList
		declare -A GoodsValueArray
		declare -A GoodsSpeedBonusArray
		declare -A GoodsWeigthArray
		echo "- Read Meta Files"
		readgoods
		SpeedBonusFile=`cat Speedbonus_Pak128Britain.tab | tr -d '\r'`

		
		readallfiles "../ToBeExported/*.dat"
		readallfiles "../ToBeExported/**/*.dat" -a
				
		echo "- Re-Converting The Files Affected By Constraint-Groups"
		ReConvert=1
		for ReFile in "${ReConvertList[@]}"; do
			echo "-- Performing Work At: "$ReFile
			readfile $ReFile
		done
		echo "==== Done ===="
	fi
unset IFS

