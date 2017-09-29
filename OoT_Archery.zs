const int Z5ARCHERY_PAID = 1;
const int Z5ARCHERY_ANGLE = 2;
const int Z5ARCHERY_FRAME = 3;
const int Z5ARCHERY_ARROWITEM = 4;
const int Z5ARCHERY_BOWITEM = 5;
const int Z5ARCHERY_ARROWTILE = 6;
const int Z5ARCHERY_ARROWCSET = 7;

const int Z5ARCHERY_INPUT_DIVISOR = 6; 

const int Z5ARCHERY_ARROW_SPRITE = 70; //Blank sprite!!
const int Z5ARCHERY_ARROW_SFX = 63;




ffc script OoT_Archery{
	void run(int cost){
		
		int archery[256];
		item target[256];
		
		archery[Z5ARCHERY_ANGLE] = 270; //aiming straight up. 
		archery[Z5ARCHERY_FRAME] = 0;
		
		archery[Z5ARCHERY_ARROWITEM] = Z5Archery_GetHighestLevelItem(IC_ARROW);
		archery[Z5ARCHERY_BOWITEM] = Z5Archery_GetHighestLevelItem(IC_BOW);
		if ( archery[Z5ARCHERY_ARROWITEM] == -1 ) { 
			//Link does not have an arrow item!
			//Give an error!
		}
		if ( archery[Z5ARCHERY_BOWITEM] == -1 ) { 
			//Link does not have a bow item!
			//Give an error!
		}
		
		//Get the itemdata for the arrow. 
		itemdata id = Game->LoadItemData(archery[Z5ARCHERY_ARROWITEM]);
		archery[Z5ARCHERY_ARROWTILE] = id->Tile;
		archery[Z5ARCHERY_ARROWCSET] = id->CSet;
		
		lweapon arrow;
		
		while(true)
		{
			
			while (!archery[ZS_ARCHERY_PAID] ) { Waitframe(); }
			
			//Run the frame counter, used for modulus while aiming. 
			if ( archery[Z5ARCHERY_FRAME] < 60 ) {
				archery[Z5ARCHERY_FRAME]++;
			}
			else archery[Z5ARCHERY_FRAME] = 0;
			
			//Pay to begin the game.
			if ( LinkCollision(this) 
				
			{
				if ( PressArcheryButton() ) {
					if ( Game->Counter[CR_RUPEES] >= cost )
					{
						Game->DCounter[CR_RUPEES] -= cost;
						!archery[ZS_ARCHERY_PAID] = 1;
						continue;
					}
				}
				
			}
			//Aiming
			if ( Link->InputLeft && archery[Z5ARCHERY_FRAME] % Z5ARCHERY_INPUT_DIVISOR == 0 ) {
				if ( archery[Z5ARCHERY_ANGLE] > 0 ) archery[Z5ARCHERY_ANGLE]--;
				if ( archery[Z5ARCHERY_ANGLE] == 0 ) archery[Z5ARCHERY_ANGLE] = 359;
			}
			
			if ( Link->InputRight && archery[Z5ARCHERY_FRAME] % Z5ARCHERY_INPUT_DIVISOR == 0 ) {
				if ( archery[Z5ARCHERY_ANGLE] < 360 ) archery[Z5ARCHERY_ANGLE]++;
				if ( archery[Z5ARCHERY_ANGLE] == 359 ) archery[Z5ARCHERY_ANGLE] = 0;
			
			}
			
			//isValid() may not siffice. I may need to mark the actual weapons somehow. 
			if ( Link->PressA || Link->PressB && !arrow->isValid() ) 
			{
				arrow = Screen->GreateLWeapon(LW_ARROW);
				arrow->Angular = true;
				arrow->Angle = archery[Z5ARCHERY_ANGLE];
				arrow->UseSprite(Z5ARCHERY_ARROW_SPRITE); //A blank sprite. 
				Game->PlaySound(Z5ARCHERY_ARROW_SFX);
				arrow->X = Link->X;
				arrow->Y = Link->Y;
			}
			
			//Generate the target items.
			
				//The item actual locations are all 0,0. Their drawoffsets and hitoffsets are
				//moved by the script. 
				//All of the items exist at all times, so that it is easier to manipulate them
				//and make them dance.
			
			
			//draw the arrow tile. 
			
			if ( arrow->isValid() ) {
				Screen->DrawTile(Z5ARCHERY_ARROW_LAYER, arrow->X, arrow->Y, arrow->Tile, 1, 1, arrow->CSet,
				-1, -1, arrow->X+arrow->HitWidth, arrow->Y+arrow->HitWidth, archery[Z5ARCHERY_ANGLE], 0, true, OP_OPAQUE);
			}

			
			//Hit an item?
				//if our weapon collides with an item, remove it; if this does not invalidate its pointer
				//then we must use an lweapon flag to track these!
			
				//Check collision 
			
			//If collision:
			//item explodes
			
			//Award for this item
			
				//The item actual locations are all 0,0. Their drawoffsets and hitoffsets are
				//moved by the script. 
				//When an arrow is at the hit offsets of any of the items, move its X/Y to Link';s position,
				//destroy it with a particle effect, and move its drawoffsets offscreen.
			
			Waitframe();
		}
		
	}
	

	int Z5Archery_GetHighestLevelItem(int itemclass)
	{
		itemdata id;
		int ret = -1;
		int curlevel = -1000;
		//143 is default max items, increase if you add lots of your own
		for(int i = 0; i <= 255; i++)
		{
			id = Game->LoadItemData(i);
			if(id->Family != itemclass)
				continue;
			if(id->Level > curlevel)
			{
				curlevel = id->Level;
				ret = i;
			}
		}
		return ret;
	}
}