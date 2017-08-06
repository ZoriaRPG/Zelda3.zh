/////////////////////////////////////
/// Z3 Style Lift and Throw Bombs ///
/// v0.3.1 - 20-Nov-2016          ///
/// By: ZoriaRPG                  ///
/////////////////////////////////////


int _____GRAM[21747];
const int LINK_HOLDING_OBJ = 23012; 

int LinkLiftingObject(){ return _____GRAM[LINK_HOLDING_OBJ]; }
void LinkLiftingObject(	bool set ) { if ( set ) _____GRAM[LINK_HOLDING_OBJ] = 1; else _____GRAM[LINK_HOLDING_OBJ] = 0; }

const int I_LINKLIFTING_TILEMOD = 200; //Ring that gives Link an LTM with lifting item tiles.

void LinkLifting(){
	if ( LinkLiftingObject() && !Link->Item[I_LINKLIFTING_TILEMOD] ) Link->Item[I_LINKLIFTING_TILEMOD] = true;
	if ( !LinkLiftingObject() && Link->Item[I_LINKLIFTING_TILEMOD] ) Link->Item[I_LINKLIFTING_TILEMOD] = false;
}

global script lift{
	void run(){
		while(true){
			BombLift();
			LinkLifting();
			Waitdraw();
			Waitframe();
		}
	}
}

const int FFC_BOMBLIFT_THROWDUR = 90; //Number of frames in the throw anim. 
const int DIST_BOMB_LIFT = 8;
const int FFC_MISC_BOMBTIMER = 5;
const int FFC_BOMBLIFT_TIME = 200;
const int CMB_LITBOMB = 1000; 
const int CMB_LITBOMB_FLASHING = 1000; 
const int FFC_BOMBLIFT_Y_OFS = 16;
const int FFC_BOMBLIFT_X_OFS = 4;
const int FFC_BOMBLIFT_TIME_BEFORE_FLASH = 50;
const int FFC_BOMBLIFT_EXPLODESPRITE_TIME = 30; //Frames of the LW_SPARKLE sprite animation.
const int SPRITE_THROWNBOMB_BOOM = 50; //Sprite of the LW_SPARKLE weapon
const int FFC_BOMBLIFT_TIME_EXPLODE_AT = 2;


void BombLift(){
	for ( int q = Screen->NumLWeapons(); q > 0; q--) {
		lweapon l = Screen->LoadLWeapon(q);
		if ( l->ID == LW_BOMB && LinkFacing(l) && DistXY(l,DIST_BOMB_LIFT) && Link->PressA && !LinkLiftingObject() ) {
			LinkLiftingObject(true);
			int f[]="BombLiftFFC";
			int ff = Game->GetFFCScript(f);
			RunFFCScript(ff,NULL);
			Remove(l);
		}
	}
}

ffc script BombLiftFFC{
	void run(){
		//ffc->Misc holds the timer
		this->Misc[FFC_MISC_BOMBTIMER] = FFC_BOMBLIFT_TIME;
		this->Data = CMB_LITBOMB;
		int throwdir = -100; int q[4]; //q[1] = throwdir
		while(this->Misc[FFC_MISC_BOMBTIMER]--){
			if ( this->Misc[FFC_MISC_BOMBTIMER] <= FFC_BOMBLIFT_TIME_BEFORE_FLASH && this->Misc[FFC_MISC_BOMBTIMER] < 1 ) this->Data = CMB_LITBOMB_FLASHING;
			if ( throwdir < 0 && throwdir > -200 ) {
				this->X = Link->X + FFC_BOMBLIFT_X_OFS;
				this->Y = Link->Y - FFC_BOMBLIFT_Y_OFS;
			}
			//Link->Action = LA_CASTING;
			//Change Link's TIile somehow. 
			//I usually make him invisible, and draw tiles. 
			//but you can also do CopyTile here.
			//LA_CASTING may work.
			if ( Link->PressA || Link->PressB ) thorowdir = Link->Dir;
			if ( throwdir > -1 ) {
				LinkLiftingObj(false); //Mark that Link is no longer lifting an object.
				////Throw the bomb in an arc based on the value of throwdir.
				q[0] = FFC_BOMBLIFT_THROWDUR; 
				while ( q[0]-- ) { //throw it and time thre throw
					if ( throwdir == DIR_UP ) this->Y--;
					if ( throwdir == DIR_DOWN ) this->Y++;
					if ( throwdir == DIR_LEFT ) this->X--; 
					if ( throwdir == DIR_RIGHT) this->X++;
					Waitframe();
				}	

				//if we reach the end of the arc, mark throwdir as stopped
				//End of arc
				throwdir = -200; 
			}
			
			
			if ( this->Misc[FFC_MISC_BOMBTIMER] <= FFC_BOMBLIFT_TIME_EXPLODE_AT ) {
				
				this->Data = FFC_INVISIBLE_COMBO; 
				lweapon boomsprite = Screen->CreateLWeapon(LW_SPARKLE); 
				boomsprite->>UseSprite(SPRITE_THROWNBOMB_BOOM);
				
				Waitframes(FFC_BOMBLIFT_EXPLODESPRITE_TIME); //Wait for the explosion anim to end.
				
				if ( !throwdir ) LinkLiftingObject(false); 
				lweapon boom = Screen->CreateLWeapon(LW_BOMBBLAST);
				l->X = this->X; 
				l->Y = this->Y; 
				Waitframe();
				this->Data = 0; this->Script = 0; Quit();
				
			Waitframe();
		}
		
	}
}