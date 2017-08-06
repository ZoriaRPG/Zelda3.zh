
//////////////////////////////////////
/// Splitting On Death             ///
/// v0.8.9                         ///
/// 20th June, 2016                ///
/// By: ZoriaRPG                   ///
////////////////////////////////////////////////////////////////////////////////////////
/// D0: Source Enemy ID.                                                             ///
/// D1: ID  of enemy to split into.                                                  ///
/// D2: Number of splits. i.e. On death, enemy D0 will split into D2 quantity of D1. ///
/// D3: A randomising factor for spawning the splits. Suggested value range: 2 to 5. ///
/// D4: Sound to play when enemy splits, from Quest->Audio->SFX/Misc                 ///
/// D5: If splitting a gleeok enemy, set this to '1' to ensure that it always spawns ///
///     at the system default coordinates.                                           ///
///                                                                                  ///
/// Requested by Cukeman on PureZC.net                                               ///
////////////////////////////////////////////////////////////////////////////////////////

//SplitOnDeath ffc a[]
//Loops
const int SPLTR_Q = 0;
const int SPLTR_W = 1; 
const int SPLTR_E = 2;
const int SPLTR_R = 3;
const int SPLTR_T = 4;
const int SPLTR_U = 5;
//X/Y Positions
const int SPLTR_X = 6;
const int SPLTR_Y = 7;

//SplitOnHit fff n[]
const int SPLTR_ENEM_BASE = 0;
const int SPLTR_ENEM_REPL = 1;

//Clamp values for constraints on spawning npcs on-screen.
//! If the defaults give you trouble, change them to 255, and 175, respectively. 
const int MAX_SPAWN_NPX_X = 255;
const int MAX_SPAWN_NPC_Y = 175;

const int FFC_TRIB_SPLIT_DEBUG_ON = 1;
const int GLEEOK_SPAWN_X = 112;
const int GLEEOK_SPAWN_Y =32;

ffc script SplitOnDeath {
	void run(int enem_id, int splits_into, int number_of_splits, int dist_flux, split_sfx, int gleeok_override ){
		npc n[2]; int a[10];
		Waitframes(5); //Enemies require five frames, to spawn.
		  // If a 'No Return' flag is set, and there are no enemies on the screen, 
		 //  cleanly exit the script and make the ffc slot available.
		if ( ( Screen->State[ST_ENEMYNORETURN] || Screen->State[ST_TEMPNORETURN] ) && !Screen->NumNPCs() ){
		    this->Data = 0; this->Script = 0; Quit();
		}
		while(true){
			for ( a[SPLTR_Q] = 1; a[SPLTR_Q] <= Screen->NumNPCs(); a[SPLTR_Q]++ ) {
				n[SPLTR_ENEM_BASE] = Screen->LoadNPC(a[SPLTR_Q]);
				if ( n[SPLTR_ENEM_BASE]->isValid() ) {
				      // If it's dying, not removed, and the correct enemy ID...
					if ( n[SPLTR_ENEM_BASE]->ID  == enem_id && n[SPLTR_ENEM_BASE]->HP < 1 && n[SPLTR_ENEM_BASE]->HP > -9999 && n[SPLTR_ENEM_BASE]->X != -32768 && n[SPLTR_ENEM_BASE]->Y != -32768 ) {
						a[SPLTR_X] = n[SPLTR_ENEM_BASE]->X; //Store its position, so that we know where to spawn its splits.
						a[SPLTR_Y] = n[SPLTR_ENEM_BASE]->Y;
						n[SPLTR_ENEM_BASE]->HitXOffset = -200; //Hide the source enemy.
						n[SPLTR_ENEM_BASE]->HitYOffset = -200;
						n[SPLTR_ENEM_BASE]->DrawXOffset = -200;
						n[SPLTR_ENEM_BASE]->DrawYOffset = -200;
						n[SPLTR_ENEM_BASE]->HP = -9999; //Kill the original enemy.
						Remove(n[SPLTR_ENEM_BASE]);
						Waitframes(1);
					
						for ( a[SPLTR_W] = 0; a[SPLTR_W] < number_of_splits; a[SPLTR_W]++ ) {
							n[SPLTR_ENEM_REPL] = Screen->CreateNPC(splits_into);  
							if ( gleeok_override && n[SPLTR_ENEM_REPL]->Type == NPCT_GLEEOK ) {
								//Force it to spawn where Gleeoks belong.
								n[SPLTR_ENEM_REPL]->X = GLEEOK_SPAWN_X; 
								n[SPLTR_ENEM_REPL]->Y = GLEEOK_SPAWN_Y;
							}
							else {
								n[SPLTR_ENEM_REPL]->X = Clamp(a[SPLTR_X]+Rand( (dist_flux * -1), dist_flux), 0, MAX_SPAWN_NPX_X), 
								n[SPLTR_ENEM_REPL]->Y = Clamp(a[SPLTR_Y]+Rand( (dist_flux * -1), dist_flux), 0, MAX_SPAWN_NPC_Y) ); 
							}
							if ( split_sfx ) Game->PlaySound(split_sfx);
							//if ( Game->GuyCount[Game->GetCurScreen()] < 10 ) Game->GuyCount[Game->GetCurScreen()]++;
						}
											
					}
				}
			} 
			if ( Game->GuyCount[Game->GetCurScreen()] != Screen->NumNPCs() ) Game->GuyCount[Game->GetCurScreen()] = Screen->NumNPCs(); 
			
			if ( ( Screen->State[ST_ENEMYNORETURN] || Screen->State[ST_TEMPNORETURN] ) && !Screen->NumNPCs() ) {
				this->Data = 0; this->Script = 0; Quit();
				// Free up the slot if we're done.
			}
			if (FFC_TRIB_SPLIT_DEBUG_ON) Screen->DrawInteger(6,4,4,FONT_Z1, 1, 0, 16, 16, Game->GuyCount[Game->GetCurScreen()], 0, 128);
			Screen->DrawInteger(6,12,4,FONT_Z1, 1, 0, 16, 16, Screen->NumNPCs(), 0, 128);				
			Waitframe();
		}
	}
}


const int DYING_ENEMY_NO_SPLIT = 0; //Set to '1' if you want to prevent dying enemies from spitting (from Split on Hit)

//////////////////////////////////////
/// Splitting When Hit             ///
/// v0.8.9                         ///
/// 20th June, 2016                ///
/// By: ZoriaRPG                   ///
////////////////////////////////////////////////////////////////////////////////////////
/// D0: Source Enemy ID.                                                             ///
/// D1: ID  of enemy to split into.                                                  ///
/// D2: Number of splits. i.e. When hit, enemy D0 will split into D2 quantity of D1. ///
/// D3: A randomising factor for spawning the splits. Suggested value range: 2 to 5. ///
/// D4: The sound to play when the enemy splits.                                     ///
/// D5: Set to '1' if you wish to prevent the enemy from splitting if it is dying.   ///
/// D6: If splitting a gleeok enemy, set this to '1' to ensure that it always spawns ///
///     at the system default coordinates.                                           ///
///                                                                                  ///
/// Requested by Cukeman on PureZC.net                                               ///
////////////////////////////////////////////////////////////////////////////////////////

ffc script SplitOnHit {
	void run(int enem_id, int splits_into, int number_of_splits, int dist_flux, split_sfx, int dying_no_split, int gleeok_override ){
		npc n[2]; int a[10];
		Waitframes(5); //Enemies require five frames, to spawn.
		  // If a 'No Return' flag is set, and there are no enemies on the screen, 
		 //  cleanly exit the script and make the ffc slot available.
		if ( ( Screen->State[ST_ENEMYNORETURN] || Screen->State[ST_TEMPNORETURN] ) && !Screen->NumNPCs() ){
		    this->Data = 0; this->Script = 0; Quit();
		}
		while(true){
			for ( a[SPLTR_Q] = 1; a[SPLTR_Q] <= Screen->NumNPCs(); a[SPLTR_Q]++ ) {
				n[SPLTR_ENEM_BASE] = Screen->LoadNPC(a[SPLTR_Q]);
				if ( n[SPLTR_ENEM_BASE]->isValid() ) {
				      // If it's dying, not removed, and the correct enemy ID...
					if ( n[SPLTR_ENEM_BASE]->ID  == enem_id && (
					( !DYING_ENEMY_NO_SPLIT && !dying_no_split ) || 
					( ( dying_no_split || DYING_ENEMY_NO_SPLIT ) && n[SPLTR_ENEM_BASE]->HP > 0 ) ) )
					{
						//Read lweapons, check collision, and see if the weapon is blocked
						for ( a[SPLTR_W] = 1; a[SPLTR_W] <= Screen->NumLWeapons(); a[SPLTR_W]++ ) { 
							//Read the lweapons on the screen, loadfing them
							lweapon l = Screen->LoadLWeapon(a[SPLTR_W]);
							if ( l->isValid() ) { //If it's valid
								if ( Collision(l,n[SPLTR_ENEM_BASE]) && l->CollDetection ) { 
									//Remove(l); //Kill the lweapon.
									l->CollDetection = false; //Stop it from colliding constantl;y. 
									//Check for collision with that weapon and the enemy
									//Check if any of the defs block this weapon.
									if ( n[SPLTR_ENEM_BASE]->Defense[ LWeaponToNPCD(l->ID) ] < 3 ) { 
										//Can be damaged by the weapon
										//for ( a[SPLTR_E] = 0; a[SPLTR_E] < number_of_splits; a[SPLTR_E]++ ) {
											//Read how many enemies to make, and make one per iteration.
										a[SPLTR_X] = n[SPLTR_ENEM_BASE]->X; //Store its position, so that we know where to spawn its splits.
										a[SPLTR_Y] = n[SPLTR_ENEM_BASE]->Y;
										n[SPLTR_ENEM_BASE]->HitXOffset = -200; //Hide the source enemy.
										n[SPLTR_ENEM_BASE]->HitYOffset = -200;
										n[SPLTR_ENEM_BASE]->DrawXOffset = -200;
										n[SPLTR_ENEM_BASE]->DrawYOffset = -200;

										n[SPLTR_ENEM_BASE]->HP = -9999; //Kill the original enemy.
										Remove(n[SPLTR_ENEM_BASE]);
											while(n[SPLTR_ENEM_BASE]->isValid()) Waitframe();
											//! Split on hit doesn't kill the original?
													//! Should it??!
											//We could add an arg for instant-kill though. ?
											//! Need this to avoid splitting if collision with that weapon. 
											//! No, we can red the defs and see if it's an one-shot, and nto split, if it is. 
											//! We ALREADY do this. NPCD_ONEHITKILL is '14', so it's > 3
											
											//! This may be funky with shielded enemies, too. 
										//}
										
										for ( a[SPLTR_E] = 0; a[SPLTR_E] < number_of_splits; a[SPLTR_E]++ ) {
											
											n[SPLTR_ENEM_REPL] = Screen->CreateNPC(splits_into);  
											if ( gleeok_override && n[SPLTR_ENEM_REPL]->Type == NPCT_GLEEOK ) {
												//Force it to spawn where Gleeoks belong.
												n[SPLTR_ENEM_REPL]->X = GLEEOK_SPAWN_X; 
												n[SPLTR_ENEM_REPL]->Y = GLEEOK_SPAWN_Y;
											}
											else {
												n[SPLTR_ENEM_REPL]->X = Clamp(a[SPLTR_X]+Rand( (dist_flux * -1), dist_flux), 0, MAX_SPAWN_NPX_X), 
												n[SPLTR_ENEM_REPL]->Y = Clamp(a[SPLTR_Y]+Rand( (dist_flux * -1), dist_flux), 0, MAX_SPAWN_NPC_Y) ); 
											}
											//if ( Game->GuyCount[Game->GetCurScreen()] < 10 ) Game->GuyCount[Game->GetCurScreen()]++;
											if ( split_sfx ) Game->PlaySound(split_sfx);
										}
							
									}
								}
							}
						}
					}
				}
			} 
			if ( Game->GuyCount[Game->GetCurScreen()] != Screen->NumNPCs() ) Game->GuyCount[Game->GetCurScreen()] = Screen->NumNPCs(); 
			
			if ( ( Screen->State[ST_ENEMYNORETURN] || Screen->State[ST_TEMPNORETURN] ) && !Screen->NumNPCs() ) {
				this->Data = 0; this->Script = 0; Quit();
				// Free up the slot if we're done.
			}
			if (FFC_TRIB_SPLIT_DEBUG_ON) Screen->DrawInteger(6,4,4,FONT_Z1, 1, 0, 16, 16, Game->GuyCount[Game->GetCurScreen()], 0, 128);
			Screen->DrawInteger(6,12,4,FONT_Z1, 1, 0, 16, 16, Screen->NumNPCs(), 0, 128);
			Waitframe();
		}
	}
}

//////////////////////////////////////
/// Tribble Enemies                ///
/// v0.8.9                         ///
/// 20th June, 2016                ///
/// By: ZoriaRPG                   ///
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Enemies using this script work similarly to Vires, and Zols, that split into tribble enemies.                     ///
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// D0: The enemy ID of the base enemy that will split when killed.                                                   ///
/// D1: The enemy that the main enemy becomes, when killed.                                                           ///
/// D2: The number of enemies the main enemy splits into.                                                             ///
/// D4: The ID of the enemy that D1 becomes when it 'tribbles up'. Set to '0' to use the main enemy (e.g. zols).      ///
/// D5: The ransomised distance to spawn the split-offs into.  Suggested value range: 2 to 5.                         ///
/// D6: The timer, for the split-offs, in frames. Thus, '240' would be 5 seconds.                                     ///
///	-> When enemy D0 dies, it splits into D2 quantity of enemy D1 at a distance of D0->X and D0->Y +/- D5 pixels. ///
///	-> Then, when the duration defined in D6 expires (it is set as a separate timer, on a per-enemy basis),       ///
///	-> D1 will transform into D4, unless D4 is not set to a positive value, in which case, it transforms into D0. ///
/// D7: The sound to play when an enemy splits, or tribbles. Decimal value is for splitting, integer for tribbling.   ///
///	Format: #####.xxxx Tribble Sound                                                                              ///
///             xxxxx.#### Split Sound                                                                                ///
///                                                                                                                   ///
/// Requested by: idontknow8 on PureZC.net                                                                            ///
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// Tribble FFC n[]
const int TRIB_BASE = 0;
const int TRIB_INTO = 1;
const int TRIB_BASE2 = 2;
const int TRIB_FINAL = 3;
const int TRIB_INIT = 4;


//Tribble NPC->Misc[]
const int TRIB_TIME = 3;

// Tribble FFC a[]
const int TRIB_Q = 0;
const int TRIB_W = 1; 
const int TRIB_E = 2;
const int TRIB_X = 4;
const int TRIB_Y = 5;
const int TRIB_BECOMES = 6;
const int TRIB_R = 7; 
const int TRIB_T = 8;
const int TRIB_SFX_SPLIT = 10;
const int TRIB_SFX_EVOLV = 11;

const int TRIB_TIME_DEFAULT = 240; 

ffc script BasicTribble{
	void run(int base_enemy, int tribbles_into, int num_tribbles, int tribbles_become, int waver, int trib_time, int split_sfx){
		int a[12]; //a vars array, for loops and stats
		npc n[6]; //an npc array
		a[10] = split_sfx << 0; 
		a[11] = (split_sfx - (split_sfx >> 0)) * 10000;
		//Handle making the splits of the main enemy tribble up.
		if ( tribbles_become <= 0 ) a[TRIB_BECOMES] = base_enemy; //Split-off enemies will turn into the main enemy, unless D3 is set.
		else a[TRIB_BECOMES] = tribbles_become;
		if ( trib_time < 1 ) trib_time = TRIB_TIME_DEFAULT;
		
		Waitframes(5); //Wait for npcsto spawn.
		if ( ( Screen->State[ST_ENEMYNORETURN] || Screen->State[ST_TEMPNORETURN] ) && !Screen->NumNPCs() ) {
			this->Data = 0; this->Script = 0; Quit();
		}
		
		//Initialise timers in any enemies that will tribnle upward that are on the screen when the ffc loads. 
		for ( a[TRIB_Q] = 1; a[TRIB_Q] <= Screen->NumNPCs(); a[TRIB_Q]++ ) { 
			n[TRIB_INIT] = Screen->LoadNPC(a[TRIB_Q]); //Load the enemy.
			if ( n[TRIB_INIT]->isValid()){ //Verify that it is valid...
				if ( n[TRIB_INIT]->ID == tribbles_into && !n[TRIB_INIT]->Misc[TRIB_TIME] ) n[TRIB_INIT]->Misc[TRIB_TIME] = trib_time; //If the timer is positive, decrement it. 
			}
		}
		
		//int makenew;
		
		while(true){
			//handle making the main enemy split.
			for ( a[TRIB_W] = 1; a[TRIB_W] <= Screen->NumNPCs(); a[TRIB_W]++ ) {
				n[TRIB_BASE] = Screen->LoadNPC(a[TRIB_W]); //Parse each npc onthe screen
				if ( n[TRIB_BASE]->isValid() ) {
					if ( n[TRIB_BASE]->HP <= 0 && n[TRIB_BASE]->HP > -9999 && n[TRIB_BASE]->ID == base_enemy && n[TRIB_BASE]->X != -32768 && n[TRIB_BASE]->Y != -32768){
						n[TRIB_BASE]->DrawXOffset = -200;
						n[TRIB_BASE]->DrawYOffset = -200;
						n[TRIB_BASE]->HitXOffset = -200;
						n[TRIB_BASE]->HitYOffset = -200;
						a[TRIB_X] = n[TRIB_BASE]->X;
						a[TRIB_Y] = n[TRIB_BASE]->Y;
						n[TRIB_BASE]->HP = -9999; //Kill the original.
						Remove(n[TRIB_BASE]);
						//makenew++;
						
						while ( n[TRIB_BASE]->isValid() ) { Waitframe(); } //A delay to make the spawning feel less insant...and prevent evil ZC issues. 
						
						for ( a[TRIB_E] = 0; a[TRIB_E] < num_tribbles; a[TRIB_E]++ ) {
							n[TRIB_INTO] = CreateNPCAt(tribbles_into, 
								Clamp(a[TRIB_X] + Rand( (waver * -1), waver ), 0, MAX_SPAWN_NPX_X),  
								Clamp(a[TRIB_Y] + Rand( (waver * -1), waver ), 0, MAX_SPAWN_NPC_Y ) ); //make the new enemies. 
							n[TRIB_INTO]->Misc[TRIB_TIME] = trib_time;
							if ( a[TRIB_SFX_SPLIT] ) Game->PlaySound(a[TRIB_SFX_SPLIT]);
							
							//if ( Game->GuyCount[Game->GetCurScreen()] < 10 ) Game->GuyCount[Game->GetCurScreen()]++;
						
						}

					}
				}
			}
			
			//Reduce timers, if they exist.
			for ( a[TRIB_R] = 1; a[TRIB_R] <= Screen->NumNPCs(); a[TRIB_R]++ ) { 
				//Count down the individual enemy timers.
				n[TRIB_BASE2] = Screen->LoadNPC(a[TRIB_R]); //Load the enemy.
				if ( n[TRIB_BASE2]->isValid()){ //Verify that it is valid...
					if ( n[TRIB_BASE2]->ID == tribbles_into && n[TRIB_BASE2]->Misc[TRIB_TIME] > 0 ) n[TRIB_BASE2]->Misc[TRIB_TIME]--; //If the timer is positive, decrement it. 
				}
			}
			
			//Check to see if timers have reached zero. 
			for ( a[TRIB_T] = 1; a[TRIB_T] <= Screen->NumNPCs(); a[TRIB_T]++ ) { 
				n[TRIB_BASE2] = Screen->LoadNPC(a[TRIB_T]); //Load the enemy.
				if ( n[TRIB_BASE2]->isValid()){ //Verify that it is valid...
					if ( n[TRIB_BASE2]->ID == tribbles_into && n[TRIB_BASE2]->Misc[TRIB_TIME] <= 0  && n[TRIB_BASE2]->HP > 0) {
						//if the timer for a specific enemy has run out...transform it.
						a[TRIB_X] = n[TRIB_BASE2]->X;
						a[TRIB_Y] = n[TRIB_BASE2]->Y;
						n[TRIB_BASE2]->DrawXOffset = -200; //Hide the main enemy.
						n[TRIB_BASE2]->DrawYOffset = -200;
						n[TRIB_BASE2]->HitXOffset = -200;
						n[TRIB_BASE2]->HitYOffset = -200;
						
						n[TRIB_BASE2]->HP = -9999;
						Remove(n[TRIB_BASE2]);
							//...the spawn its replacement. 
						while ( n[TRIB_BASE2]->isValid() ) { Waitframe(); } //A delay to make the spawning feel less insant...and prevent evil ZC issues. 
						
						n[TRIB_FINAL] = CreateNPCAt(a[TRIB_BECOMES], a[TRIB_X], a[TRIB_Y]);
						if ( a[TRIB_SFX_EVOLV] ) Game->PlaySound(a[TRIB_SFX_EVOLV]);
						//break;
						//Waitframes(5);
						//if ( Game->GuyCount[Game->GetCurScreen()] < 10 ) Game->GuyCount[Game->GetCurScreen()]++;
						
					}
				}
			}
			if ( Game->GuyCount[Game->GetCurScreen()] != Screen->NumNPCs() ) Game->GuyCount[Game->GetCurScreen()] = Screen->NumNPCs(); 
			if ( ( Screen->State[ST_ENEMYNORETURN] || Screen->State[ST_TEMPNORETURN] ) && !Screen->NumNPCs() ) {
				this->Data = 0; this->Script = 0; Quit();
			}
			if (FFC_TRIB_SPLIT_DEBUG_ON) {
				Screen->DrawInteger(6,4,4,FONT_Z1, 1, 0, 16, 16, Game->GuyCount[Game->GetCurScreen()], 0, 128);
				Screen->DrawInteger(6,12,4,FONT_Z1, 1, 0, 16, 16, Screen->NumNPCs(), 0, 128);
			
			}
			Waitframe();
		}
	}
}
					

/////////////////////////////
///   Global Functions    /// 
///     for Splitting     /// 
/// and Tribbling Enemies ///
//////////////////////////////////////////////////////////////////
/// Call before Waitdraw();                                    ///
//////////////////////////////////////////////////////////////////


const int TRIBBLE_DIST_FLUX = 3;
const int NPCM_TRIBBLEUP_TO = 6; //Index to store the index to tribble up to.
const int NPCM_TRIBBLE_TIMER = 5; //Index to holsd the timer for tribbling up.
const int TRIBLE_TIME_DUR = 200; 

void TribbleEnemies(int waver, int trib_timer_dur){
	int list[]={1,10,2,16,	2,102,3,103,	40, 12, 2, 70};
		//Format: base_enemy, replace with, number of tribbles, tribbles_become
	npc n[2]; int a[6]; //a 0 = q, 1 = w, 2 = e; 3 = n->X, 4  = n->Y; 5 = r
	for ( a[0] = 1; a[0] <= Screen->NumNPCs(); a[0]++ ) {
                n[0] = Screen->LoadNPC(a[0]);
                if ( n[0]->isValid() ) {
                      // If it's dying, not removed, and the correct enemy ID...
			for ( a[1] = 0; a[1] < SizeOfArray(list); a[1]+=4 ) {
				//Parse the list looking for base enemies.
				if ( n[0]->ID  == list[a[1]] ) {
					if ( n[0]->HP < 1 && n[0]->HP > -9999 && n[0]->X != -32768 && n[0]->Y != -32768 ) {
						a[3] = n->X; //Store its position, so that we know where to spawn its splits.
						a[4] = n->Y;
						n[0]->HitXOffset = -200; //Hide the source enemy.
						n[0]->HitYOffset = -200;
						n[0]->DrawXOffset = -200;
						n[0]->DrawYOffset = -200;
						n[0]->HP = -9999; //Kill the original enemy.
						Remove(n[0]);
					
						//Read how many enemies to make, and make one per iteration.
						for ( a[5] = 0; a[5] < list[a[0]]+2; a[5]++ ) {
							n[1] = CreateNPCAt( list[a[0]+1], 
								Clamp(a[3]+Rand( (waver * -1), waver), 0, MAX_SPAWN_NPX_X),  
								Clamp(a[4]+Rand( (waver * -1), waver), 0, MAX_SPAWN_NPC_Y) ); //Reuse our pointer, instead of wasting one.
							n[1]->Misc[NPCM_TRIBBLEUP_TO] = list[a[0]+3]; //Store the ID of the enemy to trible it up to.
							n[1]->Misc[NPCM_TRIBBLE_TIMER] = trib_timer_dur;
							//if ( Game->GuyCount[Game->GetCurScreen()] < 10 ) Game->GuyCount[Game->GetCurScreen()]++;
						
						}
						
					}
				}
			}
			if ( n[0]->Misc[NPCM_TRIBBLEUP_TO] > 0 && n[0]->Misc[NPCM_TRIBBLE_TIMER] > 0 ) n[0]->Misc[NPCM_TRIBBLE_TIMER]--;
				//Reduce tribbling enemy timers.
			if ( n[0]->Misc[NPCM_TRIBBLEUP_TO] > 0 && n[0]->Misc[NPCM_TRIBBLE_TIMER] == 0 ) {
				//Cause it to tribble upward.
				a[3] = n->X; //Store its position, so that we know where to spawn its splits.
				a[4] = n->Y;
				n[0]->HitXOffset = -200; //Hide the source enemy.
				n[0]->HitYOffset = -200;
				n[0]->DrawXOffset = -200;
				n[0]->DrawYOffset = -200;
				n[1] = CreateNPCAt(n[0]->Misc[NPCM_TRIBBLEUP_TO], 
					Clamp(a[3] + Rand( (waver * -1), waver ), 0, MAX_SPAWN_NPX_X), 
					Clamp(a[4] + Rand( (waver * -1), waver ), 0, MAX_SPAWN_NPC_Y)); //make the new enemies. 
				n[0]->HP = -9999; //Kill the original enemy.
				Remove(n[0]);
			}
				
		}
	}
	//if ( Game->GuyCount[Game->GetCurScreen()] != Screen->NumNPCs() ) Game->GuyCount[Game->GetCurScreen()] = Screen->NumNPCs(); 
}

//Split on Death globally

const int SPLITONDEATH_DIST_FLUX = 3;

void SplitOnDeath(int dist_flux){
	int list[]={1,10,2,	2,102,3,	40, 12, 5};
		//Format: base_enemy, replace with, number of replacements
	npc n[2]; int a[6]; //a 0 = q, 1 = w, 2 = e; 3 = n->X, 4  = n->Y; 5 = r
	for ( a[0] = 1; a[0] <= Screen->NumNPCs(); a[0]++ ) {
                n[0] = Screen->LoadNPC(a[0]);
                if ( n[0]->isValid() ) {
                      // If it's dying, not removed, and the correct enemy ID...
			for ( a[1] = 0; a[1] < SizeOfArray(list); a[1]+=3 ) {
				//Parse the list looking for base enemies.
				if ( n[0]->ID  == list[a[1]] ) {
					if ( n[0]->HP < 1 && n[0]->HP > -9999 && n[0]->X != -32768 && n[0]->Y != -32768 ) {
						
						a[3] = n->X; //Store its position, so that we know where to spawn its splits.
						a[4] = n->Y;
						n[0]->HitXOffset = -200; //Hide the source enemy.
						n[0]->HitYOffset = -200;
						n[0]->DrawXOffset = -200;
						n[0]->DrawYOffset = -200;
						n[0]->HP = -9999; //Kill the original enemy.
						Remove(n[0]);
					
						for ( a[2] = 0; a[2] < list[a[0]+2]; a[2]++ ) {
							//Read how many enemies to make, and make one per iteration.
							n[1] = CreateNPCAt( list[a[0]+1], 
								Clamp(a[3]+Rand( (dist_flux * -1), dist_flux), 0, MAX_SPAWN_NPX_X),
								Clamp(a[4]+Rand( (dist_flux * -1), dist_flux), 0, MAX_SPAWN_NPC_Y));
							//if ( Game->GuyCount[Game->GetCurScreen()] < 10 ) Game->GuyCount[Game->GetCurScreen()]++;
						
						}
				
					}
				}
			}
		}
	}
	//if ( Game->GuyCount[Game->GetCurScreen()] != Screen->NumNPCs() ) Game->GuyCount[Game->GetCurScreen()] = Screen->NumNPCs(); 
}


//Global Split on hit

const int SPLITONHIT_DIST_FLUX = 3;

void SplitOnHit(int dist_flux){
	int list[]={1,10,2,	2,102,3,	40, 12, 5};
		//Format: base_enemy, replace with, number of replacements
	npc n[2]; int a[8]; //a 0 = q, 1 = w, 2 = e; 3 = n->X, 4  = n->Y; 5 = r; 6 = t ; 7 = y
	for ( a[0] = 1; a[0] <= Screen->NumNPCs(); a[0]++ ) {
                n[0] = Screen->LoadNPC(a[0]);
                if ( n[0]->isValid() ) {
                      // If it's dying, not removed, and the correct enemy ID...
			for ( a[1] = 0; a[1] < SizeOfArray(list); a[1]+=3 ) {
				//Parse the list looking for base enemies.
				if ( n[0]->ID  == list[a[1]] && ( !DYING_ENEMY_NO_SPLIT || ( DYING_ENEMY_NO_SPLIT && n[0]->HP > 0 ) ) ) {
					//Read lweapons, check collision, and see if the weapon is blocked
					for ( a[6] = 1; a[6] <= Screen->NumLWeapons(); a[6]++ ) { 
						//Read the lweapons on the screen, loadfing them
						lweapon l = Screen->LoadLWeapon(a[6]);
						if ( l->isValid() ) { //If it's valid
							if ( Collision(l,n[0]) ) { 
								//Check for collision with that weapon and the enemy
								//Check if any of the defs block this weapon.
								if ( n[0]->Defense[ LWeaponToNPCD(l->ID) ] < 3 ) { 
									//Can be damaged by the weapon
									a[3] = n->X; //Store its position, so that we know where to spawn its splits.
									a[4] = n->Y;
									//if  ) {
										//n[0]->HitXOffset = -200; //Hide the source enemy.
										//n[0]->HitYOffset = -200;
										//n[0]->DrawXOffset = -200;
										//n[0]->DrawYOffset = -200;
										//n[0]->HP = -9999; //Kill the original enemy.
										//Remove(n[0]);
										
									for ( a[2] = 0; a[2] < list[a[0]+2]; a[2]++ ) {
										//Read how many enemies to make, and make one per iterations
										n[1] = CreateNPCAt( list[a[0]+1], 
											Clamp(a[3]+Rand( (dist_flux * -1), dist_flux), 0, MAX_SPAWN_NPX_X),
											Clamp(a[4]+Rand( (dist_flux * -1), dist_flux), 0, MAX_SPAWN_NPC_Y) );
										//if ( Game->GuyCount[Game->GetCurScreen()] < 10 ) Game->GuyCount[Game->GetCurScreen()]++;
						
									}
									
								}
							}
						}
					}
				}
			}
		}
	}
	//if ( Game->GuyCount[Game->GetCurScreen()] != Screen->NumNPCs() ) Game->GuyCount[Game->GetCurScreen()] = Screen->NumNPCs(); 
}

// Versions that accept an array pointer as an input. 

void TribbleEnemies(int waver, int trib_timer_dur, int list){
	//int list[]={1,10,2,16,	2,102,3,103,	40, 12, 2, 70};
		//Format: base_enemy, replace with, number of tribbles, tribbles_become
	npc n[2]; int a[6]; //a 0 = q, 1 = w, 2 = e; 3 = n->X, 4  = n->Y; 5 = r
	for ( a[0] = 1; a[0] <= Screen->NumNPCs(); a[0]++ ) {
                n[0] = Screen->LoadNPC(a[0]);
                if ( n[0]->isValid() ) {
                      // If it's dying, not removed, and the correct enemy ID...
			for ( a[1] = 0; a[1] < SizeOfArray(list); a[1]+=4 ) {
				//Parse the list looking for base enemies.
				if ( n[0]->ID  == list[a[1]] ) {
					if ( n[0]->HP < 1 && n[0]->HP > -9999 && n[0]->X != -32768 && n[0]->Y != -32768 ) {
						a[3] = n->X; //Store its position, so that we know where to spawn its splits.
						a[4] = n->Y;
						n[0]->HitXOffset = -200; //Hide the source enemy.
						n[0]->HitYOffset = -200;
						n[0]->DrawXOffset = -200;
						n[0]->DrawYOffset = -200;
						n[0]->HP = -9999; //Kill the original enemy.
						Remove(n[0]);
					
						//Read how many enemies to make, and make one per iteration.
						for ( a[5] = 0; a[5] < list[a[0]]+2; a[5]++ ) {
							n[1] = CreateNPCAt( list[a[0]+1], 
								Clamp(a[3]+Rand( (waver * -1), waver), 0, MAX_SPAWN_NPX_X),
								Clamp(a[4]+Rand( (waver * -1), waver), 0, MAX_SPAWN_NPC_Y) ); //Reuse our pointer, instead of wasting one.
							n[1]->Misc[NPCM_TRIBBLEUP_TO] = list[a[0]+3]; //Store the ID of the enemy to trible it up to.
							n[1]->Misc[NPCM_TRIBBLE_TIMER] = trib_timer_dur;
							//if ( Game->GuyCount[Game->GetCurScreen()] < 10 ) Game->GuyCount[Game->GetCurScreen()]++;
						
						}
						
					}
				}
			}
			if ( n[0]->Misc[NPCM_TRIBBLEUP_TO] > 0 && n[0]->Misc[NPCM_TRIBBLE_TIMER] > 0 ) n[0]->Misc[NPCM_TRIBBLE_TIMER]--;
				//Reduce tribbling enemy timers.
			if ( n[0]->Misc[NPCM_TRIBBLEUP_TO] > 0 && n[0]->Misc[NPCM_TRIBBLE_TIMER] == 0 ) {
				//Cause it to tribble upward.
				a[3] = n->X; //Store its position, so that we know where to spawn its splits.
				a[4] = n->Y;
				n[0]->HitXOffset = -200; //Hide the source enemy.
				n[0]->HitYOffset = -200;
				n[0]->DrawXOffset = -200;
				n[0]->DrawYOffset = -200;
				n[1] = CreateNPCAt(n[0]->Misc[NPCM_TRIBBLEUP_TO], 
					Clamp(a[3] + Rand( (waver * -1), waver ), 0, MAX_SPAWN_NPX_X),
					Clamp(a[4] + Rand( (waver * -1), waver ), 0, MAX_SPAWN_NPC_Y) ); //make the new enemies. 
				n[0]->HP = -9999; //Kill the original enemy.
				Remove(n[0]);
			}
				
		}
	}
	//if ( Game->GuyCount[Game->GetCurScreen()] != Screen->NumNPCs() ) Game->GuyCount[Game->GetCurScreen()] = Screen->NumNPCs(); 
}

//Split on Death globally

void SplitOnDeath(int dist_flux, int list){
	//int list[]={1,10,2,	2,102,3,	40, 12, 5};
		//Format: base_enemy, replace with, number of replacements
	npc n[2]; int a[6]; //a 0 = q, 1 = w, 2 = e; 3 = n->X, 4  = n->Y; 5 = r
	for ( a[0] = 1; a[0] <= Screen->NumNPCs(); a[0]++ ) {
                n[0] = Screen->LoadNPC(a[0]);
                if ( n[0]->isValid() ) {
                      // If it's dying, not removed, and the correct enemy ID...
			for ( a[1] = 0; a[1] < SizeOfArray(list); a[1]+=3 ) {
				//Parse the list looking for base enemies.
				if ( n[0]->ID  == list[a[1]] ) {
					if ( n[0]->HP < 1 && n[0]->HP > -9999 && n[0]->X != -32768 && n[0]->Y != -32768 ) {
						
						a[3] = n->X; //Store its position, so that we know where to spawn its splits.
						a[4] = n->Y;
						n[0]->HitXOffset = -200; //Hide the source enemy.
						n[0]->HitYOffset = -200;
						n[0]->DrawXOffset = -200;
						n[0]->DrawYOffset = -200;
						n[0]->HP = -9999; //Kill the original enemy.
						Remove(n[0]);
					
						for ( a[2] = 0; a[2] < list[a[0]+2]; a[2]++ ) {
							//Read how many enemies to make, and make one per iteration.
							n[1] = CreateNPCAt( list[a[0]+1], 
								Clamp(a[3]+Rand( (dist_flux * -1), dist_flux), 0, MAX_SPAWN_NPX_X), 
								Clamp(a[4]+Rand( (dist_flux * -1), dist_flux), 0 , MAX_SPAWN_NPC_Y) );
							//if ( Game->GuyCount[Game->GetCurScreen()] < 10 ) Game->GuyCount[Game->GetCurScreen()]++;
						
						}
				
					}
				}
			}
		}
	}
	//if ( Game->GuyCount[Game->GetCurScreen()] != Screen->NumNPCs() ) Game->GuyCount[Game->GetCurScreen()] = Screen->NumNPCs(); 
}


//Global Split on hit


void SplitOnHit(int dist_flux, int list){
	//int list[]={1,10,2,	2,102,3,	40, 12, 5};
		//Format: base_enemy, replace with, number of replacements
	npc n[2]; int a[8]; //a 0 = q, 1 = w, 2 = e; 3 = n->X, 4  = n->Y; 5 = r; 6 = t ; 7 = y
	for ( a[0] = 1; a[0] <= Screen->NumNPCs(); a[0]++ ) {
                n[0] = Screen->LoadNPC(a[0]);
                if ( n[0]->isValid() ) {
                      // If it's dying, not removed, and the correct enemy ID...
			for ( a[1] = 0; a[1] < SizeOfArray(list); a[1]+=3 ) {
				//Parse the list looking for base enemies.
				if ( n[0]->ID  == list[a[1]] && ( !DYING_ENEMY_NO_SPLIT || ( DYING_ENEMY_NO_SPLIT && n[0]->HP > 0 ) ) ) {
					//Read lweapons, check collision, and see if the weapon is blocked
					for ( a[6] = 1; a[6] <= Screen->NumLWeapons(); a[6]++ ) { 
						//Read the lweapons on the screen, loadfing them
						lweapon l = Screen->LoadLWeapon(a[7]);
						if ( l->isValid() ) { //If it's valid
							if ( Collision(l,n[0]) ) { 
								//Check for collision with that weapon and the enemy
								//Check if any of the defs block this weapon.
								if ( n[0]->Defense[ LWeaponToNPCD(l->ID) ] < 3 ) { 
									//Can be damaged by the weapon
									a[3] = n->X; //Store its position, so that we know where to spawn its splits.
									a[4] = n->Y;
									//if  ) {
										//n[0]->HitXOffset = -200; //Hide the source enemy.
										//n[0]->HitYOffset = -200;
										//n[0]->DrawXOffset = -200;
										//n[0]->DrawYOffset = -200;
										//n[0]->HP = -9999; //Kill the original enemy.
										//Remove(n[0]);
										
									for ( a[2] = 0; a[2] < list[a[0]+2]; a[2]++ ) {
										//Read how many enemies to make, and make one per iterations
										n[1] = CreateNPCAt( list[a[0]+1], 
											Clamp(a[3]+Rand( (dist_flux * -1), dist_flux), 0, MAX_SPAWN_NPX_X),
											Clamp(a[4]+Rand( (dist_flux * -1), dist_flux), 0, MAX_SPAWN_NPC_Y) );
										//if ( Game->GuyCount[Game->GetCurScreen()] < 10 ) Game->GuyCount[Game->GetCurScreen()]++;
						
									}
									
								}
							}
						}
					}
				}
			}
		}
	}
	//if ( Game->GuyCount[Game->GetCurScreen()] != Screen->NumNPCs() ) Game->GuyCount[Game->GetCurScreen()] = Screen->NumNPCs(); 
}

//std functions for this


//Convert an LWeapon ID to the related NPCD. Returns -1 on error. 
//Does not respect Stomp Boots (ZC limitation)
int LWeaponToNPCD(int ltype){
	if ( ltype == LW_ARROW ) return NPCD_ARROW;
	if ( ltype == LW_BEAM ) return NPCD_BEAM;
	if ( ltype == LW_BRANG ) return NPCD_BRANG;
	if ( ltype == LW_BOMBBLAST ) return NPCD_BOMB;
	if ( ltype == LW_CANEOFBYRNA ) return NPCD_BYRNA;
	if ( ltype == LW_FIRE ) return NPCD_FIRE;
	if ( ltype == LW_HAMMER ) return NPCD_HAMMER;
	if ( ltype == LW_HOOKSHOT ) return NPCD_HOOKSHOT;
	if ( ltype == LW_MAGIC ) return NPCD_MAGIC;
	if ( ltype == LW_REFBEAM ) return NPCD_REFBEAM;
	if ( ltype == LW_REFMAGIC ) return NPCD_REFMAGIC;
	if ( ltype == LW_REFFIREBALL ) return NPCD_REFFIREBALL;
	if ( ltype == LW_REFROCK ) return NPCD_REFROCK;
	if ( ltype == LW_SBOMBBLAST ) return NPCD_SBOMB;
	//if ( ltype == LW_STOMP ) return NPCD_STOMP;
	if ( ltype == LW_SWORD ) return NPCD_SWORD;
	if ( ltype == LW_WAND ) return NPCD_WAND;
	if ( ltype == LW_SCRIPT1 ) return NPCD_SCRIPT;
	if ( ltype == LW_SCRIPT2 ) return NPCD_SCRIPT;
	if ( ltype == LW_SCRIPT3 ) return NPCD_SCRIPT;
	if ( ltype == LW_SCRIPT4 ) return NPCD_SCRIPT;
	if ( ltype == LW_SCRIPT5 ) return NPCD_SCRIPT;
	if ( ltype == LW_SCRIPT6 ) return NPCD_SCRIPT;
	if ( ltype == LW_SCRIPT7 ) return NPCD_SCRIPT;
	if ( ltype == LW_SCRIPT8 ) return NPCD_SCRIPT;
	if ( ltype == LW_SCRIPT9 ) return NPCD_SCRIPT;
	if ( ltype == LW_SCRIPT10 ) return NPCD_SCRIPT;
	return -1;
}

//Concert an NPCD category to its related lweapon ID.
//Returns '100' if the LWeapon is a script type (as 2.50.2 doesn;t distinguish these indivually)
//Returns -1 on error.
//Does not respect Stomp Boots (ZC limitation)
int NPCDtoLWeapon(int ltype){
	if ( ltype == NPCD_ARROW ) return LW_ARROW;
	if ( ltype == NPCD_BEAM ) return LW_BEAM;
	if ( ltype == NPCD_BRANG ) return LW_BRANG;
	if ( ltype == NPCD_BOMB ) return LW_BOMBBLAST;
	if ( ltype == NPCD_BYRNA ) return LW_CANEOFBYRNA;
	if ( ltype == NPCD_FIRE ) return LW_FIRE;
	if ( ltype == NPCD_HAMMER ) return LW_HAMMER;
	if ( ltype == NPCD_HOOKSHOT ) return LW_HOOKSHOT;
	if ( ltype == NPCD_MAGIC ) return LW_MAGIC;
	if ( ltype == NPCD_REFBEAM ) return LW_REFBEAM;
	if ( ltype == NPCD_REFMAGIC ) return LW_REFMAGIC;
	if ( ltype == NPCD_REFFIREBALL ) return LW_REFFIREBALL;
	if ( ltype == NPCD_REFROCK ) return LW_REFROCK;
	if ( ltype == NPCD_SBOMB ) return LW_SBOMBBLAST;
	//if ( ltype == NPCD_STOMP ) return LW_STOMP;
	if ( ltype == NPCD_SWORD ) return LW_SWORD;
	if ( ltype == NPCD_WAND ) return LW_WAND;
	if ( ltype == NPCD_SCRIPT ) return 100; 
	return -1;
}
