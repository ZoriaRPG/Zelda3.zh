
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
            
	if ( Mirror[BYRNA_BEAM_1_ORBIT_ANG2] == 0 ){
		Mirror[BYRNA_BEAM_1_ORBIT_X] = Mirror[BYRNA_BEAM_1_ORBIT_CX] + Mirror[BYRNA_BEAM_1_ORBIT_RADIUS] * Cos( Mirror[BYRNA_BEAM_1_ORBIT_ANG1] );
                Mirror[BYRNA_BEAM_1_ORBIT_Y] = Mirror[BYRNA_BEAM_1_ORBIT_CY] + Mirror[BYRNA_BEAM_1_ORBIT_RADIUS] * Sin( Mirror[BYRNA_BEAM_1_ORBIT_ANG1] );
	}
	else {
		Mirror[BYRNA_BEAM_1_ORBIT_X] = Mirror[BYRNA_BEAM_1_ORBIT_CX] + Mirror[BYRNA_BEAM_1_ORBIT_RADIUS] 
			* Cos( Mirror[BYRNA_BEAM_1_ORBIT_ANG1] ) * Cos( Mirror[BYRNA_BEAM_1_ORBIT_ANG2] ) 
			- Mirror[BYRNA_BEAM_1_ORBIT_RADIUS2] * Sin( Mirror[BYRNA_BEAM_1_ORBIT_ANG1] ) 
			* Sin( Mirror[BYRNA_BEAM_1_ORBIT_ANG2] );
		Mirror[BYRNA_BEAM_1_ORBIT_Y] = Mirror[BYRNA_BEAM_1_ORBIT_CY ] + Mirror[BYRNA_BEAM_1_ORBIT_RADIUS2] 
			* Sin( Mirror[BYRNA_BEAM_1_ORBIT_ANG1] ) * Cos( Mirror[BYRNA_BEAM_1_ORBIT_ANG2] ) 
			+ Mirror[BYRNA_BEAM_1_ORBIT_RADIUS] * Cos( Mirror[BYRNA_BEAM_1_ORBIT_ANG1] )
			* Sin( Mirror[BYRNA_BEAM_1_ORBIT_ANG2] );
	}
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
	int loops = Max(npcs, 
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

