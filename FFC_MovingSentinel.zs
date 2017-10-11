///////////////////////////
/// Moving Sentinel FFC ///
/// v0.3                ///
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
/// D5: Initial facing direction, where 0 == UP, 1 == DOWN, 2 == LEFT, 3 == RIGHT

const int FFC_SENTINEL_SOUND_DELAY = 120; //Delay between sound and string.
const int FFC_SENTINEL_MESSAGE_WARP_DELAY = 300;  //Delay between string, and warp. 
const int FFC_SENTINEL_SFX_WHISTLE = 63; //Default sound.
const int FFC_SENTINEL_DEFAULT_STRING = 1; //Default string. 

const int FFC_SENTINEL_SPR_BLANK = 100; //A blank weapon sprite. 
ffc script MovingSentinel
{
	void run(int sfx, int str, int dmap, int scrn, int npcid, int init_dur)
	{
		npc n = Screen->CreateNPC(npcid); //Used to visibly display the sentry using a sprite. 
		n->HitWidth = 0; n->HitYOffset = -32768; //THe NPC has no collision rect. 
		n->X = this->X; n->Y = this->Y; //Lock the NPC coordinates to the FFC.
		eweapon spotter; //Used to check for solidity in LoS. 
		bool spotted; int delay; int spotcond; bool hit;
		if ( init_dir < 0 || init_dir > 3 ) init_dir = DIR_DOWN; //Face down by default. 
		int dir = init_dir; //FFCs have no 'dir' variable, so we need to give this a direction.
		n->Dir = dir; //Lock the NPC to the same dir as this.
			
		//Sanity checks.
		if ( sfx < 1 ) sfx = FFC_SENTINEL_SFX_WHISTLE; //Default
		if ( str < 1 ) str = FFC_SENTINEL_DEFAULT_STRING;
		
		//begin infinite loop
		while(1) 
		{
			n->Dir = dir; //Lock the NPC to the same dir as this.
			n->X = this->X; n->Y = this->Y; //Move the npc with this.
			
			//Generate the physical weapon if Link is in LoS of the ffc
			//to determine if that LoS should be blocked!
			if ( spotted )
			{
				//fire LoS Weapon
				spotter = Screen->CreateEWeapon(EW_ARROW); //Generate a weapon with properties that we can use. 
				spotter->HitYOffset = -32768; //Move the collision rect off-screen.
				spotter->UseSprite(FFC_SENTINEL_SPR_BLANK); //invisible
				spotter->X = this->X; //Spawn from the FFC->X/Y.
				spotter->Y = this->Y;
				spotter->HitWidth = 16; //May be useful for Collision using the actual weapon size. 
				spotter->HitHeight = 16; 
				spotter->Dir = dir; //Aim in the direction of the ffc.
				spotter->Step = 10000; //Mad-fast for instant-hit. 
			}
			
			//A way to ensure that LoS is blocked by any solid object.
			//Uses an eweapon that is destroyed when it hits a solid object.
			//If it hits Link, he is spotted. 
			if ( spotter->isValid() )
			{
				//If the weapon hits a solid space, remove it. 
				if ( Screen->isSolid(spotter->X, spotter->Y)
				{
					Remove(spotter);
				}
				//If it collides with Link, remove it, and begin the process of removing him, too. 
				if ( LinkCollision(spotter) )
				{
					Remove(spotter);
					hit = true;
				}
			} 
			
			//If Link is hit with the LoS projectile:
			while ( hit ) 
			{
				//Condition 0, Play the sound. 
				if ( spotcond == 0 )
				{
					delay = FFC_SENTINEL_SOUND_DELAY; //Set the timer.
					NoAction(); //Freeze Link.
					Game->PlaySound(sfx); //Play the4 sound.
					for ( ; delay > 0; delay-- ) 
					{
						WaitNoAction(); //Wait for the duration of the timer.
					}
					spotcond = 1; //Advance to condition 1. 
				}
				//Condition 1, show the message.
				if ( spotcond == 1 )
				{
					delay = FFC_SENTINEL_MESSAGE_WARP_DELAY; //Set the timer.
					NoAction(); //Freeze Link
					Screen->Message(str); //Show the string.
					for ( ; delay > 0; delay-- )
					{
						WaitNoAction(); //Wait for the duration of the timer.
					}
					spotcond = 2; //Advance to condition 2.
					
				}
				//Condition 2, warp.
				if ( spotcond == 2 )
				{
					Link->Warp(dmap,scrn); //Warp Link tot he desired coordinates. 
					//! This will use Warp Return A on the destination screen.
					//! This will also automatically exit the ffc script. 
				}
				Waitframe(); //Emergency waitframe call. 
			} //end (hit) loop
			
			//Establish the ffc facing direction.
			if ( this->Ay > 0 )
			{
				dir = DIR_UP; //The ffc is moving upward.
			}
			else if ( this->Ay < 0 )
			{ 
				dir = DIR_DOWN; //The ffc is moving downward.
			}
			else if ( this->Ax > 0 )
			{
				dir = DIR_RIGHT; //The ffc is moving right.
			}
			else if ( this->Ax < 0 )
			{
				dir = DIR_RIGHT; //The ffc is moving left.
			}
			else
			{
				dir = init_dir; //The ffc is NOT moving, so use the static dir. 
			} 
			
			//Check for LoS:
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
			} //end LoS checks.
			Waitframe();
		} //end infinite loop. 
	} //end run()
	
	//! Local functions
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
			
} //end script