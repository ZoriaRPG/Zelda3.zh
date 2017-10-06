
const int VAL1 = 50;
const int VAL2 = 100;
const int VAL3 = 150;
const int SFX_CHINK = 63;

int vy;

//I wrote this to test a merging utiloity, not as a real, optimised script.
//nevertheless, it probably does work, and if optimised, would make a fine method of preventing stunlocking.

global script active{
	void run(){
		while(true){
			for ( int q = Screen->NumLWeapons(); q > 0; q-- ) 
			{
				lweapon l = Screen->LoadLWeapon(w);
				if ( l->Damage == 0 ) {
					if ( l->ID == LW_BRANG || l->ID == LW_HOOKSHOT ) 
					{
						l->Misc[4] = VAL1;
						l->HitYOffset = -32768;
					}
				else l->Misc[4] = VAL2;
			}
			
			for ( int q = Screen->NumNPCs(); q > 0; q-- ) 
			{
				npc n = Screen->LoadNPC(q);
				for ( int w = Screen->NumLWeapons(); w > 0; q-- )
				{
					lweapon l = Screen->LoadLWeapon(w);
					if ( l->Misc[4] == VAL1 ) {
						if ( Collision(l,n ) {
							if ( !n->Stun ) {
								l->HitYOffset = 0;
								l->Misc[4] = VAL3;
							}
							else
							{
								l->HitYOffset = -32768;
								Game->PlaySound(SFX_CHINK);
								l->DeadState = WDS_BOUNCE;
							}
						}
					}
				}
			}
			
			Waitdraw();
			
			//cleanup verification. 
		}
	}
}
			