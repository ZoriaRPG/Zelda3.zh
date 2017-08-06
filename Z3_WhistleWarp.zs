///////////////////////////////////
/// Zelda 3 Whistle Warp Screen ///
/// v0.1 - 27-Nov-2016          ///
/// By: ZoriaRPG                ///
///////////////////////////////////

/// place ffcs on a screen, each with D0 set as its ID, D1 its dmap, D2 its screen, D3 its x dest, D4 its y dest


const int WARP_CURSOR_MOVE_SFX = = 75; 
const int WARP_CURSOR_SELECT_SFX = = 76; 
const int WARP_CURSOR_SELECT_SFX_DUR = 60; 
const int WARP_WHISTLE_WAVY_DUR = 100; 

ffc script WhistleWarpSelect{
	void run(){
		ffc f[32]; int q[4]; int ff[]="WhistleWarpSelect"; int ffd[]="WhistleWarpDest";
		int fff; int dests[32]; int cursor[256]; int ffcOfFirstDest; int ffcOfLastDest;
		int selection = 1; int last; int coordinates[8];
		
		for ( q[0] = 1; q[0] <= 32; q[0]++ ) {
			//load each ffc into a pointer
			f[ q[0] ] = Screen->LoadFFC(q[0]);
			fff = Game->GetFFCScript(ffd); 
			if ( f[ q[0] ]->Script == fff ) { //it is a selection 
				cursor[ q[0] ] = f[ q[0] ]->InitD[0]; 
				if ( !ffcOfFirstDest ) ffcOfFirstDest = q[0];
				ffcOfLastDest = q[0];
				if ( f[ q[0] ]->InitD[0] > last ) last = f[ q[0] ]->InitD[0]; //Store the highest destination ID for wrapping. 
			}
			//if ( f[ q[0] ]->Script != fff ) ffcOfLastDest = last 
		}
		//Set the initial position. 
		this->X = f[ffcOfFirstDest]->X; this->Y = f[ffcOfFirstDest]->Y;
		Link->Invisible = true; //We need to tie this into IsInvisible()
		Waitframes(2); //Wait for other ffcs to set their values. 
		while(true){
			//This->Datais the selection cursor
			
			if ( Link->PressRight ) { 
				Link->PressRight = false; 
				if ( WARP_CURSOR_MOVE_SFX ) Game->PlaySound(WARP_CURSOR_MOVE_SFX);
				if ( selection < last ) {
					//Find the next dest.
					for ( q[1] = 1; q[1] <= 32; q[1]++ ){
						if ( cursor[ q[1] ] == selection += 1 ) {
							selection++;
							this->X = f[ q[1] ]->X; this->Y = f[ q[1] ]->Y;
							//clear all non-selected ffcs of any special iconography
							for ( q[2] = 1; q[2] <= 32; q[2]++ ) {
								f[ q[2] ]->Data = f[ q[2] ]->misc[0];
							}
							f[selection]->Data++; //Give it a flashing indicator. 
						}
					}
				}
				else { //wrap to 1
					for ( q[1] = 1; q[1] <= 32; q[1]++ ){
						if ( f[ q[1] ]->InitD[0] == 1 ) {
							selection = 1;
							this->X = f[ q[1] ]->X; this->Y = f[ q[1] ]->Y;
							//clear all non-selected ffcs of any special iconography
							for ( q[2] = 1; q[2] <= 32; q[2]++ ) {
								f[ q[2] ]->Data = f[ q[2] ]->misc[0];
							}
							f[selection]->Data++; //Give it a flashing indicator. 
						}
					}
				}
			}
			
			
			if ( Link->PressUp ) { 
				Link->PressUp = false; 
				if ( WARP_CURSOR_MOVE_SFX ) Game->PlaySound(WARP_CURSOR_MOVE_SFX);
				if ( selection < last ) {
					//Find the next dest.
					for ( q[1] = 1; q[1] <= 32; q[1]++ ){
						if ( cursor[ q[1] ] == selection += 1 ) {
							selection++;
							this->X = f[ q[1] ]->X; this->Y = f[ q[1] ]->Y;
							//clear all non-selected ffcs of any special iconography
							for ( q[2] = 1; q[2] <= 32; q[2]++ ) {
								f[ q[2] ]->Data = f[ q[2] ]->misc[0];
							}
							f[selection]->Data++; //Give it a flashing indicator. 
						}
					}
				}
				else { //wrap to 1
					for ( q[1] = 1; q[1] <= 32; q[1]++ ){
						if ( f[ q[1] ]->InitD[0] == 1 ) {
							selection = 1;
							this->X = f[ q[1] ]->X; this->Y = f[ q[1] ]->Y;
							//clear all non-selected ffcs of any special iconography
							for ( q[2] = 1; q[2] <= 32; q[2]++ ) {
								f[ q[2] ]->Data = f[ q[2] ]->misc[0];
							}
							f[selection]->Data++; //Give it a flashing indicator. 
						}
					}
				}
			}
			
			if ( Link->PressLeft ) { 
				Link->PressLeft = false; 
				if ( WARP_CURSOR_MOVE_SFX ) Game->PlaySound(WARP_CURSOR_MOVE_SFX);
				if ( selection > 1 ) {
					//Find the prior dest.
					for ( q[1] = 1; q[1] <= 32; q[1]++ ){
						if ( cursor[ q[1] ] == selection -= 1 ) {
							selection--;
							this->X = f[ q[1] ]->X; this->Y = f[ q[1] ]->Y;
							//clear all non-selected ffcs of any special iconography
							for ( q[2] = 1; q[2] <= 32; q[2]++ ) {
								f[ q[2] ]->Data = f[ q[2] ]->misc[0];
							}
							f[selection]->Data++; //Give it a flashing indicator. 
						}
					}
				}
				else { //wrap to last
					for ( q[1] = 1; q[1] <= 32; q[1]++ ){
						if ( f[ q[1] ]->InitD[0] == last ) {
							selection = last;
							this->X = f[ q[1] ]->X; this->Y = f[ q[1] ]->Y;
							//clear all non-selected ffcs of any special iconography
							for ( q[2] = 1; q[2] <= 32; q[2]++ ) {
								f[ q[2] ]->Data = f[ q[2] ]->misc[0];
							}
							f[selection]->Data++; //Give it a flashing indicator. 
						}
					}
				}
			}
			
			if ( Link->PressDown ) { 
				Link->PressDown = false; 
				if ( WARP_CURSOR_MOVE_SFX ) Game->PlaySound(WARP_CURSOR_MOVE_SFX);
				if ( selection > 1 ) {
					//Find the prior dest.
					for ( q[1] = 1; q[1] <= 32; q[1]++ ){
						if ( cursor[ q[1] ] == selection -= 1 ) {
							selection--;
							this->X = f[ q[1] ]->X; this->Y = f[ q[1] ]->Y;
							//clear all non-selected ffcs of any special iconography
							for ( q[2] = 1; q[2] <= 32; q[2]++ ) {
								f[ q[2] ]->Data = f[ q[2] ]->misc[0];
							}
							f[selection]->Data++; //Give it a flashing indicator. 
						}
					}
				}
				else { //wrap to last
					for ( q[1] = 1; q[1] <= 32; q[1]++ ){
						if ( f[ q[1] ]->InitD[0] == last ) {
							selection = last;
							this->X = f[ q[1] ]->X; this->Y = f[ q[1] ]->Y;
							//clear all non-selected ffcs of any special iconography
							for ( q[2] = 1; q[2] <= 32; q[2]++ ) {
								f[ q[2] ]->Data = f[ q[2] ]->misc[0];
							}
							f[selection]->Data++; //Give it a flashing indicator. 
						}
					}
				}
			}
			
			if ( Link->PressA || Link->PressB ) { //Warp
				if ( WARP_CURSOR_SELECT_SFX ) Game->PlaySound(WARP_CURSOR_SELECT_SFX);
				if ( WARP_CURSOR_SELECT_SFX_DUR ) { 
					for ( q[2] = 0; q[2] < WARP_CURSOR_SELECT_SFX_DUR; q[2]++ ) WaitNoAction();
					for ( q[3] = 0; q[3] < 8; q[3]++ ) coordinates[q] = f[selection]->InitD[q];
					break;

			}
			
			if ( Link->PressEx1 ) {} //Cancel
			//Move this->X/Y to each position in sequence. 
			Waitframe();
		}
		Link->X = coordinates[3]; Link->Y = coordinates[4];
		Screen->Wavy = WARP_WHISTLE_WAVY_DUR;
		Link->Invisible = false; //Again, tie int IsInvisible()
		Link->PitWarp(coordinates[1], coordinates[2]);
	}
}

ffc script WhistleWarpDest{
	void run(int dest_number, int dmap, int screen, int destX, int destY){
		this->Misc[0] = this->Data;
		while(true) Waitframe();
	}
}
		