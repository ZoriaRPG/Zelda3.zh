///////////////////////
/// Cane of Somaria ///
/// v0.4.1          ///
/// 12-NOV-2016     ///
/// By: ZoriaRPG    ///
///////////////////////////
/// Created for TeamUDF ///
///////////////////////////

//! Platform code

const int I_SOMARIA_BLOCK = 200; //When a somaria block ffc is on a conveyor, generatethis and key the ffc x/y
				// coordinates to the item, so that the block uses engine onveyor movement
				//The item should use a blank tile, and thus, be invisible.

const int I_SOMARIA_MISC = 0; 
const int I_FLAG_SOMARIA_ON_CONVEYOR = 01b;

const int CMB_SOMARIA_PLATFORM_INACTIVE = 100; //the '?' combo

const int LWEAPON_MISC_ID = 8; //l->Misc[] holds the ID of the weapon. 
const int LWT_SOMARIA = 100; //Attribute for somaria objects.

const int STORE_FFC_DATA = 0; 
const int STORE_FFC_SCRIPT = 1;
const int STORE_FFC_CSET = 2;
const int STORE_FFC_DELAY = 3;
const int STORE_FFC_X = 4;
const int STORE_FFC_Y = 5;
const int STORE_FFC_VX = 6;
const int STORE_FFC_VY = 7;
const int STORE_FFC_AX = 8;
const int STORE_FFC_AY = 9;
const int STORE_FFC_TILEWIDTH = 10;
const int STORE_FFC_TILEHEIGHT = 11;
const int STORE_FFC_EFFECTWIDTH = 12;
const int STORE_FFC_EFFECTHEIGHT = 13;
const int STORE_FFC_LINK = 14;

const int STORE_FFC_FLAGS_MIN = 15; 
const int STORE_FFC_FLAGS_MAX = 24; 

const int STORE_FFC_FLAGS_0 = 15; 
const int STORE_FFC_FLAGS_1 = 16;
const int STORE_FFC_FLAGS_2 = 17;
const int STORE_FFC_FLAGS_3 = 18;
const int STORE_FFC_FLAGS_4 = 19; 
const int STORE_FFC_FLAGS_5 = 20;
const int STORE_FFC_FLAGS_6 = 21; 
const int STORE_FFC_FLAGS_7 = 22;
const int STORE_FFC_FLAGS_8 = 23; 
const int STORE_FFC_FLAGS_9 = 24; 

const int STORE_FFC_MISC_MIN = 25; 
const int STORE_FFC_MISC_MAX = 39; 

const int STORE_FFC_MISC_0 = 25;
const int STORE_FFC_MISC_1 = 26; 
const int STORE_FFC_MISC_2 = 27;
const int STORE_FFC_MISC_3 = 28; 
const int STORE_FFC_MISC_4 = 29; 
const int STORE_FFC_MISC_5 = 30; 
const int STORE_FFC_MISC_6 = 31; 
const int STORE_FFC_MISC_7 = 32; 
const int STORE_FFC_MISC_8 = 33;
const int STORE_FFC_MISC_9 = 34;
const int STORE_FFC_MISC_10 = 35; 
const int STORE_FFC_MISC_11 = 36; 
const int STORE_FFC_MISC_12 = 37; 
const int STORE_FFC_MISC_13 = 38; 
const int STORE_FFC_MISC_14 = 39; 

void StoreSomariaPlatform(ffc this, int arr){
	int q;
	arr[STORE_FFC_DATA] = this->Data;
	arr[STORE_FFC_SCRIPT] = this->Script;
	arr[STORE_FFC_CSET] = this->CSet;
	arr[STORE_FFC_DELAY] = this->Delay;
	arr[STORE_FFC_X] = this->X;
	arr[STORE_FFC_Y] = this->Y;
	arr[STORE_FFC_VX] = this->Vx;
	arr[STORE_FFC_VY] = this->Vy;
	arr[STORE_FFC_AX] = this->Ax;
	arr[STORE_FFC_AY] = this->Ay;
	for ( q = 0; q < 10; q++ ) arr[STORE_FFC_FLAGS_MIN] + q = this->Flags[q];
	arr[STORE_FFC_TILEWIDTH] = this->TileWidth;
	arr[STORE_FFC_TILEHEIGHT] = this->TileWidth;
	arr[STORE_FFC_EFFECTWIDTH] = this->EffectWidth;
	arr[STORE_FFC_EFFECTHEIGHT] = this->EffectHeight;
	arr[STORE_FFC_LINK] = this->Link;
	for ( q = 0; q < 15; q++ ) arr[STORE_FFC_MISC_MIN] + q = this->Misc[q];
}

void RestoreSomariaPlatform(ffc this, int arr){
	int q;
	this->Data = arr[STORE_FFC_DATA];
	this->Script = arr[STORE_FFC_SCRIPT];
	this->CSet = arr[STORE_FFC_CSET];
	this->Delay = arr[STORE_FFC_DELAY];
	this->X = arr[STORE_FFC_X];
	this->Y = arr[STORE_FFC_Y];
	this->Vx = arr[STORE_FFC_VX]; 
	this->Vy = arr[STORE_FFC_VY]; 
	this->Ax = arr[STORE_FFC_AX];
	this->Ay = arr[STORE_FFC_AY];
	for ( q = 0; q < 10; q++ ) this->Flags[q] = arr[STORE_FFC_FLAGS_MIN] + q;
	this->TileWidth = arr[STORE_FFC_TILEWIDTH];
	this->TileWidth = arr[STORE_FFC_TILEHEIGHT];
	this->EffectWidth = arr[STORE_FFC_EFFECTWIDTH];
	this->EffectHeight = arr[STORE_FFC_EFFECTHEIGHT];
	this->Link = arr[STORE_FFC_LINK];
	for ( q = 0; q < 15; q++ ) this->Misc[q] = arr[STORE_FFC_MISC_MIN] + q;
}

const int SOMARIA_PLATFORM_MOVE_COMBO_LAYER = 4;
const int SOMARIA_PLATFORM_MOVE_COMBO_LEFT = 1000;
const int SOMARIA_PLATFORM_MOVE_COMBO_RIGHT = 1001; 
const int SOMARIA_PLATFORM_MOVE_COMBO_UP = 1002;
const int SOMARIA_PLATFORM_MOVE_COMBO_DOWN = 1003;
const int SOMARIA_PLATFORM_MOVE_COMBO_STOP = 1004;

//**** TO DO ****

//! We need to make platforms flobal, so that they continue to exist between screen transitions.
//! To do this, the drawn effect, and the conditions that determine if Link is on a platform, and thus
//! unaffected by pits, will need to be global.
//! Further. the actual platform visuals will need to be drawn globally.
//! On-screen movement of the platform, following a combo path, can still be an ffc.

//! The tiles need to be CENTRED on the path, not bound to it at precise XY. This requires an offset
//! for each axis.

//! The player will need to be able to choose from branching paths. Thus, while on the platform, Link
//! should not be able to move, but he should be able to change direction. 
//! Pressing U/D/L/R should change his facing direction, and if on a path branch, change the path.
//! Only when the platform reaches a new [?] combo, should he be able to walk off.

//! Link should be able to use all items while on the platform, although jumping may be broken. 

//! We need to use a global condition, 'GRAM[ON_SOMARIA_PLATFORM]' to denote that Link can sail over pits. 
//! We can use this, without setting his Z-axis or anything else. This will be far more reliable, although
//! for bomb jumping, off the platform, we may need to set his Z-axis.

//! We need to prevent Link from being knocked back while on the Somaria platform. 

//Run on screen init. 
ffc script SomariaPlaform{
	void run(){
		
		
		bool inactive = true;
		int a[255]; lweapon l; ffc f; //f holds platform settings. 
		int platform[40]; 
		//we need void BackupFFC(ffc f, int arr) and RestoreFFC(int arr, ffc f)
		StoreSomariaPlatform(this, a); 
		while(true){
			while(inactive) {
				this->Vx = 0;
				this->Vy = 0; 
				this->Ax = 0;
				this->Ay = 0;
				this->Data = CMB_SOMARIA_PLATFORM_INACTIVE;
				this->EffectWidth = 16;
				this->EffectHeight = 16;
				this->TileWidth = 1; 
				this->TileHeight = 1;
				this->Effect
				for ( a[254] = Screen->NumLWeapons(); a[254] > 0; a[254]-- ) { //optimised v0.4
					l = Screen->LoadLWeapon(a[254]); 
					if ( l->Misc[LWEAPON_MISC_ID] == LWT_SOMARIA ) {
						if ( Collision(l,this) ) inactive = false; 
					}
				}
				Waitframe();
			}
			RestoreSomariaPlatform(this,a); //Restore the movement params, and the graphics, and size. 
			for ( q[254] = 0; q[254] < 176; q[254]++ ) {
				//Check collisions with combos on layer N for movement changes. 
				if ( GetLayerComboD(SOMARIA_PLATFORM_MOVE_COMBO_LAYER, q[254]) == SOMARIA_PLATFORM_MOVE_COMBO_LEFT )  {
					if ( Collision(this, cmb) {
						//This Collision() may be too sensitive. 
						//Change movement to leftward.
					}
				}
				if ( GetLayerComboD(SOMARIA_PLATFORM_MOVE_COMBO_LAYER, q[254]) == SOMARIA_PLATFORM_MOVE_COMBO_RIGHT )  {
					if ( Collision(this, cmb) {
						//This Collision() may be too sensitive. 
						//Change movement to rightward.
					}
				}
				if ( GetLayerComboD(SOMARIA_PLATFORM_MOVE_COMBO_LAYER, q[254]) == SOMARIA_PLATFORM_MOVE_COMBO_UP )  {
					if ( Collision(this, cmb) {
						//This Collision() may be too sensitive. 
						//Change movement to upwward.
					}
				}
				if ( GetLayerComboD(SOMARIA_PLATFORM_MOVE_COMBO_LAYER, q[254]) == SOMARIA_PLATFORM_MOVE_COMBO_DOWN )  {
					if ( Collision(this, cmb) {
						//This Collision() may be too sensitive. 
						//Change movement to downward.
					}
				}
				if ( GetLayerComboD(SOMARIA_PLATFORM_MOVE_COMBO_LAYER, q[254]) == SOMARIA_PLATFORM_MOVE_COMBO_STOP )  {
					if ( Collision(this, cmb) {
						//This Collision() may be too sensitive. 
						//Halt all movement
						this->Vx = 0;
						this->Vy = 0; 
						this->Ax = 0;
						this->Ay = 0;
					}
				}
				
				
			}
			//If Link is on the playform
			if ( Collision(this) ) { 
				//Move Link with the platform
				if ( !Link->Misc[ON_PLATFORM] ) Link->Misc[ON_PLATFORM = 1];
				Link->Z = 1;
				//...and keep his Z at 1 to pass over pits, unharmed. 
				
				//Store that Link is on a platform in Link->Misc[]
				//...we'll use that to ensure that we make a new platform under him, after screen transitions / during scrolling 
			}
			
			//If Link walks off the platform onto a pit...he shouldn;t keep falling in mid-air. 
			//We need to prevent that.
			
			//Stop reporting being on a platform, if Link isn't riding. 
			if ( !Collision(this) && Link->Misc[ON_PLATFORM] ) Link->Misc[ON_PLATFORM] = 0;
			
			Waitframe(); 
		}
	}
}


const int PITS_GRACE_WHEN_INJURED = 1; //If Link is hurt, he won;t fall down a pit. Good for bomb jumping, bad for other things.
const int PITS_ALLOW_BOMB_JUMPING = 1; //More precise for bomb jumping. 

	
	
ffc script Pit{
	void run(int respawn_screen_init){
		int a[256]; bool falling; bool pit; bool onpitedge; 
		
		Waitframes(5);
		
		//Store where Link was on screen init:
		a[50] = Link->X; a[51] = Link->Y;
		
		while(true){
			if ( !falling && !onpitedge && !Link->Misc[ON_PLATFORM] ) { a[10] = Link->X; a[11] = Link->Y; }
			if ( falling ) { a[12] = a[10]; a[13] = a[11]; }
			//Store Link's X/Y in the array, so that we have a respawn location. 
			//Find combos with a type of HOOKSHOT_ONLY and an Inherent Flag of CI_PIT.
			for ( a[0] = 0; a[0] < 176; a[0]++ ) {
				if ( ComboT[a[0]] == CT_HOOKSHOT || ComboT[a[0]] == CT_LADDER || ComboT[a[0]] == CT_LADDERHOOKSHOT || ComboI[a[0]] == CT_PIT ) {
					if ( DistX(a[0],14) && DistY(a[0],14) && !DistY(a[0],9) && !DistX(a[0],9) ) onpitedge = true; 
					else onpitedge = false; 
					if ( DistX(a[0],8) && DistY(a[0],8) {
						if ( !NumLWeaponsOf(LW_HOOKSHOT) ) {
							if ( Link->Z <= 0 && !Link->Jump ) {
								falling = true;
							}
						}
					}
				}
			}
			
				
			if ( falling ) {
				NoAction();
				
				Link->X = ComboX(a[0]); Link->Y = ComboY(a[0]);
				
				a[4] = ComboX(a[0]); a[5] = ComboY(a[0]);
				a[8] = 16; //Scale
				//Waitframe(); //Not needed if we're going it after Waitdraw()
				a[20] = Link->Tile; //Set before hs becomes invisible and this value turns to shyte.
				
				// We need to avoid storing this if the new location is a platform.  This is important, primarily 
				//because he can walk off the edge of a platform manually, and he'd fall in an endless loop. 
				
				//This might mean that either the platform ffc needs higher priority than this, so that the Link->Misc
				//value is set, or that we need to check if he is on a platform in the pits ffc, too. 
				
				
				
				if ( !effects ) {
					effects = true; 
					Game->PlaySound(SFX_FALL_PIT);
					Link->HP -= PIT_DAMAGE; 
				}
				for ( a[1] = 0; a[1] < PIT_FALLING_ANIM_DUR; a[1]++ ) {
					Screen_>DrawTile(2, a[4]; a[5]; a[20]; ... scale=a[8], ... true, OP_OPAQUE);
					if ( a[1] % 10 == 0 && a[8] > 0 ) a[8]--; //Trim the scale.
					Waitframe();
				}
				Waitframes(5);
				//Spawn Link Again
				for ( a[1] = 0; a[1] < PIT_RESPAWN_LINK_DUR; a[1]++ ) {
					if ( !respawn_screen_init ) 
						Link->X = a[12]; Link->Y = a[13];
					if ( respawn_screen_init ) 
						//If d0 is set, we read a[50] and a[51] for the values to use when respawning him.
						Link->X = a[50]; Link->Y = a[51];
					if ( a[1] % 4 != 0 ) Link->Invisible = true;
					else Link->Invisible = false; 
					Waitframe(); 
				}
				falling = false;
				effects = false; 
					//Freeze Link
					//Store his x/y
					//Center the x/y over the combo
					//Make Link invisible, 
					//Draw his tile in a loop, growing smaller
					//Play falling sound
					//hurt him
					//Wait a few frames
					//Spawn him
					//make him flicker by using a for loop, in which at % == 0 he is visible, and ! % == 0 he is invisible
						//for 30 frames, during which his collision is off. 
				}
			Waitframe();
		}
	}
}


//! Somaria Blocks

const int CMB_SOMARIA = 1000;
const int TILE_SOMARIA = 10000;
const int SPRITE_SOMARIA = 100; 

const int SFX_SOMARIA_BEAMS = 63;

const int CMB_MOVING_COMARIA_D = 1001;  //4-way push
const int CMB_MOVING_SOMARIA_C = 0; //CSet
const int CMB_MOVING_SOMARIA_T = ;
const int CMB_MOVING_SOMARIA_S = 4;
const int CMB_MOVING_SOMARIA_F = ;
const int CMB_MOVING_SOMARIA_I = ;

const int SPRITE_SOMARIA_BEAM = 101; 

const int SOMARIA_BEAM_BASEPOWER = 8;


int Somaria[214747];
const int SOMARIA_NEWBLOCK_OLDCOMBO = 0;
const int SOMARIA_NEWBLOCK_OLDCOMBO_D = 1;
const int SOMARIA_NEWBLOCK_OLDCOMBO_T = 2;
const int SOMARIA_NEWBLOCK_OLDCOMBO_C = 3;
const int SOMARIA_NEWBLOCK_OLDCOMBO_S = 4;
const int SOMARIA_NEWBLOCK_OLDCOMBO_F = 5;
const int SOMARIA_NEWBLOCK_OLDCOMBO_I = 6;


const int SOMARIA_NEWBLOCK_NEWCOMBO = 7;
const int SOMARIA_NEWBLOCK_NEWCOMBO_D = 8;
const int SOMARIA_NEWBLOCK_NEWCOMBO_T = 9;
const int SOMARIA_NEWBLOCK_NEWCOMBO_C = 10;
const int SOMARIA_NEWBLOCK_NEWCOMBO_S = 11;
const int SOMARIA_NEWBLOCK_NEWCOMBO_F = 12;
const int SOMARIA_NEWBLOCK_NEWCOMBO_I = 13;

const int SOMARIA_BLOCK_EXISTS = 100; 
const int SOMARIA_BEAM_POWER = 200; 

void SetSomariaBeamPower(int power){
	Somaria[SOMARIA_BEAM_POWER] = power;
}
int GetSomariaBeamPower(){ return Somaria[SOMARIA_BEAM_POWER];}

const int TILE_LINK_LIFT_UP = 0;
const int TILE_LINK_LIFT_DOWN = 0;
const int TILE_LINK_LIFT_LEFT = 0;
const int TILE_LINK_LIFT_RIGHT = 0;
const int SOMARIA_OVERHEAD_OFFSET_X_UP = 0;
const int SOMARIA_OVERHEAD_OFFSET_X_DOWN = 0;
const int SOMARIA_OVERHEAD_OFFSET_X_LEFT = 0;
const int SOMARIA_OVERHEAD_OFFSET_X_RIGHT = 0;
const int SOMARIA_OVERHEAD_OFFSET_Y_UP = 0;
const int SOMARIA_OVERHEAD_OFFSET_Y_DOWN = 0;
const int SOMARIA_OVERHEAD_OFFSET_Y_LEFT = 0;
const int SOMARIA_OVERHEAD_OFFSET_Y_RIGHT = 0;

const int LW_SOMARIA = 0; //Probably a script type. 
const int LW_SOMARIA_BEAM = 0; //Probably the same as swordbeams. 
const int LW_SOMARIA_FLAME = 0; //If we also want to double the somaria beam so that it acts as fire. 

const int SOMARIA_BEAMS_COUNT_AS_FIRE = 1; //A setting to make somaria beams also count as fire weapons. 
const int SOMARIA_BEAMS_SET_OFF_BOMBS = 1; //What it says on the tin. 

bool CreateBlock(int x, int y){
	//Store the combo that was at this location. 
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] = ComboAt(x,y);
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_D] = Screen->ComboD[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_C] = Screen->ComboC[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_T] = Screen->ComboT[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_S] = Screen->ComboS[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_F] = Screen->ComboF[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_I] = Screen->ComboI[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	
	
	
	
	//Chexk that the combo is non-solid. 
	if ( Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_S] ) return false;
	else {
		//otherwise, let's make a moving block. 
		Screen->ComboD[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_COMARIA_D;
		Screen->ComboC[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_SOMARIA_C;
		Screen->ComboT[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_SOMARIA_T;
		Screen->ComboS[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_SOMARIA_S;
		Screen->ComboF[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_SOMARIA_F;
		Screen->ComboI[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_SOMARIA_I; 
		Somaria[SOMARIA_BLOCK_EXISTS] = 1;
		
		//Mark where the Somaria Block is going, and its types. 
		
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO] = SOMARIA_NEWBLOCK_OLDCOMBO;
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_D] = Screen->ComboD[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_C] = Screen->ComboC[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_T] = Screen->ComboT[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_S] = Screen->ComboS[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_F] = Screen->ComboF[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_I] = Screen->ComboI[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	
		
		return true;
	}
}

//Returns the Nuth combo index of a combo based on a central point, and a direction.
//For example, combo 22 + COMBO_UPRIGHT returns '7', 
//as combo 7 is to the upper-right of combo 22.
int AdjacentCombo(int cmb, int dir){
    int combooffsets[13]={-0x10,-0x0F,-0x0E,1,0x10,0x0F,0x0E,-1,-0x10};
    if ( cmb % 16 == 0 ) combooffsets[9] = 1;
    if ( cmb & 15 == 1 ) combooffsets[10] = 1;
    if ( cmb < 0x10 ) combooffsets[11] = 1;
    if ( cmb < 0xAF ) combooffsets[12] = 1;
    if ( combooffsets[9] && ( dir == CMB_LEFT || dir == CMB_UPLEFT || dir == CMB_DOWNLEFT || dir == CMB_LEFTUP ) ) return 0;
    if ( combooffsets[10] && ( dir == CMB_RIGHT || dir == CMB_UPRIGHT || dir == CMB_DOWNRIGHT ) ) return 0;
    if ( combooffsets[11] && ( dir == CMB_UP || dir == CMB_UPRIGHT || dir == CMB_UPLEFT || dir == CMB_DOWNLEFT ) ) return 0;
    if ( combooffsets[12] && ( dir == CMB_DOWN || dir == CMB_DOWNRIGHT || dir == CMB_DOWNLEFT ) ) return 0;
    else if ( cmb > 0 && cmb < 177 ) return cmb + combooffsets[dir];
    else return 0;
}

bool CheckMovingBlocksForSomaria(){
	if ( Somaria[SOMARIA_BLOCK_EXISTS] && Screen->MovingBlockX != -1 && Screen->MovingBlockY !+ -1 ) {
		//Compare the XY of any moving block on the screen, and see if it is/was where a somari ablock is located. 
		
		if ( ComboAt(Screen->MovingBlockX, Screen->MovingBlockY) == Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ){
			
			//We found a somaria block thT IS MOVING. 
			//Update the combo and location. 
			int loc[20];
			loc[0] = AdjacentCombo( Somaria[SOMARIA_NEWBLOCK_OLDCOMBO], Link->Dir );
			loc[1] = ComboAt(Screen->MovingBlockX, Screen->MovingBlockY);
			//Replace the 'old' combo with the stored values, and store the values for the new combo onto 
			//which the block moves. 
			
			//First, store the values for the old position. 
			loc[2] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_D];
			loc[3] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_T];
			loc[4] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_C];
			loc[5] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_S];
			loc[6] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_F];
			loc[7] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_I];
			
			//Then update the combos for the new location, so that we know what *was* under where the block is moving.
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_D] = ComboD[ loc[0] ];
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_T] = ComboT[ loc[0] ];
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_C] = ComboC[ loc[0] ];
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_S] = ComboS[ loc[0] ];
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_F] = ComboF[ loc[0] ];
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_I] = ComboI[ loc[0] ];
			
			
			//then wait a frame, and draw back the old, stored combo values. 
			
			Waitframe(); //We may need to wait extra frames between these steps. 
			
			ComboD[ loc[1] ] = loc[2];
			ComboT[ loc[1] ] = loc[3];
			ComboC[ loc[1] ] = loc[4];
			ComboS[ loc[1] ] = loc[5];
			ComboF[ loc[1] ] = loc[6];
			ComboI[ loc[1] ] = loc[7];
			
			//Updating should be done. 
			return true;
		}
		return false;
		
	}
}

bool LiftBlock(int x, int y){
	//Should we change the combo back?
	//Only if we're not in A DUNGEON.
	
}
	
//! Somaria Cane Item
item script CaneOfSomaria{
	void run(){
		if ( !Somaria[SOMARIA_BLOCK_EXISTS] ) {
			if ( Link->Dir == DIR_UP ) CreateBlock( GridX(Link->X), GridY(Link->Y - 16) );
			if ( Link->Dir == DIR_DOWN ) CreateBlock( GridX(Link->X), GridY(Link->Y + 16) );
			if ( Link->Dir == DIR_RIGHT ) CreateBlock( GridX(Link->X + 16), GridY(Link->Y) );
			if ( Link->Dir == DIR_LEFT ) CreateBlock( GridX(Link->X - 16), GridY(Link->Y) ); 
			
			//! We need to make an lweapon with a Misc. attribute that matches position with the moving block.
				//! If on a conveyor, we only make the lweapon. The Block combo can be created ONLY when the 
				//! lweapon STOPS MOVING, reaching the end of a conveyor path, and only after a specific number of frames.
				//! We need these frames for conveyors that change direction, to determine if the block has fully stopped moving.
				//! Alternatively, we could force the block to move off the conveyor, onto another combo, if it 
				//! is not blocked from further movement, or something.
				//! Perhaps we could use a 'stop Somaria block' flag?
			
			lweapon block;
			
			
			else {
				//Change the combo back to what was stored.
				
		
				Screen->ComboD[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_D];
				Screen->ComboC[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_C];
				Screen->ComboT[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_T];
				Screen->ComboS[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_S];
				Screen->ComboF[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_F];
				Screen->ComboI[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_I];
						
				
				
				//Create a 4-way beam.
				lweapon somariabeam[4];
				Game->PlaySound(SFX_SOMARIA_BEAMS); 
				for ( int q = 0; q < 4; q++ ) {
					somariabeam[q] = Screen->CreateLWeapon(LW_SOMARIBEAM); 
					somariabeam[q]->X = CenterX(ComboX(Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]));
					somariabeam[q]->Y = CenterY(ComboY(Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]));
					somariabeam[q]->UseSprite = SPRITE_SOMARIA_BEAM;
					if ( GetSomariaBeamPower() ) somariabeam[q]->Damage = SOMARIA_BEAM_POWER;
					else somariabeam[q]->Damage = SOMARIA_BEAM_POWER; 
					if ( q % 2 != 0 ) somariabeam[q]->UseSprite++;
				}
				
				somariabeam[0]->Dir = DIR_UP;
				somariabeam[1]->Dir = DIR_LEFT;
				somariabeam[2]->Dir = DIR_DOWN;
				somariabeam[3]->Dir = DIR_RIGHT;
				
			}
		}
	}
}
				
				
//! Somaria Lift-able Objects

//! Somaria Blocks on Conveyors

//Move Bombs or Blocks on Conveyors

//Global conditions to move all of any object type. 
const int CONVEYORS_MOVE_FFCS = 0;
const int CONVEYORS_MOVE_ITEMS = 0; //ZC already does, but you could use this to chane their speed. 
const int CONVEYORS_MOVE_LWEAPONS = 0;
const int CONVEYORS_MOVE_EWEAPONS = 0;
const int CONVEYORS_MOVE_NPCS = 0;

const int CONVEYORS_MOVE_BOMBS = 1; 
const int CONVEYORS_MOVE_WALKING_NPCS = 0;

const int CONVEYORS_USE_COLLISION = 1; //Se tto 0 to use coordinates, instead of collision. 

 bool IsOnConveyor(int cmb){
	 return ( ComboT[cmb] == CT_CVLEFT || ComboT[cmb] == CT_CVRIGHT || ComboT[cmb] == CT_CVUP ||ComboT[cmb] == CT_CVDOWN );
 }
 
 const int WEAP_CONVEY_TIMER = 1; //Misc Index
 
 const int CONVEY_TIME = 20; //How many frames to wait before moving one pixel on a conveyor, +1. 
				//! The movement occurs at '1', not '0'.
 
 void MarkObjectConveyor(lweapon l) { if ( !l->Misc[WEAP_CONVEY_TIMER] ) l->Misc[WEAP_CONVEY_TIMER] = CONVEY_TIME; }
 
 void MoveObjectConveyor(lweapon l) { 
	if ( l->Misc[WEAP_CONVEY_TIMER] == 1 ) {
		//Move it
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVLEFT ) l->X--;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVRIGHT ) l->X++;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVUP ) l->Y--;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVDOWN ) l->Y++;
	}
	if ( l->Misc[WEAP_CONVEY_TIMER] > 1 ) l->Misc[WEAP_CONVEY_TIMER]--;
	if ( !l->Misc[WEAP_CONVEY_TIMER] && IsOnConveyor(l) ) MarkObjectConveyor(l);
}
 

 void MarkObjectConveyor(eweapon l) { if ( !l->Misc[WEAP_CONVEY_TIMER] ) l->Misc[WEAP_CONVEY_TIMER] = CONVEY_TIME; }
 
 void MoveObjectConveyor(eweapon l) { 
	if ( l->Misc[WEAP_CONVEY_TIMER] == 1 ) {
		//Move it
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVLEFT ) l->X--;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVRIGHT ) l->X++;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVUP ) l->Y--;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVDOWN ) l->Y++;
	}
	if ( l->Misc[WEAP_CONVEY_TIMER] > 1 ) l->Misc[WEAP_CONVEY_TIMER]--;
	if ( !l->Misc[WEAP_CONVEY_TIMER] && IsOnConveyor(l) ) MarkObjectConveyor(l);
}

 void MarkObjectConveyor(item l) { if ( !l->Misc[WEAP_CONVEY_TIMER] ) l->Misc[WEAP_CONVEY_TIMER] = CONVEY_TIME; }
 
 void MoveObjectConveyor(item l) { 
	if ( l->Misc[WEAP_CONVEY_TIMER] == 1 ) {
		//Move it
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVLEFT ) l->X--;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVRIGHT ) l->X++;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVUP ) l->Y--;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVDOWN ) l->Y++;
	}
	if ( l->Misc[WEAP_CONVEY_TIMER] > 1 ) l->Misc[WEAP_CONVEY_TIMER]--;
	if ( !l->Misc[WEAP_CONVEY_TIMER] && IsOnConveyor(l) ) MarkObjectConveyor(l);
}
 
 void MarkObjectConveyor(ffc l) { if ( !l->Misc[WEAP_CONVEY_TIMER] ) l->Misc[WEAP_CONVEY_TIMER] = CONVEY_TIME; }
 
 void MoveObjectConveyor(ffc l) { 
	if ( l->Misc[WEAP_CONVEY_TIMER] == 1 ) {
		//Move it
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVLEFT ) l->X--;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVRIGHT ) l->X++;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVUP ) l->Y--;
		if ( ComboT[ComboAt(l->X, l->Y)] == CT_CVDOWN ) l->Y++;
	}
	if ( l->Misc[WEAP_CONVEY_TIMER] > 1 ) l->Misc[WEAP_CONVEY_TIMER]--;
	if ( !l->Misc[WEAP_CONVEY_TIMER] && IsOnConveyor(l) ) MarkObjectConveyor(l);
}


 void MoveObjectConveyorCollision(ffc l, int cmb) { 
	if ( l->Misc[WEAP_CONVEY_TIMER] == 1 ) {
		//Move it
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVLEFT ) l->X--;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVRIGHT ) l->X++;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVUP ) l->Y--;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVDOWN ) l->Y++;
	}
	if ( l->Misc[WEAP_CONVEY_TIMER] > 1 ) l->Misc[WEAP_CONVEY_TIMER]--;
	if ( !l->Misc[WEAP_CONVEY_TIMER] && IsOnConveyor(l) ) MarkObjectConveyor(l);
}

 void MoveObjectConveyorCollision(item l, int cmb) { 
	if ( l->Misc[WEAP_CONVEY_TIMER] == 1 ) {
		//Move it
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVLEFT ) l->X--;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVRIGHT ) l->X++;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVUP ) l->Y--;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVDOWN ) l->Y++;
	}
	if ( l->Misc[WEAP_CONVEY_TIMER] > 1 ) l->Misc[WEAP_CONVEY_TIMER]--;
	if ( !l->Misc[WEAP_CONVEY_TIMER] && IsOnConveyor(l) ) MarkObjectConveyor(l);
}

 void MoveObjectConveyorCollision(lweapon l, int cmb) { 
	if ( l->Misc[WEAP_CONVEY_TIMER] == 1 ) {
		//Move it
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVLEFT ) l->X--;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVRIGHT ) l->X++;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVUP ) l->Y--;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVDOWN ) l->Y++;
	}
	if ( l->Misc[WEAP_CONVEY_TIMER] > 1 ) l->Misc[WEAP_CONVEY_TIMER]--;
	if ( !l->Misc[WEAP_CONVEY_TIMER] && IsOnConveyor(l) ) MarkObjectConveyor(l);
}

 void MoveObjectConveyorCollision(eweapon l, int cmb) { 
	if ( l->Misc[WEAP_CONVEY_TIMER] == 1 ) {
		//Move it
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVLEFT ) l->X--;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVRIGHT ) l->X++;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVUP ) l->Y--;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVDOWN ) l->Y++;
	}
	if ( l->Misc[WEAP_CONVEY_TIMER] > 1 ) l->Misc[WEAP_CONVEY_TIMER]--;
	if ( !l->Misc[WEAP_CONVEY_TIMER] && IsOnConveyor(l) ) MarkObjectConveyor(l);
}

 void MoveObjectConveyorCollision(npc l, int cmb) { 
	if ( l->Misc[WEAP_CONVEY_TIMER] == 1 ) {
		//Move it
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVLEFT ) l->X--;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVRIGHT ) l->X++;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVUP ) l->Y--;
		if ( Collision(l,cmb) && ComboT[cmb] == CT_CVDOWN ) l->Y++;
	}
	if ( l->Misc[WEAP_CONVEY_TIMER] > 1 ) l->Misc[WEAP_CONVEY_TIMER]--;
	if ( !l->Misc[WEAP_CONVEY_TIMER] && IsOnConveyor(l) ) MarkObjectConveyor(l);
}

void ConveyorObjects(){
	lweapon l; item i; eweapon e; npc n; ffc f; int q;
	if ( CONVEYORS_MOVE_BOMBS ) {
		for ( q = Screen->NumLWeapons(); q > 0; q-- ) {
			l = Screen->LoadLWeapon(q); 
			if ( l->ID == LW_BOMB || l->ID == LW_SBOMB ) MoveObjectConveyor(l);
		}
	}
	//Add more definitions. 
	//Somaria Blocks
	
	//Walking NPCs? -- How should we handle ghosted NPCs?
}

void ConveyorObjectsCollision(){
	lweapon l; item i; eweapon e; npc n; ffc f; int q; int cmb; 
	if ( CONVEYORS_MOVE_BOMBS ) {
		for ( cmb = 0; cmb < 176; cmb++ ) {
			for ( q = Screen->NumLWeapons(); q > 0; q-- ) {
				l = Screen->LoadLWeapon(q); 
				if ( l->ID == LW_BOMB || l->ID == LW_SBOMB ) MoveObjectConveyorCollision(l,cmb);
			}
		}
	}
	//Add more definitions. 
	//Somaria Blocks
	
	//Walking NPCs? -- How should we handle ghosted NPCs?
}
 
global script conveyor_test{
	void run(){
		while(true){
			if ( !CONVEYORS_USE_COLLISION ) ConveyorObjects();
			if ( CONVEYORS_USE_COLLISION ) ConveyorObjectsCollision();
			Waitdraw();
			Waitframe();
		}
	}
}
				