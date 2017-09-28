/// A Basic Running Implementation
/// ZoriaRPG
/// v1.0
/// 28th September, 2017
/// Note: Adapted from the Link's Awakening Header Project 'Pieces of Power' fast walk functions. 

int RunningBoots[26]; //Array to hold the values for the Z4 items.
const int WALK_SPEED_POWERUP = 4; //Number of extra Pixels Link walks when he has a Piece of Power
const int POWER_WALK_TIMER = 24; //The timer for WalkSpeed().
const int WALK_TIME = 8; //Increase this value to slow the speed at which Link walks when sped up, 
			  //and to speed him up when slowed down.
			  
const int RUN_MP_COST = 4; //The MP cost of running, reduced every N frames, as defined above.//Call only one time, prior to Waitdraw().
const int RUN_COST_TIME = 12; //How many frames to wait between reductions in MP while running.  


const int RUN_COST_TIMER = 25; //Index for the timer that is used to reduce MP. 


const int GAME_FRAME = 0; //Index for storing the game frame. 


global script Music_ZH_Global_Active{
	void run(){
		InitRunningCode();
		while(true){
			DoGameFrameUpdate();
			DoRButtonRun();
			

			//WandSound(30);
			Waitdraw();
			Waitframe();
		}
	}
}

void DoRunCost(){
	if ( RunningBoots[RUN_COST_TIMER] == 0 ) {
		Link->MP -= RUN_MP_COST;
		RunningBoots[RUN_COST_TIMER] = RUN_COST_TIME;
		
	}
	if ( RunningBoots[RUN_COST_TIMER] > 0 ) {
		RunningBoots[RUN_COST_TIMER]--;
	}
}

int GetWalkSpeedPixels(){
	return Cond( (RunningBoots[GAME_FRAME] % 2 == 0 ), (WALK_SPEED_POWERUP * 1.5), WALK_SPEED_POWERUP);
}
		
void InitRunningCode(){ RunningBoots[POWER_WALK_TIMER] = WALK_TIME; RunningBoots[RUN_COST_TIMER]= 0; RunningBoots[GAME_FRAME] = 0; }

void DoGameFrameUpdate() { 
	if ( RunningBoots[GAME_FRAME] < 60 ) RunningBoots[GAME_FRAME]++;
	else RunningBoots[GAME_FRAME] = 0; 
}

int IsLinkJump(){
	return ( Link->Jump << 0 );//Floor Link->Jump to ensure that a value of 0.050 is '0'.
}

void DoRButtonRun(){
	int linkX;
	int linkY;
	if ( Link->InputR && Link->MP >= RUN_MP_COST ) { //Check to see if Link has enough MP
		
		if ( Link->Action == LA_HOLD1LAND ) return;
		if ( Link->Action == LA_WALKING && !IsLinkJump() && Link->Z == 0 ) { //If he isnt attacking, swimming, hurt, or casting, and h
			if ( Link->InputDown && !IsSideview() //If the player presses down, and we aren't in sideview mode...
				&& !Screen->isSolid(Link->X,Link->Y+17) //SW Check Solidity
				&& !Screen->isSolid(Link->X+7,Link->Y+17) //S Check Solidity
				&& !Screen->isSolid(Link->X+15,Link->Y+17) //SE Check Solidity
			) {
				//We use a timer to choke the walk speed. Without it, Link would move the full additional number of
				//pixels PER FRAME. THus, a walk speed bonus of +1 would be +60 pixels (almost four tiles) PER SECOND!
				if ( RunningBoots[POWER_WALK_TIMER] == WALK_TIME ) {  //If our timer is fresh, or has reset...
					Link->Y += GetWalkSpeedPixels(); //Let Link move faster...
					DoRunCost(); //Deduct the cost.
					RunningBoots[POWER_WALK_TIMER]--; //Decrement the timer, to start the ball rolling.
				}
				
			}
			else if ( Link->InputUp && !IsSideview()  //If the player presses up, and we aren't in sideview mode...
				&& !Screen->isSolid(Link->X,Link->Y+6) //NW Check Solidity
				&& !Screen->isSolid(Link->X+7,Link->Y+6) //N Check Solidity
				&& !Screen->isSolid(Link->X+15,Link->Y+6) //NE Check Solidity
			) {
				if ( RunningBoots[POWER_WALK_TIMER] == WALK_TIME ) { //If our timer is fresh, or has reset...
					Link->Y -= GetWalkSpeedPixels(); //Increase the distance the player moves down, by this constant.
					DoRunCost(); //Deduct the cost.
					RunningBoots[POWER_WALK_TIMER]--; //Decrement the timer, to start the ball rolling.
				}
			}
			else if ( Link->InputRight && !Screen->isSolid(Link->X+17,Link->Y+8) //If the player presses right, check NE solidity...
				&& !Screen->isSolid(Link->X+17,Link->Y+15) //and check SE Solidity 
			) { 
				if ( RunningBoots[POWER_WALK_TIMER] == WALK_TIME ) { //If our timer is fresh, or has reset...
					Link->X += GetWalkSpeedPixels(); //Increase the distance the player moves down, by this constant.
					DoRunCost(); //Deduct the cost.
					RunningBoots[POWER_WALK_TIMER]--; //Decrement the timer, to start the ball rolling.
				}
			}
			else if ( Link->InputLeft && !Screen->isSolid(Link->X-2,Link->Y+8)  //If the player presses right, check NW solidity...
				&& !Screen->isSolid(Link->X-2,Link->Y+15) //SW Check Solidity
			) {
				if ( RunningBoots[POWER_WALK_TIMER] == WALK_TIME ) { //If our timer is fresh, or has reset...
					Link->X -= GetWalkSpeedPixels(); //Increase the distance the player moves down, by this constant.
					DoRunCost(); //Deduct the cost.
					RunningBoots[POWER_WALK_TIMER]--; //Decrement the timer, to start the ball rolling.
				}

			}
		}
	}
	if ( RunningBoots[POWER_WALK_TIMER] > 0 && RunningBoots[POWER_WALK_TIMER] != WALK_TIME ) RunningBoots[POWER_WALK_TIMER]--; 
	//Decrement the timer if it is greater than zero, and not = to WALK_TIME.
	if ( RunningBoots[POWER_WALK_TIMER] <= 0 ) RunningBoots[POWER_WALK_TIMER] = WALK_TIME; //If it's back to zero, reset it.
}


