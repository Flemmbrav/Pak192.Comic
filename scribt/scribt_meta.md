dat file speceifics
	Able to be compiled by standard makeobj
	You can create a dat for extendended out of the comments
	You can figure the values to be calculated by a scribt from the comments
	You can comment the dat file with your own stuff
	Able to add extra features like "nicknames" for automatic transations
	Constraint groups
	Maybe even different values for different simutrans versions
		early implementation of "any" constraints with groups etc

Comment types

#!		things the user writes in there
	#!nocompile!ex, std			this object won't be compiled for extended nor standard
	#!donot!abc,xyz			the commands abc and xyz will not be overwritten by automatic values
								this is to make sure the author can adjust the balancing
	#!ex!abc					abc is a command that only will be used for experimental
								the scribt shall generate a dat file for both versions of the game. This part of the dat is to be able to store experimental specific commands. Some of them may as well be used to calculate stuff for standard.
								this command overwites the abc command set in the dat, if such exists
	#!alias!abc,xyz				this vehicles is part of the constraint-prev-groups abc and xyz
	#!alias[prev]!abc,xyz			this vehicles has the alias-groups abc and xyz as constraint[prev]
	#!alias[next]!abc,xyz			this vehicles has the alias-groups abc and xyz as constraint[next]
	
#=		things the scribt wrote
	#=alias[next][abc]=def,xyz	the in the constraint[next][x]= used vehicles def and xyz are part of the alias-group abc
								these will be replaced every time the scribt runs
	#=alias[prev][abc]=def,xyz	the in the constraint[prev][x]= used vehicles def and xyz are part of the alias-group abc
								these will be replaced every time the scribt runs
	#=generated=abc,xyz		the commands abc and xyz have been previously added or replaced by the scribt

#text						plain text used as comment


Scribts

	Figuring what needs to be recompiled
		Shall be done for every aspect of the compiling process
		new /changed dat files
		dat files that use an alias used in the old/new version of that dat
			shall not trigger itself over this again, unless it affects more with it
		changed png files
		re-compile changed files
		
		#should we do a list? or open every dat file each time?
		
	Balancing
		Balances for both games
		Opens global files for balancing
		calculates values
		writes them in there
		
	Converting to extended
		creates a new folder
		copies the png and dat, and converts the dat files
		copies the trunk in the folder and converts it to extended
		
	Compiling
		creates a new folder
		runs (extended or standard) makeobj over the files needed and copies the pak files in the folder
		copies the trunk in the folder
		