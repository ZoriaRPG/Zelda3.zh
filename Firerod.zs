////////////////////////////
/// Simple Firerod       ///
/// v0.2                 ///
/// By: ZoriaRPG         ///
/// 24th September, 2017 ///
////////////////////////////
/// Note: All of this is ugly. In 2.54, you will be able to set NPCs to specific script defences, so you can use a real
///       FLAME weapon that you set up, and 2.54 may add SCRIPT weapon triggers to combos, as well. 


int LightSources[3120]; //All the light source metrics for drawing, per frame. 
//x, y, diameter: 176 combos * 3 layers, (255 weapons * 2) * 3

//Settings
const int LW_CUST_FLAME 	= 31; //Script 1
const int FIREROD_MIN_STEP 	= 100;
const int FIREROD_DAMAGE 	= 4;
const int FIREROD_MISC_INDEX 	= 1;
const int FIREROD_FLAME_FLAG 	= 00001000b;
const int FIREROD_FLAME_SPRITE 	= 89;
const int BLANK_FIRE_SPRITE 	= 90; //Should be a blank tile sprite.  

//The diameter of the light source for combos.
const int LIGHT_SOURCE_COMBO_RADIUS_MIN = 29;
const int LIGHT_SOURCE_COMBO_RADIUS_MAX = 33;
//The diameter of the light source for weapons. 
const int LIGHT_SOURCE_WPN_RADIUS_MIN = 22;
const int LIGHT_SOURCE_WPN_RADIUS_MAX = 26;

const int BITMAP_DARKNESS = 2; //The bitmap ID to use for the darkness effect.
const int DARKROOM_LAYER = 7; //The layer to blit the output bitmap.
const int COLOUR_BLACK = 0x0F; //A  black colour swatch in your palette. 

const int LIGHT_SOURCE_CIRCLE_SCALE = 1; //Scale and layer args for the colour-0 circles. 
const int LIGHT_SOURCE_CIRCLE_LAYER = 0;

item script BasicFireRod{
	void run(int sprite, int damage, int step_speed){
		Link->Action = LA_ATTACKING;
		lweapon flame = Screen->CreateLWeapon(LW_CUST_FLAME);
		flame->X = Link->X;
		flame->Y = Link->Y;
		flame->UseSprite = Cond(sprite > 0, sprite, FIREROD_FLAME_SPRITE);
		flame->Dir = Link->Dir;
		if ( Link->Dir == DIR_UP ) {
			flame->Y -= 16;
		}
		if ( Link->Dir == DIR_DOWN ) {
			flame->Flip = FLIP_VERTICAL;
			flame->Y += 16;
			
		}
		if ( Link->Dir == DIR_RIGHT ) {
			flame->Flip = ROT_CCW;
			flame->X += 16;
		}
		if ( Link->Dir == DIR_RIGHT ) {
			flame->Flip = ROT_CW;
			flame->X -= 16;
		}
		//Ternary would help here, as it would jus tbe:
		//flame->Step = step_speed > 0 ? step_speed : FIREROD_MIN_STEP; 
		//sigh. 
		flame->Step = Cond(step_speed > 0, step_speed, FIREROD_MIN_STEP); 
		flame->Damage = Cond(damage > 0, damage, FIREROD_DAMAGE); 
		//! Damage is forwarded to the real fire weapon via the global active script.
		flame->Misc[FIREROD_MISC_INDEX] |= FIREROD_FLAME_FLAG; //Mark it for detection. 
		flame->HitYOffset = -214747; //Move the true hitbox offscreen so that it cannot trigger or hit anything. 
		//! The global active script handles real collisions. 
	}
}

//Returns true if the combo at '(x, y)' has either an inherent or place flag of type 'flag'
bool ____LayerComboFI(int pos, int flag, int layer){
	return GetLayerComboF(layer,pos) == flag || GetLayerComboI(layer,pos) == flag;
}



//Call before Waitdraw. 
void DoFireRod(){
	int cmb_pos; bool makeflame; int flags[3]={CF_CANDLE1, CF_CANDLE2};
	for ( int q = Screen->NumLWeapons(); q > 0; q-- ) {
		lweapon l = Screen->LoadLWeapon(q);
		if ( l->ID == LW_CUST_FLAME ){
			if ( l->Misc[FIREROD_MISC_INDEX]&FIREROD_FLAME_FLAG ) {
				//We make a real dire weapon on top of fire trigger combos. 
				cmb_pos = ComboAt(l->X, l->X);
				for ( int q = 0; q < 3; q++ ) {
					for ( int w = 0; w < 2; w++ ) {
						if ( ____LayerComboFI(pos, flags[w] , layer ) ) {
							lweapon makefire = Screen->CreateLWeapon(LW_FIRE);
							makefire->X = ComboX(cmb_pos);
							makefire->Y = ComboY(cmb_pos);
							makefire->UseSprite = BLANK_FIRE_SPRITE;
							SetLayerComboF(LAYER_TORCH_FLAG, cmb_pos, CF_LIT_TORCH);
						}
					}
				}
				//Make fire weapon on enemies on collision if the enemy has its hitbox enabled, and on-screen.
				for ( int e = Screen->NumNPCs(); e > 0; e-- ) {
					npc n = Screen->LoadNPC(e);
					if ( !n->CollDetection ) continue; 
					if ( n->HitXOffset < 0 ) continue;
					if ( n->HitXOffset > 255 ) continue;
					if ( n->HitYOffset < 0 ) continue;
					if ( n->HitYOffset > 255 ) continue;
					if ( Collision(l,e) ){
						lweapon makefire = Screen->CreateLWeapon(LW_FIRE);
						makefire->Damage = l->Damage;
						makefire->X = n->X + n->HitXOffset;
						makefire->Y = n->Y + n->HitYOffset;
						Remove(l); //Remove the fire rod object.
						//Fire weapons on enemies should be real gfx. 
						//makefire->UseSprite = BLANK_FIRE_SPRITE;
					}
				}
			}
		}
	}
}

const int CF_LIT_TORCH = 99; //script 2. 
const int LAYER_TORCH_FLAG = 0; //Look for them on his layer. 


//Call before Waitdraw()
//DarkDroom(DARKROOM_LAYER, false, BITMAP_DARKNESS);
void DarkRoom(int layer, bool trans, int bitmap_id)
{
	int q[16]; int src; int cnt; 
	int lightsourceflags[]={CF_LIT_TORCH}; 
	q[9] = SizeOfArray(lightsourceflags);
	int lightsourceflaglayers[]={LAYER_TORCH_FLAG};
	q[15] = SizeOfArray(lightsourceflaglayers);
	
	for ( q[10] = SizeOfArray(LightSources); q[10] >= 0; q[10]-- ) { LightSources[ q[10] ] = -1; } //Wipe it every frame. 
	Screen->SetRendertarget(bitmap_id);
	Screen->Rectangle(layer, 0, 0, 256, 256, COLOUR_BLACK, 100, 0, 0, 0, true, OP_OPAQUE);
	//Add light sources to the array for combos. 
	for ( q[0] = 0; q[0] < q[15]; q[0]++ ) 
	{
		//Check for light sources on layers
		for ( q[1] = 0; q[1] < 176; q[1]++ ) 
		{
			//check all positions.
			for ( q[2] = 0; q[2] < q[9]; q[2]++ ) 
			{	//and all flags
				if (  ____LayerComboFI(q[1], lightsourceflags[ q[2] ], lightsourceflaglayers[ [q[0] ] ) 
				{
					LightSources[src] = ComboX(q[1]);
					LightSources[src+1] = ComboY(q[1]);
					LightSources[src+2] = Rand(LIGHT_SOURCE_COMBO_RADIUS_MIN, LIGHT_SOURCE_COMBO_RADIUS_MAX);
					cnt++; 
					src+=3;
				}
			}
		}
	}
	//add light sources to the array for weapons
	for ( q[4] = Screen->NumLWeapons(); q[4] > 0; q[4] -- )
	{
		lweapon l = Screen->LoadLWeapon[q[4]];
		//for special fire rod weapons
		if ( l->ID == LW_CUST_FLAME )
		{
			LightSources[src] = l->X + 8;
			LightSources[src+1] = l->Y + 8;
			LightSources[src+2] = Rand(LIGHT_SOURCE_WPN_RADIUS_MIN, LIGHT_SOURCE_WPN_RADIUS_MAX);
			cnt++; 
			src+=3;
		}
		//for fire weapons that are not dummy weapons
		if ( l->ID == LW_FIRE )
		{
			if ( l->UseSprite != BLANK_FIRE_SPRITE ) 
			{
				LightSources[src] = l->X + 8;
				LightSources[src+1] = l->Y + 8;
				LightSources[src+2] = Rand(LIGHT_SOURCE_WPN_RADIUS_MIN, LIGHT_SOURCE_WPN_RADIUS_MAX);
				cnt++; 
				src+=3;	
			}
		}
	}
	
	q[13] = cnt*3;
	//Draw all light sources to the bitmap.
	for ( q[12] = 0; q[12] <= q[13]; q[12] += 3 )
	{
		Screen->Circle(LIGHT_SOURCE_CIRCLE_LAYER, LightSources[ q[12] ], LightSources[ q[12] ]+1, LightSources[ q[12] ]+2, 0, LIGHT_SOURCE_CIRCLE_SCALE,
		0,0,0, true, OP_OPAQUE);
		if ( LightSources[ q[12] ] == -1 ) break; //Sanity check. 
	}
	
	//! Blits
	Screen->SetRenderTarget(RT_SCREEN);
	// if ( trans )  //2.54+ stuff t/b/a
	// {
	//	Screen->DrawBitmapEx()
	// }
	// else {
	Screen->DrawBitmap(layer, bitmap_id, 0, 0, 256, 176, 0, 0, 256, 176, 0, true);
}
			

		