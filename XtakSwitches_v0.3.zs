/// Xtal Switches
/// By: ZoriaRPG

//Settings
const int LINK_WALK_BLOCKS = 1; //Link can walk on a barrier block if he was standing on that type when they changed.

//Crystal Switch Combo IDs:

const int CMB_XTAL_RED_UP 		= 0; //Red switch, up state combo.
const int CMB_XTAL_RED_DOWN		= 0; //Red switch, down state combo.
const int CMB_XTAL_BLUE_UP 		= 0; //Blue switch, up state combo.
const int CMB_XTAL_BLUE_DOWN 		= 0; //Blue switch, down state combo.
const int CMB_XTAL_SWITCH_TRIG 		= 0; //Combo ID of the trigger.

const int CMB_XTAL_BLUE_UP_WALKABLE	= 0; //Blue switch, WALKABLE up state combo.
const int CMB_XTAL_RED_UP_WALKABLE	= 0; //Red switch, WALKABLE up state combo.

//Switch States
const int XTAL_BLUE_UP 			= 1;
const int XTAL_RED_UP 			= 0;

//DMAP Constants
const int MAX_XTAL_DMAPS 		= 463;  //Set to number of DMAPs in use. 
						//Only Dmaps 0 through 462 are usable for this.
const int XTAL_SHARED 			= 1;
const int XTAL_NOT_SHARED 		= 0;

//Sounds
const int SFX_XTAL_SWITCH 		= 0; //Sound ID for hitting a Crystal Switch Trigger.

//Arrays

float XtalSwitches[464]; //Set index size, to number of DMAPs in use + 1.
float XTalSwitchesList[214369]; //Set index size, to number of DMAPs in use, SQUARED.
//512 DMAps is too many though, as the maximum number of indices is 214747.
//463 is the maximum.

const int LINK_ON_BLOCK  = 464; //Set to the last index of XtalSwitches[]

float XtalSwitchTriggerLWeapons[]={0};
float XtalSwitchTriggerEWeapons[]={0};

void XtalSwitchTrig(int cmb, bool limitLW){
	int c; int w; lweapon l;
	int curDMAP = Game->GetCurDMap();
	for ( int q = 0; q < 176; q ++ ) {
		c = Screen->ComboD[q];
		if ( c == cmb ) {
			for ( w = Screen->NumLWeapons(); w > 0; w-- ){
				l = Screen->LoadLWeapon(w);
				
				if ( limitLW ) {
				if ( l->Type != LW_SWORD || l->Type != LW_BRANG ||
					l->Type != LW_HOOKSHOT || l=>Type != LW_MAGIC || l->Type != LW_HAMMER ) continue;
				if ( Collision(c,l) SetXtalSwitch(curDMAP);
			}
		}
	}
}

//Use list of LWeapons to trigger switches.
void XtalSwitchTrig(int cmb, int listLW){
	int c; int w; lweapon l; int e; int size = SizeOfArray(listLW); 
	int curDMAP = Game->GetCurDMap();
	bool match;
	for ( int q = 0; q < 176; q ++ ) {
		c = Screen->ComboD[q];
		if ( c == cmb ) {
			for ( w = Screen->NumLweapons(); w > 0; w-- ){
				l = Screen->LoadLWeapon(w);
				
				for ( e = 0; e < size; e >= 0; e++ ) {
					if ( l->Type == listLW[e] ) {
						match = true;
					}
				}
				if ( match && Collision(c,l) ) SetXtalSwitch(curDMAP);
			}
		}
	}
}

//Use list of LWeapons to trigger switches.
void XtalSwitchTrig(int cmb, int weapList, bool eWeapons){
	int c; int w; int e; lweapon l; eweapon ew; int size = SizeOfArray(weapList);
	int curDMAP = Game->GetCurDMap();
	bool match;
	for ( int q = 0; q < 176; q ++ ) {
		c = Screen->ComboD[q];
		if ( c == cmb ) {
			if ( !eWeapons ) {
				for ( w = Screen->NumLWeapons(); w > 0; w-- ){
					l = Screen->LoadLWeapon(w);
					for ( int e = 0; e < size; e++ ) {
						if ( l->Type == weapList[e] ) match = true;
					}
				}
				if ( match && Collision(c,l) ) SetXtalSwitch(curDMAP);
			}
			if ( eWeapons ) {
				for ( w = Screen->NumEWeapons(); w > 0; w-- ){
					l = Screen->LoadEWeapon(w);
					for ( int e = 0; e < size; e++ ) {
						if ( l->Type == weapList[e] ) match = true;
					}
				}
				if ( match && Collision(c,l) ) SetXtalSwitch(curDMAP);
			}
		}
	}
}

//Use list of LWeapons, to trigger switches, plus list of eweapons.
void XtalSwitchTrig(int cmb, int listLW, int listEW){
	int c[20]; lweapon l; eweapon e;
	c[5] = SizeOfArray(listLW); c[6] = SizeOfArray(listEW);
	c[8] = Screen->NumLWeapons(); c[9] = Screen->NumEWeapons();
	c[10] = Max(c[8],c[9]);
	int curDMAP = Game->GetCurDMap();
	bool match;
	for ( c[1] = 0; c[1] < 176; c[1]++ ) {
		c[0] = Screen->ComboD[q];
		if ( c[0] == cmb ) {
			for ( c[2] = 0; c[2] > c[10]; c[2]++ ){
				if ( c[2] <= c[8] ) l = Screen->LoadLWeapon(c[2]);
				if ( c[2] <= c[9] ) e = Screen->LoadLWeapon(c[2]);
				
				for ( c[3] = 0; c[3] < c[5]; c[3]++ ) {
					if ( c[2] <= c[8] ) {
						if ( l->Type == listLW[ c[3] ] ) {
							match = true;
						}
					}
				}
				for ( c[4] = 0; c[4] < c[6]; c[4]++ ) {
					if ( c[2] <= c[9] ){
						if ( e->Type == listEW[ c[4] ] ) {
							match = true;
						}
					}
				}
				if ( match ) {
					if ( l->isValid && Collision(c[0],l) ) SetXtalSwitch(curDMAP);
					if ( e->isValid && Collision(c[0],e) ) SetXtalSwitch(curDMAP);
				}
			}
		}
	}
}

void SetXtalSwitch(int dmap){
	Game->PlaySound(SFX_XTAL_SWITCH);
	if ( XtalSwitches[dmap] ) XtalSwitches[dmap] = XTAL_RED_UP;
	else XtalSwitches[dmap] = XTAL_BLUE_UP;
	XtalSwitches_SetDMAPs(dmap);
}



global script activeExample{
	void run(){
		while(true){
			Xtals();
			Waitdraw();
			Waitframe();
		}
	}
}



//Run before Waitdraw().
void Xtals(){
	int dmap = Game->GetCurDMap();
	int cmb;

	if ( XtalSwitches[dmap] ) { //Blue is up
		for ( int q = 1; q < 176; q++ ){
			cmb = Screen->ComboD[q];
			if ( cmb == CMB_XTAL_BLUE_DOWN ) Screen->ComboD[q] = CMB_XTAL_BLUE_UP;
			if ( cmb == CMB_XTAL_RED_UP ) Screen->ComboD[q] = CMB_XTAL_RED_DOWN;
			if ( LinkComboD == CMB_XTAL_BLUE_UP && LINK_WALK_BLOCKS ) Screen->ComboD[q] = CMB_XTAL_BLUE_UP_WALKABLE;
			
		}
	}
	else {
		for ( int q = 1; q < 176; q++ ){
			cmb = Screen->ComboD[q];
			if ( cmb == CMB_XTAL_BLUE_UP ) Screen->ComboD[q] = CMB_XTAL_BLUE_DOWN;
			if ( cmb == CMB_XTAL_RED_DOWN ) Screen->ComboD[q] = CMB_XTAL_RED_UP;
			if ( LinkComboD == CMB_XTAL_RED_UP && LINK_WALK_BLOCKS ) Screen->ComboD[q] = CMB_XTAL_RED_UP_WALKABLE;
		}
	}
}

//Sets switch positions for each DMAP, based on a list.
void XtalSwitches_SetDMAPs(){
	int curDMAP = Game->GetCurDMap();
	for ( int q = 0; q <= MAX_XTAL_DMAPS; q++ ){
		if ( XTalSwitchesList[ (curDMAP * MAX_XTAL_DMAPS) + q] ) {
			if ( XtalSwitches[q] != XtalSwitches[curDMAP] )
			XtalSwitches[q] = XtalSwitches[curDMAP];
		}
	}
}

//Sets switch positions for each DMAP, based on a list.
void XtalSwitches_SetDMAPs(int curDMAP){
	for ( int q = 0; q <= MAX_XTAL_DMAPS; q++ ){
		if ( XTalSwitchesList[ (curDMAP * MAX_XTAL_DMAPS) + q] ) {
			if ( XtalSwitches[q] != XtalSwitches[curDMAP] )
			XtalSwitches[q] = XtalSwitches[curDMAP];
		}
	}
}
	

//Run before Waitdraw().
//void XtalSwitches(){
	//XtalSwitches_SetDMAPs();
//	Xtals();
//}

//void XtalSwitchesFlip(int dmap){
	

	
//! These functions allow you to add shared DMAPs to the list.

// SetXtalSwitches(16,3,true) 
// This sets DMAP 3 to share the state of DMAP 16

//Add another DMAP to the switches affected by triggering them from a single DMAP.
//Row is the base DMAP. Column is the DMAP to share its state.
void SetXtalSwitches(int row, int column, int shared){
	XTalSwitchesList[ (row * MAX_XTAL_DMAPS ) + column] = shared;
}

//Add another DMAP to the switches affected by triggering them from a single DMAP.
//Row is the base DMAP. Column is the DMAP to share its state.
void SetXtalSwitches(int row, int column, bool shared){
	int share;
	if ( shared ) share = 1;
	XTalSwitchesList[ (row * MAX_XTAL_DMAPS ) + column] = share;
}

//float XTalSwitchesList[100] = { 
//			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
//	;
	



global script onExit{
	void run(){
		ClearXtalSwitches();
	}
}
	

void ClearXtalSwitches(){
	for ( int q = 0; q <= 512; q++ ){
		XtalSwitches[q] = 0;
	}
}

// Return ComboD for combo Link is over.
int LinkComboD() {
 return Screen->ComboD[ComboAt(Link->X+8, Link->Y+13)];
}

// Return ComboI for combo Link is over.
int LinkComboI() {
 return Screen->ComboI[ComboAt(Link->X+8, Link->Y+13)];
}

// Return ComboF for combo Link is over.
int LinkComboF() {
 return Screen->ComboF[ComboAt(Link->X+8, Link->Y+13)];
}

// Return ComboS for combo Link is over.
int LinkComboS() {
 return Screen->ComboS[ComboAt(Link->X+8, Link->Y+13)];
}

// Return ComboC for combo Link is over.
int LinkComboC() {
 return Screen->ComboC[ComboAt(Link->X+8, Link->Y+13)];
}

// Return ComboT for combo Link is over.
int LinkComboT() {
 return Screen->ComboT[ComboAt(Link->X+8, Link->Y+13)];
}