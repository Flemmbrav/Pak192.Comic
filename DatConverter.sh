#!/bin/bash

# Structure of the file:
# - parameters for balancing
#   - buildings
#   - vehicles
# - general functions that don't have a single purpose and are used quite often
# - single use functions that run once the script starts
#   - functions related to reading the goods from the goods file
# - functions related to balancing
# - functions related to writing certain objects
# - the main function



#parameters for balancing

    #buildings

    	#will be used in case no class proporion is given in the dat file
   		BuildingClassProportion0=1
   		BuildingClassProportion1=4
   		BuildingClassProportion2=40
   		BuildingClassProportion3=50
   		BuildingClassProportion4=5

    #vehicles

		StandardComfort=(33 66 100 150 200)
		PriceForClasses=(33 66 100 150 200)

		StandardPayloadPerLength=8
		StandardPayloadPerLength0=3
		StandardPayloadPerLength1=6
		StandardPayloadPerLength2=8
		StandardPayloadPerLength3=10
		StandardPayloadPerLength4=12




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


#single use functions that run once the script starts

#functions related to reading the goods from the goods file

readgoods() {
	#opens the goods.dat file
	#creates a new GoodArray including all the parameters of a single good
	#runs readgoodline for each line in the file
	#saves the good to an array when it's fully read
	local GoodsFile=`cat pakset/buildings/factories/goods/goods.dat | tr -d '\r'`

	`rm -f calculated/pakset/buildings/factories/goods/goods.dat`
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
	#echo "Speed: $Speed ; GoodSpeedBonus: $GoodSpeedBonus ; SpeedBonus: $SpeedBonus"
	#calculate the speedbonus multiplied by 10.000
	Income=10000
	#calculate the income
	Income=$(( Income * Payload * GoodValue / 3 ))
	#lowering the multiplyer to times 10
	Income=$(( Income / 10 ))
	echo $Income
}













calculatepayload(){
	local dat=$1
	local length=8
	local width=3200

	if [[ ! -z ${ObjectArray[freight]} ]] ;then
	if [[ ${ObjectArray[freight]} -eq "Passagiere" || ${ObjectArray[freight]} -eq "passagiere" ]] ;then



		if [[ ! -z ${ObjectArray[payload]} ]] ;then
		#only write in the payload if it is given at all
			ObjectArray[payload[0]]=0
			ObjectArray[payload[1]]=0
			ObjectArray[payload[2]]=${ObjectArray[payload]}
		fi

		
		for i in {0..4} ;do
			if [[ ! -z ${ObjectArray[payload[$i]]} ]] ;then
				echo "payload[$i]=${ObjectArray[payload[$i]]}" >> calculated/$dat

				if [[ ! -z ${ObjectArray[comfort[$i]]} ]] ;then
					echo "comfort[$i]=${ObjectArray[comfort[$i]]}" >> calculated/$dat
				else
					if [[ 0 -eq ${ObjectArray[payload[$i]]} ]] ;then
						echo "comfort[$i]=0" >> calculated/$dat
						ObjectArray[comfort[$i]]=0
					else
						echo "comfort[$i]=${StandardComfort[$i]}" >> calculated/$dat
						ObjectArray[comfort[$i]]=${StandardComfort[$i]}
					fi
				fi
			fi
		done


		
		if [[ ! -z ${ObjectArray[catering_level]} ]] ;then
			echo "catering_level=${ObjectArray[catering_level]}" >> calculated/$dat
		fi



		if [[ -z ${ObjectArray[overcrowded_capacity]} ]] ;then

			if [[ ! -z ${ObjectArray[payload[0]]} ]] ;then

				if [[ ! -z ${ObjectArray[length]} ]] ;then
					length=${ObjectArray[length]}
				else
					length=0
				fi

				if [[ ${ObjectArray[waytype]} == track || ${ObjectArray[waytype]} == tram_track || ${ObjectArray[is_tall]} == 0 ]] ;then
					width=$(( $width * 2 / 3 ))
				fi
			fi

			# 3200*8=25.600*mm*tile/2
			local FreeSpace=$(( width * length ))
			#echo "Budget = $FreeSpace"
			for i in {0..4} ;do
				local PayloadI=0
				PayloadI=${ObjectArray[payload[$i]]}
				local ComfortI=0
				ComfortI=${ObjectArray[comfort[$i]]}
				local SpaceTaken=0
				SpaceTaken=$(( ComfortI * PayloadI * 9 / 2 ))
			#	echo "SpraceTaken = $SpaceTaken"
				FreeSpace=$(( FreeSpace -  SpaceTaken))
			done
			if [[ ! -z ${ObjectArray[power]} ]] ;then
				local PowerI=${ObjectArray[power]}
				PowerI=$(( PowerI * 4 ))
			#	echo "PowerI= $PowerI"
				FreeSpace=$(( FreeSpace - PowerI ))
			fi

			if [[ ! -z ${ObjectArray[has_front_cab]} ]] ;then
				if [[ ${ObjectArray[has_front_cab]} -eq 1 ]] ;then
					FreeSpace=$(( FreeSpace - 2500 ))
			#		echo "Frontcap = 2500"
				fi
			fi
			if [[ ! -z ${ObjectArray[has_rear_cab]} ]] ;then
				if [[ ${ObjectArray[has_rear_cab]} -eq 1 ]] ;then
					FreeSpace=$(( FreeSpace - 2500 ))
			#		echo "Rearcap = 2500"
				fi
			fi
			if [[ ! -z ${ObjectArray[catering_level]} ]] ;then
				FreeSpace=$(( FreeSpace - (${ObjectArray[catering_level]} * 1000 ) ))
			#	echo "Catering $((${ObjectArray[catering_level]} * 1000 ))"
			fi
			#echo "Result = $FreeSpace"
			if [[ 0 -gt $FreeSpace ]] ;then
				FreeSpace=0
			fi
			FreeSpace=$(( FreeSpace / 250 ))
			FreeSpace=$(( FreeSpace + length + length ))
			ObjectArray[overcrowded_capacity]=$FreeSpace
			#echo $FreeSpace


		fi
		echo "overcrowded_capacity=${ObjectArray[overcrowded_capacity]}" >> calculated/$dat
	fi
	fi

}

calculatevehicleincome(){
	local dat=$1


	local capaOC=${ObjectArray[overcrowded_capacity]}

	local payingcapa=$(( capaOC * 25 ))
		
	for i in {0..4} ;do
		if [[ ! -z ${ObjectArray[payload[$i]]} ]] ;then
			payingcapa=$(( ObjectArray[payload[$i]] * OPriceForClasses[$i] ))
		fi
	done
	payingcapa=$(( payingcapa / 100 ))
	#echo "test"
	local Income="$(getincome ${ObjectArray[freight]} $payingcapa ${ObjectArray[waytype]} ${ObjectArray[intro_year]} ${ObjectArray[speed]})"
	


	#get the value of the power installed, this is essentially the income of 
	local PowerValue=0
	if [[ ! -z ${ObjectArray[power]} ]] ;then
		local EffectivePower=${ObjectArray[power]}
		EffectivePower=$(( EffectivePower * 100 ))
		PowerValue="$(getincome "None" $EffectivePower ${ObjectArray[waytype]} ${ObjectArray[intro_year]} ${ObjectArray[speed]})"
		
		if [[ ! -z ${ObjectArray[engine_type]} ]] ;then
			if [[ ${ObjectArray[engine_type]} == "electric" ]] ;then
				PowerValue=$(( PowerValue  / 100 * 75 ))
			fi
		fi
		PowerValue=$(( PowerValue / 1000 ))
	fi
	
	Income=$(( Income + PowerValue ))


	#malus for passenger trains as they usually get higher average payload
	if [[ ${ObjectArray[freight]} == "Passagiere" ]] ;then
		Income=$(( Income / 100 * 110 ))
	fi

	echo $Income
}


calculatecosts(){
	local dat=$1
	#get the income of the vehicle by 1000 times

	Income=$(calculatevehicleincome $dat )
	#echo $Income
	#echo "lalala"

	#calculate the runningcosts
	local Cost=$(( Income + 10 * PowerValue ))
	local RunningCost=$(( Income + PowerValue ))
	RunningCost=$(( RunningCost / 4000 ))
	local speed=${ObjectArray[speed]}
	if [[ ${ObjectArray[is_tilting]} == 1 ]] ;then
		speed=$(( speed + 20 ))
	fi
	local LoadingTime=$(( Income / 300 ))
	LoadingTime=$(( LoadingTime * speed / 270 + LoadingTime / 2))
	LoadingTime=$(( LoadingTime / 150 ))

	local MinLoadingTime=$(( 10 + LoadingTime / 10 ))
	LoadingTime=$(( 10 + LoadingTime ))
	#the next two lines are for the experimental implementation of fix costs. The running costs will be reduced to 10%, while the fix costs are a nice guess on what they should look like. I did some short math on them, but it's very vague.
	#local FixCost=$(( RunningCost * 240 ))
	#speed=$(( speed - 10 ))
	local FixCost=$(( RunningCost * speed * 1000 / 700 ))
	RunningCost=$(( RunningCost / 10 ))
	if [[ $ForcingNewValues == 1 || $ForcingNewPrices == 1 ]];then
		echo "max_loading_time=$LoadingTime" >> calculated/$dat
		echo "min_loading_time=$MinLoadingTime" >> calculated/$dat
		echo "runningcost=$RunningCost" >> calculated/$dat
		echo "cost=$Cost" >> calculated/$dat
		echo "fixed_cost=$FixCost" >> calculated/$dat
	else
		#if [[ ! -z ${ObjectArray[loading_time]} ]] ;then
		#	echo "loading_time=${ObjectArray[loading_time]}" >> calculated/$dat
		#else
		#	echo "loading_time=$LoadingTime" >> calculated/$dat			
		#fi
		
		if [[ ! -z ${ObjectArray[min_loading_time]} ]] ;then
			echo "min_loading_time=${ObjectArray[min_loading_time]}" >> calculated/$dat
		else
			echo "min_loading_time=$MinLoadingTime" >> calculated/$dat				
		fi
		if [[ ! -z ${ObjectArray[max_loading_time]} ]] ;then
			echo "max_loading_time=${ObjectArray[max_loading_time]}" >> calculated/$dat
		else
			echo "max_loading_time=$LoadingTime" >> calculated/$dat			
		fi
		
		
		if [[ ! -z ${ObjectArray[runningcost]} ]] ;then
			echo "runningcost=${ObjectArray[runningcost]}" >> calculated/$dat
		else
			echo "runningcost=$RunningCost" >> calculated/$dat			
		fi
		if [[ ! -z ${ObjectArray[cost]} ]] ;then
			echo "cost=${ObjectArray[cost]}" >> calculated/$dat
		else
			echo "cost=$Cost" >> calculated/$dat
		fi
		if [[ ! -z ${ObjectArray[fixed_cost]} ]] ;then
			echo "fixed_cost=$FixCost" >> calculated/$dat
			#echo "fixed_cost=${ObjectArray[fixed_cost]}" >> calculated/$dat
		else
			echo "fixed_cost=$FixCost" >> calculated/$dat
		fi
		
		
	fi
}


writeconstraints() {
	Direction=$1
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
						echo "constraint[$Direction][$CounterAfter]=$Line" >> calculated/$dat
						CounterAfter=$(( CounterAfter + 1 ))						
					done
				else
					for Line in $File; do
						echo "constraint[$Direction][$CounterAfter]=$Line" >> calculated/$dat
						CounterAfter=$(( CounterAfter + 1 ))						
					done
				fi
			fi
			HasToBeRemade=1
			CounterBefore=$(( CounterBefore + 1 ))
			CounterAfter=$(( CounterAfter + 1 ))
		else
			echo "constraint[$Direction][$CounterAfter]=${ObjectArray["constraint[$Direction][$CounterBefore]"]}" >> calculated/$dat
			CounterBefore=$(( CounterBefore + 1 ))
			CounterAfter=$(( CounterAfter + 1 ))
		fi
	done
	if [[ $HasToBeRemade -eq 1 ]];then
		ReConvertList[$dat]=$dat
	fi
}


writeimages() {
	for Key in "${!ObjectArray[@]}"; do
		if [[ $Key =~ "image" ]];then
			if [[ ${ObjectArray[$Key]:0:2} == './' ]]; then
				ObjectArray[$Key]=${ObjectArray[$Key]:2:${#ObjectArray[$Key]}}
			fi
			echo "$Key=${ObjectArray[$Key]}" >> calculated/$dat
		fi
	done
	for Key in "${!ObjectArray[@]}"; do
		if [[ $Key =~ "livery" ]];then
			if [[ ${ObjectArray[$Key]:0:2} == './' ]]; then
				ObjectArray[$Key]=${ObjectArray[$Key]:2:${#ObjectArray[$Key]}}
			fi
			echo "$Key=${ObjectArray[$Key]}" >> calculated/$dat
		fi
	done
}













writeroadsign() {
	local dat=$1

	for Key in "${!ObjectArray[@]}"; do
		if [[ $Key =~ "is_prioritysignal=1" ]];then
			echo "is_signal=1" >> calculated/$dat
			echo "aspects=3" >> calculated/$dat
		elif [[ $Key =~ "is_longblocksignal=1" ]];then
			echo working_method=token_block >> calculated/$dat
		else
			echo "$Key=${ObjectArray[$Key]}" >> calculated/$dat
		fi

	done
}

writebuilding() {
	local dat=$1
	local HasClassProportion=0

	if [[ ObjectArray[type]=="res" || ObjectArray[type]=="com" ||ObjectArray[type]=="ind" ]];then
		for Key in "${!ObjectArray[@]}"; do
			if [[ $Key =~ "class_proportion" ]];then
				HasClassProportion=1
			fi
		done
	#echo "has class proportion: $HasClassProportion"
		if [[ HasClassProportion -eq 0 ]];then
			for Key in "${!ObjectArray[@]}"; do
				echo "$Key=${ObjectArray[$Key]}" >> calculated/$dat
			done

			echo "class_proportion[0]=$BuildingClassProportion0" >> calculated/$dat
			echo "class_proportion[1]=$BuildingClassProportion1" >> calculated/$dat
			echo "class_proportion[2]=$BuildingClassProportion2" >> calculated/$dat
			echo "class_proportion[3]=$BuildingClassProportion3" >> calculated/$dat
			echo "class_proportion[4]=$BuildingClassProportion4" >> calculated/$dat
		else
			copyobject
		fi
		#copyobject
	fi
}


writevehicle() {
	local dat=$1
	
#Object
	#the object being a vehicle is given by running this function
	echo "obj=vehicle" >> calculated/$dat
	#the name of the vehicle has to be given
	echo "name=${ObjectArray[name]}" >> calculated/$dat
	#only write the name of the author if it is given
	if [[ ! -z ${ObjectArray[copyright]} ]] ;then
		echo "copyright=${ObjectArray[copyright]}" >> calculated/$dat
	fi
	echo  >> calculated/$dat
#Dates
	#the intro year of the vehicle has to be given
	echo "intro_year=${ObjectArray[intro_year]}" >> calculated/$dat
	#only write in the intro month if it is given
	if [[ ! -z ${ObjectArray[intro_month]} ]] ;then
		echo "intro_month=${ObjectArray[intro_month]}" >> calculated/$dat
	fi
	#only write in the outro year if it is given
	if [[ ! -z ${ObjectArray[retire_year]} ]] ;then
		echo "retire_year=${ObjectArray[retire_year]}" >> calculated/$dat
	fi
	#only write in the outro month if it is given
	if [[ ! -z ${ObjectArray[retire_month]} ]] ;then
		echo "retire_month=${ObjectArray[retire_month]}" >> calculated/$dat
	fi
	echo  >> calculated/$dat
#Parameters
	#the waytype of the vehicle has to be given
	echo "waytype=${ObjectArray[waytype]}" >> calculated/$dat
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
	#length has to be given. This will return an error if not, but that's intended
	echo "length=${ObjectArray[length]}" >> calculated/$dat

	#only write in the engine type if it is given
	if [[ ! -z ${ObjectArray[engine_type]} ]] ;then
		echo "engine_type=${ObjectArray[engine_type]}" >> calculated/$dat
	fi
	#only write in the power if it is given
	if [[ ! -z ${ObjectArray[power]} ]] ;then
		echo "power=${ObjectArray[power]}" >> calculated/$dat
	fi
	echo  >> calculated/$dat
#Freigth
	#only write in the freigth if it is given
	if [[ ! -z ${ObjectArray[freight]} ]] ;then
		echo "freight=${ObjectArray[freight]}" >> calculated/$dat
	fi

	#calculate the payload and stuff
	calculatepayload $dat
	#calculate the costs and loading time
	calculatecosts $dat
	echo  >> calculated/$dat
	writeconstraints "prev"
	writeconstraints "next"
	echo  >> calculated/$dat
	#only write in the smoke if it is given
	if [[ ! -z ${ObjectArray[smoke]} ]] ;then
		echo "smoke=${ObjectArray[smoke]}" >> calculated/$dat
	fi
	#only write in the sound if it is given
	if [[ ! -z ${ObjectArray[sound]} ]] ;then
		echo "sound=${ObjectArray[sound]}" >> calculated/$dat
	fi


	#return images
	writeimages

#Extended extras only written when given in the dat file

	if [[ ! -z ${ObjectArray[range]} ]] ;then
		echo "range=${ObjectArray[range]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[axles]} ]] ;then
		echo "axles=${ObjectArray[axles]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[axle_load]} ]] ;then
		echo "axle_load=${ObjectArray[axle_load]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[brake_force]} ]] ;then
		echo "brake_force=${ObjectArray[brake_force]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[rolling_resistance]} ]] ;then
		echo "rolling_resistance=${ObjectArray[rolling_resistance]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[air_resistance]} ]] ;then
		echo "air_resistance=${ObjectArray[air_resistance]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[way_wear_factor]} ]] ;then
		echo "way_wear_factor=${ObjectArray[way_wear_factor]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[is_tall]} ]] ;then
		echo "is_tall=${ObjectArray[is_tall]}" >> calculated/$dat
	else
		echo "is_tall=1" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[has_front_cab]} ]] ;then
		echo "has_front_cab=${ObjectArray[has_front_cab]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[has_rear_cab]} ]] ;then
		echo "has_rear_cab=${ObjectArray[has_rear_cab]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[bidirectional]} ]] ;then
		echo "bidirectional=${ObjectArray[bidirectional]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[is_tilting]} ]] ;then
		echo "is_tilting=${ObjectArray[is_tilting]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[minimum_runway_length]} ]] ;then
		echo "minimum_runway_length=${ObjectArray[minimum_runway_length]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[fixed_maintenance]} ]] ;then
		echo "fixed_maintenance=${ObjectArray[fixed_maintenance]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[increase_maintenance_after_years]} ]] ;then
		echo "increase_maintenance_after_years=${ObjectArray[increase_maintenance_after_years]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[years_before_maintenance_max_reached]} ]] ;then
		echo "years_before_maintenance_max_reached=${ObjectArray[years_before_maintenance_max_reached]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[increase_maintenance_by_percent]} ]] ;then
		echo "increase_maintenance_by_percent=${ObjectArray[increase_maintenance_by_percent]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[tractive_effort]} ]] ;then
		echo "tractive_effort=${ObjectArray[tractive_effort]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[mixed_load_prohibition]} ]] ;then
		echo "mixed_load_prohibition=${ObjectArray[mixed_load_prohibition]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[available_only_as_upgrade]} ]] ;then
		echo "available_only_as_upgrade=${ObjectArray[available_only_as_upgrade]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[upgrade_price]} ]] ;then
		echo "upgrade_price=${ObjectArray[upgrade_price]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[upgrade]} ]] ;then
		echo "upgrade=${ObjectArray[upgrade]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[way_constraint_permissive]} ]] ;then
		echo "way_constraint_permissive=${ObjectArray[way_constraint_permissive]}" >> calculated/$dat
	fi
	if [[ ! -z ${ObjectArray[way_constraint_prohibitive]} ]] ;then
		echo "way_constraint_prohibitive=${ObjectArray[way_constraint_prohibitive]}" >> calculated/$dat
	fi
}













copyobject() {
	local FileName=$1
	`cp -f $Filename calculated/$Filename`
}


writeobject() { 
	local FileName=$1
	if [[ ! -z ${ObjectArray[obj]} ]] ;then
		if [[ ${ObjectArray[obj]} == "vehicle" || ${ObjectArray[obj]} == "Vehicle" ]];	then
			#`rm -f calculated/$Filename`
			echo "--- Writing Object: ${ObjectArray[name]} "

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
			writevehicle $FileName
			echo >> calculated/$1
			echo "---" >> calculated/$1
		elif [[ ${ObjectArray[obj]} == "roadsign" || ${ObjectArray[obj]} == "Roadsign" ]];	then
			echo "--- Writing Object: ${ObjectArray[name]} "
			local calculateddir=calculated/$(dirname "$dat")/
			local calculatedextendeddir=calculatedextended/$(dirname "$dat")/
			# Create folder for *.dat or delete all old dats if folder already exists
			if [ ! -d $calculateddir ]; then
				mkdir -p $calculateddir
			fi
			if [ ! -d $calculatedextendeddir ]; then
				mkdir -p $calculatedextendeddir
			fi
			writeroadsign $FileName
			echo >> calculated/$1
			echo "---" >> calculated/$1
		elif [[ ${ObjectArray[obj]} == "building" || ${ObjectArray[obj]} == "Building" ]];	then
			#`rm -f calculated/$Filename`
			echo "--- Writing Object: ${ObjectArray[name]}"
			local calculateddir=calculated/$(dirname "$dat")/
			local calculatedextendeddir=calculatedextended/$(dirname "$dat")/
			# Create folder for *.dat or delete all old dats if folder already exists
			if [ ! -d $calculateddir ]; then
				mkdir -p $calculateddir
			fi
			if [ ! -d $calculatedextendeddir ]; then
				mkdir -p $calculatedextendeddir
			fi
			writebuilding $FileName	
			echo >> calculated/$1
			echo "---" >> calculated/$1
		else
			copyobject
		fi
	else
		copyobject
	fi
}


















readallfiles() {
	local directionary=$1
	IFS='
	'
  for dat in $directionary ; do
		echo "-- Performing Work At: $dat "
		readfile $dat
	done
}


readfile() {
	#opens a file
	#creates a new ObjectArray
	#runs readline for each line in the file
	local Filename=$1
	local File=`cat $Filename | tr -d '\r'`

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













echohelp() {
	echo "DatConverter Beta Version
Copies the pakset-directionary to a new location and adds not given values to dat files
Features:
!    constraint-groups: use exclamation marks in front of constraints to refer to a group
Commands:
-h   displays the help and stopp the program after that
-f   forcing new values on vehicles
-p   only forcing new prices on vehicles
-a   converting the whole directionary
-v   converting all vehicles"
}



#main
	echo "==== Dat Converter ===="
	#reading the arguments
	ForcingNewValues=0
	ForcingNewPrices=0
	ReadAll=0
	AllVehicles=0
	Help=0
	ReConvert=0
	for arg in "$@"; do
		if [[ $arg == "-f" ]];then
			ForcingNewValues=1
			echo "- -f Forcing New Values"
		fi
		if [[ $arg == "-p" ]];then
			ForcingNewPrices=1
			echo "- -f Forcing New Prices"
		fi
		if [[ $arg == "-a" ]];then
			ReadAll=1
			echo "- -a Convertig All Files"
		fi
		if [[ $arg == "-v" ]];then
			AllVehicles=1
			echo "- -v Convertig All Vehicles"
		fi
		if [[ $arg == "-h" ]];then
			Help=1
			echo "- -h Display Help"
		fi
	done

	if [[ $Help == 1 ]];then
		echohelp
	else

		echo "- Creating Directionaries "
		IFS='
		'
		`rm -rf calculated/`
		#`rm -rf calculatedextended/`
		#mkdir -p calculatedextended/pakset
		mkdir -p calculated/pakset
		#mkdir -p calculatedextended/AddOn
		mkdir -p calculated/AddOn
		#`cp -rf pakset/* calculatedextended/pakset`
		`cp -rf pakset/* calculated/pakset`
		#`cp -rf AddOn/* calculatedextended/AddOn`
		`cp -rf AddOn/* calculated/AddOn`

		declare -A ReConvertList
		declare -A GoodsValueArray
		declare -A GoodsSpeedBonusArray
		declare -A GoodsWeigthArray
		echo "- Read Meta Files"
		readgoods
		SpeedBonusFile=`cat pakset/trunk/config/speedbonus.tab | tr -d '\r'`

		if [[ $ReadAll == 1 ]];then
			echo "- Edit All .dat Files"
			readallfiles 'pakset/*.dat'
			readallfiles 'pakset/**/*.dat'
			readallfiles 'pakset/**/**/*.dat'
			readallfiles 'pakset/**/**/**/*.dat'
			readallfiles 'pakset/**/**/**/**/*.dat'
			readallfiles 'AddOn/*.dat'
			readallfiles 'AddOn/**/*.dat'
			readallfiles 'AddOn/**/**/*.dat'
			readallfiles 'AddOn/**/**/**/*.dat'
			readallfiles 'AddOn/**/**/**/**/*.dat'
		else
			if [[ $AllVehicles == 1 ]] ;then
				echo "- Edit All Vehicle .dat Files "
				readallfiles 'pakset/384/vehicles/*.dat'
				readallfiles 'pakset/vehicles/**/*.dat'
				readallfiles 'AddOn/**/vehicles/**/*.dat'
			else	
				echo "- Edit Costoum .dat Files "

				readfile "pakset/buildings/city/ind_1tropic_1x2.dat"
				#readfile "pakset/vehicles/track/Tram_DUEWAG_Grossraumwagen.dat"
				#readfile "pakset/vehicles/narrowgauge/Car_1885_Piece_goods.dat"

				#readallfiles 'calculated/AddOn/britain/infrastruktur/*.dat'
				readallfiles 'AddOn/belgian/**/*.dat'
				#readallfiles 'calculated/AddOn/britain/vehicles/**/*.dat'
				#readallfiles 'calculated/AddOn/czech/vehicles/**/*.dat'
				#readallfiles 'calculated/AddOn/german/vehicles/**/*.dat'
				#readallfiles 'calculated/AddOn/japanese/*.dat'

				#readallfiles 'pakset/landscape/**/*.dat'
				#readallfiles 'ConvertTest/*.dat'
			fi
		fi
		echo "- Re-Converting The Files Affected By Constraint-Groups"
		ReConvert=1
		for ReFile in "${ReConvertList[@]}"; do
			echo "-- Performing Work At: "$ReFile
			readfile $ReFile
		done
		echo "==== Done ===="
	fi
unset IFS

