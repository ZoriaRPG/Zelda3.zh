const int I_POTION3 = 0;
const int I_POTION4 = 0;

//Pickup Script for potion stacking. Might not work in standard shoppes. 
//D0: Level of this potion.

item script PotionStackingFix{
	void run(int potionLevel){
		if ( !potionLevel) potionLevel = 1;
		if ( Link->Item[I_POTION4] ) Quit();
		if ( !Link->Item[I_POTION4] && Link->Item[I_POTION3] ) {
			Link->Item[I_POTION1] = true;
			Link->Item[I_POTION2] = true;
			Link->Item[I_POTION3] = true;
			Link->Item[I_POTION4] = true;
		}
		if ( !Link->Item[I_POTION4] && !Link->Item[I_POTION3] && Link->Item[I_POTION2] ) {
			if ( potionLevel == 1 ) {
				Link->Item[I_POTION1] = true;
				Link->Item[I_POTION2] = true;
				Link->Item[I_POTION3] = true;
			}
			if ( potionLevel > 1 ) {
				Link->Item[I_POTION1] = true;
				Link->Item[I_POTION2] = true;
				Link->Item[I_POTION3] = true;
				Link->Item[I_POTION4] = true;
			}
		}
		if ( !Link->Item[I_POTION4] && !Link->Item[I_POTION3] && !Link->Item[I_POTION2] ) {
			
			
			if ( potionLevel == 1 ) {
				if ( !Link->Item[I_POTION1] ) Link->Item[I_POTION1] = true;
				else Link->Item[I_POTION2] = true;
			}
			if ( potionLevel == 2 ) {
				if ( !Link->Item[I_POTION1] ) { 
					Link->Item[I_POTION1] = true;
					Link->Item[I_POTION2] = true;
				}
				else {
					Link->Item[I_POTION2] = true;
					Link->Item[I_POTION3] = true;
				}
			}
			if ( potionLevel == 3 ) {
				if ( !Link->Item[I_POTION1] ) { 
					Link->Item[I_POTION1] = true;
					Link->Item[I_POTION2] = true;
					Link->Item[I_POTION3] = true;
				}
				else {
					Link->Item[I_POTION2] = true;
					Link->Item[I_POTION3] = true;
					Link->Item[I_POTION4] = true;
				}
			}
			if ( potionlevel == 4 ) {
					Link->Item[I_POTION1] = true;
					Link->Item[I_POTION2] = true;
					Link->Item[I_POTION3] = true;
					Link->Item[I_POTION4] = true;
			}
		}
	}
}