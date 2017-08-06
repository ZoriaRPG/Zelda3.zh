//If we also switch normal ffcs, check for those now.
			
						if ( SWITCHHOOK_SUPPORT_NORMAL_FFCS ) { //If the item is allowed to switch enemies, and there are enemies on the screen...
							for (q = 1; q <= 32; q++ ) {	//Parse through the enemies on the screen...
								f = Screen->LoadFFC(q);			//and load each...
								bool match;
								for ( q = 0; q < SizeOfArray(SwitchHookFFCs); q++ ) {
									if ( f->Script == SwitchHookFFCs[q] && l->ID == LW_HOOKSHOT && Collision(l,n) )
										//if the switchhook collides with an ffc, and it is one on the listt...
									{	//...then check for collision.
										
										if ( sfx ) Game->PlaySound(sfx); //Play the sound defined in the item script,
										if ( !sfx && SFX_SWITCHHOOK ) Game->PlaySound(SFX_SWITCHHOOK);  //or the constant if the item editor arg isn't set.
										
										
									
									
										
										// Move the enemy, and Link...
										SwitchHookVars[SWH_FFC_X] = f->X;	//Store the enemy X/Y position...	
										SwitchHookVars[SWH_FFC_Y] = f->Y;
										
										
										SwitchHookVars[SWH_LX] = Link->X;	//...and Link's X/Y position.
										SwitchHookVars[SWH_LY] = Link->Y;
										
										f->X = -1; 		//Move the ffc offscreen for a moment...
										f->Y = -1;		//...to prevent collision with Link.
										
								
										
										Link->X = SwitchHookVars[SWH_FFC_X];		//Then move Link to where the enemy WAS...
										Link->Y = SwitchHookVars[SWH_FFC_Y];
										f->X = SwitchHookVars[SWH_LX]; 		//and the enemy to where Link WAS.
										f->Y = SwitchHookVars[SWH_LY];
										
										this->Script = 0;	//Free the FFC by releasing the script...
										this->Data = 0;		//and combo assignment, then...
										Quit();			//terminate the FFC. 
									}
								}
							}
						}