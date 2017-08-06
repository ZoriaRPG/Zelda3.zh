const int GODDESS_CUBE_REG = 6;
const int GODDESS_CUBE_REVEAL_TIME = 300; 
const int GODDESS_CUBE_SPRITE = 10;
const int GODDESS_CUBE_SPRITE_X = 4;
const int GODDESS_CUBE_SPRITE_Y = 4;


ffc script GoddessCube{
	void run(int dmap, int screen, int swordlevel){
		int q; lweapon l; lweapon sprite; 
		if ( Screen->D[GODDESS_CUBE_REG] ){
			this->Data++; This->Script = 0;
			Quit();
		}
		while(true){
			if ( !Screen->D[GODDESS_CUBE_REG] ) {
				for ( q = 1; q <= Screen->NumLWeapons(); q++ ) {
					l = Screen->LoadLWeapon(q);
					if ( l->ID == LW_SWORD ) {
						if ( l->Level >= swordlevel ) {
							if ( Collision(l,this) ){
								//mark the reveal on this screen.
								Screen->D[GODDESS_CUBE_REG] = 1;
								//Animation effect
								sprite = Screen->CreateLWeapon(LW_SPARKLE); 
								sparkle->CollDetection = false;
								sparkle->UseSprite(GODDESS_CUBE_SPRITE);
								sparkle->X = this->X + GODDESS_CUBE_SPRITE_X ; sparkle->Y = this->Y + GODDESS_CUBE_SPRITE_Y;
								Waitframes(sprite->NumFrames);
								this->Data++;
								//Draw the reveal:
								
								for ( q = 0; q < GODDESS_CUBE_REVEAL_TIME; q++ ) {
									Screen->DrawScreen(7, DMapToMap(dmap), screen, 0, 0, 0); 
									FreezeAllExceptFFCs();
									SuspendGhostZH();
									WaitNoAction();
								}
								UnfreezeAll()
								ResumeGhostZH(); 
							}
						}
					}
				}
			}
			Waitframe();
		}
	}
}

ffc script GoddessChest{
	void run(){
		//If the chest is triggered...
		if ( Screen->D[GODDESS_CUBE_REG] ) {
			//if the chest is already opened, and the item taken...
			if ( Screen->State[ST_ITEM] ) { 
				ComboD[ComboAt(this->X,this->Y)] +=2;
				ComboT[ComboAt(this->X,this->Y)] = 0;
				ComboS[ComboAt(this->X,this->Y)] = 4;
			}
			//if the chest is unopened...
			else { //make the chest
				ComboD[ComboAt(this->X,this->Y)]++;
				ComboT[ComboAt(this->X,this->Y)] = CT_CHEST;
				ComboS[ComboAt(this->X,this->Y)] = 4;
			}
		}
	}
}
								
									