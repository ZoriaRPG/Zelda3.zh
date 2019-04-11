import "std.zh"
import "classic.zh"

/////////////////////////////
/// Zelda 3 Follower      ///
/// v1.0                  ///
/// 11th April, 2019      ///
/// By: ZoriaRPG          ///
/// Made for: JudasRising ///
/////////////////////////////
// v0.1 : Initial
// v0.2 : Changed hardcoded > 3 frame cap to use FOLLOWER_MAX_FRAME in drawing loops.
// v0.3 : Fix scrolling positions and positions onContinue
// v0.4 : The follower's tile is now set by the combo of the ffc 'GetZelda'. (It's combo tile, -4.)
//      : Added the ability for the follower to play a message, and give an item to Link, when Link
//      : delivers them to their destination. 
//	: Added the ability to show a message when you collect the npc.
// v0.5 : The follower CSet is now set by the ffc when you collect him. 
// v0.6 : Renamed scripts and functions, and moved global functions into local functions of ffc script Follower.
// v0.7 : Moved array to be script-namespace local to ffc Follower. Used for 2.55.
//      : You could use this in 2.53, but it needs the included Init script to work, as it will have bugs
//      : (the array values aren't correct) on init in versions < 2.55. 
//	: The follower ffc now makes its data invisible on init.
// v0.8 : Added support for up to 10 unique followers in a quest.
// v0.9 : Set combo under follower solid when that follower is dropped off. 
// v1.0 : Make enemies and weapons harmless during animation.
//	: Fix a flag check, and optimise statements.
//	: Added a setting for solidity layer, and only do SetLayerComboD(), if this value is nonzero.

//For future versions, used in 2.55+, a specific follower *type*.
//enum the_follower = { folNONE, folZELDA, folOLDMAN, folBLACKSMITH, folCHEST, folGHOST, folLAST };

//Settings
const int FOLLOWER_ZELDA_MIDI_DURATION 	= 300;
const int FOLLOWER_ZELDA_MIDI 		= 1;
const int FOLLOWER_MAX_FRAME 		= 3; //4-frame walking animation
const int FOLLOWER_CMB_BLANK_SOLID 	= 1;
const int FOLLOWER_SOLIDITY_LAYER 	= 1;

const int FOLLOWER_REGISTER 		= 1; //Screen->D register to use on any screen where you leave a follower. 

//Binary flags for Screen->D
const int FOLLOWER_GAVE_ITEM 		= 1b;
const int FOLLOWER_SHOWED_MESSAGE 	= 10b;
const int FOLLOWER_DELIVERED 		= 100b;
const int FOLLOWER_RESCUED 		= 1000b;


//Array and array indices.
//int TheFollower[128] = {-1, -1};
const int FOLLOWER_MIDI_TIMER 	= 0;
const int FOLLOWER_CUR_RESCUED 	= 1;
const int FOLLOWER_ACTIVE 	= 2;
const int FOLLOWER_ANIMATING 	= 3; //Unused
const int FOLLOWER_FRAME 	= 4;
const int FOLLOWER_SUBFRAME 	= 5;
const int FOLLOWER_ORIG_MIDI 	= 6;
const int FOLLOWER_BASE_TILE 	= 7;
const int FOLLOWER_CSET 	= 8;
const int FOLLOWER_CURRENT_ID 	= 9;

//Positional data for drawing.
const int FOLLOWER_X		= 10; 
const int FOLLOWER_X1		= 11;
const int FOLLOWER_X2		= 12;
const int FOLLOWER_X3		= 13; 
const int FOLLOWER_X4		= 14;
const int FOLLOWER_X5		= 15;
const int FOLLOWER_X6		= 16;
const int FOLLOWER_X7		= 17;
const int FOLLOWER_X8		= 19;
const int FOLLOWER_X9		= 20;
const int FOLLOWER_X10		= 21;
const int FOLLOWER_X11		= 22;
const int FOLLOWER_X12		= 23; //Highest used
const int FOLLOWER_X13		= 23;
const int FOLLOWER_X14		= 24;
const int FOLLOWER_X15		= 26;
const int FOLLOWER_X16		= 27;
const int FOLLOWER_X17		= 28;
const int FOLLOWER_X18		= 29;
const int FOLLOWER_X19		= 30;
const int FOLLOWER_X20		= 31;

const int FOLLOWER_Y		= 40;
const int FOLLOWER_Y1		= 41;
const int FOLLOWER_Y2		= 42;
const int FOLLOWER_Y3		= 43;
const int FOLLOWER_Y4		= 44;
const int FOLLOWER_Y5		= 45;
const int FOLLOWER_Y6		= 46;
const int FOLLOWER_Y7		= 47; 
const int FOLLOWER_Y8		= 48;
const int FOLLOWER_Y9		= 49;
const int FOLLOWER_Y10		= 50;
const int FOLLOWER_Y11		= 51;
const int FOLLOWER_Y12		= 52; //Highest used
const int FOLLOWER_Y13		= 53;
const int FOLLOWER_Y14		= 54;
const int FOLLOWER_Y15		= 55;
const int FOLLOWER_Y16		= 56;
const int FOLLOWER_Y17		= 57;
const int FOLLOWER_Y18		= 58;
const int FOLLOWER_Y19		= 59;
const int FOLLOWER_Y20		= 60;

const int FOLLOWER_DIR		= 70;
const int FOLLOWER_DIR1 	= 71;
const int FOLLOWER_DIR2 	= 72;
const int FOLLOWER_DIR3 	= 73;
const int FOLLOWER_DIR4 	= 74;
const int FOLLOWER_DIR5 	= 75;
const int FOLLOWER_DIR6 	= 76; 
const int FOLLOWER_DIR7 	= 77; 
const int FOLLOWER_DIR8 	= 78;
const int FOLLOWER_DIR9 	= 79;
const int FOLLOWER_DIR10	= 80;
const int FOLLOWER_DIR11 	= 81;
const int FOLLOWER_DIR12 	= 82; //Highest used
const int FOLLOWER_DIR13 	= 83;
const int FOLLOWER_DIR14 	= 84;
const int FOLLOWER_DIR15 	= 85;
const int FOLLOWER_DIR16 	= 86;
const int FOLLOWER_DIR17 	= 87;
const int FOLLOWER_DIR18 	= 88;
const int FOLLOWER_DIR19 	= 89;
const int FOLLOWER_DIR20 	= 90;

//Tile and CSet, supporting up to 10 unique followers in the quest.
const int FOLLOWER_ID_1_TILE 	= 100;
const int FOLLOWER_ID_2_TILE 	= 101;
const int FOLLOWER_ID_3_TILE 	= 102;
const int FOLLOWER_ID_4_TILE 	= 103;
const int FOLLOWER_ID_5_TILE 	= 104;
const int FOLLOWER_ID_6_TILE 	= 105;
const int FOLLOWER_ID_7_TILE 	= 106;
const int FOLLOWER_ID_8_TILE 	= 107;
const int FOLLOWER_ID_9_TILE 	= 108;
const int FOLLOWER_ID_10_TILE	= 109;

const int FOLLOWER_ID_1_CSET 	= 110;
const int FOLLOWER_ID_2_CSET 	= 111;
const int FOLLOWER_ID_3_CSET 	= 112;
const int FOLLOWER_ID_4_CSET 	= 113;
const int FOLLOWER_ID_5_CSET 	= 114;
const int FOLLOWER_ID_6_CSET 	= 115;
const int FOLLOWER_ID_7_CSET 	= 116;
const int FOLLOWER_ID_8_CSET 	= 117;
const int FOLLOWER_ID_9_CSET 	= 118;
const int FOLLOWER_ID_10_CSET 	= 119;

//Screen on which Link encountered the follower.
//Used to set a remote screen flag after Link delivers them home.
const int FOLLOWER_CUR_SRC_DMAP 	= 120;
const int FOLLOWER_CUR_SRC_SCRN 	= 121;


// When Link collides with this ffc, it triggers the follower. 
//
// When you use this, add a second ffc on the screen with the combo of the follower, and then
// set the Link property of the ffc running the script to the ffc ID of the second ffc.
//
// The second, linked ffc is used to draw the follower until you collect them, and it also sets
// both the tiles to draw, and the CSet to use when drawing the follower. 
//
// You can Link this to itself, but then Link will need to walk onto the follower image to 'collect' them. 
// Arg 'id' (D2) should be 0 to 9, for a total of 10 possible, unique followers in a quest.
// NOTE: You will need to use this same ID in arg D2 (id) for the LeaveFollower ffc script, as a PAIR.
ffc script Follower
{
	int data[128];
	void run(int sfx, int msg, int id)
	{
		this->Data = CMB_INVISIBLE;
		ffc f = Screen->LoadFFC(this->Link);
		
		//Follower delivered, so clear the linked ffc data.
		if ((Screen->D[FOLLOWER_REGISTER]&FOLLOWER_DELIVERED))
		{ 
			f->Data = 0; 
			if ( FOLLOWER_SOLIDITY_LAYER ) SetLayerComboD(FOLLOWER_SOLIDITY_LAYER, ComboAt(f->X, f->Y), 0); //Clear the solid combo under the npc follower graphic.
			Quit(); 
		}
		while(1)
		{
			if ( Collision(this) )
			{
				if ( !(Screen->D[FOLLOWER_REGISTER]&FOLLOWER_DELIVERED) )
				{
					if ( !Follower.data[FOLLOWER_CURRENT_ID] )
					{
						Follower.data[FOLLOWER_CUR_RESCUED] = 2;
						Game->PlaySound(sfx);
						Follower.data[FOLLOWER_BASE_TILE] = Game->ComboTile(f->Data)-4;
						Follower.data[FOLLOWER_CSET] = f->CSet;
						
						Follower.data[FOLLOWER_ID_1_TILE+id] = Game->ComboTile(f->Data)-4;
						Follower.data[FOLLOWER_ID_1_CSET+id] = f->CSet;
						Follower.data[FOLLOWER_CURRENT_ID] = id+1;
						Follower.data[FOLLOWER_CUR_SRC_DMAP] = Game->GetCurDMap();
						Follower.data[FOLLOWER_CUR_SRC_SCRN] = Game->GetCurScreen();

						if ( msg ) Screen->Message(msg);
						if ( FOLLOWER_SOLIDITY_LAYER ) SetLayerComboD(FOLLOWER_SOLIDITY_LAYER, ComboAt(f->X, f->Y), 0); //Clear the solid combo under the npc follower graphic.
					}
				}
			} //end collision check
			if ( Follower.data[FOLLOWER_ACTIVE] > 15 )
			{
				if ( Follower.data[FOLLOWER_CURRENT_ID] == id+1 ) 
				{
					f->Data = 0;
				}
			}
			if ( Link->Action == LA_SCROLLING ) Follower.data[FOLLOWER_ACTIVE] = 16; //Immediately jump on scroll. 
			
			Waitframe();
		}
	}
	void wait(int num, int x, int y, int til, int cset, bool noaction)
	{
		for (; num >= 0; --num)
		{
			Screen->FastTile(2, x, y, til, cset, 128 );
			if ( noaction ) { NoAction(); } //NoPress(true); NoInput(true); }
			Waitframe();
		}
	}
	//Returns true if the player is holding, or pressed a directional key or button.
	bool pressedDPad()
	{
		//if ( Link->Pushing ) return false; //2.55 and above
		if ( Link->InputUp ) return true;
		if ( Link->InputDown ) return true;
		if ( Link->InputLeft ) return true;
		if ( Link->InputRight ) return true;
		if ( Link->PressUp ) return true;
		if ( Link->PressDown ) return true;
		if ( Link->PressLeft ) return true;
		if ( Link->PressRight ) return true;
		if ( Link->InputAxisUp ) return true;
		if ( Link->InputAxisDown ) return true;
		if ( Link->InputAxisLeft ) return true;
		if ( Link->InputAxisRight ) return true;
		if ( Link->PressAxisUp ) return true;
		if ( Link->PressAxisDown ) return true;
		if ( Link->PressAxisLeft ) return true;
		if ( Link->PressAxisRight ) return true;
		return false;
	}
	//Zelda follows in Link's path with an 8 frame delay before updating
	void draw() 
	{
		if ( !Follower.data[FOLLOWER_ACTIVE] ) return;
		if ( pressedDPad() )
		{
			++Follower.data[FOLLOWER_ACTIVE];
			if ( Follower.data[FOLLOWER_ACTIVE] > 100000 ) Follower.data[FOLLOWER_ACTIVE] = 8; //Don't roll over
		}

		if ( Link->Action == LA_GOTHURTLAND ) 
		{
			//if ( Link->HitDir == DIR_UP ) 
			//{
			//	Follower.data[FOLLOWER_Y12] = Link->Y - 32;
			//	Follower.data[FOLLOWER_ACTIVE] = 16;
			//}
			//if ( Link->HitDir == DIR_DOWN ) 
			//{
			//	Follower.data[FOLLOWER_Y12] = Link->Y + 32;
			//	Follower.data[FOLLOWER_ACTIVE] = 16;
			//}
			//if ( Link->HitDir == DIR_LEFT ) 
			//{
			//	Follower.data[FOLLOWER_X12] = Link->X + 32;
			//	Follower.data[FOLLOWER_ACTIVE] = 16;
			//}
			//if ( Link->HitDir == DIR_RIGHT ) 
			//{
			//	Follower.data[FOLLOWER_X12] = Link->X - 32;
			//	Follower.data[FOLLOWER_ACTIVE] = 16;
			//}
			return; //Don't update if Link was hurt and pushed back. 
		}

		if ( pressedDPad() )
		{
			++Follower.data[FOLLOWER_SUBFRAME];
			if ( Follower.data[FOLLOWER_SUBFRAME]&1 )
			{
				++Follower.data[FOLLOWER_FRAME];
				if ( Follower.data[FOLLOWER_FRAME] > FOLLOWER_MAX_FRAME ) Follower.data[FOLLOWER_FRAME] = 0; 
			}
			
			Follower.data[FOLLOWER_X] = Link->X;
			Follower.data[FOLLOWER_Y] = Link->Y;
			Follower.data[FOLLOWER_DIR] = Link->Dir;
			for ( int q = FOLLOWER_X12; q >= FOLLOWER_X; --q )
			{
				Follower.data[q] = Follower.data[q-1];
			}
			for ( int q = FOLLOWER_Y12; q >= FOLLOWER_Y; --q )
			{
				Follower.data[q] = Follower.data[q-1];
			}
			for ( int q = FOLLOWER_DIR12; q >= FOLLOWER_DIR; --q )
			{
				Follower.data[q] = Follower.data[q-1];
			}
		
		}
		if ( Follower.data[FOLLOWER_ACTIVE] < 16 ) return; //Wait 8 frames to begin.
		//Draw tiles
		int the_tile;
		 
		the_tile = Follower.data[FOLLOWER_BASE_TILE] + (Follower.data[FOLLOWER_DIR12]*4) + Follower.data[FOLLOWER_FRAME];
		//Based on X, Y, Dir and Frame
		Screen->FastTile(2, Follower.data[FOLLOWER_X12], Follower.data[FOLLOWER_Y12], 
					the_tile, Follower.data[FOLLOWER_CSET], 128 );
		
		
		//...then Update the frame
		
	}
	
	
	//Called to initialise the follower. 
	void rescue(int follower_midi, int dur)
	{
		if ( Follower.data[FOLLOWER_CUR_RESCUED] < 2 ) return;
		
		--Follower.data[FOLLOWER_CUR_RESCUED];
		if ( !dur ) dur = FOLLOWER_ZELDA_MIDI_DURATION;
		if ( !follower_midi ) follower_midi = FOLLOWER_ZELDA_MIDI; 
		Follower.data[FOLLOWER_ACTIVE] = 1;
		if ( Follower.data[FOLLOWER_MIDI_TIMER] == -1 )
		{
			
			Follower.data[FOLLOWER_ORIG_MIDI] = Game->DMapMIDI[Game->GetCurDMap()];
			Follower.data[FOLLOWER_MIDI_TIMER] = dur;
			Game->PlayMIDI(follower_midi);
		}
		else
		{
			--Follower.data[FOLLOWER_MIDI_TIMER];
			if ( Follower.data[FOLLOWER_MIDI_TIMER] < 1 ) 
			{
				Game->PlayMIDI(Follower.data[FOLLOWER_ORIG_MIDI]);
				Follower.data[FOLLOWER_MIDI_TIMER] = 0;
			}
		}

	}	

	// Clears the follower positions if Link dies, if the playe presses F6, and so forth. 
	// Called in active, continue, and exit scripts. 
	// Use in Link's Init script if using 2.55. 
	void clear()
	{
		for ( int q = FOLLOWER_X; q <= FOLLOWER_X20; ++q )
		{ 
			Follower.data[q] = Link->X;
		}
		for ( int q = FOLLOWER_Y; q <= FOLLOWER_Y20; ++q )
		{ 
			Follower.data[q] = Link->Y;
		}
		for ( int q = FOLLOWER_DIR; q <= FOLLOWER_DIR20; ++q )
		{ 
			Follower.data[q] = Link->Dir;
		}
	}

	// Called in the active script during scrolling to prevent the follower from drawing at the wrong position. 
	void scroll()
	{
		if ( Link->Action != LA_SCROLLING ) return;
		for ( int q = FOLLOWER_X; q <= FOLLOWER_X20; ++q )
		{ 
			Follower.data[q] = Link->X;
		}
		for ( int q = FOLLOWER_Y; q <= FOLLOWER_Y20; ++q )
		{ 
			Follower.data[q] = Link->Y;
		}
		for ( int q = FOLLOWER_DIR; q <= FOLLOWER_DIR20; ++q )
		{ 
			Follower.data[q] = Link->Dir;
		}
	}
}


//Place on the screen where Link is to leave the follower, at the position to which you want the 
//follower to move toward, and stop, on the screen.
//Set this to run on screen init.
ffc script LeaveFollower
{
	void run(int msg, int itm, int id)
	{
		this->Data = CMB_INVISIBLE;
		
		int the_tile;
		
		if ( (Screen->D[FOLLOWER_REGISTER] & FOLLOWER_DELIVERED) )
		{
			//Clear the solid combo under the npc follower graphic.
			if ( FOLLOWER_SOLIDITY_LAYER ) SetLayerComboD(FOLLOWER_SOLIDITY_LAYER, ComboAt(this->X, this->Y), FOLLOWER_CMB_BLANK_SOLID);
			while(1)
			{
				Follower.wait(2,this->X,this->Y,Follower.data[FOLLOWER_ID_1_TILE+id]+4, Follower.data[FOLLOWER_ID_1_CSET+id],false);
			}
		}
		
		while (1) 
		{
			if ( Follower.data[FOLLOWER_CURRENT_ID] == id+1 )
			{
				//Follower.data[FOLLOWER_ANIMATING] = 1;
				//Move to the target.
				for( int q = Screen->NumNPCs(); q > 0; --q )
				{
					npc n = Screen->LoadNPC(q); n->Stun = 10;
				}
				for ( int q = Screen->NumEWeapons(); q > 0; --q )
				{
					eweapon e = Screen->LoadEWeapon(q);
					e->HitYOffset = 32768;
					e->DeadState = WDS_DEAD;
				}
				if ( Follower.data[FOLLOWER_X12] < this->X ) { ++Follower.data[FOLLOWER_X12]; Follower.data[FOLLOWER_DIR12] = DIR_RIGHT; }
				if ( Follower.data[FOLLOWER_X12] > this->X ) { --Follower.data[FOLLOWER_X12]; Follower.data[FOLLOWER_DIR12] = DIR_LEFT; }
				
				if ( Follower.data[FOLLOWER_Y12] < this->Y ) { ++Follower.data[FOLLOWER_Y12]; Follower.data[FOLLOWER_DIR12] = DIR_DOWN; }
				if ( Follower.data[FOLLOWER_Y12] > this->Y ) { --Follower.data[FOLLOWER_Y12]; Follower.data[FOLLOWER_DIR12] = DIR_UP; }
			
				++Follower.data[FOLLOWER_FRAME];
				if ( Follower.data[FOLLOWER_FRAME] > FOLLOWER_MAX_FRAME ) Follower.data[FOLLOWER_FRAME] = 0;
				the_tile = Follower.data[FOLLOWER_BASE_TILE] + (Follower.data[FOLLOWER_DIR12]*4) + Follower.data[FOLLOWER_FRAME];
				//If the follower is aligned, set its final properties.
				if ( Follower.data[FOLLOWER_X12] == this->X )
				{
					if ( Follower.data[FOLLOWER_Y12] == this->Y ) 
					{ 
						Follower.data[FOLLOWER_DIR12] = DIR_DOWN; 
						Follower.data[FOLLOWER_FRAME] = 0; 
					}
				}
				if ( !(Screen->D[FOLLOWER_REGISTER]&FOLLOWER_DELIVERED)) Follower.wait(2,Follower.data[FOLLOWER_X12],Follower.data[FOLLOWER_Y12],the_tile, Follower.data[FOLLOWER_CSET],true);
				else Follower.wait(2,Follower.data[FOLLOWER_X12],Follower.data[FOLLOWER_Y12],the_tile, Follower.data[FOLLOWER_CSET],false);
				if ( Follower.data[FOLLOWER_X12] == this->X )
				{
					if ( Follower.data[FOLLOWER_Y12] == this->Y )
					{
						Trace(Follower.data[FOLLOWER_CUR_SRC_DMAP]);
						Trace(Follower.data[FOLLOWER_CUR_SRC_SCRN]);
						int src_d = Game->GetDMapScreenD(Follower.data[FOLLOWER_CUR_SRC_DMAP], Follower.data[FOLLOWER_CUR_SRC_SCRN], FOLLOWER_REGISTER);
						Trace(src_d);
						src_d |= FOLLOWER_DELIVERED;
						Trace(src_d);
						Game->SetDMapScreenD(Follower.data[FOLLOWER_CUR_SRC_DMAP], Follower.data[FOLLOWER_CUR_SRC_SCRN], FOLLOWER_REGISTER, src_d);
							
						if ( Follower.data[FOLLOWER_ACTIVE] ) 
						{
							Follower.data[FOLLOWER_ACTIVE] = 0; 
							Screen->D[FOLLOWER_REGISTER] |= FOLLOWER_DELIVERED;
							Follower.data[FOLLOWER_CURRENT_ID] = 0;
							
							//Set the flags on its source screen, too.
							
						}
						if ( msg )
						{
							if ( !(Screen->D[FOLLOWER_REGISTER]&FOLLOWER_SHOWED_MESSAGE) )
							{
								Screen->D[FOLLOWER_REGISTER] |= FOLLOWER_SHOWED_MESSAGE;
								Screen->Message(msg);
							}
						}
						if ( itm ) 
						{
							if ( !(Screen->D[FOLLOWER_REGISTER]&FOLLOWER_GAVE_ITEM) )
							{
								Screen->D[FOLLOWER_REGISTER] |= FOLLOWER_GAVE_ITEM;
								item giveit = Screen->CreateItem(itm);
								giveit->X = Link->X;
								giveit->Y = Link->Y;
								giveit->Pickup = IP_HOLDUP;
							
							}
						}
						if ( FOLLOWER_SOLIDITY_LAYER ) SetLayerComboD(FOLLOWER_SOLIDITY_LAYER, ComboAt(this->X, this->Y), FOLLOWER_CMB_BLANK_SOLID); //Set the solid combo under the npc follower graphic.
						while(1) Follower.wait(2,this->X,this->Y,Follower.data[FOLLOWER_ID_1_TILE+id]+4, Follower.data[FOLLOWER_ID_1_CSET+id],false);
					}
				}
			}
			else Waitframe();
		
		}
	
	}
}	

//Example global script.
global script FollowerActive
{
	void run()
	{
		Follower.clear();
		while(1)
		{
			//if ( Follower.data[FOLLOWER_ANIMATING] ) { Trace(1); NoAction(); }
			Follower.rescue(FOLLOWER_ZELDA_MIDI, FOLLOWER_ZELDA_MIDI_DURATION);
			Follower.draw();
			Follower.scroll();
			Waitdraw();
			Waitframe();
		}
	}
}





global script FollowerResume
{
	void run()
	{
		Follower.clear();
	}
}

global script Init
{
	void run()
	{
		Follower.data[0] = -1;
		Follower.data[1] = -1;
	}
}