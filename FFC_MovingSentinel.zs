///////////////////////////
/// Moving Sentinel FFC ///
/// v0.1                ///
/// 11th october, 2017  ///
/// By: ZoriaRPG        ///
/////////////////////////////////////////////////////////////////////////////
/// A mobile sentry that halts Link when it sees him, and warps him away. ///
/// Set this to an ffc with an invisible combo (usually combo 1)          ///
/// that moves along a path of changers.                                  ///
/////////////////////////////////////////////////////////////////////////////
/// D0: Sound effect.
/// D1: String
/// D2: Destination DMap
/// D3: Destination Screen
/// D4: NPC to use (for display purposes)

const int FFC_SENTINEL_SOUND_DELAY = 120; //Delay between sound and string.
const int FFC_SENTINEL_MESSAGE_WARP_DELAY = 300;  //Delay between string, and warp. 
const int FFC_SENTINEL_SFX_WHISTLE = 63; //Default sound.
const int FFC_SENTINEL_DEFAULT_STRING = 1; //Default string. 

ffc script MovingSentinel
{
	void run(int sfx, int str, int dmap, int scrn, int npcid)
	{
		npc n = Screen->CreateNPC(npcid);
		n->HitWidth = 0; n->HitYOffset = -32768;
		int dir = -1; bool spotted; int delay; int spotcond;
		//Sanity checks.
		if ( sfx < 1 ) sfx = FFC_SENTINEL_SFX_WHISTLE; //Default
		if ( str < 1 ) str = FFC_SENTINEL_DEFAULT_STRING;
		while(1)
		{
			n->Dir = dir; //Lock the NPC to the same dir as this.
			n->X = this->X; n->Y = this->Y; //Move the npc with this.
			
			while ( spotted ) {
				if ( spotcond == 0 )
				{
					delay = FFC_SENTINEL_SOUND_DELAY;
					NoAction(); //Freeze Link.
					Game->PlaySound(sfx);
					for ( ; delay > 0; delay-- )
					{
						WaitNoAction();
					}
					spotcond = 1;
				}
				if ( spotcond == 1 )
				{
					delay = FFC_SENTINEL_MESSAGE_WARP_DELAY;
					NoAction();
					Screen->Message(str);
					for ( ; delay > 0; delay-- )
					{
						WaitNoAction();
					}
					spotcond = 2;
					
				}
				if ( spotcond == 2 )
				{
					Link->Warp(dmap,scrn)
				}
			}
			//Establish the ffc facing direction.
			if ( this->Ay > 0 )
			{
				dir = DIR_UP;
			}
			else if ( this->Ay < 0 )
			{ 
				dir = DIR_DOWN;
			}
			else if ( this->Ax > 0 )
			{
				dir = DIR_RIGHT;
			}
			else if ( this->Ax < 0 )
			{
				dir = DIR_RIGHT;
			}
			else
			{
				dir = -1;
			}
			//Check for LoS
			
			if ( dir == DIR_LEFT )
			{	//if Link is to the left of the sentinel
				if ( FFC_Sentinel_LinkLeftOf(this) )
				{
					//and within 8 pixels of the sentinel's Y axis
					if ( FFC_Sentinel_DistY(this, 8) )
					{
						spotted = true; //we see you.
						continue; //resume loop from the top.
					}
				}
			}
			if ( dir == DIR_RIGHT )
			{	//if Link is to the left of the sentinel
				if ( FFC_Sentinel_LinkRightOf(this) )
				{
					//and within 8 pixels of the sentinel's Y axis
					if ( FFC_Sentinel_DistY(this, 8) )
					{
						spotted = true;
						continue;
					}
				}
			}
			if ( dir == DIR_UP )
			{	//if Link is to the left of the sentinel
				if ( FFC_Sentinel_LinkAbove(this) )
				{
					//and within 8 pixels of the sentinel's X axis
					if ( FFC_Sentinel_DistX(this, 8) )
					{
						spotted = true;
						continue;
					}
				}
			}
			if ( dir == DIR_DOWN )
			{	//if Link is to the left of the sentinel
				if ( FFC_Sentinel_LinkBelow(this) )
				{
					//and within 8 pixels of the sentinel's X axis
					if ( FFC_Sentinel_DistX(this, 8) )
					{
						spotted = true;
						continue;
					}
				}
			}
			Waitframe();
		}
	}
	//These are copies of functions from std.zh 2.0, with renamed
	//identifiers, set at a scope local to this script.
	bool FFC_Sentinel_DistX(ffc a, int distance) {
	    int dist;
	    if ( a->X > Link->X ) dist = a->X - Link->X;
		else dist = Link->X - a->X;
	    return ( dist <= distance );
	}
	bool FFC_Sentinel_DistY(ffc a, int distance) {
	    int dist;
	    if ( a->Y > Link->Y ) dist = a->Y - Link->Y;
		else dist = Link->Y - a->Y;
	    return ( dist <= distance );
	} 
	bool FFC_Sentinel_LinkAbove(ffc n){ return Link->Y < n->Y; }
	bool FFC_Sentinel_LinkBelow(ffc n){ return Link->Y > n->Y; }
	bool FFC_Sentinel_LinkLeftOf(ffc n){ return Link->X < n->X; }
	bool FFC_Sentinel_LinkRightOf(ffc n){ return Link->X > n->X; }
			
}