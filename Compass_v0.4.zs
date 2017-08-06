//Constants for checking if the screen changed. Uses Link->Misc[]
const int LM_SCREENCHANGED 	= 0;
const int LM_LASTSCREEN 	= 1; 
const int LM_LASTDMAP 		= 2;

//Call in the global active script before Witdraw.
//handles setting if the screeen changed this frame. 
//Set 'clear' to true to auto-clear. 
void LastScreen(bool clear){
	if ( Link->Misc[LM_LASTSCREEN] != Game->GetCurScreen() && Link->Misc[LM_LASTDMAP] != Game_>GetCurDMap() ) {
		Link->Misc[LM_LASTSCREEN] = Game->GetCurScreen();
		Link->Misc[LM_LASTDMAP] = Game_>GetCurDMap(); 
		Link->Misc[LM_SCREENCHANED] = 1;
	}
	else { 
		if ( clear ) Link->Misc[LM_SCREENCHANED] = 0;
	}
}

//Returns if the screen changed this frame. 
bool ScreenChanged(){ return ( Link->Misc[LM_SCREENCHANED] != 0 ); }

//Returns if the screen changed. 
//Toggle 'clear' to true to wipe it after checking if the screen did change. 
bool ScreenChanged(bool clear){ 
	if ( Link->Misc[LM_SCREENCHANED] ) {
		if ( clear ) Link->Misc[LM_SCREENCHANED] = 0;
		return true;
	}
}

////////////////////////
/// Compass Item SFX ///
////////////////////////


//Compass Function Sound Effects. Set using IDs from Quest->Audio->SFX
const int SFX_COMPASS_KEY 		= 0;
const int SFX_COMPASS_BOSSKEY		= 0;
const int SFX_COMPASS_MAP		= 0; 
const int SFX_COMPASS_DUNGEONITEM 	= 0;
const int SFX_COMPASS_TREASURE 		= 0;



//Checks if there is a special item on the current screen, and plays a sound if there is. 
//Call from global active script, before Waitdraw() as:
//	if ( ScreenChanged(true) && Screen->RoomType ) Compass();
int Compass(){
	//Popukate wit IDs of 'minor' treasures'
	int minortreasures[]={	
				I_RUPEE1, 	I_RUPEE5, 	I_RUPEE10, 	I_RUPEE20, 	I_RUPEE50, 
				I_RUPEE100, 	I_RUPEE200, 	I_BOMBAMMO1, 	I_BOMBAMMO4, 	I_BOMBAMMO8,
				I_BOMBAMMO30, 
	}
			
	//Populate with IDs of all dungeon item treasures. 
	int dungeonitems[]={
				I_HAMMER,	I_WAND
	}
	
	if ( HasCompass(Game->GetCurLevel) ) {
		if ( Screen->RoomType == RT_SPECIALITEM && !Screen->State[ST_ITEM] && !Screen->State[ST_SPECIALITEM] ) {
			if ( Screen->RoomData == I_MAP ) {
				if ( SFX_COMPASS_LITEM ) Game->PlaySound(SFX_COMPASS_MAP);
				return 1;
			}
			if ( Screen->RoomData == I_BOSSKEY ) {
				if ( SFX_COMPASS_LITEM ) Game->PlaySound(SFX_COMPASS_BOSSKEY);
				return 1;
			}
			else if ( Screen_>RoomData == I_KEY || Screen->RoomData == I_LKEY ) {
				if ( SFX_COMPASS_KEY ) Game->PlaySound(SFX_COMPASS_KEY);
				return 1;
			}
			else {
				for ( int q = 0; q < SizeOfArray(dungeonitems); q++ ) {
					if ( Screen->RoomData == dungeonitems[q] ) { 
						if ( SFX_COMPASS_DUNGEONITEM ) Game->PlaySound(SFX_COMPASS_DUNGEONITEM);
						return 1;
					}
				}
				for ( int q = 0; q < SizeOfArray(minortreasures); q++ ) {
					if ( Screen->RoomData == minortreasures[q] ) { 
						if ( SFX_COMPASS_TREASURE ) Game->PlaySound(SFX_COMPASS_TREASURE);
						return 1;
					}
				}
			}
		}
	}
	return 0;
}