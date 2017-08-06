/////////////////////////
/// Zelda 3 King Zora ///
/// v0.3              ///
/// 18-Nov-2016       ///
/// By: ZoriaRPG      ///
/////////////////////////

///Graphics
const int TILE_KINGZORA_BASE = 0;
const int TILE_KINGZORA_OPENMOUTHBASE = 6;
const int SPRITE_KING_ZORA_SPLASH = 100;

//Sounds
const int SFX_KING_ZORA_RISES = 63;
const int SFX_KINGZORA_POST_RISE_SPLASH = 64; 
const int SFX_KINGZORA_OPEN_MOUTH = 65;

//Splash Sprite Random Distance
const int KINGZORA_SPLASH_X_WAVER = 32;
const int KINGZORA_SPLASH_Y_WAVER = 48;

//Script Settings
const int KINGZORA_SPLASH_ANIM_REPEAT = 12; //The number of times that the splash sprites repeat. 
const int KIGZORA_RISE_LOOP_DUR = 200; //The total duration of the animation, in frames. 
const int KINGZORA_INITIAL_RISE_TIME = 20; //Delays with water splashes before King Zora begins to rise. 
const int KINGZORA_RISE_CYCLE_MODULUS = 60; //The divsor that determines hor many frames to wait before drawing the
					//next row of tiles, and moving King Zora up a bit. 
const int KINGZORA_WAIT_OPEN_MOUTH = 40; //Frames after rising animation ends, before mouth opens. 

const int KINGZORA_ITEM_JUMP = 10; 

//Tango Window Styles

const int TANGO_SIZE_TINY = 4;
const int WINDOW_STYLE_KINGZORA_MAIN = 4;
const int WINDOW_STYLE_KINGZORA_TINY = 5;
const int WINDOW_STYLE_KINGZORA_ERROR= 6;



ffc script KingZora{ //zora npc id, initial distance minimum to run, item to sell, item cost, message, min distance for dialogue, Screen->D[reg] (-1 to repeat sale)
	void run(int npctype, int initdist, int giveitem, int cost, int msg, int distance, int reg){
		
		if ( reg > -1 && Screen->D[reg] ) { this->Data = 0; this->Script = 0; Quit(): }
		npc kingzora[20]; int buffer[256];
		int cost_str[5];
		
		
		itoa(cost_str,cost); //Store the cost of the item as text. 
		
		int msg1[]="I will sell you something good, for ";
		int msg2[]="rupees. What do you say?";
		strcpy(buffer,msg1);
		strcat(buffer,cost_str);
		strcat(buffer,msg2);
		//The string is now in the buffer.
		
		//Spawn King Zora
		
		//Init animation
		//screen rumbles 
		//water ripples
		
		//King zora rises
		
		
		
		kingzora[1] = Screen->CreateNPC(npctype);
		kingzora[1]->X = this->X;
		kingzora[1]->Y = this->Y;
		kingzora[1]->HitXOffset = -200;
		kingzora[1]->HitYOffset = -200;
		
		kingzora[1]->DrawYOffset = -200; //We'll move him in afterthe animation.
		
		
		kingzora[1]->Extend = 3;
		kingzora[1]->TileWidth = 3;
		kingzora[1]->TileHeight = 1; //We will make this 2, then 3, gradually.
		
		eweapon splash[12]; //the size of this array should match the constant 'KINGZORA_SPLASH_ANIM_REPEAT'.
		
		int q[4];
		
		while(true){
			
			while( DistXY(this) < initdist ) Waitframe(); //Wait until Link is close enugh.
			
			//shake screen, do ripples
			
			if ( !q[3] ) { //Don't do this more than one time.
				if ( SFX_KING_ZORA_RISES ) Game->PlaySound(SFX_KING_ZORA_RISES);
				for  q[0] = 1, q[0] < KIGZORA_RISE_LOOP_DUR; q++ ) {
					Screen->Quake = 2;
					for ( q[1] = 0; q[1] < KINGZORA_SPLASH_ANIM_REPEAT; q[1]++ ){
						//draw splashes
						splash[ q[1] ] = Screen->CreateLWeapon(LW_SPARKLE);
						splash[ q[1] ]->CollDetection = false;
						splash[ q[1] ]->UseSprite = SPRITE_KING_ZORA_SPLASH;
						splash[ q[1] ]->X = this->X + Rand(-KINGZORA_SPLASH_X_WAVER, KINGZORA_SPLASH_X_WAVER);
					`	splash[ q[1] ]->Y = this->Y + Rand(-KINGZORA_SPLASH_Y_WAVER, KINGZORA_SPLASH_Y_WAVER);
					}
					//King Zora Rises from the Deep
					kingzora[1]->DrawYOffset = this->Y + 32;
					if ( (q[0]-KINGZORA_INITIAL_RISE_TIME) % KINGZORA_RISE_CYCLE_MODULUS == 0 && q[0] != 0 ) { 
						if ( kingzora[1]->TileHeight != 3 ) kingzora[1]->TileHeight++; //add a row of tiles
						if ( kingzora[1]->DrawYOffset != kingzora[1]->Y ) kingzora[1]->DrawYOffset += 16; //and move him upward 
																//to simulate rising from the water.
					}
					Waitframe();
				}
				
				//Play the post-rise splash sound.
				if ( SFX_KINGZORA_POST_RISE_SPLASH ) Game->PlaySound(SFX_KINGZORA_POST_RISE_SPLASH);
				
				//Wait a few rames after rising		
				Waitframes(KINGZORA_WAIT_OPEN_MOUTH);
				//!!King Zora Opens his mouth, here. 
				
				//Play open mouth sound
				
				if ( SFX_KINGZORA_OPEN_MOUTH ) Game->PlaySound(SFX_KINGZORA_OPEN_MOUTH);
				
				q[3] = 1; // Mark that the animation sequence is complete.
			}
						
			

			
			
			
			if ( ( reg > -1 && !Screen->D[reg] ) && DistXY(this) < distance && ( Link->PressA || Link->PressB ) ) {
				//Open his mouth
				kingzora[1]->OriginalTile = TILE_KINGZORA_OPENMOUTHBASE;
			
				//Display the buffer string in a menu.
				if ( KingZoraMenu(cost,buffer) { 
					
					//Opens the menu and dialogues/
					//if it returns true, create the item. 
					item it = Screen->CreateItem(giveitem);
					it->X = -200;
					it->Y = this->Y;
					it->Jump = KINGZORA_ITEM_JUMP;
					it->Pickup = IP_HOLDUP; 
					WaitNoAction();
					it->X = Link->X; //Fall in a pseudo-3d arc, to Link
					while( !LinkCollision(it) ) {
						it->Y--; 
						WaitNoAction();
					}
					if ( reg > -1 ) Screen->D[reg] = 1; //Stop the player from buying the item twice, unless 'reg' is set to a neative value.  
				
				}
				else error();

			}
			Waitframe();
		}
	}
	
	bool KingZoraMenu(int cost, int str){
		int buffer[300];
		strcpy(buffer, str);
		
		//Display the buffer string in a menu.
		ShowString(buffer, WINDOW_SLOT_1, WINDOW_STYLE_KINGZORA_MAIN, 48, 48);
		
		//Give a yes/no choice.
		if ( yesno() ) {
			if ( cost <= Game->Counter[CR_RUPEES] ) {
				Game->DCounter[CR_RUPEES] -= cost;
				return true;
			//Compare cost to Game->Counter[CR_RUPEES]
			//if item sold, return true.
		}
		else return false;
	}
	bool yesno(){
		//the yes no menu.
		//Opens a submenu over the dialogue display.
		int y[]="@choice(1)Yes@26";
		int n[]="@choice(2)No@domenu(1)@suspend()";
		SetUpWindow(WINDOW_SLOT_2, WINDOW_STYLE_KINGZORA_TINY, 32, 32, TANGO_SIZE_TINY);
		Tango_LoadString(WINDOW_SLOT_2, y);
		Tango_AppendString(WINDOW_SLOT_2, n);
		
		while( !Tango_MenuIsActive() ) Waitframe();
	
		int slotState[278];
		int menuState[960];
		int cursorPos;
		Tango_SaveSlotState(WINDOW_SLOT_2, slotState);
		Tango_SaveMenuState(menuState);
	    
		int done = 0;
		int choice;
		
		while(true){
    
			while( Tango_MenuIsActive() ) {
				cursorPos=Tango_GetMenuCursorPosition();
				Waitframe();
			}
        
			choice = Tango_GetLastMenuChoice();
			if ( choice == 1 ) { // yes
				done = choice;
				menuArg = choice;
			}
			
			else if ( choice == 2 ) { //no
				done = choice;
				menuArg = choice;
			}
        

			if ( done ) {
				break;
			//	return choice;
			}
			else {
				Tango_RestoreSlotState(WINDOW_SLOT_1, slotState);
				Tango_RestoreMenuState(menuState);
				Tango_SetMenuCursorPosition(cursorPos);
			}
		}
	
		Tango_ClearSlot(WINDOW_SLOT_2);
		
		if ( done == 1 ) return true; //if yes, return true
		else return false;
	}
	void error(){
		//a dialogue that gives an error message.
		int err[]="Sorry, you seem to lack the funds to buy my marvelous goodies.";
		//clear slot 2 (the yes/no menu)
		Tango_ClearSlot(WINDOW_SLOT_1);
		Tango_ClearSlot(WINDOW_SLOT_2);
		//ShowMessage(err); //show the message in the slot used by the initial dialogue
		ShowString(err, WINDOW_SLOT_1, WINDOW_STYLE_KINGZORA_ERROR, 48, 48);
	}
}