const int NPC_MISC_HOLDING_ITEM = 12; 

ffc script BasicStealItem{
	void run(int npc_ID, int stealsfx, float dragdur){
		npc n; item i; int q; int w; int e; int r; itemdata it;
		if ( !dragdur ) dragdur = 1; 
		int itemlist[]={	IC_RUPEE, IC_HEART, IC_ARROWAMMO, IC_MAGIC, IC_BOMBAMMO};
		while(true){
			for ( w = 1; w <= Screen->NumItems(); w++){
				for ( q = 1; q <= Screen->NumNPCs(); q++) {
					n = Screen->LoadNPC(q);
					if ( n->isValid() )	{
						if ( n->ID == npc_ID && !n->Misc[NPC_MISC_HOLDING_ITEM]) {
							i = Screen->LoadItem(w);
							if ( i->isValid() ) {
								if ( __DistX(n,i,4) && __DistY(n,i,4) ){
								
									it = Game->LoadItemData(i->ID);
									for ( e = 0; e < SizeOfArray(itemlist); e++){
										if ( it->Family == itemlist[e] ) {
											n->Misc[NPC_MISC_HOLDING_ITEM] = 1; 
											for ( r = 0; r < (dragdur * 60); r ++ ) {
												i->X = n->X;
												i->Y = n->Y;
												Waitframe();
											}
											Game->PlaySound(stealsfx);
											Remove(i);
											n->Misc[NPC_MISC_HOLDING_ITEM] = 0;
										}
									}									
								}
							}
						}
					}
				}
			}
			Waitframe();
		}
	}
	bool __DistX(npc a, item b, int distance) {
		int dist;
		if ( a->X > b->X ) dist = a->X - b->X;
		else dist = b->X - a->X;
		return ( dist <= distance );
	} 
	bool __DistY(npc a, item b, int distance) {
		int dist;
		if ( a->Y > b->Y ) dist = a->Y - b->Y;
		else dist = b->Y - a->Y;
		return ( dist <= distance );
	} 

}