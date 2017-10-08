//Prevents stuniogn weapons from stunlocking npcs. 
//v0.2
//7th October, 201
//ZoriaRPG

const int SFX_CHINK = 63;

const int LW_FLAGS_Z3ENGINE = 4;
const int LW_FLAG_STUNNING = 0000000000001b;
const int HITY_OFFSCREEN = -32768;

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
			n = Screen->LoadNPC(npc_count);
			for ( ; lweapon_count > 0; lweapon_count-- )
			{
				l = Screen->LoadLWeapon(lweapon_count);
				if ( Collision(l,n)
				{
					AllNpcLWeaponCollisionRoutines(l,n);
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
				if ( Collision(l,n)
				{
					AllNpcLWeaponCollisionRoutines(l,n);
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
	
	
	int counts[COUNT_NPCS] = Screen->NumNPCs();
	int counts[COUNT_LWEAPONS] = Screen->NumLWeapons();
	int counts[COUNT_EWEAPONS] = Screen->NumEWeapons();
	int counts[COUNT_COMBOS] = 175; //combo positions. 
	int counts[COUNT_FFCS] = 32; 
	int counts[COUNT_ITEMS] = Screen->NumItems();
	for ( ; counts[COUNT_LWEAPONS] > 0; counts[COUNT_LWEAPONS]-- )
	{
		l = Screen->LoadLWeapon(counts[COUNT_LWEAPONS]);
		
		//LWeapon Setup
		LWeaponRoutines(l);
		
		//LWeapon and NPC
		for ( ; counts[COUNT_NPCS] > 0; counts[COUNT_NPCS]-- )
		{ 
			n = Screen->LoadNPC(counts[COUNT_NPCS]);
			if ( Collision(l,n)
			{
				AllNpcLWeaponCollisionRoutines(l,n);
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
				

//Global active script. 
global script Z3_active{
	void run(){
		while(true){
			MasterLWeaponsLoop();
			
			Waitdraw();
			
			//cleanup and verification. 
		}
	}
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
void SetStunning(lweapon l, bool canstun){
	if ( canstun )
	{
		l->Misc[LW_FLAGS_Z3ENGINE]|=LW_FLAG_STUNNING;
		MoveWeaponHitbox(l,true);
		}
	else 
	{
		l->Misc[LW_FLAGS_Z3ENGINE]&=~LW_FLAG_STUNNING;
		MoveWeaponHitbox(l,false);
	}
}


//Marks the flags on all weapons that would stun, and can bounce. 
void MarkStunningWeapons(lweapon l){
	if ( l->Damage == 0 )
	{
		if ( l->ID == LW_BRANG || l->ID == LW_HOOKSHOT ) 
		{	
			SetStunning(l,true); //Move the hitbox offscreen and mark the flag. 
		}
	}
}

//Forces a stunning weapon to not stun,a nd to bounce. 
void BlockStun(lweapon l)
{
	MoveWeaponHitbox(l,true);
	Game->PlaySound(SFX_CHINK);
	l->DeadState = WDS_BOUNCE;
}

//Sets the correct stun variables to lweapons of the npc is not stunned. 
void StunCollision(lweapon l, npc n)
{
	if ( !n->Stun )
	{
		StunNPCThisFrame(l);
	}
	
	else BlockStun(l);
}
		