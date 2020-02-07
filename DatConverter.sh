#!/bin/bash
echo '====test====='



trim() {
	#removes unintentional white spaces
	#returns the string to the command line
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








	
readgoods() {
	#echo readgoods
	local GoodsFile=`cat pakset/buildings/factories/goods/goods.dat`
	#opens a file
	#creates a new ObjectArray
	#runs readline for each line in the file

	`rm -f calculated/pakset/buildings/factories/goods/goods.dat`
	declare -A GoodArray
	IFS='
	'
	for Line in $GoodsFile; do
  	PosMin=`expr index "$Line" '-'`
		if [ $PosMin -eq 1 ]
		then
			savegoodtoram
			#editobject
			#writeobject $Filename
			unset GoodArray
			declare -A GoodArray
		else 
			readgoodline $Line
		fi
	done
	savegoodtoram
	#editobject
	#writeobject $Filename
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
			#echo added 1 line from the comments
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
	#echo "Speed: $Speed ; GoodSpeedBonus: $GoodSpeedBonus ; SpeedBonus: $SpeedBonus"
	#calculate the speedbonus multiplied by 10.000
	if [ $SpeedBonus -eq 0 ];then
		Income=10000
	else
		Income=$(( (( Speed * 1000 / SpeedBonus ) - 1000 ) * ( GoodSpeedBonus ) + 10000 ))
	fi
	#calculate the income
	Income=$(( Income * Payload * GoodValue / 3 ))
	#lowering the multiplyer to times 10
	Income=$(( Income / 10 ))
	echo $Income
}













readallfiles() {
	local directionary=$1
	IFS='
	'
  for dat in $directionary ; do
		echo dat is: $dat
		readfile $dat
	done
}


readfile() {
	#opens a file
	#creates a new ObjectArray
	#runs readline for each line in the file
	local Filename=$1
	local File=`cat $Filename`

	`rm -f calculated/$Filename`
	declare -A ObjectArray
	local IFS='
	'
	for Line in $File; do
  	PosMin=`expr index "$Line" '-'`
		if [ $PosMin -eq 1 ]
		then
			writeobject $Filename
			unset ObjectArray
			declare -A ObjectArray
		else 
			readline $Line
		fi
	done
	if [[ ! -z ${ObjectArray[obj]} ]] ;then
		writeobject $Filename
	fi
	unset ObjectArray
}


readline() {
	#reads a line and adds it to the ObjectArray
	local Line="$1"
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
		Value=${Line:PosEq}
		Value="$(trim $Value)"
	  ObjectArray[$Name]=$Value
	fi
}


calculatecosts(){
	local dat=$1
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
		PowerValue=$(( PowerValue / 1000 ))
	fi
	#calculate the runningcosts
	#echo "$PowerValue ; $Income"
	local Cost=$(( Income + PowerValue ))
	local RunningCost=$(( ( Income + PowerValue ) / 3000 ))
	local LoadingTime=$(( Income / 300 ))

	echo "loading_time=$LoadingTime" >> calculated/$dat
	echo "runningcost=$RunningCost" >> calculated/$dat
	echo "cost=$Cost" >> calculated/$dat
}


writevehicle() {
	local dat=$1
	#echo klappt
	
#Object
	#the object being a vehicle is given by running this function
	echo "obj=vehicle" >> calculated/$dat
	#the name of the vehicle has to be given
	echo "name=${ObjectArray[name]}" >> calculated/$dat
	#only write the name of the author if it is given
	if [[ ! -z ${ObjectArray[copyright]} ]] ;then
		echo "copyright=${ObjectArray[copyright]}" >> calculated/$dat
	fi
	echo >> calculated/$dat
	#the waytype of the vehicle has to be given
	echo "name=${ObjectArray[waytype]}" >> calculated/$dat
	echo  >> calculated/$dat
#Dates
	#the intro year of the vehicle has to be given
	echo "intro_year=${ObjectArray[intro_year]}" >> calculated/$dat
	#only write in the intro month if it is given
	if [[ ! -z ${ObjectArray[intro_month]} ]] ;then
		echo "intro_month=${ObjectArray[intro_month]}" >> calculated/$dat
	fi
	#only write in the outro year if it is given
	if [[ ! -z ${ObjectArray[outro_year]} ]] ;then
		echo "outro_year=${ObjectArray[outro_year]}" >> calculated/$dat
	fi
	#only write in the outro month if it is given
	if [[ ! -z ${ObjectArray[outro_month]} ]] ;then
		echo "outro_month=${ObjectArray[outro_month]}" >> calculated/$dat
	fi
#Parameters
	#write the speed if given, else write the speed used in the speedbonus
	if [[ ! -z ${ObjectArray[speed]} ]] ;then
		echo "speed=${ObjectArray[speed]}" >> calculated/$dat
	else
		local SpeedBonus="$(getspeedbonus ${ObjectArray[waytype]} ${ObjectArray[intro_month]} )"
		echo "speed=$SpeedBonus" >> calculated/$dat
	fi
	#write the weigth if given, else write the 2t for every length
	if [[ ! -z ${ObjectArray[weight]} ]] ;then
		echo "weight=${ObjectArray[weight]}" >> calculated/$dat
	else
		local Weigth=${ObjectArray[length]}
		Weigth=$(( 2 * Weigth ))
		echo "weight=$Weigth" >> calculated/$dat
	fi
	#only write in the engine type if it is given
	if [[ ! -z ${ObjectArray[engine_type]} ]] ;then
		echo "engine_type=${ObjectArray[engine_type]}" >> calculated/$dat
	fi
	#only write in the power if it is given
	if [[ ! -z ${ObjectArray[power]} ]] ;then
		echo "power=${ObjectArray[power]}" >> calculated/$dat
	fi
	#only write in the gear if it is given
	if [[ ! -z ${ObjectArray[gear]} ]] ;then
		echo "gear=${ObjectArray[gear]}" >> calculated/$dat
	fi
	echo  >> calculated/$dat
#Freigth
	#only write in the freigth if it is given
	if [[ ! -z ${ObjectArray[freight]} ]] ;then
		echo "freight=${ObjectArray[freight]}" >> calculated/$dat
	fi
	#only write in the payload if it is given
	if [[ ! -z ${ObjectArray[payload]} ]] ;then
		echo "payload=${ObjectArray[payload]}" >> calculated/$dat
	fi
	#calculate the costs and loading time
	calculatecosts $dat
	echo  >> calculated/$dat
	#return constraints
	for Key in "${!ObjectArray[@]}"; do
		if [[ $Key =~ "Constraint" || $Key =~ "constraint" ]];then
			echo "$Key=${ObjectArray[$Key]}" >> calculated/$dat
		fi
	done
	echo  >> calculated/$dat
	#return images
	for Key in "${!ObjectArray[@]}"; do
		if [[ $Key =~ "Image" || $Key =~ "image" ]];then
			echo "$Key=${ObjectArray[$Key]}" >> calculated/$dat
		fi
	done

}


writeobject() { 
	echo "===new object==="
	local dat=$1

  # get directory where the dat file is located
  local calculateddir=calculated/$(dirname "$dat")/
  local calculatedextendeddir=calculatedextended/$(dirname "$dat")/
	# Create folder for *.dat or delete all old dats if folder already exists
	if [ ! -d $calculateddir ]; then
			mkdir -p $calculateddir
	fi
	if [ ! -d $calculatedextendeddir ]; then
			mkdir -p $calculatedextendeddir
	fi
	if [[ ${ObjectArray[obj]} == "vehicle" || ${ObjectArray[obj]} == "Vehicle" ]];	then
			writevehicle $dat
	else
		for key in "${!ObjectArray[@]}"; do
			echo "$key=${ObjectArray[$key]}" >> calculated/$1
		done
	fi
	echo "
---" >> calculated/$1
}



#main
	IFS='
	'
	`rm -rf calculated/`
	`rm -rf calculatedextended/`
	mkdir -p calculatedextended/pakset
	mkdir -p calculated/pakset
	mkdir -p calculatedextended/AddOn
	mkdir -p calculated/AddOn
	`cp -rf pakset/* calculatedextended/pakset`
	`cp -rf pakset/* calculated/pakset`
	`cp -rf AddOn/* calculatedextended/AddOn`
	`cp -rf AddOn/* calculated/AddOn`

	declare -A GoodsValueArray
	declare -A GoodsSpeedBonusArray
	declare -A GoodsWeigthArray
	readgoods
	SpeedBonusFile=`cat pakset/trunk/config/speedbonus.tab`

	
	#readallfiles 'calculated/AddOn/britain/infrastruktur/*.dat'
	readallfiles 'calculated/AddOn/britain/vehicles/**/*.dat'
	readallfiles 'calculated/AddOn/czech/vehicles/**/*.dat'
	readallfiles 'calculated/AddOn/german/vehicles/**/*.dat'
	readallfiles 'calculated/AddOn/japanese/*.dat'
	readallfiles 'calculated/AddOn/belgian/**/*.dat'

	#readallfiles 'pakset/vehicles/**/*.dat'


	#readfile "pakset/vehicles/narrowgauge/Electric_2008_Komet.dat"
	#readfile "pakset/vehicles/narrowgauge/Car_1885_Piece_goods.dat"

unset IFS

