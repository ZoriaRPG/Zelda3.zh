////////////////////////////
/// Simple Firerod       ///
/// v0.1                 ///
/// By: ZoriaRPG         ///
/// 24th September, 2017 ///
////////////////////////////
/// Note: All of this is ugly. In 2.54, you will be able to set NPCs to specific script defences, so you can use a real
///       FLAME weapon that you set up, and 2.54 may add SCRIPT weapon triggers to combos, as well. 


//Settings
const int LW_CUST_FLAME 	= 31; //Script 1
const int FIREROD_MIN_STEP 	= 100;
const int FIREROD_DAMAGE 	= 4;
const int FIREROD_MISC_INDEX 	= 1;
const int FIREROD_FLAME_FLAG 	= 00001000b;
const int FIREROD_FLAME_SPRITE 	= 89;
const int BLANK_FIRE_SPRITE 	= 90; //Should be a blank tile sprite.  

item script BasicFireRod{
	void run(int sprite, int damage, int step_speed){
		lweapon flame = Screen->CreateLWeapon(LW_CUST_FLAME);
		flame->X = Link->X;
		flame->Y = Link->Y;
		flame->UseSprite = Cond(sprite > 0, sprite, FIREROD_FLAME_SPRITE);
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
		if ( Link->Dir = DIR_RIGHT ) {
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

	int loc = ComboAt(x,y);

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
						if ( ____LayerComboFI(pos, flags[w] , layer ) {
							lweapon makefire = Screen->CreateLWeapon(LW_FIRE);
							makefire->X = ComboX(cmb_pos);
							makefire->Y = ComboY(cmb_pos);
							makefire->UseSprite = BLANK_FIRE_SPRITE;
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
						makefire->UseSprite = BLANK_FIRE_SPRITE;
					}
				}
			}
		}
	}
}
					
						
				
void DrawFireRodLightSources(){ 
	//t/b/a
}