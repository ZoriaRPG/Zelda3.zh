const int NPC_DEADROCK_STONETIME = 300; //Time in frames that DeadRock will be petrified.
const int NPC_DEADROCK_TURNTIME = 48; //The 'halttime' value for Ghost_HaltingWalk4()
const int NPC_DEADROCK_TILE = 10200; //Tile for DeadRock in stoned state. 
const int NPC_DEADROCK_LAYER = 2; //Layer of drawn 'rock' tile. 
const int NPC_DEADROCK_CSET = -1; //Set to 0 or higher to use a fixed CSet. 
const int NPC_DEADROCK_DIST = 8; //Radius distant from enemy, when in a stoned state, to block Link's inputs. 
const int NPC_DEADROCK_DIST_HITDIR = 24;
const int NPC_DEADROCK_WEAPONDIST = 12; //Distance for collisio of the weapon and the npc when in a rock state. 
const int NPC_DEADROCK_SFX_CLINK = 100;

ffc script DeadRock{
	void run(int enem_id){
		
		npc ghost = Ghost_InitAutoGhost(enem_id); 
		int orighp = ghost->HP; 
		Ghost_SetFlag(GHF_FULL_TILE_MOVEMENT); //Will not move onto partially solid combos. 
		Ghost_SetFlag(GHF_4WAY); //4-Way walking.
		int random_hitdir = ghost->Attributes[11];
		int rock; int q; lweapon l; int lasthp; int walk = -1; int w;
		
		while(true){
			lasthp = ghost->HP; 
			
			//Handle movement. 
			walk = Ghost_Walk4(walk, ghost->Step, ghost->Rate, ghost->Homing, ghost->Haltrate, NPC_DEADROCK_TURNTIME);
			
			//Check for collision with items
			for ( q = Screen->NumLWeapons(); q >= 0; q-- ) {
				l = Screen->LoadLWeapon(q);
				if ( Collision(ghost,l) ) { //&& ghost->HP < lasthp
					//if *anything hits him...
					//Turn to stone:
					
					//Draw flesh-to-stone transformation anim.
					
					for ( q = 0; q < 12; q++ ){
						if ( q % 2 == 0 ) {
							for ( w = 0; w < 5; w++ ) {
								ghost->DrawXOffset = ghost->X;
								Ghost_WaitframeLight(this, ghost); 
							}
						}
						else {
							for ( w = 0; w < 5; w++ ) {
								ghost->DrawXOffset = -200;
								if ( NPC_DEADROCK_CSET >= 0 ) Screen->FastTile(NPC_DEADROCK_LAYER, ghost->X, ghost->Y, NPC_DEADROCK_TILE, NPC_DEADROCK_CSET, OP_OPAQUE); 
								else Screen->FastTile(NPC_DEADROCK_LAYER, ghost->X, ghost->Y, NPC_DEADROCK_TILE, ghost->CSet, OP_OPAQUE); 
								Ghost_WaitframeLight(this, ghost);
							}
						}
						
					}
					
					rock = NPC_DEADROCK_STONETIME;
				}
			}
			
			//While he's stoned...
			while (rock--) {
				
				//Check for weapon collision and do effects by weapon type
				for ( q = Screen->NumLWeapons(); q >= 0; q-- ) {
					l = Screen->LoadLWeapon(q);
					if ( DistXY(ghost,l,NPC_DEADROCK_WEAPONDIST) ) {
						if ( l->ID == LW_HOOKSHOT || l->ID == LW_BRANG ) { l->DeadState = WDS_BOUNCE; Game->PlaySound(NPC_DEADROCK_SFX_CLINK); }
						if ( l->ID == LW_BEAM || l->ID >= LW_SCRIPT1 ) l->DeadState = WDS_DEAD; 
						if ( l->ID == LW_ARROW ) { l->DeadState = WDS_DEAD; Game->PlaySound(NPC_DEADROCK_SFX_CLINK); }
						if ( l->ID == LW_SWORD || l->ID == LW_HAMMER || l->ID == LW_WAND ) Game->PlaySound(NPC_DEADROCK_SFX_CLINK);
					}
				}
				
				//Move the real npc offscreen
				ghost->DrawXOffset = -200; ghost->HitXOffset = -200;
				
				//Draw the rock tile
				if ( NPC_DEADROCK_CSET >= 0 ) Screen->FastTile(NPC_DEADROCK_LAYER, ghost->X, ghost->Y, NPC_DEADROCK_TILE, NPC_DEADROCK_CSET, OP_OPAQUE); 
				else Screen->FastTile(NPC_DEADROCK_LAYER, ghost->X, ghost->Y, NPC_DEADROCK_TILE, ghost->CSet, OP_OPAQUE); 
				 
				//Kill inputs if Link tries to pass through DeadRock or damage to Link would push him past DeadRock...
				//Link is on the left side...
				if ( __LeftOf(ghost) && Link->CollDetection ) {
					if ( __DistXY(ghost, NPC_DEADROCK_DIST) && __LinkFacing(ghost) ) {
						if ( Link->PressRight || Link->InputRight ) {
							Link->PressRight = false; Link->InputRight = false; 
						}
					}
					
					//Prevent Link from damage boosting past it. 
					if ( __DistXY(ghost, NPC_DEADROCK_DIST_HITDIR) && Link->Action == LA_GOTHURTLAND || Link->Action == LA_GOTHURTWATER && Link>HitDir == DIR_RIGHT ) {
						if ( !random_hitdir ) Link->HitDir = -1;
						else { 
							do { 
								Link->HitDir = Rand(4);
							} while(Link->HitDir == DIR_RIGHT); 
						}
					}
					
				}
				//Link is on the right side...
				if ( __RightOf(ghost) && Link->CollDetection ) {
					if ( __DistXY(ghost, NPC_DEADROCK_DIST) && __LinkFacing(ghost) ) {
						if ( Link->PressLeft || Link->InputLeft ) {
							Link->PressLeft = false; Link->InputLeft = false; 
						}
					}
					
					//Prevent Link from damage boosting past it. 
					if ( __DistXY(ghost, NPC_DEADROCK_DIST_HITDIR) && Link->Action == LA_GOTHURTLAND || Link->Action == LA_GOTHURTWATER && Link>HitDir == DIR_LEFT ) {
						if ( !random_hitdir ) Link->HitDir = -1;
						else { 
							do { 
								Link->HitDir = Rand(4);
							} while(Link->HitDir == DIR_LEFT); 
						}
					}
				}
				
				//Link is above...
				if ( __Above(ghost) && Link->CollDetection ) {
					if ( __DistXY(ghost, NPC_DEADROCK_DIST) && __LinkFacing(ghost) ) {
						if ( Link->PressDown || Link->InputDown ) {
							Link->PressDown = false; Link->InputDown = false; 
						}
					}
					//Prevent Link from damage boosting past it. 
					if ( __DistXY(ghost, NPC_DEADROCK_DIST_HITDIR) && Link->Action == LA_GOTHURTLAND || Link->Action == LA_GOTHURTWATER && Link>HitDir == DIR_DOWN ) {
						if ( !random_hitdir ) Link->HitDir = -1;
						else { 
							//do { 
							//	hitdir = Rand(4);
							//} while(hitdir == DIR_DOWN); 
							//Link->HitDir = hitdir; 
							
							do { 
								Link->HitDir = Rand(4);
							} while(Link->HitDir == DIR_DOWN);
					
						}
					}
				}
				
				//Link is below...
				if ( __Below(ghost) && Link->CollDetection ) {
					if ( __DistXY(ghost, NPC_DEADROCK_DIST) && __LinkFacing(ghost) ) {
						if ( Link->PressUp || Link->InputUpLink ) {
							Link->PressUp = false; Link->InputUp = false; 
						}
					}
					//Prevent Link from damage boosting past it. 
					if ( __DistXY(ghost, NPC_DEADROCK_DIST_HITDIR) && Link->Action == LA_GOTHURTLAND || Link->Action == LA_GOTHURTWATER && Link>HitDir == DIR_UP ) {
						if ( !random_hitdir ) Link->HitDir = -1;
						else { 
							do { 
								Link->HitDir = Rand(4);
							} while(Link->HitDir == DIR_UP); 
						}
					}
				}
				Ghost_WaitframeLight(this, ghost); 
			}
			
			//Deadrock is no longer stoned. Restore him...
			ghost->HitXOffset = ghost->X; 
			ghost->DrawXOffset = -200;
			ghost->HP = orighp; 
			Ghost_Waitframe(this,ghost,true,true); 
		}
	}
	
	
	//Embed:
	
	bool __DistXY(npc b, int distance) {
		int distx; int disty;
		if ( Link->X > b->X ) distx = Link->X - b->X;
		else distx = b->X - Link->X;
		
		if ( Link->Y > b->Y ) disty = Link->Y - b->Y;
		else disty = b->Y - Link->Y;

		return ( distx <= distance && disty <= distance );
	} 


	bool __DistXY(ffc b, int distance) {
		int distx; int disty;
		if ( Link->X > b->X ) distx = Link->X - b->X;
		else distx = b->X - Link->X;
		
		if ( Link->Y > b->Y ) disty = Link->Y - b->Y;
		else disty = b->Y - Link->Y;

		return ( distx <= distance && disty <= distance );
	} 
		
	bool __DistXY(lweapon a, ffc b, int distance) {
		int distx; int disty;
		if ( a->X > b->X ) distx = a->X - b->X;
		else distx = b->X - a->X;
		
		if ( a->Y > b->Y ) disty = a->Y - b->Y;
		else disty = b->Y - a->Y;

		return ( distx <= distance && disty <= distance );
	} 
	bool __DistXY(lweapon a, npc b, int distance) {
		int distx; int disty;
		if ( a->X > b->X ) distx = a->X - b->X;
		else distx = b->X - a->X;
		
		if ( a->Y > b->Y ) disty = a->Y - b->Y;
		else disty = b->Y - a->Y;

		return ( distx <= distance && disty <= distance );
	} 
	bool __DistXY(npc a, lweapon b, int distance) {
		int distx; int disty;
		if ( a->X > b->X ) distx = a->X - b->X;
		else distx = b->X - a->X;
		
		if ( a->Y > b->Y ) disty = a->Y - b->Y;
		else disty = b->Y - a->Y;

		return ( distx <= distance && disty <= distance );
	} 
	bool __DistXY(ffc a, lweapon b, int distance) {
		int distx; int disty;
		if ( a->X > b->X ) distx = a->X - b->X;
		else distx = b->X - a->X;
		
		if ( a->Y > b->Y ) disty = a->Y - b->Y;
		else disty = b->Y - a->Y;

		return ( distx <= distance && disty <= distance );
	} 

	bool __Above(npc n){ return Link->Y < n->Y; }
	bool __Below(npc n){ return Link->Y > n->Y; }
	bool __LeftOf(npc n){ return Link->X < n->X; }
	bool __RightOf(npc n){ return Link->X > n->X; }

	bool __Above(ffc n){ return Link->Y < n->Y; }
	bool __Below(ffc n){ return Link->Y > n->Y; }
	bool __LeftOf(ffc n){ return Link->X < n->X; }
	bool __RightOf(ffc n){ return Link->X > n->X; }
	
	bool __LinkFacing(ffc f){
		if ( Link->Dir == DIR_UP && Link->Y > f->Y ) return true;
		if ( Link->Dir == DIR_DOWN && Link->Y < f->Y ) return true;
		if ( Link->Dir == DIR_RIGHT && Link->X < f->X ) return true;
		if ( Link->Dir == DIR_LEFT && Link->X > f->X ) return true;
		return false;
	}


	bool __LinkFacing(npc f){
		if ( Link->Dir == DIR_UP && Link->Y > f->Y ) return true;
		if ( Link->Dir == DIR_DOWN && Link->Y < f->Y ) return true;
		if ( Link->Dir == DIR_RIGHT && Link->X < f->X ) return true;
		if ( Link->Dir == DIR_LEFT && Link->X > f->X ) return true;
		return false;
	}
}
			