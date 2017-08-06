/////////////////////////////////////
/// BlockHandling Library v0.4.4 ////////////////
/////////////////////////////////////////////////
/// Originally MovingBlocks.z from March 2015 ///
/// Updated 19-March-2015 for Testing/Sharing ///
/// Typo Correction 25-April-2015             ///
/////////////////////////////////////////////////
/// Expanded Version 26-April-2015            ///
/// Created & Maintained by: ZoriaRPG/TMGS    ///
/// (c) 2015 TMGS                             ///
/////////////////////////////////////////////////
/// Contributors/Testers:                     ///
/// MoscowModder                              ///
/////////////////////////////////////////////////

// This library contains code for creating block puzzles that allow the player to transport a block from one room to another.
// This works (in theory) by placing an FFC in the room with the originating block, and setting a direction in the ffc args.
// When the push block--which MUST be a specific combo sett in the constants-- touches this FFC, it vanishes...
// ...the transporter graphic, or whatever you use, changes into another tile, and the push flag is removed. 

// Then, in the direction you are sending the block, you will need a second FFC. 
// This one creates a block on the transporter, and you will need a genuine undercombo for this one.
// (I do not yet have a solution for that.)
// The second FFC--let's say you are mopving a block up a screen, and call it NORTHbound--detects if a block is in motion...
// ...by reading from the boolean rray BlockLoaded. If there is a block loaded NORTHbound, and the FFC is set (args) to NORTH ...
// ...then it will generate a 4-way push block on the position of the FFC (in theory, as the FFC uses a 'this' argument that I have not tested...
// ...that is now in this room, and sets the condition of BlockLoaded[NORTH] (in this example) back to false. The FFC then quits.

// This would allow for a multi-room puzzle, and you could technically extend this with multiple directional block-mover FFCs in any area...
// ...or string along one block--or whatever object--throughout a dungeon or area.

// The inspiration for this, is the cannonball mover in 'Twilight Princess'.

// Last, it's important to note that this depends on one global function, that reads for a specific combo, set as the constant CB_BLOCK_MOVE ...
// ...to automatically give it the flag CF_PUSH4WAY. You can integrate this into the FFCs, but I have this type of global function in a more general form...
// ...so I left it using this function. The MovingBlock() function, if used, should run *before* Waitdraw(); , as should any function that changes combos.
// I had planned to use the FFCs to run a state change, instead of making the object, once I tested them, ny automating the block creation with functions...
/// ...that run before waitdraw. The difference, is that the array size may need to be larger, to hold additional datum, and that the FFCs would run at...
// ...screen init, and change the state of combos in a room, if the player moves *in that direction8 after moving a block there, but that is harder to implement.

// Please note that this code is untested, and still in development. Feel free to modify and utilise it as you see fit. 

bool BlockLoaded[4]={}; //0 North, 1 East, 2 South, 3 West.

const int NORTH = 0;
const int EAST = 1;
const int SOUTH = 2;
const int WEST = 3;
	
const int CB_MOVING_BLOCK = 1100; //Set to combo of block to transform into 4-way.
const int CB_TRANSPORTER = 1101; //Set to transporter combo if you want to use a constant for this.
	
	
void MovingBlock(){
	for ( int i = 176; i > 0; i-- ){
		if ( Screen->ComboD[i] == CB_BLOCK_MOVE ){
			if ( Screen->ComboF[i] != CF_PUSH4WAY ) {
				Screen->ComboF[i] = CF_PUSH4WAY;
			}
		}
	}
}

ffc script movingBlock(int cmbNum){
	//FFC for movable block
}
	
	
ffc script makeBlock {
	void run(int directionalCondition){
		bool waiting = true;
		while(waiting){
			if ( directionalCondition == NORTH && BlockLoaded[NORTH] ) {
				Screen->ComboD[ComboAt(this->X, this->Y] = CB_MOVING_BLOCK;
				waiting = false;
			}
			else if ( directionalCondition == EAST && BlockLoaded[EAST] ) {
				Screen->ComboD[ComboAt(this->X, this->Y] = CB_MOVING_BLOCK;
				waiting = false;
			}
			else if ( directionalCondition == SOUTH && BlockLoaded[SOUTH] ) {
				Screen->ComboD[ComboAt(this->X, this->Y] = CB_MOVING_BLOCK;
				waiting = false;
			}
			else if ( directionalCondition == WEST && BlockLoaded[WEST] ) {
				Screen->ComboD[ComboAt(this->X, this->Y] = CB_MOVING_BLOCK;
				waiting = false;
			}
			Waitframe();
		}
		return;
	}
}

ffcScipt transportBlock(int transportDir, int underCombo){
	void run(){
		bool waiting = true;
		while(waiting){
			for ( int i = 176; i > 0; i-- ) {
				if ( Screen->ComboD[i] == CB_BLOCK_MOVE && ComboCollision(i, this) { //Requires stdCombos.zh
					BlockLoaded[transportDir] = true;
					if ( underCombo > 0 ) {
						ComboD[i] = underCombo; //Change to combo used for transporter graphics.
					}
					else {
						ComboD[i] = CB_TRANSPORTER; //Change to combo used for transporter graphics.
					}
					ComboF[i] = NONE;
					waiting = false;
				}
			}
			Waitframe();
		}
		return;
	}
}

ffc script transportBlock(int transportDir, int underCombo){ //V2
	void run(){
		bool waiting = true;
		int combo = ComboAt(this->X, this->Y);
		while(Screen->ComboD[combo] != CB_BLOCK_MOVE){
			Waitframe();
		}
  
		BlockLoaded[transportDir] = true;
		if ( underCombo > 0 ) {
			ComboD[i] = underCombo; //Change to combo used for transporter graphics.
		}
		else {
			ComboD[i] = CB_TRANSPORTER; //Change to combo used for transporter graphics.
		}
	}
} //Credit MM, for revised version removing for loop.
	
ffc script transportBlock(int transportDir, int underCombo){ //V3
	void run(){
		bool waiting = true;
		int i;
		while(waiting){
			i = ComboAt(this->X, this->Y);
			if  (Screen->ComboD[i] == CB_BLOCK_MOVE){
				waiting = false;
			}
			Waitframe();
		}
  
		BlockLoaded[transportDir] = true;
		if ( underCombo > 0 ) {
			ComboD[i] = underCombo; //Change to combo used for transporter graphics.
		}
		else {
			ComboD[i] = CB_TRANSPORTER; //Change to combo used for transporter graphics.
		}
	}
} //Credit MM, for revision (version 2)

//Make a block.

const int BYRNA_BLOCK = 0; //Set to ID of Bryna Block

void makeBlock(int type, int x, int y){
	ComboD[type] //Set XY coords
}

//!! How do I read a combo and set a combo relative to Link? FastCombo, OR Draw?!!//

//Global Stuff for Cane

bool byrnaBlock; //Reads true if there is a byrna block on the screen.

int StoreUndercombos[8]={}; //Store Undercombos for creeated blocks.
const int UNDCMB_UP = 0;
const int UNDCMB_DOWN = 1;
const int UNDCMB_LEFT = 2;
const int UNDCMB_RIGHT = 3;
const int UNDCMB_UP_OLD = 4;
const int UNDCMB_DOWN_OLD = 5;
const int UNDCMB_LEFT_OLD = 6;
const int UNDCMB_RIGHT_OLD = 7;		
void updateUndercombo(){
	if  ( Link->Dir = DIR_UP ) {
		currentUnderbombo[UNDCMB_UP] = ComboD[LinkY-16);
	}
	else if  ( Link->Dir = DIR_DOWN ) {
		currentUnderbombo[UNDCMB_DOWN] = ComboD[LinkY+16);
	}
	else if  ( Link->Dir = DIR_LEFT ) {
		currentUnderbombo[UNDCMB_LEFT] = ComboD[LinkX-16);
	}
	else if  ( Link->Dir = DIR_RIGHT ) {
		currentUnderbombo[UNDCMB_RIGHT] = ComboD[LinkX-+16);
	}
}

int byrnaBlocks[256]={}; //Array to store positions of Byrna Blocks and undercombos.

void byrnaBlock(){
		//Store the position of a byrna block each frame, and store the combos next to it.
}

void byrnaBlockUpdate(){
		//Check to see if the position of a byrna block moved. if so, draw the undercombo stored in the array where the block was...
		//Then update the undercombos again.
}

item script CaneOfSomaria{
	void run(){
		if ComboCollision(lw, CMB_BYRNABLOCK) { //If this LW touches a byrna block
			//Remove block.
			//Set old combo from array to that position.
			//Create fireball blast.
			C
			byrnaBlock = false; //Chear boolean.
		}
		else if (ComboCollision(lw, BYRNA_PLATFORM_SPOT) {
			//Enable platform. Thus should use magic, but do nothing else.
			//The FFC should take care of the rest, when the cane collides with it.
		}
		else {
			if  ( Link->Dir = DIR_UP ) { //Store undercombo beforfe making block
				currentUnderbombo[UNDCMB_UP] = ComboD[LinkY-16);
				ComboD[] //Make block.
			}
			else if  ( Link->Dir = DIR_DOWN ) {
				currentUnderbombo[UNDCMB_DOWN] = ComboD[LinkY+16);
			}
			else if  ( Link->Dir = DIR_LEFT ) {
				currentUnderbombo[UNDCMB_LEFT] = ComboD[LinkX-16);
			}
			else if  ( Link->Dir = DIR_RIGHT ) {
				currentUnderbombo[UNDCMB_RIGHT] = ComboD[LinkX-+16);
			}
		}
	}
}

ffc script byrnaPlatform
    // You can pair this with any walkable FFC you want, and it will act as a platform that
    // moves Link with it while he's standing on it, rather than the silly method of having
    // to walk in time with it. :D Should work with any speeds in any directions, even diagonal!
    // The D arguments aren't even needed. ^_^
{
    void run()
    {
        int StoredX;    // these variables hold the X,Y coordinates of the FFC one frame ago
        int StoredY;    //
	bool touched = false;
	
	while (!touched){
		if ( Collision(this, LW_SOMARIA){
			touched = true;
		}
		Waitframe();
	}
	    
        while(touched)
        {
            // compare the X,Y coordinates of the FFC with Link's at the START of its movement
            if(RectCollision(CenterLinkX(), (CenterLinkY() + 4), CenterLinkX(), (CenterLinkY() + 4), Floor(this->X), Floor(this->Y), (Floor(this->X) + this->EffectWidth), (Floor(this->Y) + this->EffectHeight)))
            {
                // if Link is standing on it, adjust his X,Y coordinates the same amount
                // as this FFC moved from the last frame to the next
                Link->X += (this->X - StoredX);
                Link->Y += (this->Y - StoredY);
            }
            // store the X,Y coordinates of the FFC at the END of its movement frame
            StoredX = Floor(this->X);
            StoredY = Floor(this->Y);

            Waitframe();    // we don't want to forget this! XD
        }
    }
}