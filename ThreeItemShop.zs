/////////////////////////////////////
/// Zelda 3 Style Three Item Shop ///
/// By: ZoriaRPG                  ///
/// v1.0                          ///
/// 27th September, 2017          ///
/////////////////////////////////////

//Array offsets
const int Z3SHOP_POSITIONS_X = 3; //Do not change!
const int Z3SHOP_POSITIONS_Y = 6; //Do not change!

const int CMB_Z3SHOP_ITEM 		= 100; //The specific comb o to find. it should be invisible, and solid.
	//Place EXACTLY THREE of these on the screen. They will turn into items based on left to right.
const int Z3SHOP_COMBO_LAYER 		= 2; //The layer on which we place the invisible combos. 
	//We use invisible combos on a specific layer (0, 1, or 2) for their solidity.
const int Z3SHOP_Y_POSITION_MAX 	= 80; //THe positions that Link must be be between
const int Z3SHOP_Y_POSITION_MIN 	= 72; //THe positions that Link must be be between

const int Z3SHOP_LINK_PROXIMITY_X 	= 8; //The X proximity to each 'item' to select it for purchase. 

//Shop item positions
const int Z3SHOP_MIN_COMBO_POS 		= 84;//Minimum combo position to check (performance)
const int Z3SHOP_MAX_COMBO_POS 		= 108; //Minimum combo position to check (performance)

//Sounds
const int Z3SHOP_SFX_BUY_ERROR 		= 63; //Error sound for buying items. Set to '0' for no sound.
const int Z3SHOP_SFX_BUY_ITEM 		= 64; //Success sound for buying items. Set to '0' for no sound.

//Drawing
const int Z3SHOP_DRAW_TILE_LAYER 	= 1; //The layer onto which to draw the item tiles. 

//Shop Text Settings
const int Z3SHOP_TEXT_YOFFSET 		= 18; //Y offset from true Y of the combo for each item. 
const int Z3SHOP_TEXT_XOFFSET 		= 6; //X offset fromt he true X of the combo for each item.
const int Z3SHOP_TEXT_BGOFFSET_Y 	= -1; //The offset for the background outline text.
const int Z3SHOP_TEXT_BGOFFSET_X 	= -1;
const int Z3SHOP_TEXT_DECIMAL_PLACES 	= 0; //Number of decimal places to pass to DrawInteger. 

const int Z3SHOP_TEXT_DRAWLAYER 	= 2; //Layer to which we draw the price text.
const int Z3SHOP_TEXT_BGCOLOUR 		= 0x0F; //Colour of the background text.
const int Z3SHOP_TEXT_FGCOLOUR 		= 0x01; //Colour of the foreground text.
const int Z3SHOP_TEXT_FONT 		= 2; //Fomt of the price text; 2 == Z3 Small

//The Item Holdup Animation to use. 
const int Z3SHOP_HOLDUP_TYPE = 4; //4 == HOLD1LAND, 5 == HOLD2LAND, 0 = NONE

//! Button Settings
//Set any button that you want the player to use for buying an item to a value of '1'. 
//Set all others to '0'.
const int Z3SHOP_USE_BUTTON_A = 1;
const int Z3SHOP_USE_BUTTON_B = 1;
const int Z3SHOP_USE_BUTTON_L = 0;
const int Z3SHOP_USE_BUTTON_R = 0;
const int Z3SHOP_USE_BUTTON_EX1 = 0;
const int Z3SHOP_USE_BUTTON_EX2 = 0;
const int Z3SHOP_USE_BUTTON_EX3 = 0;
const int Z3SHOP_USE_BUTTON_EX4 = 0;

/// The Shop FFC:
/// The price, and the item ID args are in a split format, where the INTEGRR portion is the price,
///     and the DECIMAL portion is the item ID. 
///	 e.g. IIIII.dddd
///     Thus, 25.0010 : THis is Item ID 25, at a price of 10 rupees. 
/// D0: The price, and the item ID of the first of the three shop items.
/// D1: The price, and the item ID of the second of the three shop items.
/// D2: The price, and the item ID of the third of the three shop items.
///
/// OPTIONAL: Tile overrides for the display of the shop items. Set to '0' to use the item tile. 
///           These are for the items DISPLAYED by ther shoppe, not the items held up on purchase. 
///	       Useful for having a potion vat, or something simialar, then holding up a bottled potion. 
/// D3: Optional tile override for the first shop item.
/// D4: Optional tile override for the second shop item.
/// D5: Optional tile override for the third shop item. 


ffc script z3shop{
	void run(int price_item_1, int price_item_2, int prive_item3, int tileA, int tileB, int tileC )
	{
		int positions[9]; int q[2]; itemdata id[3]; int prices[3]; int tiles[3]={tileA,tileB,tileC};
		int items[3]; //Needed for 2.50.x. 
		for ( q[0] = 0; q[0] < 3; q[0]++ ) {
			//Load the items and prices.
			id[q[0]] = Game->LoadItemData ( ( this->InitD[q[0]] - (this->InitD[q[0]] << 0) ) * 10000 );
			items[q[0]] = ( this->InitD[q[0]] - (this->InitD[q[0]] << 0) ) * 10000;
			prices[q[0]] = ( this->InitD[q[0]] << 0 );
		}
		for ( q[0] = Z3SHOP_MIN_COMBO_POS; q[0] < Z3SHOP_MAX_COMBO_POS; q[0]++ )
		{
			//Set up positions
			if ( GetLayerComboC(Z3SHOP_COMBO_LAYER, q[0]) == CMB_Z3SHOP_ITEM )
			{
				//Store the positions of the three items.
				positions[q] = q[0];
				positions[q+Z3SHOP_POSITIONS_X] = ComboX(q[0]);
				positions[q+Z3SHOP_POSITIONS_Y] = ComboY(q[0]);
			}
		}
		while(true){
			//Draw Tiles / items, and prices
			for ( int q[1] = 0; q[1] < 3; q[1]++ ) {
				
				//Item icons
				Screen->DrawTile(Z3SHOP_DRAW_TILE_LAYER, positions[ q[1]+Z3SHOP_POSITIONS_X ],
				positions[q[1]+Z3SHOP_POSITIONS_Y], Cond((tiles[ q[1] ] > 0), tiles[ q[1] ], id[ q[1] ]->Tile),
				1, 1, id[ q[1] ]->CSet, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
				
				//Prices
				//Background text
				Screen->DrawInteger(Z3SHOP_TEXT_DRAWLAYER, 
				positions[ q[1]+Z3SHOP_POSITIONS_X ] + Z3SHOP_TEXT_XOFFSET + Z3SHOP_TEXT_BGOFFSET_X,
				positions[q[1]+Z3SHOP_POSITIONS_Y] + Z3SHOP_TEXT_YOFFSET + Z3SHOP_TEXT_BGOFFSET_Y,
				Z3SHOP_TEXT_FONT, Z3SHOP_TEXT_BGCOLOUR, -1, -1, prices[ q[1] ], Z3SHOP_TEXT_DECIMAL_PLACES, 
				OP_OPAQUE);
				//Foreground
				Screen->DrawInteger(Z3SHOP_TEXT_DRAWLAYER, 
				positions[ q[1]+Z3SHOP_POSITIONS_X ] + Z3SHOP_TEXT_XOFFSET,
				positions[q[1]+Z3SHOP_POSITIONS_Y] + Z3SHOP_TEXT_YOFFSET,
				Z3SHOP_TEXT_FONT, Z3SHOP_TEXT_FGCOLOUR, -1, -1, prices[ q[1] ], Z3SHOP_TEXT_DECIMAL_PLACES, 
				OP_OPAQUE);
				
			}
			
			//Performace checks if Link could not buy an item.
			if ( Link->Dir != DIR_UP ) {
				Waitframe();
				continue;
			}
			if ( Link->Y < Z3SHOP_Y_POSITION_MIN ) {
				Waitframe();
				continue;
			}
			if ( Link->Y > Z3SHOP_Y_POSITION_MAX ) {
				Waitframe();
				continue;
			}
			
			//If we reach here, then Link is with the Y axis field that allows buying items.
			for ( q[1] = 0; q[1] < 3; q[1]++ ) 
			{
				//If We are not decrementing the DCounter...
				if ( Game->DCounter[CR_RUPEES] == 0 ) 
				{
					//if Link is within proximity of any of the three items.
					if ( Z3Shop_LinkDistX(positions[ q[1]+Z3SHOP_POSITIONS_X ], Z3SHOP_LINK_PROXIMITY_X )
					{
						//If Link presses a valid purchasing button:
						if ( Z3Shop_PressButton() ) 
						{
							//Buy the item!
							
							//This syntax works in 2.54, but not 2.50.x:
							//if (!( Z3Shop_BuyItem(id[ q[1] ]->ID, prices[ q[1] ], Z3SHOP_HOLDUP_TYPE) ))
							//{
							//	if ( Z3SHOP_SFX_BUY_ERROR ) Game->PlaySound(Z3SHOP_SFX_BUY_ERROR);
							//}
							//else {
							//	if ( Z3SHOP_SFX_BUY_ITEM ) Game->PlaySound(Z3SHOP_SFX_BUY_ITEM);
							//}
							
							//if we are using 2.50.0, we need to do it this way@
							if (!( Z3Shop_BuyItem(items[ q[1] ], prices[ q[1] ], Z3SHOP_HOLDUP_TYPE) ))
							{
								if ( Z3SHOP_SFX_BUY_ERROR ) Game->PlaySound(Z3SHOP_SFX_BUY_ERROR);
							}
							else {
								if ( Z3SHOP_SFX_BUY_ITEM ) Game->PlaySound(Z3SHOP_SFX_BUY_ITEM);
							}
						}
					}
				}
			}
			Waitframe();
		} //end infinite loop
	} //end run()
	
	//Local functions.
	
	//Buy a shop item using 2.54+
	bool Z3Shop_BuyItem(itemdata id, int price, int holdup){
		if ( price > Game->Counter[CR_RUPEES] ) return false;
		Game->DCounter[CR_RUPEES] -= price;
		item i = Screen->CreateItem(id->ID);
		i->X = Link->X;
		i->Y = Link->Y;
		if ( holdup > 0 ) 
		{
			Link->Action = holdup;
			Link->HeldItem = i->ID;
		}
	}
	
	//Buy a shop item using 2.50.x
	bool Z3Shop_BuyItem(int id, int price, int holdup){
		if ( price > Game->Counter[CR_RUPEES] ) return false;
		Game->DCounter[CR_RUPEES] -= price;
		item i = Screen->CreateItem(id)
		i->X = Link->X;
		i->Y = Link->Y;
		if ( holdup > 0 ) 
		{
			Link->Action = holdup;
			Link->HeldItem = id;
		}
	}
	
	//Check proximity to the item. 
	bool Z3Shop_LinkDistX(int a, int distance) {
		int dist;
		if ( a > Link->X ) dist = a - Link->X;
		else dist = Link->X - a;
		return ( dist <= distance );
	} 
	
	//Checks if Link presses a valid button for buying an item.
	bool Z3Shop_PressButton() {
		if ( Z3SHOP_USE_BUTTON_A && Link->PressA ) return true;
		if ( Z3SHOP_USE_BUTTON_B && Link->PressB ) return true;
		if ( Z3SHOP_USE_BUTTON_L && Link->PressL ) return true; 
		if ( Z3SHOP_USE_BUTTON_R && Link->PressR ) return true;
		if ( Z3SHOP_USE_BUTTON_EX1 && Link->PressEx1 ) return true;
		if ( Z3SHOP_USE_BUTTON_EX2 && Link->PressEx2 ) return true;
		if ( Z3SHOP_USE_BUTTON_EX3 && Link->PressEx3 ) return true;
		if ( Z3SHOP_USE_BUTTON_EX4 && Link->PressEx4 ) return true;
		return false;
	}
} //end script