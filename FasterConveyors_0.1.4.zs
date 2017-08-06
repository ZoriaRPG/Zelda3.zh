/////////////////////////////
/// Faster Conveyor Belts ///
/// v0.1.5                ///
/// 15-Nov-2016           ///
/// By: ZoriaRPG          ///
/////////////////////////////////////////////////////////////////////////////////
/// Purpose: This allows creating conveyor belts that move *Link* faster than ///
/// the stock ZC conveyors.                                                   ///
///                                                                           ///
/// Future versions may support bombs, items, somaria blocks, and npcs.       ///
/// I have *no plans* to add, or support creating *slower* conveyors with     ///
/// this header.                                                              ///
/////////////////////////////////////////////////////////////////////////////////

//FFC Version

//Flags for ffcs. Using these alternative ffcs permits you to have both normal, and fast conveyors on the same screen
//without usin the global script. 
const int FFC_FLAG_I_FAST_CONVEY = 100; //The Inherent Flag to use on conveyor combos for use with ffc script FasterConveyorsInhFlagged.
					//Default: SCRIPT_3
const int FFC_FLAG_FAST_CONVEY = 99; //The Placed Flag to use on conveyor combos on the screen with ffc script FasterConveyorsManFlagged.
					// Default: SCRIPT_2. 

ffc script FasterConveyors{
	void run(int speed, int step){
		int timer = speed; 
		while(true){
			if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVLEFT ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_LEFT, step, false) ) { 
					Link->X--;
					timer = speed;
				}
			}
			else if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVRIGHT ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_RIGHT, step, false) ) { 
					Link->X++;
					timer = speed;
				}
			}
			if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVUP ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_UP, step, false)  ) { 
					Link->Y--;
					timer = speed;
				}
			}
			else if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVDOWN ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_DOWN, step, false) ) { 
					Link->Y++;
					timer = speed;
				}
			}
			else timer = speed;
			Waitframe();
		}
	}
}




//As ffc above, except this only works with conveyor combos that ALSO have an INHERENT flag of FFC_FLAG_I_FAST_CONVEY.
ffc script FasterConveyorsInhFlagged{
	void run(int speed, int step){
		int timer = speed; 
		while(true){
			if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVLEFT && Screen->ComboI[ ComboAt(Link->X+8, Link->Y+8) ] == FFC_FLAG_I_FAST_CONVEY ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_LEFT, step, false) ) { 
					Link->X--;
					timer = speed;
				}
			}
			else if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVRIGHT && Screen->ComboI[ ComboAt(Link->X+8, Link->Y+8) ] == FFC_FLAG_I_FAST_CONVEY ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_RIGHT, step, false) ) { 
					Link->X++;
					timer = speed;
				}
			}
			if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVUP && Screen->ComboI[ ComboAt(Link->X+8, Link->Y+8) ] == FFC_FLAG_I_FAST_CONVEY ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_UP, step, false)  ) { 
					Link->Y--;
					timer = speed;
				}
			}
			else if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVDOWN && Screen->ComboI[ ComboAt(Link->X+8, Link->Y+8) ] == FFC_FLAG_I_FAST_CONVEY ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_DOWN, step, false) ) { 
					Link->Y++;
					timer = speed;
				}
			}
			else timer = speed;
			Waitframe();
		}
	}
}


//As ffc above, except this only works with conveyor combos that ALSO have a PLACED flag of FFC_FLAG_FAST_CONVEY.
ffc script FasterConveyorsManFlagged{
	void run(int speed, int step){
		int timer = speed; 
		while(true){
			if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVLEFT && Screen->ComboF[ ComboAt(Link->X+8, Link->Y+8) ] == FFC_FLAG_FAST_CONVEY ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_LEFT, step, false) ) { 
					Link->X--;
					timer = speed;
				}
			}
			else if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVRIGHT && Screen->ComboF[ ComboAt(Link->X+8, Link->Y+8) ] == FFC_FLAG_FAST_CONVEY ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_RIGHT, step, false) ) { 
					Link->X++;
					timer = speed;
				}
			}
			if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVUP && Screen->ComboF[ ComboAt(Link->X+8, Link->Y+8) ] == FFC_FLAG_FAST_CONVEY ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_UP, step, false)  ) { 
					Link->Y--;
					timer = speed;
				}
			}
			else if ( Screen->ComboT[ ComboAt(Link->X+8, Link->Y+8) ] == CT_CVDOWN && Screen->ComboF[ ComboAt(Link->X+8, Link->Y+8) ] == FFC_FLAG_FAST_CONVEY ) {
				if ( !timer ) timer = speed; 
				if ( timer > 1 ) timer--; 
				if ( timer <= 1 && CanWalk(Link->X+8, Link->Y+8, DIR_DOWN, step, false) ) { 
					Link->Y++;
					timer = speed;
				}
			}
			else timer = speed;
			Waitframe();
		}
	}
}

//Global Version

int ____GRAM[214747];

const int CONVEYOR_TIMER = 10020; //Index of ____GRAM.
const int FAST_CONVEY_SPEED = 15;
const int FAST_CONVEY_STEP = 1; 
const int CMB_FAST_CONVEY_RT = 1000; //Set to combo ID of Fast Conveyor (Right)
const int CMB_FAST_CONVEY_LF = 1001; //Set to combo ID of Fast Conveyor (Left)
const int CMB_FAST_CONVEY_UP = 1002; //Set to combo ID of Fast Conveyor (Up)
const int CMB_FAST_CONVEY_DN = 1003; //Set to combo ID of Fast Conveyor (Down)

//Call as FasterConveyors(FAST_CONVEY_SPEED, FAST_CONVEY_STEP, ____GRAM, CONVEYOR_TIMER);
void FasterConveyors(int speed, int step, int arr, int index){
	if ( Screen->ComboD[ ComboAt(Link->X+8, Link->Y+8) ] == CMB_FAST_CONVEY_LF ) {
		if ( !arr[index] ) arr[index] = speed; 
		if ( arr[index] > 1 ) arr[index]--; 
		if ( arr[index] == 1 && CanWalk(Link->X+8, Link->Y+8, DIR_LEFT, step, false) ) { 
			Link->X--;
			arr[index] = speed;
		}
	}
	else if ( Screen->ComboD[ ComboAt(Link->X+8, Link->Y+8) ] == CMB_FAST_CONVEY_RT ) {
		if ( !arr[index] ) arr[index] = speed; 
		if ( arr[index] > 1 ) arr[index]--; 
		if ( arr[index] == 1 && CanWalk(Link->X+8, Link->Y+8, DIR_RIGHT, step, false) ) { 
			Link->X++;
			arr[index] = speed;
		}
	}
	else if ( Screen->ComboD[ ComboAt(Link->X+8, Link->Y+8) ] == CMB_FAST_CONVEY_UP ) {
		if ( !arr[index] ) arr[index] = speed; 
		if ( arr[index] > 1 ) arr[index]--; 
		if ( arr[index] == 1 && CanWalk(Link->X+8, Link->Y+8, DIR_UP, step, false)  ) { 
			Link->Y--;
			arr[index] = speed;
		}
	}
	else if ( Screen->ComboD[ ComboAt(Link->X+8, Link->Y+8) ] == CMB_FAST_CONVEY_DN ) {
		if ( !arr[index] ) arr[index] = speed; 
		if ( arr[index] > 1 ) arr[index]--; 
		if ( arr[index] == 1 && CanWalk(Link->X+8, Link->Y+8, DIR_DOWN, step, false) ) { 
			Link->Y+++;
			arr[index] = speed;
		}
	}
	else arr[index] = speed;
}

global script convey{
	void run(){
		while(true){
			FasterConveyors(FAST_CONVEY_SPEED, FAST_CONVEY_STEP, ____GRAM, CONVEYOR_TIMER);
			Waitdraw();
			Waitframe();
		}
	}
}