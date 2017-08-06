//////////////////////////////////
/// Hedge Clip Reward / Secret ///
/// v0.1.2 - 19-Nov-2016       ///
/// By: ZoriaRPG               ///
//////////////////////////////////

ffc script HedgeClip{
	void run(int cmb_bush, int itm, int sfx, int layer, int reg){
		int q; bool bush;
		if ( Screen->D[reg] || layer < 0 || layer > 6 || cmb_bush == 0 || itm < 0 ) { this->Data = 0; this->Script = 0; Quit(); }
		if ( layer > 0 && layer < 7 && ( Screen->LayerMap(layer) < 0 || Screen->LayerScreen(layer) < 0 ) ) { this->Data = 0; this->Script = 0; Quit(); }

		while( !Screen->D[reg] ){
			if ( cmb_bush > 0 ) {
				for ( q = 0; q < 176; q++ ) {
					if ( layer ==  0 ) {
						if ( ComboD[q] == cmb_bush ) { bush = true; break; }
					}
					if ( layer > 0 ) {
						if ( GetLayerComboD(layer,q) == cmb_bush ) { bush = true; break; }
					}
				}
			}
			if ( cmb_bush < 0 ) { 
				for ( q = 0; q < 176; q++ ) {
					if ( layer == 0 ) {
						if ( ComboT[q] == CT_SLASHNEXT ) { bush = true; break; }
					}
					if ( layer > 0 ) {
						if ( GetlayerComboT(layer,q) == CT_SLASHNEXT ) { bush = true; break; }
					}
				}
			}
			if ( !bush ) {
				if ( sfx ) Game->PlaySound(sfx);
				item i = Screen->CreateItem(itm);
				i->X = this->X;
				i->Y = this->Y;
				Screen->D[reg] = 1;
			}
			Waitframe();
		}
		this->Data = 0; this->Script = 0; Quit();
	}
}

//For placing the reward on another screen.

ffc script HedgeClipRemote{
	void run(int cmb_bush, int itm, int sfx, int layer, int reg, int dmap, int screen){
		int q; bool bush;
		if ( GetDMapScreenD(dmap,screen,reg) || layer < 0 || layer > 6 || cmb_bush == 0 || itm < 0 ) { this->Data = 0; this->Script = 0; Quit(); }
		if ( layer > 0 && layer < 7 && ( Screen->LayerMap(layer) < 0 || Screen->LayerScreen(layer) < 0 ) ) { this->Data = 0; this->Script = 0; Quit(); }
		
		while( !GetDMapScreenD(dmap,screen,reg){
			if ( cmb_bush > 0 ) {
				for ( q = 0; q < 176; q++ ) {
					if ( layer ==  0 ) {
						if ( ComboD[q] == cmb_bush ) { bush = true; break; }
					}
					if ( layer > 0 ) {
						if ( GetLayerComboD(layer,q) == cmb_bush ) { bush = true; break; }
					}
				}
			}
			if ( cmb_bush < 0 ) { 
				for ( q = 0; q < 176; q++ ) {
					if ( layer == 0 ) {
						if ( ComboT[q] == CT_SLASHNEXT ) { bush = true; break; }
					}
					if ( layer > 0 ) {
						if ( GetlayerComboT(layer,q) == CT_SLASHNEXT ) { bush = true; break; }
					}
				}
			}
			if ( !bush ) {
				if ( sfx ) Game->PlaySound(sfx);
				item i = Screen->CreateItem(itm);
				i->X = this->X;
				i->Y = this->Y;
				SetDMapScreenD(dmap,screen,reg,1)
			}
			Waitframe();
		}
		this->Data = 0; this->Script = 0; Quit();
	}
}