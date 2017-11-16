//Saffith, Antifairy

// import "std.zh"
// import "string.zh"
// import "ghost.zh"

// npc->Attributes[] indices
const int WB_ATTR_TILE_WIDTH = 2;
const int WB_ATTR_TILE_HEIGHT = 3;
const int WB_ATTR_IGNORE_WATER = 4;
const int WB_ATTR_IGNORE_PITS = 5;

ffc script WallBouncer
{
    void run(int enemyID)
    {
        npc ghost;
        int flags;
        int angle;
        float step;
        float xStep;
        float yStep;
        
        // Initialize
        ghost=Ghost_InitAutoGhost(this, enemyID, GHF_NO_FALL);
        Ghost_TileWidth=Ghost_GetAttribute(ghost, WB_ATTR_TILE_WIDTH, 1, 1, 4);
        Ghost_TileHeight=Ghost_GetAttribute(ghost, WB_ATTR_TILE_HEIGHT, 1, 1, 4);
        Ghost_SpawnAnimationPuff(this, ghost);
        
        // Set flags
        flags=GHF_STUN|GHF_CLOCK;
        if(ghost->Attributes[WB_ATTR_IGNORE_WATER]>0)
            flags|=GHF_IGNORE_WATER;
        if(ghost->Attributes[WB_ATTR_IGNORE_PITS]>0)
            flags|=GHF_IGNORE_PITS;
        Ghost_SetFlags(flags);
        
        // Get initial movement
        angle=45+90*Rand(4);
        step=ghost->Step/100;
        ghost->Step=0; // In case it's a walker
        
        xStep=step*Cos(angle);
        yStep=step*Sin(angle);
        
        while(true)
        {
            // Bounce
            if(xStep<0)
            {
                if(!Ghost_CanMove(DIR_LEFT, -xStep, 3))
                   xStep*=-1;
            }
            else
            {
                if(!Ghost_CanMove(DIR_RIGHT, xStep, 3))
                   xStep*=-1;
            }
            
            if(yStep<0)
            {
                if(!Ghost_CanMove(DIR_UP, -yStep, 3))
                   yStep*=-1;
            }
            else
            {
                if(!Ghost_CanMove(DIR_DOWN, yStep, 3))
                   yStep*=-1;
            }
            
            // And move
            Ghost_MoveXY(xStep, yStep, 3);
            Ghost_Waitframe(this, ghost, true, true);
        }
    }
}

/*
This will work with walking enemies so you can use their touch effects. Other attributes won't work normally.

Attribute 3 (Death Attr. 1): Tile width (1-4, default 1)
Attribute 4 (Death Attr. 2): Tile Height (1-4, default 1)
Attribute 5 (Death Attr. 3): Move over water (0: no, 1: yes)
Attribute 6 (Extra Shots): Move over direct warps (0: no, 1: yes) 
*/