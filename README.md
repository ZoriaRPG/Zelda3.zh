
	Zelda3.zh README

	Premise:  A template quest and script set, for creating a 'Zelda 3' style quest, **sans-Z3 scrolling**.
	Note:     PLEASE DO NOT BEG FOR Z3 SCROLLING. That is outside the premise, and the scope of this project. 
	Purpose:  To facilitate a quest template that is preloaded with graphics, combo aliases, enemies
		  items, bosses, and various system mechanics so that the questmaker need not configure all
		  of these things manually. 
	Scope:    Quests in the 'Z3 style', such as 'Quest 744'. 
	Audience: Novice to Advanced user targets.
	Compiler: ZQuest, internal ZScript Parser, 2.50.x and higher. 
	Deps:     std.zh, std_update.zh ( ZQ < 2.54 ), ghost.zh, tango.zh, lweapon.zh, stdWeapons.zh, laser.zh, ZVersion.zh ( ZQ  < 2.54 ) 

	Working files will go into a path structure as follows:
	/
		Z3.cgf -- Configuration File
		Z3.zh -- Main import. 
		Z3.qst -- Quest File Template
		
		include/ -- Headers required by the  component scripts. 
		enemies/ -- Base Enemies
			bosses/ -- Boss Enemies
		npcs/ -- Villagers
		dialogue/ -- Dialogue Controls and Scripts
		items/ -- Link's Inventory
		
		
		system/ -- Primary Z3.zh system files. 
			mechanics/ -- The core of how various things interact.
			audio/ -- audio files ued by the system
			graphical/ -- Various visual effects
			tiles/ Tilesheets
		
		

			

	//Working

		StealItem_0.5.zs
		Chestgame.zs
		FFC_SplittersAndTribbles.zs
		heartjar_magicjar.zs
		FasterConveyors.zs
		Mirror_3.3.zs

	//Untested
		CaneOfByrna.zs
		ChestCallbacks.zs
		GOddessCube.zs
		Compass.zs
		PotionStacking.zs -- We can probably toss this one. 
		XtalSwitches.zs
		Z3_Items_Mirror_Byrna.zs
		Mirror_Cape_Byrna2.zs -- Duplication here. 
		HedgeClipReward.zs
		DeadRock.zs

	//Unfinished
		Cane of Somaria Components
			CaneOfSomaria.zs
			SomariaBlock.zs
			MovingBlocks.zs	
		KingZora.zs
		ScriptedHookshot.zs - Meant for Double-Hookshot
		Z3Items.zs
