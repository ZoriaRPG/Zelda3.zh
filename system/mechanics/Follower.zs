/////////////////////////////
/// Zelda 3 Follower      ///
/// v0.2                  ///
/// 10th April, 2019      ///
/// By: ZoriaRPG          ///
/// Made for: JudasRising ///
/////////////////////////////
// v0.1 : Initial
// v0.2 : Changed hardcoded > 3 frame cap to use FOLLOWER_MAX_FRAME in drawing loops.
// v0.3 : Fix scrolling positions and positions onContinue

int Follower[128] = {-1, -1};

const int FOLLOWER_ZELDA_MIDI_DURATION = 300;
const int FOLLOWER_ZELDA_MIDI = 1;
const int FOLLOWER_MAX_FRAME = 3; //4-frame walking animation
const int FOLLOWER_BASE_TILE = 8600; //An octorock
const int FOLLOWER_CSET = 2; //Blue

const int FOLLOWER_MIDI_TIMER 	= 0;
const int FOLLOWER_RESCUED 	= 1;
const int FOLLOWER_ACTIVE 	= 2;
const int FOLLOWER_UPDATE 	= 3;
const int FOLLOWER_FRAME 	= 4;
const int FOLLOWER_SUBFRAME 	= 5;

const int FOLLOWER_ORIG_MIDI 	= 6;

void FollowerContinue()
{
	for ( int q = FOLLOWER_X; q <= FOLLOWER_X20; ++q )
	{ 
		Follower[q] = Link->X;
	}
	for ( int q = FOLLOWER_Y; q <= FOLLOWER_Y20; ++q )
	{ 
		Follower[q] = Link->Y;
	}
	for ( int q = FOLLOWER_DIR; q <= FOLLOWER_DIR20; ++q )
	{ 
		Follower[q] = Link->Dir;
	}
}

void FollowerScroll()
{
	if ( Link->Action != LA_SCROLLING ) return;
	for ( int q = FOLLOWER_X; q <= FOLLOWER_X20; ++q )
	{ 
		Follower[q] = Link->X;
	}
	for ( int q = FOLLOWER_Y; q <= FOLLOWER_Y20; ++q )
	{ 
		Follower[q] = Link->Y;
	}
	for ( int q = FOLLOWER_DIR; q <= FOLLOWER_DIR20; ++q )
	{ 
		Follower[q] = Link->Dir;
	}
}

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
const int FOLLOWER_X12		= 23;
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
const int FOLLOWER_Y12		= 52;
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
const int FOLLOWER_DIR12 	= 82;
const int FOLLOWER_DIR13 	= 83;
const int FOLLOWER_DIR14 	= 84;
const int FOLLOWER_DIR15 	= 85;
const int FOLLOWER_DIR16 	= 86;
const int FOLLOWER_DIR17 	= 87;
const int FOLLOWER_DIR18 	= 88;
const int FOLLOWER_DIR19 	= 89;
const int FOLLOWER_DIR20 	= 90;

ffc script GetZelda
{
	void run(int sfx)
	{
		ffc f = Screen->LoadFFC(this->Link);
		while(1)
		{
			if ( Collision(this) && Follower[FOLLOWER_RESCUED] < 0)
			{
				//f->Data = 0; 
				Follower[FOLLOWER_RESCUED] = 2;
				Game->PlaySound(sfx);
				
				//break;//Quit();
			}
			if ( Follower[FOLLOWER_ACTIVE] > 15 ) 
			{
				f->Data = 0;
			}
			Waitframe();
		}
	}
}

global script the_follower
{
	void run()
	{
		FollowerContinue();
		while(1)
		{
			RescueZelda(FOLLOWER_ZELDA_MIDI, FOLLOWER_ZELDA_MIDI_DURATION);
			DrawFollower();
			FollowerScroll();
			Waitdraw();
			Waitframe();
		}
	}
}

void RescueZelda(int follower_midi, int dur)
{
	if ( Follower[FOLLOWER_RESCUED] < 2 ) return;
	
	--Follower[FOLLOWER_RESCUED];
	if ( !dur ) dur = FOLLOWER_ZELDA_MIDI_DURATION;
	if ( !follower_midi ) follower_midi = FOLLOWER_ZELDA_MIDI; 
	Follower[FOLLOWER_ACTIVE] = 1;
	if ( Follower[FOLLOWER_MIDI_TIMER] == -1 )
	{
		
		Follower[FOLLOWER_ORIG_MIDI] = Game->DMapMIDI[Game->GetCurDMap()];
		Follower[FOLLOWER_MIDI_TIMER] = dur;
		Game->PlayMIDI(follower_midi);
	}
	else
	{
		--Follower[FOLLOWER_MIDI_TIMER];
		if ( Follower[FOLLOWER_MIDI_TIMER] < 1 ) 
		{
			Game->PlayMIDI(Follower[FOLLOWER_ORIG_MIDI]);
			Follower[FOLLOWER_MIDI_TIMER] = 0;
		}
	}

}	

bool PressedDPad()
{
	if ( Link->InputUp ) return true;
	if ( Link->InputDown ) return true;
	if ( Link->InputLeft ) return true;
	if ( Link->InputRight ) return true;
	if ( Link->PressUp ) return true;
	if ( Link->PressDown ) return true;
	if ( Link->PressLeft ) return true;
	if ( Link->PressRight ) return true;
	return false;
}

//Zelda follows in Link's path with an 8 frame delay before updating
void DrawFollower() 
{
	if ( !Follower[FOLLOWER_ACTIVE] ) return;
	if ( PressedDPad() )
	{
		++Follower[FOLLOWER_ACTIVE];
		if ( Follower[FOLLOWER_ACTIVE] > 100000 ) Follower[FOLLOWER_ACTIVE] = 8; //Don't roll over
		
	}
	
	
		
	if ( Link->Action == LA_GOTHURTLAND ) return; //Don't update if Link was hurt and pushed back. 

	if ( PressedDPad() )
	{
		++Follower[FOLLOWER_SUBFRAME];
		if ( Follower[FOLLOWER_SUBFRAME]&1 )
		{
			++Follower[FOLLOWER_FRAME];
			if ( Follower[FOLLOWER_FRAME] > FOLLOWER_MAX_FRAME ) Follower[FOLLOWER_FRAME] = 0; 
		}
		
		Follower[FOLLOWER_X] = Link->X;
		Follower[FOLLOWER_Y] = Link->Y;
		Follower[FOLLOWER_DIR] = Link->Dir;
		for ( int q = FOLLOWER_X12; q >= FOLLOWER_X; --q )
		{
			Follower[q] = Follower[q-1];
		}
		for ( int q = FOLLOWER_Y12; q >= FOLLOWER_Y; --q )
		{
			Follower[q] = Follower[q-1];
		}
		for ( int q = FOLLOWER_DIR12; q >= FOLLOWER_DIR; --q )
		{
			Follower[q] = Follower[q-1];
		}
	
	}
	if ( Follower[FOLLOWER_ACTIVE] < 16 ) return; //Wait 8 frames to begin.
	//Draw tiles
	int the_tile;
	 
	the_tile = FOLLOWER_BASE_TILE + (Follower[FOLLOWER_DIR12]*4) + Follower[FOLLOWER_FRAME];
	//Based on X, Y, Dir and Frame
	Screen->FastTile(2, Follower[FOLLOWER_X12], Follower[FOLLOWER_Y12], 
				the_tile, FOLLOWER_CSET, 128 );
	
	
	//...then Update the frame
	
	
	
}

void LeaveZeldabehind(ffc follower)
{
	Follower[FOLLOWER_ACTIVE] = 0;
}

ffc script SanctuaryZelda
{
	void run()
	{
		this->Data = CMB_INVISIBLE;
		//bool matched = false;
		//if ( Follower[FOLLOWER_ACTIVE] ) this->Data = CMB_INVISIBLE;
		if ( Follower[FOLLOWER_ACTIVE] ) Follower[FOLLOWER_ACTIVE] = 0;
		//else ; 
		int the_tile;
		
		while ( 1 ) //Follower[FOLLOWER_X12] != this->X && Follower[FOLLOWER_Y12] != this->Y )
		{
			if ( Follower[FOLLOWER_X12] < this->X ) { ++Follower[FOLLOWER_X12]; Follower[FOLLOWER_DIR12] = DIR_RIGHT; }
			if ( Follower[FOLLOWER_X12] > this->X ) { --Follower[FOLLOWER_X12]; Follower[FOLLOWER_DIR12] = DIR_LEFT; }
			
			if ( Follower[FOLLOWER_Y12] < this->Y ) { ++Follower[FOLLOWER_Y12]; Follower[FOLLOWER_DIR12] = DIR_DOWN; }
			if ( Follower[FOLLOWER_Y12] > this->Y ) { --Follower[FOLLOWER_Y12]; Follower[FOLLOWER_DIR12] = DIR_UP; }
			++Follower[FOLLOWER_FRAME];
			if ( Follower[FOLLOWER_FRAME] > FOLLOWER_MAX_FRAME ) Follower[FOLLOWER_FRAME] = 0;
			the_tile = FOLLOWER_BASE_TILE + (Follower[FOLLOWER_DIR12]*4) + Follower[FOLLOWER_FRAME];
			if ( Follower[FOLLOWER_X12] == this->X && Follower[FOLLOWER_Y12] == this->Y ) { Follower[FOLLOWER_DIR12] = DIR_DOWN; Follower[FOLLOWER_FRAME] = 0; }
			WatiframesDrawZelda(2,Follower[FOLLOWER_X12],Follower[FOLLOWER_Y12],the_tile);
		}
		
	}
	void WatiframesDrawZelda(int num, int x, int y, int til)
	{
		for (; num >= 0; --num)
		{
			Screen->FastTile(2, x, y, til, FOLLOWER_CSET, 128 );
			Waitframe();
		}
	}
}

global script FollowerResume
{
	void run()
	{
		//int ss[]="Running onContinue";
		//TraceS(ss);
		FollowerContinue();
	}
}