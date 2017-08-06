ffc script SwitchHook{
	void run(int comboF, int affectEnemies, int sfx, int npcdt){
		
		int SwitchHookFFCs[]={1}; //List all the switchhook FFCs.
		int SwitchHookVars[50]; //Array to hold the main variables. 
		
		bool switching; //Enabled if there is a matching combo.
		
		ffc f;
		int q;
		npc n;
		lweapon l;
			
		
		//Initial script variables.
		
		//quitCounter //A countwer to use to end the script prematureSwitchHookVars[SWH_LY]. 
		//Not used// int layer; //We'll need this to do collision on layers other than 0.
		
		//if ( comboF == 0 ) comboF = CF_SWITCHHOOK; //We no longer need this, but we'll retain it (commented out) for the present. 
		
		//Switchchot combo at the start of the script. 
		//int SwitchHookVars[SWH_CMBX]; //X position.
		//int SwitchHookVars[SWH_CMBY]; //Y position.
		//int SwitchHookVars[SWH_CMBD]; //Combo Data
		//int SwitchHookVars[SWH_CMBS]; //Combo Solidity
		
		//Combo where Link is standing at the start of the script.
		//int SwitchHookVars[SWH_CMBLX]; //X position.
		//int SwitchHookVars[SWH_CMBLY]; //Y position
		//int SwitchHookVars[SWH_CMBLD]; //Data
		//int SwitchHookVars[SWH_CMBLS]; //Solidity
		//int SwitchHookVars[SWH_CMBL]; //Screen index (of 176)
		
		//Layer 1 Combos
		//SwitchHookVars[SWH_CMB1];
		//int SwitchHookVars[SWH_CMB1X]; //X position
		//int SwitchHookVars[SWH_CMB1Y];
		//int SwitchHookVars[SWH_CMB1D];
		//int SwitchHookVars[SWH_CMB1S];
		//int SwitchHookVars[SWH_CMB1LX]; //X position under Link.
		//int SwitchHookVars[SWH_CMB1LY]; //Y position
		//int SwitchHookVars[SWH_CMB1LD]; //Data
		//int SwitchHookVars[SWH_CMB1LS]; //Solidity
		//int SwitchHookVars[SWH_CMB1L]; //Screen index (of 176)
		//int SwitchHookVars[SWH_CMB1C]; //CSet
		//int SwitchHookVars[SWH_CMB1LC]; //Link combo CSet.
		
		//Layer 2 Combos
		//int SwitchHookVars[SWH_CMB2X];
		//int SwitchHookVars[SWH_CMB2Y];
		//int SwitchHookVars[SWH_CMB2D];
		//int SwitchHookVars[SWH_CMB2S];
		//int SwitchHookVars[SWH_CMB2LX]; //X position.
		//int SwitchHookVars[SWH_CMB2LY]; //Y position
		//int SwitchHookVars[SWH_CMB2LD]; //Data
		//int SwitchHookVars[SWH_CMB2LS]; //Solidity
		//int SwitchHookVars[SWH_CMB2L]; //Screen index (of 176)
		//int SwitchHookVars[SWH_CMB2C]; //CSet
		//int SwitchHookVars[SWH_CMB2LC]; //Link combo CSet.
		
		//Link positions.
		//int SwitchHookVars[SWH_LX];
		//int SwitchHookVars[SWH_LY];
		
		//Ghjost FFC locations
		//int SwitchHookVars[SWH_GHOST_FFC_X];
		//int SwitchHookVars[SWH_GHOST_FFC_Y];
		//int SwitchHookVars[SWH_FFC_ID];
		
		
		
		while( true ) {
			
			if ( Screen->NumLWeapons() ) { //If there are no weapons on the screen, ignore the pass. 
				//if ( NumLWeaponsOf(LW_HOOKSHOT) ) TraceS(str);
				
				for (q = 1; q <= Screen->NumLWeapons(); q++ ) { 	//Pass through the lweapons on the screen...
					l = Screen->LoadLWeapon(q); 		//...loading each one and...
					if ( l->ID == LW_HOOKSHOT ){			//if a hookshot lweapon is present...
				
											//Check for switchshot combos...
						
						//Parse layer 0:
						
						if ( SWITCHHOOK_USE_LAYER_0 ) {
							for (q = 0; q < 176; q++ ) { 	//Pass through the screen combos to find a match...
								SwitchHookVars[SWH_CMB] = Screen->ComboI[q]; 	//loading them along the way...
								if ( ( comboF && cmb == comboF ) || ( !comboF && cmb == CF_SWITCHHOOK ) ) { 	
												//If D0 is assigned a value above 0, check to see if it matches
												//that combo inherent flag, otherwise check if it matches the one
												//assigned to the constant CF_SWITCHSHOT.
									
												//If it does....
									
									if ( ComboCollision(q,l) ) {	//and there is collision between that combo and the hookshot...
										
									//!We need to check every layer...too..for combos on layers higher than 0. (?)
										l->DeadState = WDS_DEAD;	//Kill the hookshot.
										
										if ( sfx ) Game->PlaySound(sfx); //Play the sound defined in the item script,
										if ( !sfx && SFX_SWITCHHOOK ) Game->PlaySound(SFX_SWITCHHOOK);  //or the constant if the item editor arg isn't set.
											
										//Store Link's starting position.
										SwitchHookVars[SWH_LX] = CenterLinkX();
										SwitchHookVars[SWH_LY] = CenterLinkY();
											
										//Store the switchshot combo to move.
										SwitchHookVars[SWH_CMBX] = ComboX(q);	//The combo number for the for loop pass...
										SwitchHookVars[SWH_CMBY] = ComboY(q);	//... X and Y
										SwitchHookVars[SWH_CMBD] = Screen->ComboD[q]; //The original data of the switchhook combo.
										SwitchHookVars[SWH_CMBS] = Screen->ComboS[q]; //The original solidity of the switchshot combo. 
										
										//Store the combo datum for the combo that Link is on. 
										
										SwitchHookVars[SWH_CMBLD] = Screen->ComboD[ComboAt(Link->X, Link->Y)]; //The combo under Link.
										SwitchHookVars[SWH_CMBLS] = Screen->ComboS[ComboAt(Link->X, Link->Y)]; //The solidity of the combo under Link.
										SwitchHookVars[SWH_CMBLX] = GridX(SwitchHookVars[SWH_LX]); //The X position
										SwitchHookVars[SWH_CMBLY] = GridY(SwitchHookVars[SWH_LY]); //The Y position
										SwitchHookVars[SWH_CMBL] = ComboAt(SwitchHookVars[SWH_CMBLX],SwitchHookVars[SWH_CMBLY]); //The screen index for that combo (Nth of 176).
											
											
										//Change the combo where Link WAS, to the switchshot combo.
										Screen->ComboD[SwitchHookVars[SWH_CMBL]] = SwitchHookVars[SWH_CMBD]; //Set its data
										Screen->ComboS[SwitchHookVars[SWH_CMBL]] = SwitchHookVars[SWH_CMBS]; //and solidity.
										
										
										//Move Link to where the old switchshot combo that we moved, WAS.
										Link->X = SwitchHookVars[SWH_CMBX];
										Link->Y = SwitchHookVars[SWH_CMBY];
										
											
										//Change the combo where Link appears, to what he was on BEFORE moving
										
										if ( ALWAYS_USE_SPECIFIC_COMBO_LAYER_0 ) { 	//If we are using a predefined combo...
																//as set in user prefs. 
											Screen->ComboD[q] = CMB_SWITCHHOOK_UNDERCOMBO_D_LAYER_0; //Set its data
											Screen->ComboS[q] = CMB_SWITCHHOOK_UNDERCOMBO_S_LAYER_0; //and solidity.
										}
										
										else {	//Use the actual combo, from the screen (default behaviour). 
											Screen->ComboD[q] = SwitchHookVars[SWH_CMBLD]; //Set its data
											Screen->ComboS[q] = SwitchHookVars[SWH_CMBLS]; //and solidity.
										}
										
										this->Script = 0; //Free the FFC for later use.
										this->Data = 0;
										Quit();
									}
								}
							}
						}
							
						//Parse Layer 1
						
						if ( SWITCHHOOK_USE_LAYER_1 ) {
							for (q = 0; q < 176; q++ ) { 	//Pass through the screen combos to find a match...
								SwitchHookVars[SWH_CMB1] = GetLayerComboI(1,q); 	//loading them along the way...
								if ( ( comboF && cmb1 == comboF ) || ( !comboF && cmb1 == CF_SWITCHHOOK ) ) { 	
												//If D0 is assigned a value above 0, check to see if it matches
												//that combo inherent flag, otherwise check if it matches the one
												//assigned to the constant CF_SWITCHSHOT.
									
												//If it does....
									
									if ( ComboCollision(q,l) ) {	//and there is collision between that combo and the hookshot...
										
									//!We need to check every layer...too..for combos on layers higher than 0. (?)
										l->DeadState = WDS_DEAD;	//Kill the hookshot.
										
										if ( sfx ) Game->PlaySound(sfx); //Play the sound defined in the item script,
										if ( !sfx && SFX_SWITCHHOOK ) Game->PlaySound(SFX_SWITCHHOOK);  //or the constant if the item editor arg isn't set.
											
										//Store Link's starting position.
										SwitchHookVars[SWH_LX] = CenterLinkX();
										SwitchHookVars[SWH_LY] = CenterLinkY();
											
										//Store the switchshot combo to move.
										SwitchHookVars[SWH_CMB1X] = ComboX(q);	//The combo number for the for loop pass...
										SwitchHookVars[SWH_CMB1Y] = ComboY(q);	//... X and Y
										SwitchHookVars[SWH_CMB1D] = GetLayerComboD(1,q); //The original data of the switchhook combo.
										SwitchHookVars[SWH_CMB1S] = GetLayerComboS(1,q); //The original solidity of the switchshot combo. 
										SwitchHookVars[SWH_CMB1C] = GetLayerComboC(1,q); //The original CSet.
										
										//Store the combo datum for the combo that Link is on. 
										
										SwitchHookVars[SWH_CMB1LD] = GetLayerComboD(1,ComboAt(Link->X, Link->Y)); //The combo under Link.
										SwitchHookVars[SWH_CMB1LS] = GetLayerComboS(1,ComboAt(Link->X, Link->Y)); //The solidity of the combo under Link.
										SwitchHookVars[SWH_CMB1LX] = GridX(SwitchHookVars[SWH_LX]); //The X position
										SwitchHookVars[SWH_CMB1LY] = GridY(SwitchHookVars[SWH_LY]); //The Y position
										SwitchHookVars[SWH_CMB1L] = ComboAt(SwitchHookVars[SWH_CMB1LX],SwitchHookVars[SWH_CMB1LY]); //The screen index for that combo (Nth of 176).
										SwitchHookVars[SWH_CMB1LC] = GetLayerComboC(1,ComboAt(Link->X, Link->Y));
										
											
										//Change the combo where Link WAS, to the switchshot combo.
										SetLayerComboD(1,SwitchHookVars[SWH_CMB1L],SwitchHookVars[SWH_CMB1D]); //Set its data
										SetLayerComboS(1,SwitchHookVars[SWH_CMB1L],SwitchHookVars[SWH_CMB1S]); //and solidity.
										SetLayerComboC(1,SwitchHookVars[SWH_CMB1L],SwitchHookVars[SWH_CMB1C]); //and CSet.
										
										
										//Move Link to where the old switchshot combo that we moved, WAS.
										Link->X = SwitchHookVars[SWH_CMB1X];
										Link->Y = SwitchHookVars[SWH_CMB1Y];
										
											
										//Change the combo where Link appears, to what he was on BEFORE moving
										
										if ( ALWAYS_USE_SPECIFIC_COMBO_LAYER_1 ) { 	//If we are using a predefined combo...
																//as set in user prefs.
											
											SetLayerComboD(1,q,CMB_SWITCHHOOK_UNDERCOMBO_D_LAYER_1); //Set the combo data
											SetLayerComboS(1,q,CMB_SWITCHHOOK_UNDERCOMBO_S_LAYER_1); //and the solidity.
											SetLayerComboC(1,q,CMB_SWITCHHOOK_UNDERCOMBO_C_LAYER_1); //and CSet.
									
										}	
										
										else { 	//Use the actual combo from the screen (default behaviour)
											SetLayerComboD(1,q,SwitchHookVars[SWH_CMB1LD]); //Set the combo data
											SetLayerComboS(1,q,SwitchHookVars[SWH_CMB1LS]); //and the solidity.
											SetLayerComboC(1,q,SwitchHookVars[SWH_CMB1LC]); //and CSet.
										}

										
										this->Script = 0; //Free the FFC for later use.
										this->Data = 0;
										Quit();
									}
								}
							}
						}
						
						//Parse Layer 2
						
						if ( SWITCHHOOK_USE_LAYER_2 ) { //2
							for (q = 0; q < 176; q++ ) { 	//Pass through the screen combos to find a match...
								SwitchHookVars[SWH_CMB2] = GetLayerComboI(2,q); 	//loading them along the way...
								SwitchHookVars[SWH_CMB2X] = ComboX(q);	//The combo number for the for loop pass...
								SwitchHookVars[SWH_CMB2Y] = ComboY(q);	//... X and Y
								SwitchHookVars[SWH_LOC] = ComboAt(SwitchHookVars[SWH_CMB2X],SwitchHookVars[SWH_CMB2Y]);

								if ( ( comboF && cmb2 == comboF ) || ( !comboF && cmb2 == CF_SWITCHHOOK ) ) { 	
												//If D0 is assigned a value above 0, check to see if it matches
												//that combo inherent flag, otherwise check if it matches the one
												//assigned to the constant CF_SWITCHSHOT.
									
												//If it does....
									//SwitchHookVars[SWH_CMB]_under = 
									
									//if ( switching ) {
									if ( ComboCollision(loc,l) ) {	//and there is collision between that combo and the hookshot...
										
									//!We need to check every layer...too..for combos on layers higher than 0. (?)
										l->DeadState = WDS_DEAD;	//Kill the hookshot.
										
										if ( sfx ) Game->PlaySound(sfx); //Play the sound defined in the item script,
										if ( !sfx && SFX_SWITCHHOOK ) Game->PlaySound(SFX_SWITCHHOOK);  //or the constant if the item editor arg isn't set.
											
										//Store Link's starting position.
										SwitchHookVars[SWH_LX] = CenterLinkX();
										SwitchHookVars[SWH_LY] = CenterLinkY();
											
										//Store the switchshot combo to move.
										SwitchHookVars[SWH_CMB2X] = ComboX(q);	//The combo number for the for loop pass...
										SwitchHookVars[SWH_CMB2Y] = ComboY(q);	//... X and Y
										SwitchHookVars[SWH_CMB2D] = GetLayerComboD(2,q); //The original data of the switchhook combo.
										SwitchHookVars[SWH_CMB2S] = GetLayerComboS(2,q); //The original solidity of the switchshot combo. 
										SwitchHookVars[SWH_CMB2C] = GetLayerComboC(2,q); //The original CSet.
										
										//Store the combo datum for the combo that Link is on. 
										
										SwitchHookVars[SWH_CMB2LD] = GetLayerComboD(2,ComboAt(Link->X, Link->Y)); //The combo under Link.
										SwitchHookVars[SWH_CMB2LS] = GetLayerComboS(2,ComboAt(Link->X, Link->Y)); //The solidity of the combo under Link.
										SwitchHookVars[SWH_CMB2LX] = GridX(SwitchHookVars[SWH_LX]); //The X position
										SwitchHookVars[SWH_CMB2LY] = GridY(SwitchHookVars[SWH_LY]); //The Y position
										SwitchHookVars[SWH_CMB2L] = ComboAt(SwitchHookVars[SWH_CMB2LX],SwitchHookVars[SWH_CMB2LY]); //The screen index for that combo (Nth of 276).
										SwitchHookVars[SWH_CMB2LC] = GetLayerComboC(2,ComboAt(Link->X, Link->Y));
										
											
										//Change the combo where Link WAS, to the switchshot combo.
										SetLayerComboD(2,SwitchHookVars[SWH_CMB2L],SwitchHookVars[SWH_CMB2D]); //Set its data
										//SetLayerComboS(2,SwitchHookVars[SWH_CMB2L],SwitchHookVars[SWH_CMB2S]); //and solidity.
										
										//!Setting solidity on layer 2 crashes ZC....BUT
										//!the solidity seems to be preserved anyway.
										
										SetLayerComboC(2,SwitchHookVars[SWH_CMB2L],SwitchHookVars[SWH_CMB2C]); //and CSet.
										
										
										//Move Link to where the old switchshot combo that we moved, WAS.
										Link->X = SwitchHookVars[SWH_CMB2X];
										Link->Y = SwitchHookVars[SWH_CMB2Y];
										
											
										//Change the combo where Link appears, to what he was on BEFORE moving
										
										if ( ALWAYS_USE_SPECIFIC_COMBO_LAYER_2 ) { 	//If we are using a predefined combo...
																//as set in user prefs.
											
											SetLayerComboD(2,q,CMB_SWITCHHOOK_UNDERCOMBO_D_LAYER_2); //Set the combo data
											//SetLayerComboS(1,q,CMB_SWITCHHOOK_UNDERCOMBO_S_LAYER_2); //and the solidity.
											SetLayerComboC(2,q,CMB_SWITCHHOOK_UNDERCOMBO_C_LAYER_2); //and CSet.
									
										}

										else { 	//use the actual combo (default behaviour)										
											SetLayerComboD(2,q,SwitchHookVars[SWH_CMB2LD]); //Set the combo data
											//SetLayerComboS(2,q,SwitchHookVars[SWH_CMB2LS]); //and the solidity.
											SetLayerComboC(2,q,SwitchHookVars[SWH_CMB2LC]); //and CSet.
										}

										
										this->Script = 0; //Free the FFC for later use.
										this->Data = 0;
										Quit();
									}
								}
							}
						}
						
						//If we also switch enemies, check for those now.
			
						if ( affectEnemies && Screen->NumNPCs() ) { //If the item is allowed to switch enemies, and there are enemies on the screen...
							for (q = 1; q <= Screen->NumNPCs(); q++ ) {	//Parse through the enemies on the screen...
								n = Screen->LoadNPC(q);			//and load each...
								if ( l->ID == LW_HOOKSHOT && Collision(l,n) ) {	//...then check for collision.
									
									if ( 					//If the user option to use enemy defs to set enemies affected...
										( SWITCHHOOK_ENEMIES_REQUIRE_SPECIAL_DEFS && !npcdt && n->Defense[NPCD_HOOKSHOT] == NPCDT_SWITCHHOOK ) 
										||				//..either with a constant to define the NPCDT, or an item arg...
										( SWITCHHOOK_ENEMIES_REQUIRE_SPECIAL_DEFS && npcdt && n->Defense[NPCD_HOOKSHOT] == npcdt ) 
										||				//or all enemies are affected...
										( !SWITCHHOOK_ENEMIES_REQUIRE_SPECIAL_DEFS ) 
									) {
											//If enemies require a special NPC Defs flag, and either we're assigning one to the item via arg D3
											//or if we are using the constant NPCDT_SWITCHHOOK...
											//...or if enemies DO NOT require a special defs flag to be affected...
										
										if ( !SWITCHHOOK_JANKED_ENEMIES ) l->DeadState = WDS_DEAD;	//Kill the hookshot weapon so that the chain doesn't become a living thing...
										if ( sfx ) Game->PlaySound(sfx); //Play the sound defined in the item script,
										if ( !sfx && SFX_SWITCHHOOK ) Game->PlaySound(SFX_SWITCHHOOK);  //or the constant if the item editor arg isn't set.
										
										
										
										// Move the enemy, and Link...
										SwitchHookVars[SWH_NPC_X] = n->X;	//Store the enemy X/Y position...	
										int SwitchHookVars[SWH_NPC_Y] = n->Y;
										
										if ( SUPPORT_GHOSTED_ENEMIES ) { //If we also move the ghost ffc
											//Check for a ghost ffc where the enemy is located via collision:
											for (q = 1; q < 32; q++ ) {
												f = Screen->LoadFFC(q);
												//if we are reasonabSwitchHookVars[SWH_LY] sure that the enemy has a ghost ffc attached to it...
												if ( Collision(n,f) && f->Script && n->Misc[__GHI_GHZH_DATA_INDEX] ) {
													SwitchHookVars[SWH_FFC_ID] = q; //Store the ID of the for this enemy. 
												}
											}
										}
										
										int SwitchHookVars[SWH_LX] = Link->X;	//...and Link's X/Y position.
										int SwitchHookVars[SWH_LY] = Link->Y;
										
										n->X = -1; 		//Move the enemy offscreen for a moment...
										n->Y = -1;		//...to prevent collision with Link.
										
										//if ghost support is enabled...
										if ( SUPPORT_GHOSTED_ENEMIES ) {
											f = Screen->LoadFFC(SwitchHookVars[SWH_FFC_ID]); //Reload the ffc
											f->X = -1; //Move the ffc offscreen to prevent collision with Link
											f->Y = -1;
										}
										
										Link->X = npcX;		//Then move Link to where the enemy WAS...
										Link->Y = SwitchHookVars[SWH_NPC_Y];
										n->X = SwitchHookVars[SWH_LX]; 		//and the enemy to where Link WAS.
										n->Y = SwitchHookVars[SWH_LY];
										
										//if ghost support is enabled
										if ( SUPPORT_GHOSTED_ENEMIES ) { 
											f = Screen->LoadFFC(SwitchHookVars[SWH_FFC_ID]); //Find the ffc again
											f->X = SwitchHookVars[SWH_LX];
											f->Y = SwitchHookVars[SWH_LY];
										}
										
										
										
										this->Script = 0;	//Free the FFC by releasing the script...
										this->Data = 0;		//and combo assignment, then...
										Quit();			//terminate the FFC. 
									}
								}
							}
						}
						
					}
				}
			}
			if ( !NumLWeaponsOf(LW_HOOKSHOT) ) SwitchHookVars[SWH_QUITCOUNTER]++; //If there hasn;t been a hookshot on the screen this frame, bump the counter.
			if ( SwitchHookVars[SWH_QUITCOUNTER] >= FFC_SWITCHSHOT_QUIT_COUNTER ) break;	//and if it reaches 600, break the loop to exit the script, and free the ffc slot. 
			Waitframe();
			
			
		}
		this->Script = 0;	//If we reach this point, for any reason, free the FFC, and exit. 
		this->Data = 0;
		Quit();
	}
}