//Chests Using Callbacks, Alpha 3

float CallBacks[1024];  //0 is NULL, and the current callback index; the rest are array pointers. 

item script Pickup_Chest_Callback{
	void run(int message){
		SetScreenDBit(Game->GetCurScreen(), CHEST_REGISTER, bit, true);
		
		
		int ptr = GetCurrentCallBack();
		
		//Callback messages. 
		int item_id = ptr[0]; 
		int bit = ptr[1];
		int key_type = ptr[2];
		//int sound = ptr[2]; 
		int holdtype = ptr[3]; 
		int combo_pos = ptr[4];
		int layer = ptr[5];
		int chest_type = ptr[6];
		
		void ChestOpened(bit, true); //Mark the chest opened. 
		
		if ( key_type == 1 ) Game->DCounter[CR_KEYS] -= 1; //Regular key
		if ( key_type == 2 ) Game->LKeys[Game->GetCurLevel()] -= 1; //Boss Key
		
		
		if ( sound > 0 ) { Game->PlaySound(sound); }
		if ( message > 0 ) { Screen->Message(sound); }
		
		if ( holdtype ) {
			Link->Action = LA_HOLD1LAND + holdtype - 1;
			Link->HeldItem = item_id;
		}
		
		//Update the chest combos based on the positions and chest types on the given layer. 
		if ( chest_type == CHEST_TYPE_SMALL ) {
			SetLayerComboD(layer, combo_pos, (GetLayerComboD(layer, combo_pos)+1);
		}
		
		if ( chest_type == CHEST_TYPE_BIG ) {
			SetLayerComboD(layer, combo_pos, (GetLayerComboD(layer, combo_pos)+1);
			SetLayerComboD(layer, combo_pos+1, (GetLayerComboD(layer, combo_pos)+1);
		}
		
		if ( chest_type == CHEST_TYPE_GRAND ) {
			SetLayerComboD(layer, combo_pos, (GetLayerComboD(layer, combo_pos)+1);
			SetLayerComboD(layer, combo_pos+1, (GetLayerComboD(layer, combo_pos)+1);
			SetLayerComboD(layer, combo_pos-15, (GetLayerComboD(layer, combo_pos)+1);
			SetLayerComboD(layer, combo_pos-16, (GetLayerComboD(layer, combo_pos)+1);
		}
		
		ClearCallBack(ptr);
		ClearCurrentCallBack();
	}
}

//void SetCallBackStart(int index) { 
	
//}

void ClearCallBacks() { 
	int sz = SizeOfArray(CallBacks); 
	for ( int q = 0; q < zs; q++ ) {
		CallBacks[q] = -1;
	}
}

int GetFreeCallback() {
	for ( int q = 0; q < zs; q++ ) {
		if ( CallBacks[q] == -1 ) return q;
	}
	return 0; //Null Callback ID
}

int SetCurrentCallBack(){
	int cb = GetFreeCallback();
	if (cb) { CallBacks[0] = cb; return cb; }
	return 0;
}

int GetCurrentCallBack(){
	return CallBacks[0];
}

int StoreCallBack(int ptr){
	int cb = GetCurrentCallBack();
	if (cb) { CallBacks[cb] = ptr; return 1; }
	return 0;
}

void ClearCallBack(int value){
	 CallBacks[value] = -1; 
}

bool ClearCurrentCallBack(){
	int cb = CallBacks[0];
	CallBacks[cb] = -1;
}

//Screen->D[reg] to use for chest open flagss.
const int CHEST_REGISTER = 5;

const int CHEST_ONE 	= 00000001b;
const int CHEST_TWO 	= 00000010b;
const int CHEST_THREE 	= 00000100b;
const int CHEST_FOUR 	= 00001000b;
const int CHEST_FIVE 	= 00010000b;
const int CHEST_SIX 	= 00100000b;
const int CHEST_SEVEN 	= 01000000b;
const int CHEST_EIGHT 	= 10000000b;

bool ChestOpenedSpecific(int flag){
	return ( (Screen->D[CHEST_REGISTER]&flag) != 0 );
bool ChestOpened(int index){
	return ((Screen->D[CHEST_REGISTER] & (01b << index) ) != 0); 
}
void ChestOpened(int index, bool state){
	if ( state ) { (Screen->D[CHEST_REGISTER] |= (01b << index) ); }
	else { (Screen->D[CHEST_REGISTER] &= (~(01b << index)) ); }
}

void ChestOpenedSpecific(int flag, bool state){
	if ( state ) { (Screen->D[CHEST_REGISTER] |= flag ); }
	else { Screen->D[CHEST_REGISTER] &= ~flag; }
}

//Combos
const int CMB_CHEST_SMALL = 0; 
const int CMB_CHEST_SMALL_LOCKED = 0;
const int CMB_CHEST_SMALL_BOSSLOCKED = 0;

//Big chests,  1x2 left combo of each
const int CMB_CHEST_BIG = 0;
const int CMB_CHEST_BIG_LOCKED = 0;
const int CMB_CHEST_BIG_BOSSLOCKED = 0;

//Big chests, 4x4 combo saize, bottom-left combo. 
const int CMB_CHEST_LARGE = 0;
const int CMB_CHEST_LARGE_LOCKED = 0;
const int CMB_CHEST_LARGE_BOSSLOCKED = 0;

//const int CHEST_LAYER = 1; //Layer on which chests are placed. 

//Check for chests on these layers. 0 = No, 1= yes.
const int CHEST_LAYER_0 = 1; //Check for chests on layer 0
const int CHEST_LAYER_1 = 1; //Check for chests on layer 1
const int CHEST_LAYER_2 = 1; //Check for chests on layer 2

const int CHEST_HOLDUP_TYPE = 1; //0 = none, 1 = one hand, 2 = two hands. 

//Type definitions, DO NOT CHANGE. 
const int CHEST_TYPE_SMALL = 1; 
const int CHEST_TYPE_SMALL_LOCKED = 2;
const int CHEST_TYPE_SMALL_BOSSLOCKED = 3;
const int CHEST_TYPE_BIG = 4;
const int CHEST_TYPE_BIG_LOCKED = 5;
const int CHEST_TYPE_BIG_BOSSLOCKED = 6;
const int CHEST_TYPE_GRAND = 7;
const int CHEST_TYPE_GRAND_LOCKED = 8;
const int CHEST_TYPE_GRAND_BOSSLOCKED = 9;

const int SFX_CHEST_UNLOCK = 0;

const int CHEST_ITEM_SPAWN_DISTANCE = 48; 
const int SFX_CHEST_ITEM_ANIM = 0; 
const int CHEST_ITEM_ANIM_DUR = 100;
const float CHEST_ITEM_ANIM_MOVE_SPEED = 0.334;

const int CHEST_BUTTON_A = 1;
const int CHEST_BUTTON_B = 0;

bool PressChestButton(){
	if ( CHEST_BUTTON_A && Link->PressA ) return true;
	if ( CHEST_BUTTON_B && Link->PressB ) return true;
	return false;
}

bool IsChest(int cmb){
	int chests[]={CMB_CHEST_LARGE_BOSSLOCKED, CMB_CHEST_LARGE_LOCKED, CMB_CHEST_LARGE, CMB_CHEST_BIG_BOSSLOCKED,
			CMB_CHEST_BIG_LOCKED,CMB_CHEST_BIG, CMB_CHEST_SMALL_BOSSLOCKED,
			CMB_CHEST_SMALL_LOCKED, CMB_CHEST_SMALL}; 
	for ( int q = SizeOfArray(chests); q >= 0; q-- ) {
		if ( cmb == chests[q] ) return true;
	}
	return false;
}

bool IsSmallChest(int cmb){
	int chests[]={CMB_CHEST_SMALL_BOSSLOCKED,
			CMB_CHEST_SMALL_LOCKED, CMB_CHEST_SMALL}; 
	for ( int q = SizeOfArray(chests); q >= 0; q-- ) {
		if ( cmb == chests[q] ) return true;
	}
	return false;
}

bool IsBigChest(int cmb){
	int chests[]={CMB_CHEST_BIG_BOSSLOCKED,
			CMB_CHEST_BIG_LOCKED,CMB_CHEST_BIG}; 
	for ( int q = SizeOfArray(chests); q >= 0; q-- ) {
		if ( cmb == chests[q] ) return true;
	}
	return false;
}

bool IsGrandChest(int cmb){
	int chests[]={CMB_CHEST_LARGE_BOSSLOCKED, CMB_CHEST_LARGE_LOCKED, CMB_CHEST_LARGE}; 
	for ( int q = SizeOfArray(chests); q >= 0; q-- ) {
		if ( cmb == chests[q] ) return true;
	}
	return false;
}

bool IsUnlockedChest(int cmb){
	int chests[]={CMB_CHEST_LARGE, CMB_CHEST_BIG, CMB_CHEST_SMALL}; 
	for ( int q = SizeOfArray(chests); q >= 0; q-- ) {
		if ( cmb == chests[q] ) return true;
	}
	return false;
}

bool IsLockedChest(int cmb){
	int chests[]={CMB_CHEST_LARGE_LOCKED, CMB_CHEST_BIG_LOCKED, CMB_CHEST_SMALL_LOCKED}; 
	for ( int q = SizeOfArray(chests); q >= 0; q-- ) {
		if ( cmb == chests[q] ) return true;
	}
	return false;
}

bool IsBossLockedChest(int cmb){
	int chests[]={CMB_CHEST_LARGE_BOSSLOCKED, CMB_CHEST_BIG_BOSSLOCKED, CMB_CHEST_SMALL_BOSSLOCKED}; 
	for ( int q = SizeOfArray(chests); q >= 0; q-- ) {
		if ( cmb == chests[q] ) return true;
	}
	return false;
}

ffc script Chest{
	//void run(int contents, int enemy, int open_from_side, int e, int f, int g, int h){
	
	
	void run(int contents_enemy_1, int contents_enemy_2, int contents_enemy_3, int contents_enemy_4, 
			int contents_enemy_5, int contents_enemy_6, int contents_enemy_7, int contents_enemy_8){
		int q[256]; 
		/*
		//	[0] Loop Q
		//	[1] Loop W
		//	[2] Loop E
		//	[3] Temp Chest Contents for Item creation anim and hold-up
			[4] Temp that holds the array index for the 8 sized arrays
			[5] Temp that holds the combo ID for check loops
			[6] Temp combo for adjacentcombo
			[7] [7] Temp for combo position above Link. 
			[8] Temp for chest ids when opening chests
			[9] UNUSED
			[10] to [19] UNUSED
			[20] = chest unlocked (ID)
			[21-29] Unused
			[30] pre-animation loop, and then animation timer
			[31-49] Unused
			[50], [51] Callbacks. 
			
		*/
		int chest_exists[8];
		int chest_pos[8];
		int chest_type[8]; 
		int chest_layer[8];
		int is_chest[176]; //flag for every combo position. values are 1, 2, and 3, for chests on layers 0, 1, and 2. 
			
		int chest_pos_id[176]; //the main combo of each chest group, 0 to 7. 
		for ( q[0] = 0; q[0] < 8; q[0]++ ) chest_pos_id[q[0]] = -1; //wipe
		
		for ( q[0] = 0; q[0] < 8; q[0]++ ) chest_layer[q[0]] = -1; //Wipe the array
			
		int pickup_script_args[8]; //fed to the callback
			// [0] None
			// [1] Small, Unlocked
			// [2] Small, Locked
			// [3] Small, Bosslocked
			// [4] Large, Unlocked
			// [5] Large, Locked
			// [6] Large, Bosslocked
		int chest_contents[8]; //negative values are npcs. 
		
		//int contents[16];
		//int enemy[16]; 
		item i; itemdata id;
		//Check which chests EXIST and flag them	
		
			
		//Sotore the positions --combo locations-- of each chest
		
		q[4] = 0; //temp for chest IDs
		for ( q[0] = 0; q[0] < 176; q[0]++ ){
			//Check by layer based on global flags
			if ( CHEST_LAYER_0 ) {
				q[5] = Screen->ComboD[q[0]]
				//if it is any type of chest...
				if ( IsChest(q[5]){
					chest_exists[ q[4] ] = 1; //Mark that there is a chest
					chest_pos[ q[4] ] = q[0]; //store the position
					chest_contents[ q[4] ] = this->InitD[ q[4] ];
					chest_layer[q[4]] = 0; 
					is_chest[q[0]] = 1;
					chest_pos_id[q[0]] = q[4];
					//if it is a small chest
					if ( IsSmallChest(q[5]){
						if ( IsUnlockedChest(q[5]){
							chest_type[q[4]] = 1; //Flag it small unlocked.
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsLockedChest(q[5]) ){
							chest_type[q[4]] = 2; //Flag it small locked.
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsBossLockedChest(q[5]) ){
							chest_type[q[4]] = 3; //Flag it small locked.
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
					}
					if ( IsBigChest(q[5]){
						if ( IsUnlockedChest(q[5]){
							chest_type[q[4]] = 4; //Flag it big unlocked.
							is_chest[q[0]+1] = 1;
							q[4]++; //increment the temp index.
							
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsLockedChest(q[5]) ){
							chest_type[q[4]] = 5; //Flag it big locked.
							is_chest[q[0]+1] = 1;
							q[4]++; //increment the temp index.
							
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsBossLockedChest(q[5]) ){
							chest_type[q[4]] = 6; //Flag it big locked.
							is_chest[q[0]+1] = 1;
							q[4]++; //increment the temp index.
							
							if ( q[4] > 7 ) break;
							continue;
						}
					}
					if ( IsGrandChest(q[5]){
						if ( IsUnlockedChest(q[5]){
							chest_type[q[4]] = 7; //Flag it small unlocked.
							is_chest[q[0]+1] = 1;
							is_chest[q[0]-15] = 1;
							is_chest[q[0]-16] = 1;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsLockedChest(q[5]) ){
							chest_type[q[4]] = 8; //Flag it small locked.
							is_chest[q[0]+1] = 1;
							is_chest[q[0]-15] = 1;
							is_chest[q[0]-16] = 1;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsBossLockedChest(q[5]) ){
							chest_type[q[4]] = 9; //Flag it small locked.
							is_chest[q[0]+1] = 1;
							is_chest[q[0]-15] = 1;
							is_chest[q[0]-16] = 1;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							
							continue;
						}
					}
					
				}
			}
			//layer 1
			if ( CHEST_LAYER_1 ) {
				q[5] = GetLayerComboD(1,q[0]);
				//if it is any type of chest...
				//ignore this pass if this index is already a chest on a lower layer. 
				if ( chest_layer[q[4]] >= 0 ) { continue; } 
				
				if ( IsChest(){
					chest_exists[ q[4] ] = 1; //mark that there is a chest
					chest_pos[ q[4] ] = q[0]; //store the position
					chest_layer[q[4]] = 1; 
					is_chest[q[0]] = 2;
					//if it is a small chest
					if ( IsSmallChest(q[5]){
						if ( IsUnlockedChest(q[5]){
							chest_type[q[4]] = 1; //Flag it small unlocked.
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsLockedChest(q[5]) ){
							chest_type[q[4]] = 2; //Flag it small locked.
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsBossLockedChest(q[5]) ){
							chest_type[q[4]] = 3; //Flag it small locked.
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
					}
					if ( IsBigChest(q[5]){
						if ( IsUnlockedChest(q[5]){
							chest_type[q[4]] = 4; //Flag it big unlocked.
							is_chest[q[0]+1] = 2;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsLockedChest(q[5]) ){
							chest_type[q[4]] = 5; //Flag it big locked.
							is_chest[q[0]+1] = 2;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsBossLockedChest(q[5]) ){
							chest_type[q[4]] = 6; //Flag it big locked.
							is_chest[q[0]+1] = 2;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
					}
					if ( IsGrandChest(q[5]){
						if ( IsUnlockedChest(q[5]){
							chest_type[q[4]] = 7; //Flag it small unlocked.
							is_chest[q[0]+1] = 2;
							is_chest[q[0]-15] = 2;
							is_chest[q[0]-16] = 2;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsLockedChest(q[5]) ){
							chest_type[q[4]] = 8; //Flag it small locked.
							is_chest[q[0]+1] = 2;
							is_chest[q[0]-15] = 2;
							is_chest[q[0]-16] = 2;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsBossLockedChest(q[5]) ){
							chest_type[q[4]] = 9; //Flag it small locked.
							is_chest[q[0]+1] = 2;
							is_chest[q[0]-15] = 2;
							is_chest[q[0]-16] = 2;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
					}
					
				}
			}
			//lsyer 2
			if ( CHEST_LAYER_2 ) {
				q[5] = GetLayerComboD(2,q[0]);
				//if it is any type of chest...
				if ( chest_layer[q[4]] >= 0 ) { continue; } //ignore chests at this position on lower layers. 
				if ( IsChest(){
					chest_exists[ q[4] ] = 1; //mark that there is a chest
					chest_pos[ q[4] ] = q[0]; //store the position
					chest_layer[q[4]] = 2; //store the layer
					is_chest[q[0]] = 3;
					//if it is a small chest
					if ( IsSmallChest(q[5]){
						if ( IsUnlockedChest(q[5]){
							chest_type[q[4]] = 1; //Flag it small unlocked.
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsLockedChest(q[5]) ){
							chest_type[q[4]] = 2; //Flag it small locked.
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsBossLockedChest(q[5]) ){
							chest_type[q[4]] = 3; //Flag it small locked.
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
					}
					if ( IsBigChest(q[5]){
						if ( IsUnlockedChest(q[5]){
							chest_type[q[4]] = 4; //Flag it big unlocked.
							is_chest[q[0]+1] = 3;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsLockedChest(q[5]) ){
							chest_type[q[4]] = 5; //Flag it big locked.
							is_chest[q[0]+1] = 3;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsBossLockedChest(q[5]) ){
							chest_type[q[4]] = 6; //Flag it big locked.
							is_chest[q[0]+1] = 3;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
					}
					if ( IsGrandChest(q[5]){
						if ( IsUnlockedChest(q[5]){
							chest_type[q[4]] = 7; //Flag it small unlocked.
							is_chest[q[0]+1] = 3;
							is_chest[q[0]-15] = 3;
							is_chest[q[0]-16] = 3;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsLockedChest(q[5]) ){
							chest_type[q[4]] = 8; //Flag it small locked.
							is_chest[q[0]+1] = 3;
							is_chest[q[0]-15] = 3;
							is_chest[q[0]-16] = 3;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
						if ( IsBossLockedChest(q[5]) ){
							chest_type[q[4]] = 9; //Flag it small locked.
							is_chest[q[0]+1] = 3;
							is_chest[q[0]-15] = 3;
							is_chest[q[0]-16] = 3;
							q[4]++; //increment the temp index.
							if ( q[4] > 7 ) break;
							continue;
						}
					}
					
				}
			}
		} //End set-up for loop on all layers
				
		

		
		//Check which have been opened by reading the bits, and advance their combos on screen init. 
		/*
		
		NOW
		
		We know what chests exist, their contents, type, and location. 
		
		int chest_exists[8];
		int chest_pos[8];
		int chest_type[8]; 
			int pickup_script_args[8]; //fed to the callback
			// [0] None
			// [1] Small, Unlocked
			// [2] Small, Locked
			// [3] Small, Bosslocked
			// [4] Large, Unlocked
			// [5] Large, Locked
			// [6] Large, Bosslocked
		int chest_contents[8]; //negative values are npcs. 
		chest_layer[8];
		/*
		
		Check which have been opened, and change them on screen init.
		
		*/
		
		for ( q[0] = 0; q[0] < 8; q[0]++ ) {
			if ( ChestOpened(q[0] ) { 
				if ( chest_type[q[0]] < CHEST_TYPE_BIG ) {
					//it is a small chest
					SetLayerComboD( chest_layer[q[0]], chest_pos[q[0]], (GetLayerComboD(chest_layer[q[0]], chest_pos[q[0]])+1) );
					//Update its combo. 
				}
				if ( chest_type[q[0]] > CHEST_TYPE_SMALL_BOSSLOCKED && chest_type[q[0]] < CHEST_TYPE_GRAND ){
					//it is a big chest, 1x2\
					//update the chest and the combo to its right
					SetLayerComboD( chest_layer[q[0]], chest_pos[q[0]], (GetLayerComboD(chest_layer[q[0]], chest_pos[q[0]])+1) );
					SetLayerComboD( chest_layer[q[0]], chest_pos[q[0]]+1, (GetLayerComboD(chest_layer[q[0]], chest_pos[q[0]])+1) );
				}
				if ( chest_type[q[0]] > CHEST_TYPE_BIG_BOSSLOCKED ) {
					//it is a grand, 4x4 chest.
					SetLayerComboD( chest_layer[q[0]], chest_pos[q[0]], (GetLayerComboD(chest_layer[q[0]], chest_pos[q[0]])+1) );
					SetLayerComboD( chest_layer[q[0]], chest_pos[q[0]]+1, (GetLayerComboD(chest_layer[q[0]], chest_pos[q[0]])+1) );
					SetLayerComboD( chest_layer[q[0]], chest_pos[q[0]]-15, (GetLayerComboD(chest_layer[q[0]], chest_pos[q[0]])+1) );
					SetLayerComboD( chest_layer[q[0]], chest_pos[q[0]]-16, (GetLayerComboD(chest_layer[q[0]], chest_pos[q[0]])+1) );
				
					//Update its combo, all four positions
				}
			}
		} // END Screen Load Set-Up
				
			
		//Now we run the code. 
		while(true){
			if ( Link->Dir == DIR_UP ) {
				
				/*
				int chest_exists[8];
				int chest_pos[8];
				int chest_type[8]; 
				int chest_layer[8];
				int is_chest[176]; //flag for every combo position. values are 1, 2, and 3, for chests on layers 0, 1, and 2. 
					
				int chest_pos_id[176]; //the main combo of each chest group, 0 to 7. 
				*/
				
				q[7] = ___AdjacentCombo(ComboAt(Link->X+8, Link->Y+8),Link->Dir) ]; //the screen position above Link. 
				
				q[6] = is_chest[ q[7] ]; //the chest type, if any. The layer is q[6]-1
				
				if ( !q[6] ) { continue; } //if the combo is not a chest, go again. 
				
				q[8] = chest_pos_id[q[7]]; //the ID of the Chest, 0 to 7
				
				//q[9] = chest_type[ q[8] ]; //the specific chest type. 
				//q[10] = chest_layer[ q[8] ]; //the layer for this chest. 
				
				
		
				//chest_pos_id[combo_loc] holds the ID of chest_pos[n] (0 to 7)
				//if it is on layer 0
				
				//align the combo index and the Nth index of the multiple size 8 arrays. 
				
				//q[6] is the combo position 0-176
				//chest_pos_id[] holds the relative IDs
				
				//! No, this is not fetching the correct value. is_chest[] holds the chest type per combo location?
				
				//we need the combo ID and the chest ID pair
				
				
				
				if ( PressChestCutton() ) {
					//check to see if it is locked
					if ( IsLockedChest(q[8]) }{ 
						if ( Game->LKeys[Game->GetCurLevel()] > 0 ) {
						//Game->DCounter[CR_LKEYS] = -1; 
							if ( SFX_CHEST_UNLOCK > 0 ) Game->PlaySound(SFX_CHEST_UNLOCK);
							
							//! Send message to pickup script to remove a level key. 
							
							//open the chest.
							if ( chest_contents[q[8]] < 0 ) { 
								//it is an enemy, so
								do_open_enemy_chest(q[8], chest_layer[ q[8] ], chest_type[ q[8] ], ( chest_contents[ q[8] ] * -1), false, true, false);
				
							}
							else do_chest_open( q[7], chest_layer[ q[8] ], chest_type[ q[8] ], chest_contents[ q[8] ], 
								false, true, false, q, q[8], CHEST_HOLDUP_TYPE);
								
							
						}
						else if ( Game->Counter[CR_KEYS] > 0 ) {
							//Game->DCounter[CR_KEYS] = -1; 
							if ( SFX_CHEST_UNLOCK > 0 ) Game->PlaySound(SFX_CHEST_UNLOCK);
							//!! Can LINK WASTE A KEY by saving here?
							
							//! Send a message to the pickup script to remove a key. 
							//open the chest.
							if ( chest_contents[q[8]] < 0 ) { 
								//it is an enemy, so
								do_open_enemy_chest(q[8], chest_layer[ q[8] ], chest_type[ q[8] ], ( chest_contents[ q[8] ] * -1), true, false, false);
				
							}
							else do_chest_open( q[7], chest_layer[ q[8] ], chest_type[ q[8] ], chest_contents[ q[8] ], 
								true, false, false, q, q[8], CHEST_HOLDUP_TYPE);
						}
					}
					if ( IsBossLockedChest(q[8]) { 
						if ( HasBossKey(Game->GetCurLevel()) ) {
							if ( chest_contents[q[8]] < 0 ) { 
								//it is an enemy, so
								do_open_enemy_chest(q[8], chest_layer[ q[8] ], chest_type[ q[8] ], ( chest_contents[ q[8] ] * -1), false, false, true);
				
							}
							else do_chest_open( q[7], chest_layer[ q[8] ], chest_type[ q[8] ], chest_contents[ q[8] ], 
								false, false, true, q, q[8], CHEST_HOLDUP_TYPE);
						}
					}
					else {
						if ( chest_contents[q[8]] < 0 ) { 
							//it is an enemy, so
							do_open_enemy_chest(q[8], chest_layer[ q[8] ], chest_type[ q[8] ], ( chest_contents[ q[8] ] * -1), false, false, false);
				
						}
						else do_chest_open( q[7], chest_layer[ q[8] ], chest_type[ q[8] ], chest_contents[ q[8] ], 
								false, false, false, q, q[8], CHEST_HOLDUP_TYPE);
					}
					
				}
					
			}
			Waitframe();
		} //end while loop
		
	} //end run()
	void do_open_chest(int combo_pos, int layer, int chest_type, int contents, bool key, bool level_key, bool boss_key, int q, int chest_bit, int holdup_type){
		
		int key_type; 
		if ( key ) key_type = 1; 
		if ( level_key ) key_type = 2;
		if ( boss_key ) key_type = 3;
		//Suspend GhostZH
		
		
		
		//Stun all npcs for the duration of the item animation
		for ( q[30] = Screen->NumNPCs(); q[30] > 0; q[30]++ ) { 
			npc n = Screen->LoadNPC(q[30]);
			n->Stun = CHEST_ITEM_ANIM_DUR;
		}
		
		//Play the sound
		if ( SFX_CHEST_ITEM_ANIM > 0 ) Game->PlaySound(SFX_CHEST_ITEM_ANIM);
		//do the item animation.
		
		//!! Send all the item script messages
		q[50] = SetCurrentCallBack()
		q[51] = ( StoreCallBack(ptr[]) != 0 ); 
		
		int messages[7]={contents, chest_bit, key_type, holdup_type, combo_pos, layer, chest_type};
		
		//Make the item
		item i = Screen->CreateItem(contents);
		i->X = Link->X;
		i->Y = Link->Y = CHEST_ITEM_SPAWN_DISTANCE; 
		
		//animation
		
		q[30] = CHEST_ITEM_ANIM_DUR;
		
		//Animation.
		while( q[30]-- || i->Y < Link->Y ) { 
			i->Y -= CHEST_ITEM_ANIM_MOVE_SPEED;
			WaitNoAction();
		}
		
		//The item collides with Link, and its pick-up script runs. 
		//The script reduces key counts, awards the item, and marks the screen flags as needed
		//using a basic messaging system.
		
	}
	void do_open_enemy_chest(int pos, int layer, int type, int enemy, bool key, bool level_key, bool boss_key){
		
		//use the appropriate key. 
		//do the delay?
		//spawn the enemy. 
	}
		
} //end script
				