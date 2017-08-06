//Scripted Hookshot

const int LW_HOOKSHOT2 = 31; //Script type
const int CHAIN_DELAY = 10; //10 frames. 
const int DRAG_LINK_DELAY = 10; 
ffc script Hookshot{
	void run(int length){
		int q[8];
			lweapon l;
			int cmb; int startx; int starty; int linktimer = DRAG_LINK_DELAY;
		startx = Link->X;
			starty = Link->Y;
		int chaintimer = CHAIN_DELAY;
		
		l = Screen->CreateLWeapon(LW_HOOKSHOT2);
		l->X = Link->X; l->Y = Link->Y; //We will need to adjust these to be in front of Link, later.
		while(true){
			
			//Facing up
			
			for ( q[0] = 0; [0] < length*16; q[0]++ ){
				
				l->Dir = Link->Dir;
				//flips
				l->Step = 160; //We want it to move 4 tile s per second, or something like that
				l->Y--;
				if ( ( starty - l->Y ) % 8 ) {
					for ( q[1] = starty; q[1] > l->X+8; q[1] -= 8 ){
						if ( chaintimer > 0 ) chaintimer--;
						if ( chaintimer <= 0 ) {
							//Draw chain tiles
						}
						
					}
				}
				if ( l->Y <= 1 || ComboFI(ComboAt(l->X, l->Y), Screen->ComboT[ComboAt(l->X+8, l->Y+8) == CT_HOOKSHOTGRAB ){
					//stop drawing more tiles by stopping the momentum
					l->Step = 0;
					//Drag link to the target.
					while ( Link->Y < l->Y ) { 
					//if ( Link->Y < l->Y ) {
						NoAction(); //We'll want to allow chaning his direction, and firing a second hookshot inthe future. 
						if ( linktimer > 0 ) linktimer--;
						if ( linktimer <= 0 ) Link->Y--;
						//Draw chainsegments between Link and the hookshot head.
						for ( q[2] = Link->Y; q[2] < l->Y; q[2] += 8 ) {
							//Draw chain tile
						}
						Waitframe();
					}
					
				}
			}
			Waitframe(); 
		}
	}
				