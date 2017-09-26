////////////////////////////
/// Simple Firerod       ///
/// v0.4                 ///
/// By: ZoriaRPG         ///
/// 26th September, 2017 ///
////////////////////////////
/// Note: All of this is ugly. In 2.54, you will be able to set NPCs to specific script defences, so you can use a real
///       FLAME weapon that you set up, and 2.54 may add SCRIPT weapon triggers to combos, as well. 


int LightSources[3120]; //All the light source metrics for drawing, per frame. 
//x, y, diameter: 176 combos * 3 layers, (255 weapons * 2) * 3

//Settings
const int LW_CUST_FLAME 			= 31; // The weapon type used by the fireball itself. The default is LW_SCRIPT1
const int FIREROD_MIN_STEP 			= 100; //The default step speed. 
const int FIREROD_DAMAGE 			= 4; //The damage forwarded to LW_FIRE when the weapon creates a flame. 
const int FIREROD_MISC_INDEX 			= 1; //The l->Misc[index] used to store flags. 
const int FIREROD_FLAME_FLAG 			= 00001000b; //This flag marks the fireball projectile as spawned by this script. 
							//! Change ONLY if you need this flag for another weapon of type LW_CUST_FLAME or LW_FIRE. 
const int SPRITE_FIREROD 			= 88; //The sprite for the Fire Rod Handle: 
							//! This will persist on-screen for a number of frames equal to 
							//! the ANIMATION FRAMES of the sprite.
const int FIREROD_FLAME_SPRITE 			= 89; //The sprite for the fireball projectile.
const int BLANK_FIRE_SPRITE 			= 90; //Should be a blank tile sprite.  



const int CF_LIT_TORCH 				= 99; //The flag placed on torches when they light from DoFireRod() to find light sources.
							//! Script 2 by default. 
const int LAYER_TORCH_FLAG 			= 0; //Look for lit torch flags on this layer. 

//The diameter of the light source for combos.
const int LIGHT_SOURCE_COMBO_RADIUS_MIN 	= 29;
const int LIGHT_SOURCE_COMBO_RADIUS_MAX 	= 33;
//The diameter of the light source for weapons. 
const int LIGHT_SOURCE_WPN_RADIUS_MIN 		= 22;
const int LIGHT_SOURCE_WPN_RADIUS_MAX 		= 26;

const int BITMAP_DARKNESS 			= 2; //The bitmap ID to use for the darkness effect.
const int DARKROOM_LAYER 			= 7; //The layer to blit the output bitmap.
const int COLOUR_BLACK 				= 0x0F; //A  black colour swatch in your palette. 

const int LIGHT_SOURCE_CIRCLE_SCALE 		= 1; //Scale and layer args for the colour-0 circles. 
const int LIGHT_SOURCE_CIRCLE_LAYER 		= 0; //Draw colour 0 circles to this layer of the bitmap. 

const int FIREROD_BALL_CENTRE_OFFSET 		= 10;  //How many pixels to offset the fireball so that it flys from the rod.
const int FIREROD_HANDLE_TO_FIREBALL_DIST 	= 16; //Length of the fire rod wand sprite. 

//Array Indicws: Do not change!!
const int FIREROD_WEAP_BALL 			= 0;
const int FIREROD_WEAP_ROD 			= 1;

item script BasicFireRod{
	void run(int sprite, int damage, int step_speed, int rod_sprite){
		Link->Action = LA_ATTACKING;
		lweapon flame[2];
		flame[FIREROD_WEAP_BALL] = Screen->CreateLWeapon(LW_CUST_FLAME);
		
		flame[FIREROD_WEAP_BALL]->UseSprite(Cond(sprite > 0, sprite, FIREROD_FLAME_SPRITE));
		flame[FIREROD_WEAP_BALL]->Dir = Link->Dir;
		
		flame[FIREROD_WEAP_ROD] = Screen->CreateLWeapon(LW_SPARKLE);
		flame[FIREROD_WEAP_ROD]->UseSprite(Cond(rod_sprite > 0, rod_sprite, SPRITE_FIREROD));
		flame[FIREROD_WEAP_ROD]->CollDetection = false; //The rod itself does no damage. 
		
		//Set initial positions of weapons. 
		flame[FIREROD_WEAP_ROD]->X = Link->X;
		flame[FIREROD_WEAP_ROD]->Y = Link->Y;
		
		if ( Link->Dir == DIR_UP ) {
			flame[FIREROD_WEAP_ROD]->Y -= 16; //Rod in front of Link
			flame[FIREROD_WEAP_BALL]->X = flame[FIREROD_WEAP_ROD]->X + FIREROD_BALL_CENTRE_OFFSET; //
			flame[FIREROD_WEAP_BALL]->Y = flame[FIREROD_WEAP_ROD]->Y - FIREROD_HANDLE_TO_FIREBALL_DIST;
		}
		if ( Link->Dir == DIR_DOWN ) {
			flame[FIREROD_WEAP_ROD]->Y += 16; //Rod in front of Link
			flame[FIREROD_WEAP_ROD]->Flip = FLIP_VERTICAL; 
			flame[FIREROD_WEAP_BALL]->Flip = FLIP_VERTICAL;
			flame[FIREROD_WEAP_BALL]->X = flame[FIREROD_WEAP_ROD]->X - FIREROD_BALL_CENTRE_OFFSET; //
			flame[FIREROD_WEAP_BALL]->Y = flame[FIREROD_WEAP_ROD]->Y + FIREROD_HANDLE_TO_FIREBALL_DIST;
			
		}
		if ( Link->Dir == DIR_LEFT ) {
			flame[FIREROD_WEAP_BALL]->Flip = ROT_CCW;
			flame[FIREROD_WEAP_ROD]->Flip = ROT_CCW;
			flame[FIREROD_WEAP_ROD]->X -= 16;
			flame[FIREROD_WEAP_BALL]->Y = flame[FIREROD_WEAP_ROD]->Y - FIREROD_BALL_CENTRE_OFFSET; //
			flame[FIREROD_WEAP_BALL]->X = flame[FIREROD_WEAP_ROD]->X + FIREROD_HANDLE_TO_FIREBALL_DIST;
		}
		if ( Link->Dir == DIR_RIGHT ) {
			flame[FIREROD_WEAP_BALL]->Flip = ROT_CW;
			flame[FIREROD_WEAP_ROD]->Flip = ROT_CW;
			flame[FIREROD_WEAP_ROD]->X += 16;
			flame[FIREROD_WEAP_BALL]->Y = flame[FIREROD_WEAP_ROD]->Y + FIREROD_BALL_CENTRE_OFFSET; //
			flame[FIREROD_WEAP_BALL]->X = flame[FIREROD_WEAP_ROD]->X - FIREROD_HANDLE_TO_FIREBALL_DIST;

		}
		//Ternary would help here, as it would jus tbe:
		//flame[FIREROD_WEAP_BALL]->Step = step_speed > 0 ? step_speed : FIREROD_MIN_STEP; 
		//sigh. 
		flame[FIREROD_WEAP_BALL]->Step = Cond(step_speed > 0, step_speed, FIREROD_MIN_STEP); 
		flame[FIREROD_WEAP_BALL]->Damage = Cond(damage > 0, damage, FIREROD_DAMAGE); 
		//! Damage is forwarded to the real fire weapon via the global active script.
		flame[FIREROD_WEAP_BALL]->Misc[FIREROD_MISC_INDEX] |= FIREROD_FLAME_FLAG; //Mark it for detection. 
		flame[FIREROD_WEAP_BALL]->HitYOffset = -214747; //Move the true hitbox offscreen so that it cannot trigger or hit anything. 
		//! The global active script handles real collisions. 
	}
}

//Returns true if the combo at '(x, y)' has either an inherent or place flag of type 'flag'
bool ____LayerComboFI(int pos, int flag, int layer){
	return GetLayerComboF(layer,pos) == flag || GetLayerComboI(layer,pos) == flag;
}

//Array indices for DoFireRod() : Do not change!!
const int DOFIREROD_COMBO_POS 		= 0;
const int DOFIREROD_LOOP_LWPNS_SCAN 	= 1;
const int DOFIREROD_LOOP_LAYERS 	= 2;
const int DOFIREROD_LOOP_FLAGS 		= 3;
const int DOFIREROD_LOOP_NPCS 		= 4;

//Call before Waitdraw. 
void DoFireRod(){
	int q[DOFIREROD_COMBO_POS]; bool makeflame; int flags[2]={CF_CANDLE1, CF_CANDLE2};
	int q[5];
	for ( q[DOFIREROD_LOOP_LWPNS_SCAN] = Screen->NumLWeapons(); q[DOFIREROD_LOOP_LWPNS_SCAN] > 0; q[DOFIREROD_LOOP_LWPNS_SCAN]-- ) {
		lweapon l = Screen->LoadLWeapon(q[DOFIREROD_LOOP_LWPNS_SCAN]);
		if ( l->ID == LW_CUST_FLAME ){
			if ( l->Misc[FIREROD_MISC_INDEX]&FIREROD_FLAME_FLAG ) {
				//We make a real dire weapon on top of fire trigger combos. 
				q[DOFIREROD_COMBO_POS] = ComboAt(l->X, l->X);
				for ( q[DOFIREROD_LOOP_LAYERS] = 0; q[DOFIREROD_LOOP_LAYERS] < 3; q[DOFIREROD_LOOP_LAYERS]++ ) { //layers
					for ( q[DOFIREROD_LOOP_FLAGS] = 0; q[DOFIREROD_LOOP_FLAGS] < 2; q[DOFIREROD_LOOP_FLAGS]++ ) { //flags
						if ( ____LayerComboFI(q[DOFIREROD_COMBO_POS], flags[ q[DOFIREROD_LOOP_FLAGS] ] , q[DOFIREROD_LOOP_LAYERS] ) ) {
							lweapon makefire = Screen->CreateLWeapon(LW_FIRE);
							makefire->X = ComboX(q[DOFIREROD_COMBO_POS]);
							makefire->Y = ComboY(q[DOFIREROD_COMBO_POS]);
							makefire->UseSprite(BLANK_FIRE_SPRITE);
							makefire->Misc[FIREROD_MISC_INDEX] |= FIREROD_FLAME_FLAG;
							SetLayerComboF(LAYER_TORCH_FLAG, q[DOFIREROD_COMBO_POS], CF_LIT_TORCH);
						}
					}
				}
				//Make fire weapon on enemies on collision if the enemy has its hitbox enabled, and on-screen.
				for ( q[DOFIREROD_LOOP_NPCS] = Screen->NumNPCs(); q[DOFIREROD_LOOP_NPCS] > 0; q[DOFIREROD_LOOP_NPCS]-- ) {
					npc n = Screen->LoadNPC(q[DOFIREROD_LOOP_NPCS]);
					if ( !n->CollDetection ) continue; 
					if ( n->HitXOffset < 0 ) continue;
					if ( n->HitXOffset > 255 ) continue;
					if ( n->HitYOffset < 0 ) continue;
					if ( n->HitYOffset > 255 ) continue;
					if ( Collision(l,n) ){
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


//DarkRoom() array indices : Do not touch!!

const int DARKROOM_LOOP_LIGHTSRC_ADD 		= 0;
const int DARKROOM_LOOP_LIGHTSRC_LAYER 		= 1;
const int DARKROOM_LOOP_CHECKPOS 		= 2;
const int DARKROOM_LOOP_LWPNS_ADD 		= 3;
const int DARKROOM_ARRAYSZ_LIGHTSRCFLAGS 	= 4;
const int DARKROOM_LOOP_LIGHTSOURCE_WIPE 	= 5;
const int DARKROOM_LOOP_BITMAP_DRAW 		= 6;
const int DARKROOM_LIGHTSOURCE_COUNT 		= 7;
const int DARKROOM_ARRAYSZ_LIGHTFLAGLAYERS 	= 8;
const int DARKROOM_SRC 				= 9;
const int DARKROOM_LIGHTSOURCE_COUNTS 		= 10;


//Call before Waitdraw()
//DarkDroom(DARKROOM_LAYER, false, BITMAP_DARKNESS);
void DarkRoom(int layer, bool trans, int bitmap_id)
{
	int q[11];
	int lightsourceflags[]={CF_LIT_TORCH}; 
	q[DARKROOM_ARRAYSZ_LIGHTSRCFLAGS] = SizeOfArray(lightsourceflags);
	int lightsourceflaglayers[]={LAYER_TORCH_FLAG};
	q[DARKROOM_ARRAYSZ_LIGHTFLAGLAYERS] = SizeOfArray(lightsourceflaglayers);
	
	for ( q[DARKROOM_LOOP_LIGHTSOURCE_WIPE] = SizeOfArray(LightSources); q[DARKROOM_LOOP_LIGHTSOURCE_WIPE] >= 0; q[DARKROOM_LOOP_LIGHTSOURCE_WIPE]-- ) { LightSources[ q[DARKROOM_LOOP_LIGHTSOURCE_WIPE] ] = -1; } //Wipe it every frame. 
	Screen->SetRenderTarget(bitmap_id);
	Screen->Rectangle(layer, 0, 0, 256, 256, COLOUR_BLACK, 100, 0, 0, 0, true, OP_OPAQUE);
	//Add light sources to the array for combos. 
	for ( q[DARKROOM_LOOP_LIGHTSRC_ADD] = 0; q[DARKROOM_LOOP_LIGHTSRC_ADD] < q[DARKROOM_ARRAYSZ_LIGHTFLAGLAYERS]; q[DARKROOM_LOOP_LIGHTSRC_ADD]++ ) 
	{
		//Check for light sources on layers
		for ( q[DARKROOM_LOOP_LIGHTSRC_LAYER] = 0; q[DARKROOM_LOOP_LIGHTSRC_LAYER] < 176; q[DARKROOM_LOOP_LIGHTSRC_LAYER]++ ) 
		{
			//check all positions.
			for ( q[DARKROOM_LOOP_CHECKPOS] = 0; q[DARKROOM_LOOP_CHECKPOS] < q[DARKROOM_ARRAYSZ_LIGHTSRCFLAGS]; q[DARKROOM_LOOP_CHECKPOS]++ ) 
			{	//and all flags
				if (  ____LayerComboFI(q[DARKROOM_LOOP_LIGHTSRC_LAYER], lightsourceflags[ q[DARKROOM_LOOP_CHECKPOS] ], lightsourceflaglayers[ q[DARKROOM_LOOP_LIGHTSRC_ADD] ] ) ) 
				{
					LightSources[ q[DARKROOM_SRC] ] = ComboX(q[DARKROOM_LOOP_LIGHTSRC_LAYER]);
					LightSources[ q[DARKROOM_SRC] +1] = ComboY(q[DARKROOM_LOOP_LIGHTSRC_LAYER]);
					LightSources[ q[DARKROOM_SRC] +2] = Rand(LIGHT_SOURCE_COMBO_RADIUS_MIN, LIGHT_SOURCE_COMBO_RADIUS_MAX);
					 q[DARKROOM_LIGHTSOURCE_COUNTS]++; 
					 q[DARKROOM_SRC] +=3;
				}
			}
		}
	}
	//add light sources to the array for weapons
	for ( q[DARKROOM_LOOP_LWPNS_ADD] = Screen->NumLWeapons(); q[DARKROOM_LOOP_LWPNS_ADD] > 0; q[DARKROOM_LOOP_LWPNS_ADD] -- )
	{
		lweapon l = Screen->LoadLWeapon(q[DARKROOM_LOOP_LWPNS_ADD]);
		//for special fire rod weapons
		if ( l->ID == LW_CUST_FLAME )
		{
			LightSources[ q[DARKROOM_SRC] ] = l->X + 8;
			LightSources[ q[DARKROOM_SRC] +1] = l->Y + 8;
			LightSources[ q[DARKROOM_SRC] +2] = Rand(LIGHT_SOURCE_WPN_RADIUS_MIN, LIGHT_SOURCE_WPN_RADIUS_MAX);
			 q[DARKROOM_LIGHTSOURCE_COUNTS]++; 
			 q[DARKROOM_SRC] +=3;
		}
		//for fire weapons that are not dummy weapons
		if ( l->ID == LW_FIRE )
		{
			if ( (l->Misc[FIREROD_MISC_INDEX]&FIREROD_FLAME_FLAG) != 0 ) 
			{
				LightSources[ q[DARKROOM_SRC] ] = l->X + 8;
				LightSources[ q[DARKROOM_SRC] +1] = l->Y + 8;
				LightSources[ q[DARKROOM_SRC] +2] = Rand(LIGHT_SOURCE_WPN_RADIUS_MIN, LIGHT_SOURCE_WPN_RADIUS_MAX);
				 q[DARKROOM_LIGHTSOURCE_COUNTS]++; 
				 q[DARKROOM_SRC] +=3;	
			}
		}
	}
	
	q[DARKROOM_LIGHTSOURCE_COUNT] =  q[DARKROOM_LIGHTSOURCE_COUNTS]*3;
	//Draw all light sources to the bitmap.
	for ( q[DARKROOM_LOOP_BITMAP_DRAW] = 0; q[DARKROOM_LOOP_BITMAP_DRAW] <= q[DARKROOM_LIGHTSOURCE_COUNT]; q[DARKROOM_LOOP_BITMAP_DRAW] += 3 )
	{
		Screen->Circle(LIGHT_SOURCE_CIRCLE_LAYER, LightSources[ q[DARKROOM_LOOP_BITMAP_DRAW] ], LightSources[ q[DARKROOM_LOOP_BITMAP_DRAW]+1 ], LightSources[ q[DARKROOM_LOOP_BITMAP_DRAW]+2 ], 0, LIGHT_SOURCE_CIRCLE_SCALE,
		0,0,0, true, OP_OPAQUE);
		if ( LightSources[ q[DARKROOM_LOOP_BITMAP_DRAW] ] == -1 ) break; //Sanity check. 
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
			

		