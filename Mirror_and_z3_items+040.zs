///////////////////////
/// Z3 Magic Mirror ///
/// v0.4.0          ///
/// 27-Nov-2016     ///
/// By: ZoriaRPG    ///
///////////////////////////////////////
/// Partial Rewrite of the Original ///
/// WarpFunctions.zh b1.1 from 2014 ///
/// originally made by request for  ///
/// Obderhode and used in the quest ///
/// 'The Three Whistles'            ///
///////////////////////////////////////
 
//! To-Do
//! Add in freeze flags and ghost suspension
 
 //! BUG 	If Link is warped onto an entrance/exit (cave walk down/u) warp tile, that tile will activate and he will 
 //! 		seem to walk in and out of a place then error out and return. 
 
 //v0.3x Changelog
 //v0.3.3 Modified the solidity tests for a far more fine tuned check. 
 //v0.3.4 Added a check to error if the player tries to use the mirron when standing on a cave combo, to prevent 
 //	warping onto an aligning cave combo in the light world.
 //0.3.5 Trimmed the solidity check slightly. 
 
/// Global Array
int Mirror[214747];

const int TEST_MIRROR_SPARKLE = 0;
const int MIRROR_SPARKLE_BEFORE_WAITDRAW = 0;

//Moon Pearl Goodies
const int I_MIRROR = 160; 
const int I_MOONPEARL = 200;
const int I_BUNNYRING = 201; //A wisp ring twith a LTM for Bunny Sprites
 
//Sound Effect Settings

const int MIRROR_WARP_SOUND_USES_ENHANCED_MUSIC 	= 0;
const int MIRROR_DUNEON_SOUND_USES_ENHANCED_MUSIC 	= 0; 

//Durations
const int MIRROR_WARP_FIRST_HALF_DUR 		= 180;
const int MIRROR_WARP_SECOND_HALF_DUR 		= 180; 
const int MIRROR_DUNGEON_WARP_FIRST_HALF_DUR 	= 180;  
const int MIRROR_DUNGEON_WARP_SECOND_HALF_DUR 	= 180;
const int SFX_WARP_ERROR_DUR 			= 80;

//Sound Effect IDs
const int SFX_WARP_ERROR 			= 67;
const int SFX_MIRROR_WARP_START 		= 73; 
const int SFX_MIRROR_WARP_FINISH 		= 74;
const int SFX_MIRROR_WARP_DUNGEON_START 	= 75; 
const int SFX_MIRROR_WARP_DUNGEON_FINISH 	= 76;

//ZStrings for the Enhanced Music filenames
const int MUS_MIRROR_WARP_START 		= 20; 
const int MUS_MIRROR_WARP_FINISH 		= 21; 
const int MUS_MIRROR_WARP_DUNGEON_START 	= 22; 
const int MUS_MIRROR_WARP_DUNGEON_FINISH 	= 23; 

//Enhanced Music Tracks
const int MUS_MIRROR_WARP_START_TRACK 		= 1;
const int MUS_MIRROR_WARP_FINISH_TRACK 		= 1;
const int MUS_MIRROR_WARP_DUNGEON_START_TRACK 	= 1;
const int MUS_MIRROR_WARP_DUNGEON_FINISH_TRACK 	= 1;

 
//Options
const int WARP_RETURNS_ON_INJURY		= 1;
const int REQUIRE_MOON_PEARL 			= 1; 
const int MIRROR_RETURNS_TO_DUNGEON_ENTRANCE 	= 1; //This requires placing a warp return square on dungeon entrance screens.
 
const int MIRROR_POST_WARP_TIMER_NUM_FRAMES = 75; // Number of frames afer warping, before Link may use a warp return sparkle.

const int POST_WARP_LINK_IS_INVINCIBLE 		= 0;     //If se tto '1', Link->CollDetection will be disabled for a number of
                        //frames equal to:
 
const int WARP_INVULNERABILITY_FRAMES 		= 90; //Number of frames that Link is invulnerable after warping.
 
//!! Caution: This may conflict with other items that grant invulnerability!

const int SF_FORBID_MIRROR = 0; //A script screen flag to forbid usin the mirror. 
 
///Constants for Array Indices of Mirror[]
 
const int IS_WARPING 			= 0;
const int AFTER_WARP 			= 1;
const int RETURN_WARP 			= 2;
const int AFTER_RETURN_WARP 		= 3;
const int DUNGEON_WARP 			= 4;
 
const int WARP_SPARKLE 			= 10;
const int WARP_SPARKLE_DMAP 		= 11;
const int WARP_SPARKLE_SCREEN 		= 12;
const int WARP_SPARKLE_X 		= 13;
const int WARP_SPARKLE_Y 		= 14;
const int WARP_SPARKLE_RETURN_DMAP 	= 15;
 
const int WARP_LINK_X 			= 20;
const int WARP_LINK_Y 			= 21;
const int WARP_LINK_Z 			= 22;
const int WARP_LINK_HP 			= 23;
const int WARP_LINK_TEMP_INVULNERABILITY = 24;
 
const int MIRROR_SPARKLE_COMBO_FRAME 	= 30; //Mirror array index
const int MIRROR_POST_WARP_TIMER 	= 40;


 
//Animation Settings

const int WARP_WAVE_DUR 	= 100; //Duration of warp wavy animation (overworld)
const int WARP_WAVE_DUR_DUNGEON = 100; //Duration of warp wavy animation (inside dungeons)
 
const int WARP_DUR 		= 60;
const int POST_WARP_DELAY 	= 15;

 
//Mirror Sparkle Settings
const int MIRROR_SPARKLE_COMBO 		= 32596; // COmbo of sparkle or other warp return effect.
const int MIRROR_SPARKLE_COMBO_LAYER 	= 2;
const int MIRROR_SPARKLE_COMBO_W 	= 1;
const int MIRROR_SPARKLE_COMBO_H 	= 1;
const int MIRROR_SPARKLE_COMBO_CSET 	= 0;
const int MIRROR_SPARKLE_COMBO_XSCALE 	= -1;
const int MIRROR_SPARKLE_COMBO_YSCALE 	= -1;
const int MIRROR_SPARKLE_COMBO_RX 	= 0;
const int MIRROR_SPARKLE_COMBO_RY 	= 0;
const int MIRROR_SPARKLE_COMBO_RANGLE 	= 0;
 
const int MIRROR_SPARKLE_COMBO_FLIP 	= 0;
const int MIRROR_SPARKLE_COMBO_OPACITY 	= 64;
 
const int MIRROR_SPARKLE_COMBO_NUM_FRAMES = 4;
const int MIRROR_SPARKLE_COMBO_INIT_FRAME = 1;
 
 
 
 
//Accessors
int IsWarping(){ return Mirror[IS_WARPING]; }
void IsWarping(bool state){ if ( state ) Mirror[IS_WARPING] = 1; else Mirror[IS_WARPING] = 0; }
 
int AfterWarp(){ return Mirror[AFTER_WARP]; }
void AfterWarp(bool state){ if ( state ) Mirror[AFTER_WARP] = 1; else Mirror[AFTER_WARP] = 0; }
 
int IsReturnWarping(){ return Mirror[RETURN_WARP]; }
void IsReturnWarping(bool state){ if ( state ) Mirror[RETURN_WARP] = 1; else Mirror[RETURN_WARP] = 0; }
 
int AfterReturnWarp(){ return Mirror[AFTER_RETURN_WARP]; }
void AfterReturnWarp(bool state){ if ( state ) Mirror[AFTER_RETURN_WARP] = 1; else Mirror[AFTER_RETURN_WARP] = 0; }
 
void DungeonWarp(bool state) { if ( state ) Mirror[DUNGEON_WARP] = 1; else Mirror[DUNGEON_WARP] = 0; }
int DungeonWarp() { return Mirror[DUNGEON_WARP]; }

int WarpSparkle(){ return Mirror[WARP_SPARKLE]; }
void WarpSparkle(bool state){ if ( state ) Mirror[WARP_SPARKLE] = 1; else Mirror[WARP_SPARKLE] = 0; }
 
int WarpSparkleReturn(){ return Mirror[WARP_SPARKLE_RETURN_DMAP]; }
void WarpSparkleReturn(int dmap){ Mirror[WARP_SPARKLE_RETURN_DMAP] = dmap; }
 
int WarpSparkleDMap(){ return Mirror[WARP_SPARKLE_DMAP]; }
void WarpSparkleDMap(int dmap){ Mirror[WARP_SPARKLE_DMAP] = dmap; }
 
int WarpSparkleX(){ return Mirror[WARP_SPARKLE_X]; }
void WarpSparkleX(int x){ Mirror[WARP_SPARKLE_X] = x; }
 
int WarpSparkleY(){ return Mirror[WARP_SPARKLE_Y]; }
void WarpSparkleY(int y){ Mirror[WARP_SPARKLE_Y] = y; }
 
int WarpSparkleScreen(){ return Mirror[WARP_SPARKLE_SCREEN]; }
void WarpSparkleScreen(int screen){ Mirror[WARP_SPARKLE_SCREEN] = screen; }

//The following four functions are used to manipulate,a nd check the post-warp timer, 
//that prevents Link from being sent back by a sparkle as soon as he finishes warping.

int WarpReturnWait(){ return Mirror[MIRROR_POST_WARP_TIMER]; }
void ReducePostWarpTimer(){ if ( Mirror[MIRROR_POST_WARP_TIMER] > 0 ) Mirror[MIRROR_POST_WARP_TIMER]--; }
void SetPostWarpTimer(){ Mirror[MIRROR_POST_WARP_TIMER] = MIRROR_POST_WARP_TIMER_NUM_FRAMES; }
void ClearPostWarpTimer(){ Mirror[MIRROR_POST_WARP_TIMER] = 0; }
 
 
//Functions
 
//Checks the present DMap and returns irts counterpart.
//!! You must set up the arrays inside this function, for it to work.
int GetOtherworldlyDMap(int dmap){
	int q[4];
	int LightWorldDMaps[]={3,-1,-1,-1,-1}; //Populate these two arrays with the IDs of your light and dark world dmaps
	int DarkWorldDMaps[]={8,-1,-1,-1,-1}; //in matched pairs.
	for ( q[0] = 0; q[0] < SizeOfArray(LightWorldDMaps); q[0]++ ) {
		q[1] = LightWorldDMaps[ q[0] ];
		q[2] = DarkWorldDMaps[ q[0] ];
		if ( dmap == q[1] ) return DarkWorldDMaps[ q[0] ];
		if ( dmap == q[2] ) return LightWorldDMaps[ q[0] ];
	}
	return -1;
}
 
//Returns if the present dmap is a dark world dmap
//!! You must set up the arrays inside this function, for it to work.
bool IsDarkWorld(){
	int DarkWorldDMaps[]={8,-1,-1,-1,-1};
	for ( int q = 0; q < SizeOfArray(DarkWorldDMaps); q++ ) {
		if ( Game->GetCurDMap() == DarkWorldDMaps[q] ) return true;
	}
	return false;
}
 
//Generates coordinates for the warp return sparkle.
//this is set when we use the mirror.
void SetWarpReturn(){
	WarpSparkle(true);
	WarpSparkleX(Link->X);
	WarpSparkleY(Link->Y);
	WarpSparkleDMap( GetOtherworldlyDMap( Game->GetCurDMap() ) );
	WarpSparkleScreen(Game->GetCurScreen());
	WarpSparkleReturn(Game->GetCurDMap());
}
 
//Removes the warp sparkle, after using it.
void ClearWarpSparkle(){
	WarpSparkle(false);
	WarpSparkleX(-100);
	WarpSparkleY(-100);
	WarpSparkleDMap(-1);
	WarpSparkleScreen(-1);
	WarpSparkleReturn(-1);
}
 
//Returns if Link is in a dungeon based on the array dungeonDMaps[]
//!! You must set up the array inside this function, for it to work.
bool IsDungeonDMap(){
	int dungeonDMaps[]={20,21,22};//List all dungeon DMaps here
	for ( int q = 0; q < SizeOfArray(dungeonDMaps); q++ ) {
		if ( Game->GetCurDMap() == dungeonDMaps[q] ) return true;
		return false;
	}
}
 
//Returns if the warp destination is solid, prior to warping.
bool ___WarpDestSolid(int x, int y, int screen, int map){
	return ( Game->GetComboSolid(map, screen, ComboAt(x,y)) );
}
   

//A very precise way to check if the warp destination is solid, based on Link's standard hitbox. 
//Checks if any of Link's corners or axis positions are on a solid combo, and if a
bool WarpDestSolid(){
	if ( Screen->isSolid(Link->X+4, Link->Y) ||
		Screen->isSolid(Link->X+8, Link->Y+8) ||
		Screen->isSolid(Link->X+4, Link->Y+8) ||
		Screen->isSolid(Link->X+8, Link->Y) ||
		Screen->isSolid(Link->X+8, Link->Y+15) ||
		Screen->isSolid(Link->X+15, Link->Y+8)  ||	
		Screen->isSolid(Link->X+15, Link->Y) ||
		Screen->isSolid(Link->X+4, Link->Y+15) ||
		Screen->isSolid(Link->X+15, Link->Y+15)) return true;
	return false;
}
//! Main Functions to Call before Waitdraw()
 
//Handles the initial warp routines.
void MirrorWarpLink() {
	int q; int curmusic[256]; int curmusictrack; int nextmusic[256]; int nexttrack; int curmidi; int nextmidi;
	int warpmusic[256];
	if ( IsWarping() ){
		Link->X = Mirror[WARP_LINK_X];
		Link->Y = Mirror[WARP_LINK_Y];
		SetPostWarpTimer(); 
		
		//Freeze all enemies and ghost scripts
		
		
		//Start the warp sound first half...
		NoAction();
		if ( MIRROR_WARP_SOUND_USES_ENHANCED_MUSIC ) {
			Game->GetDMapMusicFilename(Game->GetCurDMap(), curmusic); 
			curmusictrack = Game->GetDMapMusicTrack(Game->GetCurDMap());
			Game->GetDMapMusicFilename(GetOtherworldlyDMap(Game->GetCurDMap()), nextmusic); 
			nexttrack = Game->GetDMapMusicTrack(GetOtherworldlyDMap(Game->GetCurDMap()));
			Game->GetMessage(MUS_MIRROR_WARP_START, warpmusic);
			if !( Game->PlayEnhancedMusic(warpmusic, MUS_MIRROR_WARP_START_TRACK) ) {
				if ( SFX_MIRROR_WARP_START ) Game->PlaySound(SFX_MIRROR_WARP_START);
			}
		}
		else { 
			if ( SFX_MIRROR_WARP_START ) Game->PlaySound(SFX_MIRROR_WARP_START);
		}
		
		Screen->Wavy = WARP_WAVE_DUR;
		
		for ( q = 0; q < MIRROR_WARP_FIRST_HALF_DUR; q++ ) {
			WaitNoAction();
		}
		
		
		//Do the warp
		Link->PitWarp(GetOtherworldlyDMap(Game->GetCurDMap()), Game->GetCurScreen());
		NoAction();
		
		//Second half of the music
		if ( MIRROR_WARP_SOUND_USES_ENHANCED_MUSIC ) {
			Game->GetDMapMusicFilename(Game->GetCurDMap(), curmusic); 
			curmusictrack = Game->GetDMapMusicTrack(Game->GetCurDMap());
			Game->GetDMapMusicFilename(GetOtherworldlyDMap(Game->GetCurDMap()), nextmusic); 
			nexttrack = Game->GetDMapMusicTrack(GetOtherworldlyDMap(Game->GetCurDMap()));
			Game->GetMessage(MUS_MIRROR_WARP_FINISH, warpmusic);
			if !( Game->PlayEnhancedMusic(warpmusic, MUS_MIRROR_WARP_FINISH_TRACK) ) {
				if ( SFX_MIRROR_WARP_FINISH ) Game->PlaySound(SFX_MIRROR_WARP_FINISH);
			}
		}
		else { 
			if ( SFX_MIRROR_WARP_FINISH ) Game->PlaySound(SFX_MIRROR_WARP_FINISH);
		}
		
		
		for ( q = 0; q < MIRROR_DUNGEON_WARP_SECOND_HALF_DUR; q++ ) {
			WaitNoAction();
		}
		
		//Resume the enhanced music file for the dmap
		Game->PlayEnhancedMusic(nextmusic, nexttrack); 
		
		//resume npcs and ghost scripts
		
		IsWarping(false);
		//for(int q = (WARP_WAVE_DUR + POST_WARP_DELAY) / 2; q > 0; q--){
		//	NoAction();
		//	Waitframe();
		//}
		AfterWarp(true);
	}
   
	if (IsReturnWarping() ){
		Mirror[WARP_LINK_HP] = Link->HP;

		Link->X = WarpSparkleX();
		Link->Y = WarpSparkleY();
	
		//Freeze all enemies and ghost scripts
		
		//Start the warp sound first half...
		NoAction();
		if ( MIRROR_WARP_SOUND_USES_ENHANCED_MUSIC ) {
			Game->GetDMapMusicFilename(Game->GetCurDMap(), curmusic); 
			curmusictrack = Game->GetDMapMusicTrack(Game->GetCurDMap());
			Game->GetDMapMusicFilename(GetOtherworldlyDMap(Game->GetCurDMap()), nextmusic); 
			nexttrack = Game->GetDMapMusicTrack(GetOtherworldlyDMap(Game->GetCurDMap()));
			Game->GetMessage(MUS_MIRROR_WARP_START, warpmusic);
			if !( Game->PlayEnhancedMusic(warpmusic, MUS_MIRROR_WARP_START_TRACK) ) {
				if ( SFX_MIRROR_WARP_START ) Game->PlaySound(SFX_MIRROR_WARP_START);
			}
		}
		else { 
			if ( SFX_MIRROR_WARP_START ) Game->PlaySound(SFX_MIRROR_WARP_START);
		}
		
		Screen->Wavy = WARP_WAVE_DUR;
		
		for ( q = 0; q < MIRROR_WARP_FIRST_HALF_DUR; q++ ) {
			WaitNoAction();
		}
		
		//Do the return warp
		Link->PitWarp(WarpSparkleReturn(), WarpSparkleScreen());
		
		
		//Second half of the music
		if ( MIRROR_WARP_SOUND_USES_ENHANCED_MUSIC ) {
			Game->GetDMapMusicFilename(Game->GetCurDMap(), curmusic); 
			curmusictrack = Game->GetDMapMusicTrack(Game->GetCurDMap());
			Game->GetDMapMusicFilename(GetOtherworldlyDMap(Game->GetCurDMap()), nextmusic); 
			nexttrack = Game->GetDMapMusicTrack(GetOtherworldlyDMap(Game->GetCurDMap()));
			Game->GetMessage(MUS_MIRROR_WARP_FINISH, warpmusic);
			if !( Game->PlayEnhancedMusic(warpmusic, MUS_MIRROR_WARP_FINISH_TRACK) ) {
				if ( SFX_MIRROR_WARP_FINISH ) Game->PlaySound(SFX_MIRROR_WARP_FINISH);
			}
		}
		else { 
			if ( SFX_MIRROR_WARP_FINISH ) Game->PlaySound(SFX_MIRROR_WARP_FINISH);
		}
		
		
		for ( q = 0; q < MIRROR_DUNGEON_WARP_SECOND_HALF_DUR; q++ ) {
			WaitNoAction();
		}
		
		//Resume the enhanced music file for the dmap
		Game->PlayEnhancedMusic(nextmusic, nexttrack); 
		
		//resume npcs and ghost scripts
		
		
		IsReturnWarping(false);
		//for(int q = (WARP_WAVE_DUR + POST_WARP_DELAY) / 2; q > 0; q--){
		//	NoAction();
		//	Waitframe();
		//}
		AfterReturnWarp(true);
	}
	if ( DungeonWarp() ) {
		//Warp to dungeon entrance.
		
		//Start the warp sound first half...
		NoAction();
		if ( MIRROR_DUNEON_SOUND_USES_ENHANCED_MUSIC ) {
			Game->GetDMapMusicFilename(Game->GetCurDMap(), curmusic); 
			curmusictrack = Game->GetDMapMusicTrack(Game->GetCurDMap());
			Game->GetDMapMusicFilename(GetOtherworldlyDMap(Game->GetCurDMap()), nextmusic); 
			nexttrack = Game->GetDMapMusicTrack(GetOtherworldlyDMap(Game->GetCurDMap()));
			Game->GetMessage(MUS_MIRROR_WARP_DUNGEON_START, warpmusic);
			if !( Game->PlayEnhancedMusic(warpmusic, MUS_MIRROR_WARP_DUNGEON_START_TRACK) ) {
				if ( SFX_MIRROR_WARP_DUNGEON_START ) Game->PlaySound(SFX_MIRROR_WARP_DUNGEON_START);
			}
		}
		else { 
			if ( SFX_MIRROR_WARP_DUNGEON_START ) Game->PlaySound(SFX_MIRROR_WARP_DUNGEON_START);
		}
		
		Screen->Wavy = WARP_WAVE_DUR;
		
		for ( q = 0; q < MIRROR_DUNGEON_WARP_FIRST_HALF_DUR; q++ ) {
			WaitNoAction();
		}
		
		//Do the dungeon warp
		Link->Warp(Game->GetCurDMap(), Game->DMapContinue[Game->GetCurDMap()]);
		
		
		//Second half of the music
		if ( MIRROR_DUNEON_SOUND_USES_ENHANCED_MUSIC ) {
			Game->GetDMapMusicFilename(Game->GetCurDMap(), curmusic); 
			curmusictrack = Game->GetDMapMusicTrack(Game->GetCurDMap());
			Game->GetDMapMusicFilename(GetOtherworldlyDMap(Game->GetCurDMap()), nextmusic); 
			nexttrack = Game->GetDMapMusicTrack(GetOtherworldlyDMap(Game->GetCurDMap()));
			Game->GetMessage(MUS_MIRROR_DUNGEON_WARP_FINISH, warpmusic);
			if !( Game->PlayEnhancedMusic(warpmusic, MUS_MIRROR_DUNGEON_WARP_FINISH_TRACK) ) {
				if ( SFX_MIRROR_DUNGEON_WARP_FINISH ) Game->PlaySound(SFX_MIRROR_DUNGEON_WARP_FINISH);
			}
		}
		else { 
			if ( SFX_MIRROR_DUNGEON_WARP_FINISH ) Game->PlaySound(SFX_MIRROR_DUNGEON_WARP_FINISH);
		}
		
		
		for ( q = 0; q < MIRROR_DUNGEON_DUNGEON_WARP_SECOND_HALF_DUR; q++ ) {
			WaitNoAction();
		}
		
		DungeonWarp(false);
		
		
		//Resume the enhanced music file for the dmap
		Game->PlayEnhancedMusic(curmusic, curmusictrack); 
		
		//resume npcs and ghost scripts
		
			
	}
}


 
//Post-warp cleanup, and bounce.
void WarpFinish() {
	if (AfterWarp()){
		int q;
		if ( Link->Action == LA_GOTHURTLAND || Link->Action == LA_GOTHURTWATER ) Link->HitDir = -1;
		//SetWarpReturn();
		//If the destination is solid, send Link back.
		if ( WarpDestSolid() ) {
			//freeze all enemies and ghost scripts.
			ClearWarpSparkle();
			
			Game->PlaySound(SFX_WARP_ERROR);
			for ( q = 0; q < SFX_WARP_ERROR_DUR; q++ ) 
				WaitNoAction();
			
			Screen->Wavy = WARP_WAVE_DUR;
			
			for(int q = (WARP_WAVE_DUR + POST_WARP_DELAY); q > 0; q--){
				NoAction();
				Waitframe();
			}
			
			//resume npcs and ghost scripts
			Link->X = Mirror[WARP_LINK_X];
			Link->Y = Mirror[WARP_LINK_Y];
			
			//Start the warp sound first half...
			NoAction();
			if ( MIRROR_WARP_SOUND_USES_ENHANCED_MUSIC ) {
				Game->GetDMapMusicFilename(Game->GetCurDMap(), curmusic); 
				curmusictrack = Game->GetDMapMusicTrack(Game->GetCurDMap());
				Game->GetDMapMusicFilename(GetOtherworldlyDMap(Game->GetCurDMap()), nextmusic); 
				nexttrack = Game->GetDMapMusicTrack(GetOtherworldlyDMap(Game->GetCurDMap()));
				Game->GetMessage(MUS_MIRROR_WARP_START, warpmusic);
				if !( Game->PlayEnhancedMusic(warpmusic, MUS_MIRROR_WARP_START_TRACK) ) {
					if ( SFX_MIRROR_WARP_START ) Game->PlaySound(SFX_MIRROR_WARP_START);
				}
			}
			else { 
				if ( SFX_MIRROR_WARP_START ) Game->PlaySound(SFX_MIRROR_WARP_START);
			}
			
			Screen->Wavy = WARP_WAVE_DUR;
			
			for ( q = 0; q < MIRROR_WARP_FIRST_HALF_DUR; q++ ) {
				WaitNoAction();
			}
			
			
			//Do the return warp
			
			Link->PitWarp(GetOtherworldlyDMap(Game->GetCurDMap()), Game->GetCurScreen());
			
			AfterWarp(false);
			
			//Second half of the music
			if ( MIRROR_WARP_SOUND_USES_ENHANCED_MUSIC ) {
				Game->GetDMapMusicFilename(Game->GetCurDMap(), curmusic); 
				curmusictrack = Game->GetDMapMusicTrack(Game->GetCurDMap());
				Game->GetDMapMusicFilename(GetOtherworldlyDMap(Game->GetCurDMap()), nextmusic); 
				nexttrack = Game->GetDMapMusicTrack(GetOtherworldlyDMap(Game->GetCurDMap()));
				Game->GetMessage(MUS_MIRROR_WARP_FINISH, warpmusic);
				if !( Game->PlayEnhancedMusic(warpmusic, MUS_MIRROR_WARP_FINISH_TRACK) ) {
					if ( SFX_MIRROR_WARP_FINISH ) Game->PlaySound(SFX_MIRROR_WARP_FINISH);
				}
			}
			else { 
				if ( SFX_MIRROR_WARP_FINISH ) Game->PlaySound(SFX_MIRROR_WARP_FINISH);
			}
			
			
			for ( q = 0; q < MIRROR_DUNGEON_WARP_SECOND_HALF_DUR; q++ ) {
				WaitNoAction();
			}
			
			
		//resume npcs and ghost scripts
			for(int q = (WARP_WAVE_DUR + POST_WARP_DELAY); q > 0; q--){
				NoAction();
				Waitframe();
			}
		}
		if ( Link->HP < Mirror[WARP_LINK_HP] && WARP_RETURNS_ON_INJURY) { //If Link is injured, send him back.
			Link->HP = Mirror[WARP_LINK_HP];
			
			Screen->Wavy = WARP_WAVE_DUR;
			//freeze all enemies and ghost scripts.
			
			//Start the warp sound first half...
			NoAction();
			if ( MIRROR_WARP_SOUND_USES_ENHANCED_MUSIC ) {
				Game->GetDMapMusicFilename(Game->GetCurDMap(), curmusic); 
				curmusictrack = Game->GetDMapMusicTrack(Game->GetCurDMap());
				Game->GetDMapMusicFilename(GetOtherworldlyDMap(Game->GetCurDMap()), nextmusic); 
				nexttrack = Game->GetDMapMusicTrack(GetOtherworldlyDMap(Game->GetCurDMap()));
				Game->GetMessage(MUS_MIRROR_WARP_START, warpmusic);
				if !( Game->PlayEnhancedMusic(warpmusic, MUS_MIRROR_WARP_START_TRACK) ) {
					if ( SFX_MIRROR_WARP_START ) Game->PlaySound(SFX_MIRROR_WARP_START);
				}
			}
			else { 
				if ( SFX_MIRROR_WARP_START ) Game->PlaySound(SFX_MIRROR_WARP_START);
			}
			
			Screen->Wavy = WARP_WAVE_DUR;
			
			for ( q = 0; q < MIRROR_WARP_FIRST_HALF_DUR; q++ ) {
				WaitNoAction();
			}
			
			
			//Do the return warp
			
			
			Link->X = Mirror[WARP_LINK_X];
			Link->Y = Mirror[WARP_LINK_Y];
			Link->PitWarp(WarpSparkleReturn(), Game->GetCurScreen());
 
			Link->X = Mirror[WARP_LINK_X];
			Link->Y = Mirror[WARP_LINK_Y];
			Link->HP = Mirror[WARP_LINK_HP];
			
			AfterWarp(false);
			
			
			//Second half of the music
			if ( MIRROR_WARP_SOUND_USES_ENHANCED_MUSIC ) {
				Game->GetDMapMusicFilename(Game->GetCurDMap(), curmusic); 
				curmusictrack = Game->GetDMapMusicTrack(Game->GetCurDMap());
				Game->GetDMapMusicFilename(GetOtherworldlyDMap(Game->GetCurDMap()), nextmusic); 
				nexttrack = Game->GetDMapMusicTrack(GetOtherworldlyDMap(Game->GetCurDMap()));
				Game->GetMessage(MUS_MIRROR_WARP_FINISH, warpmusic);
				if !( Game->PlayEnhancedMusic(warpmusic, MUS_MIRROR_WARP_FINISH_TRACK) ) {
					if ( SFX_MIRROR_WARP_FINISH ) Game->PlaySound(SFX_MIRROR_WARP_FINISH);
				}
			}
			else { 
				if ( SFX_MIRROR_WARP_FINISH ) Game->PlaySound(SFX_MIRROR_WARP_FINISH);
			}
			
			
			for ( q = 0; q < MIRROR_DUNGEON_WARP_SECOND_HALF_DUR; q++ ) {
				WaitNoAction();
			}

			//resume npcs and ghost scripts
		}
		else {
			Link->X = Mirror[WARP_LINK_X];
			Link->Y = Mirror[WARP_LINK_Y];
			//SetPostWarpTimer();
			//Mirror[WARP_LINK_TEMP_INVULNERABILITY] = WARP_INVULNERABILITY_FRAMES;
			AfterWarp(false);
		}
	}
   
	if (AfterReturnWarp()){
		if ( Link->Action == LA_GOTHURTLAND || Link->Action == LA_GOTHURTWATER ) Link->HitDir = -1;
		ClearWarpSparkle();
		Mirror[WARP_LINK_TEMP_INVULNERABILITY] = WARP_INVULNERABILITY_FRAMES;
		AfterReturnWarp(false);
		ClearPostWarpTimer();
           
	}
   
	if ( POST_WARP_LINK_IS_INVINCIBLE ) {
		if ( Mirror[WARP_LINK_TEMP_INVULNERABILITY] ) {
			//If we find a way to Flicker Link, it goes here. 
			Link->CollDetection = false;
			Mirror[WARP_LINK_TEMP_INVULNERABILITY]--;
		}
		if ( !Mirror[WARP_LINK_TEMP_INVULNERABILITY] ) Link->CollDetection = true;
	}
	
	//if ( Mirror[MIRROR_POST_WARP_TIMER] > 0 ) Mirror[MIRROR_POST_WARP_TIMER]--;
}
 
 
//Creates the mirror return sparkle.
void MirrorSparkle(){
	if ( Game->GetCurDMap() == WarpSparkleDMap() && Game->GetCurScreen() == WarpSparkleScreen() ) {
		Screen->DrawCombo(  MIRROR_SPARKLE_COMBO_LAYER, WarpSparkleX(), WarpSparkleY(),
			MIRROR_SPARKLE_COMBO, MIRROR_SPARKLE_COMBO_H, MIRROR_SPARKLE_COMBO_W, MIRROR_SPARKLE_COMBO_CSET,
			MIRROR_SPARKLE_COMBO_XSCALE, MIRROR_SPARKLE_COMBO_YSCALE, MIRROR_SPARKLE_COMBO_RX,
			MIRROR_SPARKLE_COMBO_RY, MIRROR_SPARKLE_COMBO_RANGLE, Mirror[MIRROR_SPARKLE_COMBO_FRAME],
			MIRROR_SPARKLE_COMBO_FLIP, true, MIRROR_SPARKLE_COMBO_OPACITY) ; //Mirror sparkle
       
		//Reduce the frames
		if ( Mirror[MIRROR_SPARKLE_COMBO_FRAME] >= MIRROR_SPARKLE_COMBO_NUM_FRAMES ) Mirror[MIRROR_SPARKLE_COMBO_FRAME] = MIRROR_SPARKLE_COMBO_INIT_FRAME;
		else Mirror[MIRROR_SPARKLE_COMBO_FRAME]++;
           
		if ( !WarpReturnWait() && !IsTempInvincible() ){
			
			if ( Abs( Link->X - WarpSparkleX()) < 8 && Abs(Link->Y - WarpSparkleY()) < 8 )
			{
				//Reurn Link via the portal
				IsReturnWarping(true);
			}
		}
	}
}

bool IsTempInvincible(){ 
	if ( Mirror[WARP_LINK_TEMP_INVULNERABILITY] && POST_WARP_LINK_IS_INVINCIBLE ) return true; 
	if ( !Mirror[WARP_LINK_TEMP_INVULNERABILITY] || !POST_WARP_LINK_IS_INVINCIBLE ) return false;
}
 
void TestSparkle(){
	int x = WarpSparkleX();
	int y = WarpSparkleY();
	if ( x < 0 ) x = 0;
	if ( y < 0 ) y = 0;
	Screen->DrawCombo(  MIRROR_SPARKLE_COMBO_LAYER, x, y,
			MIRROR_SPARKLE_COMBO, MIRROR_SPARKLE_COMBO_H, MIRROR_SPARKLE_COMBO_W, MIRROR_SPARKLE_COMBO_CSET,
			MIRROR_SPARKLE_COMBO_XSCALE, MIRROR_SPARKLE_COMBO_YSCALE, MIRROR_SPARKLE_COMBO_RX,
			MIRROR_SPARKLE_COMBO_RY, MIRROR_SPARKLE_COMBO_RANGLE, Mirror[MIRROR_SPARKLE_COMBO_FRAME],
			MIRROR_SPARKLE_COMBO_FLIP, true, MIRROR_SPARKLE_COMBO_OPACITY) ; //Mirror sparkle
       
		//Reduce the frames
		if ( Mirror[MIRROR_SPARKLE_COMBO_FRAME] >= MIRROR_SPARKLE_COMBO_NUM_FRAMES ) Mirror[MIRROR_SPARKLE_COMBO_FRAME] = MIRROR_SPARKLE_COMBO_INIT_FRAME;
		else Mirror[MIRROR_SPARKLE_COMBO_FRAME]++;
}
 

//Runs the moon pearl bunny sprite change, and halts using any item other than the mirror. 
void MoonPearl(){
	if ( IsDarkWorld() && !Link->Item[I_MOONPEARL] && !Link->Item[I_BUNNYRING] ) Link->Item[I_BUNNYRING] = true;
	if ( !IsDarkWorld() && Link->Item[I_BUNNYRING] ) Link->Item[I_BUNNYRING] = false;
	if ( IsDarkWorld() && Link->Item[I_MOONPEARL] && Link->Item[I_BUNNYRING] ) Link->Item[I_BUNNYRING] = false;
	if ( Link->Item[I_BUNNYRING] ) {
		if ( Link->PressA && GetEquipmentA() != I_MIRROR ) Link->PressA = false;
		if ( Link->PressB && GetEquipmentB() != I_MIRROR ) Link->PressB = false;
	}
}
 
/// Items
 
item script Mirror{
	void run(){
		int cmb[4]; 
		cmb[0] = Screen->ComboT[ComboAt(Link->X+8, Link->Y+8)];
		cmb[1] = GetLayerComboT(1,cmb[0]);
		cmb[2] = GetLayerComboT(2,cmb[0]);
		if ( IsDungeonDMap() && MIRROR_RETURNS_TO_DUNGEON_ENTRANCE ) {
			DungeonWarp(true);
			//Warp to dungeon entrance.
			//Game->PlaySound(SFX_WARP_DUNGEON);
			//Screen->Wavy = WARP_WAVE_DUR_DUNGEON;
			//Link->Warp(Game->GetCurDMap(), Game->DMapContinue[Game->GetCurDMap()]);
		}
		
		
		else {
			if ( IsDarkWorld() ) {
				for ( cmb[3] = 0; cmb[3] <= 3; cmb[3]++ ) {
					if ( cmb[ cmb[3] ] == CT_CAVE || cmb[ cmb[3] ] == CT_CAVE2 || cmb[ cmb[3] ] == CT_CAVEB 
						|| cmb[ cmb[3] ] == CT_CAVEC || cmb[ cmb[3] ] == CT_CAVED ||
						cmb[ cmb[3] ] == CT_CAVE2B || cmb[ cmb[3] ] == CT_CAVE2C ||cmb[ cmb[3] ] == CT_CAVE2D ) 
					{
						Game->PlaySound(SFX_WARP_ERROR);
						Quit();
					}
				}
				SetPostWarpTimer();
				//Mirror[MIRROR_POST_WARP_TIMER] = MIRROR_POST_WARP_TIMER_NUM_FRAMES;
				Mirror[WARP_LINK_X] = Link->X;
				Mirror[WARP_LINK_Y] = Link->Y;
				Mirror[WARP_LINK_HP] = Link->HP;
				SetWarpReturn();
				IsWarping(true);
			}
			//Warp to other world
			if ( !IsDarkWorld() && SFX_WARP_ERROR ) Game->PlaySound(SFX_WARP_ERROR);
		}
	}
}
 
//Global Script Example
 
global script Z3_Mirror{
	void run(){
		while(true){
			if ( REQUIRE_MOON_PEARL ) MoonPearl();
			ReducePostWarpTimer();
			MirrorWarpLink();
			
			//if ( TEST_MIRROR_SPARKLE ) TestSparkle();
			//if ( MIRROR_SPARKLE_BEFORE_WAITDRAW ) MirrorSparkle();
			WarpFinish();
			Waitdraw();
			
			//if ( !MIRROR_SPARKLE_BEFORE_WAITDRAW ) MirrorSparkle();
			if ( WarpSparkle() ) MirrorSparkle(); //Call only if it exists.
			Waitframe();
		}
	}
}

//Deprecated

const int SOLIDITY_CHECK_DISTANCE = 8;
 
bool TouchingSolid(int x, int y) {
	if ( Screen->isSolid(x,y) ||
		Screen->isSolid(x + SOLIDITY_CHECK_DISTANCE, y) ||
		Screen->isSolid(x + SOLIDITY_CHECK_DISTANCE, y+SOLIDITY_CHECK_DISTANCE) ||
		Screen->isSolid(x + SOLIDITY_CHECK_DISTANCE, y-SOLIDITY_CHECK_DISTANCE) ||
		Screen->isSolid(x - SOLIDITY_CHECK_DISTANCE, y) ||
		Screen->isSolid(x - SOLIDITY_CHECK_DISTANCE, y+SOLIDITY_CHECK_DISTANCE) ||
		Screen->isSolid(x - SOLIDITY_CHECK_DISTANCE, y-SOLIDITY_CHECK_DISTANCE) ) {
		return true;
	}
	return false;
}

bool TouchingSolid(){
	if ( Screen->isSolid(Link->X,Link->Y) ||
		Screen->isSolid(Link->X + 15, Link->Y) ||
		Screen->isSolid(Link->X + 15, Link->Y+15) ||
		Screen->isSolid(Link->X + 15, Link->Y-15) ||
		Screen->isSolid(Link->X - 15, Link->Y) ||
		Screen->isSolid(Link->X - 15, Link->Y+15) ||
		Screen->isSolid(Link->X - 15, Link->Y-15) ) 
	{
		return true;
	}
	return false;
}



//Cape


void CapeOfInvisibility(){}



//if ( Mirror[CAPE_ON] ) {
//	CapeCost();
//	DoCape();
//}

void DoCape(){
	int scale = Rand(13,15);
	int flip;
	if ( Link->Dir == DIR_DOWN ) flip = 1;
	else if ( Link->Dir == DIR_LEFT ) flip = 7;
	else if ( Link->Dir == DIR_DOWN ) flip = ;
	else flip = 0;
	Screen->DrawTile(CAPE_SHADOW_LAYER, Link->X+CAPE_SHADOW_X_OFFSET, Link->Y+CAPE_SHADOW_Y_OFFSET, CAPE_SHADOW_TILE, 1,1, CAPE_SHADOW_CSET, scale, scale, 0, 0, 0, flip, true, CAPE_SHADOW_OPACITY);
}

const int CAPE_SHADOW_LAYER = 2; 
const int CAPE_SHADOW_X_OFFSET = 0; 
const int CAPE_SHADOW_Y_OFFSET = 4;
const int CAPE_SHADOW_TILE = 2001; 
const int CAPE_SHADOW_CSET = 0;
const int CAPE_SHADOW_OPACITY = 64;





item script CapeOfInvisibility{
	void run(){
		if ( Mirror[CAPE_ON] ) { Mirror[CAPE_ON] = 0; }
		else {
			InitCapeTimer(); //Should we start at 0 to ensure a magic cost?
			Mirror[CAPE_ON] = 1;
		}
	}
}

void InitCapeTimer() { Mirror[CAPE_TIMER] = CAPE_MAGIC_USE_RATE; }



//! I need to include these, along with IsInvisible() and IsInvincible() to ensure that there ar eno comflicts between this and other cape/cane scripts.



const int CAPE_ON = 50;



const int CAPE_MAGIC_COST = 3; //Cost per rate
const int CAPE_MAGIC_USE_RATE = 50; //frames per cost unit



//cAPE ARRAY INDICES
const int CAPE_TIMER = 60;
const int CAPE_SHADOW_WAVER_TIMER = 61;


//Cape Settingds
const int CAPE_SHADOW_TILE = 2100;

/////////////////////
/// Cane of Byrna ///
/////////////////////

void InitByrnaTimer() { Mirror[BYRNA_TIMER] = BYRNA_MAGIC_USE_RATE; }

void ByrnaCost(){
	if ( Mirror[BYRNA_TIMER] > 0 ) Mirror[BYRNA_TIMER]--;
	if ( Mirror[BYRNA_TIMER] <= 0 ) {
		Game->MCounter[CR_MAGIC] -= ( CAPE_MAGIC_COST * Game->Generic[GEN_MAGICDRAINRATE]; //Allow half magic
		InitByrnaTimer();
	}
}


//Byrna Array Indices
const int BYRNA_ON = 51;

const int BYRNA_TIMER = 70;

//The true z3 cane has only one orbit
const int BYRNA_BEAM_SPRITE 		= 80;
const int BYRNA_BEAM_1_ORBIT_X 		= 81;
const int BYRNA_BEAM_1_ORBIT_Y 		= 82;
const int BYRNA_BEAM_1_ORBIT_CX 	= 83;
const int BYRNA_BEAM_1_ORBIT_CY 	= 84;
const int BYRNA_BEAM_1_ORBIT_VELOCITY 	= 85;
const int BYRNA_BEAM_1_ORBIT_ANG1 	= 86; 
const int BYRNA_BEAM_1_ORBIT_ANG2	= 87; 
const int BYRNA_BEAM_1_ORBIT_RADIUS 	= 88; 
const int BYRNA_BEAM_1_ORBIT_RADIUS2 	= 89; 
const int BYRNA_BEAM_1_ORBIT_FRAME	= 90;
const int BYRNA_ORBIT_SOUND_TIMER 	= 91; 

void ByrnaSound(){ 
	if ( Mirror[BYRNA_ORBIT_SOUND_TIMER] > 0 ) Mirror[BYRNA_ORBIT_SOUND_TIMER]--;
	else { 
		Mirror[BYRNA_ORBIT_SOUND_TIMER] = BYRNA_ORBIT_SOUND_LOOP_TIME;
		if ( SFX_BYRNA_ORBIT ) Game->PlaySound(SFX_BYRNA_ORBIT);
	}
}


//const int BYRNA_BEAM_2_ORBIT_X 		= 86;
//const int BYRNA_BEAM_2_ORBIT_Y 		= 87;
//const int BYRNA_BEAM_2_ORBIT_VELOCITY 	= 88;
//const int BYRNA_BEAM_2_ORBIT_SIN 	= 89;
//const int BYRNA_BEAM_2_ORBIT_COSIN 	= 90;

//const int BYRNA_BEAM_3_ORBIT_X 		= 91;
//const int BYRNA_BEAM_3_ORBIT_Y 		= 92;
//const int BYRNA_BEAM_3_ORBIT_VELOCITY 	= 93;
//const int BYRNA_BEAM_3_ORBIT_SIN 	= 94;
//const int BYRNA_BEAM_3_ORBIT_COSIN 	= 95;

//const int BYRNA_BEAM_4_ORBIT_X 		= 96;
//const int BYRNA_BEAM_4_ORBIT_Y 		= 97;
//const int BYRNA_BEAM_4_ORBIT_VELOCITY 	= 98;
//const int BYRNA_BEAM_4_ORBIT_SIN 	= 99;
//const int BYRNA_BEAM_4_ORBIT_COSIN 	= 100;

const int BYRNA_COST = 4;
const int BYRNA_MAGIC_USE_RATE = 120; //frames per unit of cost

const int WDS_BYRNABLOCKED = 0; //Deadstate for eweapons blocked by the byrna beam.
const int BYRNA_BEAMS_REFLECT_WEAPONS = 1; 
const int BYRNA_DAMAGE = 2;
const int LW_CUSTOMBYRNA = 20; //The weapon type to spoof. 

const int BYRNA_NUM_ORBITS = 1;

const int BYRNA_ORBIT_RADIUS = 40; 
const int BYRNA_ORBIT_SPEED = 120; 
const int BYRNA_ORBIT_COMBO = 2002; 
const int BYRNA_ORBIT_NUM_FRAMES = 4; 
const int BYRNA_ORBIT_COMBO_LAYER = 6;
const int BYRNA_ORBIT_COMBO_H = 1;
const int BYRNA_ORBIT_COMBO_W = 1;
const int BYRNA_ORBIT_COMBO_CSET = 0;
const int BYRNA_ORBIT_COMBO_RY = 0;
const int BYRNA_ORBIT_COMBO_RX = 0; 
const int BYRNA_ORBIT_COMBO_RANGLE = 0; 
const int BYRNA_ORBIT_COMBO_FLIP = 0;
const int BYRNA_ORBIT_COMBO_OPACITY = 128;
const int BYRNA_ORBIT_COMBO_XSCALE = -1; 
const int BYRNA_ORBIT_COMBO_YSCALE = -1;
const int BYRNA_ORBIT_INIT_FRAME = 1;


const int SFX_BYRNA_ON = 63;
const int SFX_BYRNA_OFF = 64;
const int SFX_BYRNA_ORBIT = 65; 
const int BYRNA_ORBIT_SOUND_LOOP_TIME = 90; 

//Handles the cost calcs.
void ByrnaCost(){
	if ( Mirror[BYRNA_TIMER] > 0 ) Mirror[BYRNA_TIMER]--;
	if ( Mirror[BYRNA_TIMER] <= 0 ) {
		Game->MCounter[CR_MAGIC] -= ( CAPE_MAGIC_COST * Game->Generic[GEN_MAGICDRAINRATE]; //Allow half magic
		InitByrnaTimer();
	}
}


//Prime the vars for orbiting. Call this only from the item script, when enabling.
void InitByrna(){ 
	Mirror[BYRNA_BEAM_1_ORBIT_RADIUS] = BYRNA_ORBIT_RADIUS;
	Mirror[BYRNA_BEAM_1_ORBIT_VELOCITY] = BYRNA_ORBIT_SPEED;
	if ( Mirror[BYRNA_BEAM_1_ORBIT_RADIUS2] == 0 ) Mirror[BYRNA_BEAM_1_ORBIT_RADIUS2] = Mirror[BYRNA_BEAM_1_ORBIT_RADIUS]; //Circle
        if ( Mirror[BYRNA_BEAM_1_ORBIT_ANG1] < 0 ) Mirror[BYRNA_BEAM_1_ORBIT_ANG1] = Rand(360); //Random Start
        Mirror[BYRNA_BEAM_1_ORBIT_CX] = Mirror[BYRNA_BEAM_1_ORBIT_X];
        Mirror[BYRNA_BEAM_1_ORBIT_CY] = Mirror[BYRNA_BEAM_1_ORBIT_Y];
}



//Call before Waitdraw to make the orbits, as if ( Mirror[BYRNA_ON] ) DoByrna();
void DoByrna(){

	int q[8]; 	
	
	Mirror[BYRNA_BEAM_1_ORBIT_ANG1] += Mirror[BYRNA_BEAM_1_ORBIT_VELOCITY];
	if ( Mirror[BYRNA_BEAM_1_ORBIT_ANG1] < -360) Mirror[BYRNA_BEAM_1_ORBIT_ANG1] += 360; //Wraping happens
	else if ( Mirror[BYRNA_BEAM_1_ORBIT_ANG1] > 360) Mirror[BYRNA_BEAM_1_ORBIT_ANG1] -= 360; 
            
	Mirror[BYRNA_BEAM_1_ORBIT_X] = Mirror[BYRNA_BEAM_1_ORBIT_CX] + VectorX(Mirror[BYRNA_BEAM_1_ORBIT_RADIUS],
		Mirror[BYRNA_BEAM_1_ORBIT_ANG1]);

	Mirror[BYRNA_BEAM_1_ORBIT_Y] = Mirror[BYRNA_BEAM_1_ORBIT_CY] + VectorY(Mirror[BYRNA_BEAM_1_ORBIT_RADIUS2], 
		Mirror[BYRNA_BEAM_1_ORBIT_ANG1]);
	//Create the beams and have them orbit Link
	//track their positions in Misc indices
	Screen->DrawCombo(  BYRNA_ORBIT_COMBO_LAYER, Mirror[BYRNA_BEAM_1_ORBIT_X], Mirror[BYRNA_BEAM_1_ORBIT_Y],
			BYRNA_ORBIT_COMBO, BYRNA_ORBIT_COMBO_H, BYRNA_ORBIT_COMBO_W, BYRNA_ORBIT_COMBO_CSET,
			BYRNA_ORBIT_COMBO_XSCALE, BYRNA_ORBIT_COMBO_YSCALE, BYRNA_ORBIT_COMBO_RX,
			BYRNA_ORBIT_COMBO_RY, BYRNA_ORBIT_COMBO_RANGLE, Mirror[BYRNA_BEAM_1_ORBIT_FRAME],
			BYRNA_ORBIT_COMBO_FLIP, true, BYRNA_ORBIT_COMBO_OPACITY) ; //Mirror sparkle
       
	//Reduce the frames
	if ( Mirror[BYRNA_BEAM_1_ORBIT_FRAME] >= BYRNA_ORBIT_NUM_FRAMES ) Mirror[BYRNA_BEAM_1_ORBIT_FRAME] = BYRNA_ORBIT_INIT_FRAME;
	else Mirror[BYRNA_BEAM_1_ORBIT_FRAME]++;
   
		
	//No, wait, the beams need to be drawn tiles and we need TileCollision.
	
	q[4] = Screen->NummNPCs(); q[5] = Screen->NumEWeapons(); 
	//int loops = Max(npcs, 
	for ( q[0] = Max(q[4], q[5]); q > 0; q-- ) {
		if ( q[0] < q[4] ) npc n = Screen->LoadNPC(q[0]);
		if ( q[0] < q[5] ) eweapon e = Screen->LoadEWeapon(q[0]); 
		for ( q[1] = 0; q[1] < BYRNA_NUM_ORBITS; q[1]++ ) { //for each beam
			
			if ( q[0] < q[4] ) {
				if ( Abs( n->X - Mirror[BYRNA_BEAM_1_ORBIT_X]) < 8 && Abs(n->Y - Mirror[BYRNA_BEAM_1_ORBIT_X]) < 8 )
				{
					beam[ q[0] ] = Screen->CreateLWeapon(LW_CUSTOMBYRNA);
					beam[ q[0] ]-> X = n->X;
					beam[ q[0] ]-> Y = n->Y; //Spawn a weapon n the npc
					beam[ q[0] ]->Damage = BYRNA_DAMAGE;
				}
			}
			if ( q[0] < q[5] ) {	
				if ( Abs( e->X - Mirror[BYRNA_BEAM_1_ORBIT_X]) < 8 && Abs(e->Y - Mirror[BYRNA_BEAM_1_ORBIT_X]) < 8 )
				{
					//block/reflect
					if ( BYRNA_BEAMS_REFLECT_WEAPONS ) ReflectWeapon(e);
					else e->DeasDtate = WDS_BYRNABLOCKED:
				}
			}
		}
	}
	
}

item script CaneOfByrna{
	void run(){
		if ( Mirror[BYRNA_ON] ) { Mirror[BYRNA_ON] = 0; }
		else { InitByrna(); Mirror[BYRNA_ON] = 1; }
	}
}

//The main byrna function. Call directly, prior to Waitdraw(); 
void CaneOfByrna(){ ByrnaCost(); DoByrna(); ByrnaSound();}




bool IsInvisible(){
	if ( Mirror[CAPE_ON] ) return true;
	return false;
}

bool IsInvincible(){
	if ( Mirror[BYRNA_ON] || Mirror[WARP_LINK_TEMP_INVULNERABILITY] ) return true;
	return false;
}

void HandleInvisibilityAndInvincibility(){
	if ( IsInvisible() ) Link->Invisible = true;
	else Link->Invisible = false;
	if ( IsInvincible() ) Link->CollDetection = false;
	else Link->CollDetection = true;
}

//! We can tighten this down baed on Link's proximity to the grid. 
bool LinkTouchingSolidCombo(){
	int cmb[6];
	cmb[0] = ComboAt(Link->X, Link->Y);
	cmb[1] = ____AdjacentCombo(cmb,3);
	cmb[2] = ____AdjacentCombo(cmb,5);
	cmb[3] = ____AdjacentCombo(cmb,4);
	for ( cmb[4] = 0; cmb[4] <= 2; cmb[4]++ ) {
		for ( cmb[5] = 0; cmb[5] <= 4; cmb[5]++ ) {
			if ( GetLayerComboS(cmb[4], cmb[ cmb[5] ]) > 0 ) return true;
		}
	}
}


//Constants for AdjacentCombo()

//const int CMB_UPLEFT    = 0;
//const int CMB_UP        = 1;
//const int CMB_UPRIGHT   = 2;
//const int CMB_RIGHT     = 3;
//const int CMB_DOWNRIGHT = 4;
//const int CMB_DOWN      = 5;
//const int CMB_DOWNLEFT  = 6;
//const int CMB_LEFT      = 7;
//const int CMB_LEFTUP    = 0; //Not 8, as those are dir + shield

//Returns the Nuth combo index of a combo based on a central point, and a direction.
//For example, combo 22 + COMBO_UPRIGHT returns '7', 
//as combo 7 is to the upper-right of combo 22.
int ____AdjacentCombo(int cmb, int dir){
    int combooffsets[13]={-0x10,-0x0F,-0x0E,1,0x10,0x0F,0x0E,-1,-0x10};
    if ( cmb % 16 == 0 ) combooffsets[9] = 1;
    if ( (cmb & 15) == 1 ) combooffsets[10] = 1;
    if ( cmb < 0x10 ) combooffsets[11] = 1;
    if ( cmb < 0xAF ) combooffsets[12] = 1;
    if ( combooffsets[9] && ( dir == CMB_LEFT || dir == CMB_UPLEFT || dir == CMB_DOWNLEFT || dir == CMB_LEFTUP ) ) return 0;
    if ( combooffsets[10] && ( dir == CMB_RIGHT || dir == CMB_UPRIGHT || dir == CMB_DOWNRIGHT ) ) return 0;
    if ( combooffsets[11] && ( dir == CMB_UP || dir == CMB_UPRIGHT || dir == CMB_UPLEFT || dir == CMB_DOWNLEFT ) ) return 0;
    if ( combooffsets[12] && ( dir == CMB_DOWN || dir == CMB_DOWNRIGHT || dir == CMB_DOWNLEFT ) ) return 0;
    else if ( cmb > 0 && cmb < 177 ) return cmb + combooffsets[dir];
    else return 0;
}