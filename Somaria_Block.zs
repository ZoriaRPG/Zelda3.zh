//Somaria Blocks

const int CMB_SOMARIA = 1000;
const int TILE_SOMARIA = 10000;
const int SPRITE_SOMARIA = 100; 

const int SFX_SOMARIA_BEAMS = 63;

const int CMB_MOVING_COMARIA_D = 1001;  //4-way push
const int CMB_MOVING_SOMARIA_C = 0; //CSet
const int CMB_MOVING_SOMARIA_T = ;
const int CMB_MOVING_SOMARIA_S = 4;
const int CMB_MOVING_SOMARIA_F = ;
const int CMB_MOVING_SOMARIA_I = ;

const int SPRITE_SOMARIA_BEAM = 101; 

const int SOMARIA_BEAM_BASEPOWER = 8;


int Somaria[214747];
const int SOMARIA_NEWBLOCK_OLDCOMBO = 0;
const int SOMARIA_NEWBLOCK_OLDCOMBO_D = 1;
const int SOMARIA_NEWBLOCK_OLDCOMBO_T = 2;
const int SOMARIA_NEWBLOCK_OLDCOMBO_C = 3;
const int SOMARIA_NEWBLOCK_OLDCOMBO_S = 4;
const int SOMARIA_NEWBLOCK_OLDCOMBO_F = 5;
const int SOMARIA_NEWBLOCK_OLDCOMBO_I = 6;


const int SOMARIA_NEWBLOCK_NEWCOMBO = 7;
const int SOMARIA_NEWBLOCK_NEWCOMBO_D = 8;
const int SOMARIA_NEWBLOCK_NEWCOMBO_T = 9;
const int SOMARIA_NEWBLOCK_NEWCOMBO_C = 10;
const int SOMARIA_NEWBLOCK_NEWCOMBO_S = 11;
const int SOMARIA_NEWBLOCK_NEWCOMBO_F = 12;
const int SOMARIA_NEWBLOCK_NEWCOMBO_I = 13;

const int SOMARIA_BLOCK_EXISTS = 100; 
const int SOMARIA_BEAM_POWER = 200; 

void SetSomariaBeamPower(int power){
	Somaria[SOMARIA_BEAM_POWER] = power;
}
int GetSomariaBeamPower(){ return Somaria[SOMARIA_BEAM_POWER];}

const int TILE_LINK_LIFT_UP = 0;
const int TILE_LINK_LIFT_DOWN = 0;
const int TILE_LINK_LIFT_LEFT = 0;
const int TILE_LINK_LIFT_RIGHT = 0;
const int SOMARIA_OVERHEAD_OFFSET_X_UP = 0;
const int SOMARIA_OVERHEAD_OFFSET_X_DOWN = 0;
const int SOMARIA_OVERHEAD_OFFSET_X_LEFT = 0;
const int SOMARIA_OVERHEAD_OFFSET_X_RIGHT = 0;
const int SOMARIA_OVERHEAD_OFFSET_Y_UP = 0;
const int SOMARIA_OVERHEAD_OFFSET_Y_DOWN = 0;
const int SOMARIA_OVERHEAD_OFFSET_Y_LEFT = 0;
const int SOMARIA_OVERHEAD_OFFSET_Y_RIGHT = 0;

const int LW_SOMARIA = 0; //Probably a script type. 
const int LW_SOMARIA_BEAM = 0; //Probably the same as swordbeams. 
const int LW_SOMARIA_FLAME = 0; //If we also want to double the somaria beam so that it acts as fire. 

const int SOMARIA_BEAMS_COUNT_AS_FIRE = 1; //A setting to make somaria beams also count as fire weapons. 
const int SOMARIA_BEAMS_SET_OFF_BOMBS = 1; //What it says on the tin. 

bool CreateBlock(int x, int y){
	//Store the combo that was at this location. 
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] = ComboAt(x,y);
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_D] = Screen->ComboD[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_C] = Screen->ComboC[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_T] = Screen->ComboT[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_S] = Screen->ComboS[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_F] = Screen->ComboF[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_I] = Screen->ComboI[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	
	
	
	
	//Chexk that the combo is non-solid. 
	if ( Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_S] ) return false;
	else {
		//otherwise, let's make a moving block. 
		Screen->ComboD[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_COMARIA_D;
		Screen->ComboC[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_SOMARIA_C;
		Screen->ComboT[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_SOMARIA_T;
		Screen->ComboS[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_SOMARIA_S;
		Screen->ComboF[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_SOMARIA_F;
		Screen->ComboI[ Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ] = CMB_MOVING_SOMARIA_I; 
		Somaria[SOMARIA_BLOCK_EXISTS] = 1;
		
		//Mark where the Somaria Block is going, and its types. 
		
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO] = SOMARIA_NEWBLOCK_OLDCOMBO;
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_D] = Screen->ComboD[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_C] = Screen->ComboC[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_T] = Screen->ComboT[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_S] = Screen->ComboS[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_F] = Screen->ComboF[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
		Somaria[SOMARIA_NEWBLOCK_NEWCOMBO_I] = Screen->ComboI[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]];
	
		
		return true;
	}
}

//Returns the Nuth combo index of a combo based on a central point, and a direction.
//For example, combo 22 + COMBO_UPRIGHT returns '7', 
//as combo 7 is to the upper-right of combo 22.
int AdjacentCombo(int cmb, int dir){
    int combooffsets[13]={-0x10,-0x0F,-0x0E,1,0x10,0x0F,0x0E,-1,-0x10};
    if ( cmb % 16 == 0 ) combooffsets[9] = 1;
    if ( cmb & 15 == 1 ) combooffsets[10] = 1;
    if ( cmb < 0x10 ) combooffsets[11] = 1;
    if ( cmb < 0xAF ) combooffsets[12] = 1;
    if ( combooffsets[9] && ( dir == CMB_LEFT || dir == CMB_UPLEFT || dir == CMB_DOWNLEFT || dir == CMB_LEFTUP ) ) return 0;
    if ( combooffsets[10] && ( dir == CMB_RIGHT || dir == CMB_UPRIGHT || dir == CMB_DOWNRIGHT ) ) return 0;
    if ( combooffsets[11] && ( dir == CMB_UP || dir == CMB_UPRIGHT || dir == CMB_UPLEFT || dir == CMB_DOWNLEFT ) ) return 0;
    if ( combooffsets[12] && ( dir == CMB_DOWN || dir == CMB_DOWNRIGHT || dir == CMB_DOWNLEFT ) ) return 0;
    else if ( cmb > 0 && cmb < 177 ) return cmb + combooffsets[dir];
    else return 0;
}

bool CheckMovingBlocksForSomaria(){
	if ( Somaria[SOMARIA_BLOCK_EXISTS] && Screen->MovingBlockX != -1 && Screen->MovingBlockY !+ -1 ) {
		//Compare the XY of any moving block on the screen, and see if it is/was where a somari ablock is located. 
		
		if ( ComboAt(Screen->MovingBlockX, Screen->MovingBlockY) == Somaria[SOMARIA_NEWBLOCK_OLDCOMBO] ){
			
			//We found a somaria block thT IS MOVING. 
			//Update the combo and location. 
			int loc[20];
			loc[0] = AdjacentCombo( Somaria[SOMARIA_NEWBLOCK_OLDCOMBO], Link->Dir );
			loc[1] = ComboAt(Screen->MovingBlockX, Screen->MovingBlockY);
			//Replace the 'old' combo with the stored values, and store the values for the new combo onto 
			//which the block moves. 
			
			//First, store the values for the old position. 
			loc[2] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_D];
			loc[3] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_T];
			loc[4] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_C];
			loc[5] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_S];
			loc[6] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_F];
			loc[7] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_I];
			
			//Then update the combos for the new location, so that we know what *was* under where the block is moving.
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_D] = ComboD[ loc[0] ];
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_T] = ComboT[ loc[0] ];
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_C] = ComboC[ loc[0] ];
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_S] = ComboS[ loc[0] ];
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_F] = ComboF[ loc[0] ];
			Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_I] = ComboI[ loc[0] ];
			
			
			//then wait a frame, and draw back the old, stored combo values. 
			
			Waitframe(); //We may need to wait extra frames between these steps. 
			
			ComboD[ loc[1] ] = loc[2];
			ComboT[ loc[1] ] = loc[3];
			ComboC[ loc[1] ] = loc[4];
			ComboS[ loc[1] ] = loc[5];
			ComboF[ loc[1] ] = loc[6];
			ComboI[ loc[1] ] = loc[7];
			
			//Updating should be done. 
			return true;
		}
		return false;
		
	}
}

bool LiftBlock(int x, int y){
	//Should we change the combo back?
	//Only if we're not in A DUNGEON.
	
}
	
item script CaneOfSomaria{
	void run(){
		if ( !Somaria[SOMARIA_BLOCK_EXISTS] ) {
			if ( Link->Dir == DIR_UP ) CreateBlock( GridX(Link->X), GridY(Link->Y - 16) );
			if ( Link->Dir == DIR_DOWN ) CreateBlock( GridX(Link->X), GridY(Link->Y + 16) );
			if ( Link->Dir == DIR_RIGHT ) CreateBlock( GridX(Link->X + 16), GridY(Link->Y) );
			if ( Link->Dir == DIR_LEFT ) CreateBlock( GridX(Link->X - 16), GridY(Link->Y) ); 
			else {
				//Change the combo back to what was stored.
				
		
				Screen->ComboD[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_D];
				Screen->ComboC[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_C];
				Screen->ComboT[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_T];
				Screen->ComboS[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_S];
				Screen->ComboF[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_F];
				Screen->ComboI[Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]] = Somaria[SOMARIA_NEWBLOCK_OLDCOMBO_I];
						
				//Create a 4-way beam.
				lweapon somariabeam[4];
				Game->PlaySound(SFX_SOMARIA_BEAMS); 
				for ( int q = 0; q < 4; q++ ) {
					somariabeam[q] = Screen->CreateLWeapon(LW_SOMARIBEAM); 
					somariabeam[q]->X = CenterX(ComboX(Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]));
					somariabeam[q]->Y = CenterY(ComboY(Somaria[SOMARIA_NEWBLOCK_OLDCOMBO]));
					somariabeam[q]->UseSprite = SPRITE_SOMARIA_BEAM;
					if ( GetSomariaBeamPower() ) somariabeam[q]->Damage = SOMARIA_BEAM_POWER;
					else somariabeam[q]->Damage = SOMARIA_BEAM_POWER; 
					if ( q % 2 != 0 ) somariabeam[q]->UseSprite++;
				}
				
				somariabeam[0]->Dir = DIR_UP;
				somariabeam[1]->Dir = DIR_LEFT;
				somariabeam[2]->Dir = DIR_DOWN;
				somariabeam[3]->Dir = DIR_RIGHT;
				
			}
		}
	}
}
				
				
				
				