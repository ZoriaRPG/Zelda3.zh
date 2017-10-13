import "std.zh"

//Prevents stuniogn weapons from stunlocking npcs. 
//v0.3
//13th October, 201
//ZoriaRPG

//Current bug: If Link is standing immediately next to an npc, the boomerang 
//can collide (in the ZC engine) before the settings are applied to it. This happens on the first frame 
//or two of its existence. 

const int DEBUG_STUNLOCK 	= 1; //Set to 1 to enable debug verbose mode. 

const int SFX_CHINK 		= 6;
const int SFX_STUN 		= 51;

const int LW_FLAGS_Z3ENGINE 	= 4;
const int LW_FLAG_STUNNING 	= 0000000000001b;
const int HITY_OFFSCREEN 	= -32768;

const int STUN_DUR 		= 200;
const int STUN_IMMUNITY		= 120; //Frames after unstunning that npc remains immune. 


//Pre-Waitdraw

//Master loop for all lweapon set-up. 
void DoLWeaponsCheckLoop(){
	lweapon l;
	
	for ( int q = Screen->NumLWeapons(); q > 0; q-- ) 
	{
		l = Screen->LoadLWeapon(q);
		LWeaponRoutines(l);
		//Add the redundant weapon-only checks here. 
	}
}

//Master loop for all lweapon and npc collision. 
void DoLWeaponNPC_Collision(){
	lweapon l; npc n;
	int npc_count = Screen->NumNPCs();
	int lweapon_count = Screen->NumLWeapons();
	bool npcs_first; 
	if ( npc_count < lweapon_count ) {
		//Do npcs first
		for ( ; npc_count > 0; npc_count-- )
		{
			if ( DEBUG_STUNLOCK ) { int s[]="npc_count: "; TraceS(s); Trace(npc_count); }
			n = Screen->LoadNPC(npc_count);
			TraceNL(); Trace(n->ID); Trace(n->X); Trace(n->Y);
			for ( ; lweapon_count > 0; lweapon_count-- )
			{
				if ( DEBUG_STUNLOCK ) { int s1[]="lweapon_count: "; TraceS(s1); Trace(lweapon_count); }
				l = Screen->LoadLWeapon(lweapon_count);
				TraceNL(); Trace(l->ID); Trace(l->X); Trace(l->Y);
				if ( DistXY(l,n,8) )
				{
					if ( DEBUG_STUNLOCK ) { int ss[]="Collision"; TraceS(ss); }
					NpcLWeaponCollisionRoutines(l,n);
				}
			}
		}
	}
	else 
	{
		for ( ; lweapon_count > 0; lweapon_count-- )
		{
			l = Screen->LoadLWeapon(lweapon_count);
			for ( ; npc_count > 0; npc_count-- )
			{ 
				n = Screen->LoadNPC(npc_count);
				if ( Collision(l,n) )
				{
					NpcLWeaponCollisionRoutines(l,n);
					//functions in the form of identifier(l,n)
				}
			}
		}
	}
}

const int COUNT_LWEAPONS 	= 0; 
const int COUNT_EWEAPONS 	= 1;
const int COUNT_NPCS 		= 2; 
const int COUNT_ITEMS 		= 3;
const int COUNT_FFCS 		= 4;
const int COUNT_COMBOS 		= 5;

//Pre-Waitdraw
//Master loop for all lweapon and npc collision. 
//Further-optimised. 
void MasterLWeaponsLoop(){
	lweapon l; npc n; item i; eweapon e; ffc f;
	int counts[7]; 
	
	
	counts[COUNT_NPCS] = Screen->NumNPCs();
	counts[COUNT_LWEAPONS] = Screen->NumLWeapons();
	counts[COUNT_EWEAPONS] = Screen->NumEWeapons();
	counts[COUNT_COMBOS] = 175; //combo positions. 
	counts[COUNT_FFCS] = 32; 
	counts[COUNT_ITEMS] = Screen->NumItems();
	for ( ; counts[COUNT_LWEAPONS] > 0; counts[COUNT_LWEAPONS]-- )
	{
		l = Screen->LoadLWeapon(counts[COUNT_LWEAPONS]);
		
		//LWeapon Setup
		LWeaponRoutines(l);
		
		//LWeapon and NPC
		for ( ; counts[COUNT_NPCS] > 0; counts[COUNT_NPCS]-- )
		{ 
			n = Screen->LoadNPC(counts[COUNT_NPCS]);
			if ( DistXY(l,n,8) )
			{
				if ( DEBUG_STUNLOCK )
				{
					int s1[]="Collision found in MasterWeaponsLoop()"; TraceS(s1);
				}
				NpcLWeaponCollisionRoutines(l,n);
				//functions in the form of identifier(l,n)
			}
		}
		
		//LWeapon and items
		
		for ( ; counts[COUNT_ITEMS] > 0; counts[COUNT_ITEMS]-- ) 
		{
			//brang pickup

			
		}
		
		
		//lweapon and eweapons
		
		for ( ; counts[COUNT_EWEAPONS] >= 0; counts[COUNT_EWEAPONS]-- )
		{
			
			
		}
		
		//lweapon and combos
		
		for ( ; counts[COUNT_COMBOS] >= 0; counts[COUNT_COMBOS]-- )
		{
			
			
		}
		
		
		//lweapon and combos
		
		for ( ; counts[COUNT_COMBOS] >= 0; counts[COUNT_COMBOS]-- )
		{
			
			
		}
		
		//lweapon and ffcs
		
		for ( ; counts[COUNT_FFCS] > 0; counts[COUNT_FFCS]-- )
		{
			
			
		}
		
	}
}
	

void MasterEnemiesLoop()
{
	lweapon l; npc n; item i; eweapon e; ffc f;
	int counts[7]; 
	
	
	counts[COUNT_NPCS] = Screen->NumNPCs();
	counts[COUNT_LWEAPONS] = Screen->NumLWeapons();
	counts[COUNT_EWEAPONS] = Screen->NumEWeapons();
	counts[COUNT_COMBOS] = 175; //combo positions. 
	counts[COUNT_FFCS] = 32; 
	counts[COUNT_ITEMS] = Screen->NumItems();
	
	//Enemy General Changes
	for ( ; counts[COUNT_NPCS] > 0; counts[COUNT_NPCS]-- )
	{
		n = Screen->LoadNPC(counts[COUNT_NPCS]);
		DecrementStun(n);
		
	}
	
}
	
//Global active script. 
global script Z3_active{
	void run(){
		while(true){
			EnemySetupRoutines();
			MasterLWeaponsLoop();
			
			MasterEnemiesLoop();
			Waitdraw();
			Waitframe();
			//cleanup and verification. 
		}
	}
}

const int NPC_MISC_STUN = 8;
	
void EnemySetupRoutines(){
	int numnpcs = Screen->NumNPCs(); npc n;
	for ( ; numnpcs > 0; numnpcs-- )
	{
		n = Screen->LoadNPC(numnpcs);
		n->Misc[NPC_MISC_STUN] = n->Stun;
	}
}

int GetStun(npc n){
	return n->Misc[NPC_MISC_STUN];
}

void SetStun(npc n){ n->Misc[NPC_MISC_STUN] = STUN_IMMUNITY + STUN_DUR; }


void DecrementStun(npc n)
{
	if ( n->Misc[NPC_MISC_STUN] > 0 ) n->Misc[NPC_MISC_STUN]--;
}
//Sub-routines. 

//This is a container for all of the lweapon and npc routines that run on collision, after
//the individual lweapon and npc routines. 
void NpcLWeaponCollisionRoutines(lweapon l, npc n)
{
	StunCollision(l,n);
	//Add all functions that you want to apply here.
}

//This is a container for all of the lweapon routines that occur early, before waitdraw.
void LWeaponRoutines(lweapon l)
{
	//Add all lweapon-only routines here. 
	MarkStunningWeapons(l);
}

//Moves the hitboix of any weapon on-screen, or off-screen. 
//May need to be updated to handle multiple sources, and to do -= or += HITY_OFFSCREEN
//	for weapons with existing hitbox positional changes. 
//	e.g. if a weapon has a -8 hitbox position adjustment, we want to preserve that!
void MoveWeaponHitbox(lweapon l, bool offscreen){ 
	if ( offscreen ) l->HitYOffset = HITY_OFFSCREEN;
	else l->HitYOffset = 0;
}

//Corrects the lweapon hotbox position if the weapon can stun an npc. 
void StunNPCThisFrame(lweapon l)
{
	MoveWeaponHitbox(l,false);
	
}

//Sets a stun flag and adjusts the hitbox position. 
void _SetStunning(lweapon l, bool canstun){
	if ( canstun )
	{
		l->Misc[LW_FLAGS_Z3ENGINE]|=LW_FLAG_STUNNING;
		MoveWeaponHitbox(l,false);
		}
	else 
	{
		l->Misc[LW_FLAGS_Z3ENGINE]&=~LW_FLAG_STUNNING;
		MoveWeaponHitbox(l,true);
	}
}

//Sets a stun flag and adjusts the hitbox position. 
void SetStunning(lweapon l){
	l->Misc[LW_FLAGS_Z3ENGINE]|=LW_FLAG_STUNNING;
	l->HitYOffset = HITY_OFFSCREEN;
	
}

bool GetStunning(lweapon l){
	return ( l->Misc[LW_FLAGS_Z3ENGINE]&LW_FLAG_STUNNING);
}


//Marks the flags on all weapons that would stun, and can bounce. 
void MarkStunningWeapons(lweapon l){
	if ( l->Damage == 0 )
	{
		if ( l->ID == LW_BRANG || l->ID == LW_HOOKSHOT ) 
		{	
			SetStunning(l); //Move the hitbox offscreen and mark the flag. 
		}
	}
}

//Forces a stunning weapon to not stun,a nd to bounce. 
void BlockStun(lweapon l, npc n)
{
	//MoveWeaponHitbox(l,true);
	Game->PlaySound(SFX_CHINK);
	l->DeadState = WDS_BOUNCE;
	n->Stun = GetStun(n);
}



//Sets the correct stun variables to lweapons of the npc is not stunned. 
void StunCollision(lweapon l, npc n)
{
	if ( DEBUG_STUNLOCK ) { int ss[]="GetStun() is: "; TraceS(ss); Trace(GetStun(n)); }
	if ( !n->Stun ) //THis is not working. The stun value is 0, and it is not updating soon enough.
	{
		if ( GetStun(n) <= 0 ) 
		{
			//StunNPCThisFrame(l);
			n->Stun = STUN_DUR;
			Game->PlaySound(SFX_STUN);
			l->DeadState = WDS_BOUNCE;
			SetStun(n);
		}
			
	}
	else
	{
		Game->PlaySound(SFX_CHINK);
		l->DeadState = WDS_BOUNCE;
		//n->Stun = GetStun(n);
	}
	//else BlockStun(l, n);
}
		
bool DistXY(lweapon a, npc b, int distance) {
	int distx; int disty;
	if ( a->X > b->X ) distx = a->X - b->X;
	else distx = b->X - a->X;
	
	if ( a->Y > b->Y ) disty = a->Y - b->Y;
	else disty = b->Y - a->Y;

	return ( distx <= distance && disty <= distance );
} 