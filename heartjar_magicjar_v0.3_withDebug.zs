/// Heart and Magic Storage Jars
/// Collects 'useless' Drops for later use.
/// By: ZoriaRPG for IotM No.2 
/// v0.3
/// 10th February, 2016
///

/// Global Arrays
float ReserveCounters[256]={0,0,0,MAX_HEART_JAR_HEARTS_STORED, MAX_MAGIC_JAR_MAGIC_STORED}; //Holds values of dropped items that can't be used when the player picks them up.
int OwnsItems[512];  //Stores what items the player actually owns.

//Array indices.
const int RESERVE_HEARTS        = 1;
const int RESERVE_MAGIC         = 2;
const int HEART_JAR_MAX_HEARTS  = 3;
const int MAGIC_JAR_MAX_MAGIC   = 4;

//item constants.
const int I_HEARTJAR = 100; //The item ID for the Heart Jar.
const int I_MAGICJAR = 101; //The item ID for the Magic Jar

//Initial caps. These can be changed as constants, or set with functions at any time (to allow upgrades).
const int MAX_HEART_JAR_HEARTS_STORED = 32;
const int MAX_MAGIC_JAR_MAGIC_STORED = 1024;

//Debug values
const int DEBUG_ON_HEART_MAGIC_JARS             = 1; //Is debug enabled in general?
const int DEBUG_TRACE_HEART_JAR_HEARTS          = 1; //indidual debug types.
const int DEBUG_TRACE_HEART_JAR_HEARTS_CAP      = 1;
const int DEBUG_TRACE_MAGIC_JAR_MAGIC           = 1;
const int DEBUG_TRACE_MAGIC_JAR_MAGIC_CAP       = 1;
const int DEBUG_TRACE_OWNERSHIP_HEART_JAR       = 1;
const int DEBUG_TRACE_OWNERSHIP_MAGIC_JAR       = 1;
const int DEBUG_TRACE_HEART_PICKUP_JAR_VALUE    = 1;
const int DEBUG_TRACE_MAGICPICKUP_JAR_VALUE     = 1;

//use with if ( Link->PressEx3 && DEBUG_VALUE ) Trace().this

Debugjarvalues(){
    int str[]="Present Heart jar Value is: "
    int str2[]="Present Magic jar value is: "
    TraceNL();  TraceS(str);    Trace(ReserveCounters[RESERVE_HEARTS]);
    TraceNL();  TraceS(str);    Trace(ReserveCounters[RESERVE_MAGIC]);
}

global script debug{
    void run(){
        while(true){
            if ( Link->PressEx3 ) Debugjarvalues();
            Waitdraw();
            Waitframe();
        }
    }
}


//Assign as the pick-up script on all heart items.
//D0: Number of hearts to give when Link picks it up.
//D1 Divisor, for how many hearts it will store in the heart jar.
item script heartdrop{
    void run(int numhearts, int divisor){
        if ( Link->HP == Link->MaxHP && OwnsItems[I_HEARTJAR] ) {
            if ( ( ReserveCounters[RESERVE_HEARTS] + ( numhearts / divisor ) ) < ReserveCounters[HEART_JAR_MAX_HEARTS] )
                {
                    ReserveCounters[RESERVE_HEARTS] += numhearts / divisor;
                    if ( DEBUG_ON_HEART_MAGIC_JARS ) {
                        int str[]="On heart pickup, the amount of hearts added to the heart jar was: ";
                        TraceNL();  TraceS(str); Trace(numhearts/divisor);
                    }
                }
            if ( (ReserveCounters[RESERVE_HEARTS] < ReserveCounters[HEART_JAR_MAX_HEARTS] ) && ( ReserveCounters[RESERVE_HEARTS] + (numhearts / divisor) > ReserveCounters[HEART_JAR_MAX_HEARTS] ) ) 
                ReserveCounters[RESERVE_HEARTS]  = ReserveCounters[HEART_JAR_MAX_HEARTS];
        }
    }
}


//Assign as the pick-up script on all magic drop items.
//D0: Amount of magic to give when Link picks it up.
//D1 Divisor, for how many magic points it will store in the magic jar.
item script magicdrop{
    void run(int num_mp, int divisor){
    if ( Link->MP == Link->MaxMp && OwnsItems[I_MAGICJAR] ) {
            if ( ( ReserveCounters[RESERVE_MAGIC] + ( num_mp / divisor ) ) < ReserveCounters[MAGIC_JAR_MAX_MAGIC] )
                {
                    ReserveCounters[RESERVE_MAGIC] += num_mp / divisor;
                    if ( if ( DEBUG_ON_HEART_MAGIC_JARS ) {
                        int str[]="On magic pickup, the amount of magic added to the heart jar was: ";
                        TraceNL();  TraceS(str); Trace(num_mp/divisor);
                    }
                }
            if ( (ReserveCounters[RESERVE_MAGIC] < ReserveCounters[MAGIC_JAR_MAX_MAGIC] ) && ( ReserveCounters[RESERVE_MAGIC] + (num_mp / divisor) > ReserveCounters[MAGIC_JAR_MAX_MAGIC] ) ) 
                ReserveCounters[RESERVE_MAGIC]  = ReserveCounters[MAGIC_JAR_MAX_MAGIC];
        }
    }
}
    

//Assign as pickup script for heart jar item.
item script HeartJarPickup{
    void run(int msg, int sfx, imt errsfx, int cap){
        if ( msg ) Screen->message(msg);
        OwnsItems[I_HEARTJAR] = 1;
        if ( cap ) SetHeartJarCap(cap);
    }
}


//Assign as pickup script for magic jar item.
item script MagicJarPickup{
    void run(int msg, int sfx, imt errsfx, int cap){
        if ( msg ) Screen->message(msg);
        OwnsItems[I_MAGICJAR] = 1;
        if ( cap ) SetMagicJarCap(cap);
    }
}


//Assign as running script for Heart Jar.
item script heartjar{
    void run(int msg, int sfx, imt errsfx){
        if ( Link->HP < Link->MaxHP ) {
            if ( ReserveCounters[RESERVE_HEARTS] > ( Ceiling((Link->MaxHP - Link->HP) / 16) ) ) {
                if ( DEBUG_ON_HEART_MAGIC_JARS ) {
                        int str[]="The value of 'Ceiling((Link->MaxHP - Link->HP) / 16)' is: ";
                        TraceNL();  TraceS(str); Trace( Ceiling((Link->MaxHP - Link->HP) / 16) );
                }
                ReserveCounters[RESERVE_HEARTS] -= ( Ceiling((Link->MaxHP - Link->HP) / 16) );
                Link->HP = Link->MaxHP;
                Game->PlaySound(sfx);
            }
            if ( ReserveCounters[RESERVE_HEARTS] < ( Ceiling((Link->MaxHP - Link->HP) / 16) ) && ReserveCounters[RESERVE_HEARTS] ){
                
                if ( DEBUG_ON_HEART_MAGIC_JARS ) {
                    int str[]="Used the heart jar when Link's HP was lower than the number of hearts in the jar.";
                    int str2[]="The amount of health restored, was: ";
                    TraceNL();  TraceS(str); TraceNL(); TraceS(str2); Trace( ReserveCounters[RESERVE_HEARTS] * 16 );
                }
                Link->HP += ReserveCounters[RESERVE_HEARTS] * 16;
                ReserveCounters[RESERVE_HEARTS] = 0; //Clear the reserve.
                Game->PlaySound(sfx);
            }
            if ( !(ReserveCounters[RESERVE_HEARTS]) ) Game->PlaySound(errsrfx);
        }
        else game->PlaySound(errsfx);
    }
}
            
                

//Assign as running script for Magic Jar.
item script magicjar{
    void run(int msg, int sfx, imt errsfx){
        if ( Link->MP < Link->MaxMP ) {
            if ( ReserveCounters[RESERVE_MAGIC] > ( Ceiling((Link->MaxMP - Link->MP) / 32) ) ) {
                if ( DEBUG_ON_HEART_MAGIC_JARS ) {
                        int str[]="The value of 'Ceiling((Link->MaxMP - Link->MP) / 32)' is: ";
                        TraceNL();  TraceS(str); Trace( Ceiling((Link->MaxMP - Link->MP) / 32) );
                }
                ReserveCounters[RESERVE_MAGIC] -= ( Ceiling((Link->MaxMP - Link->MP) / 32) );
                Link->MP = Link->MaxMP;
                Game->PlaySound(sfx);
            }
            if ( ReserveCounters[RESERVE_MAGIC] < ( Ceiling((Link->MaxMP - Link->MP) / 32) ) && ReserveCounters[RESERVE_MAGIC] ){
                if ( DEBUG_ON_HEART_MAGIC_JARS ) {
                    int str[]="Used the magic jar when Link's MP was lower than the number of magic in the jar.";
                    int str2[]="The amount of magic restored, was: ";
                    TraceNL();  TraceS(str); TraceNL(); TraceS(str2); Trace( ReserveCounters[RESERVE_MAGIC] * 32 );
                }
                
                Link->MP += ReserveCounters[RESERVE_MAGIC] * 32;
                ReserveCounters[RESERVE_MAGIC] = 0;
                Game->PlaySound(sfx);
            }
            if ( !(ReserveCounters[RESERVE_MAGIC]) ) Game->PlaySound(errsrfx);
        }
        else game->PlaySound(errsfx);
    }
}
            

//Global Accessor Functions
void SetHeartJarCap(int cap){
    ReserveCounters[HEART_JAR_MAX_HEARTS] = cap;
}

void SetMagicJarCap(int cap){
    ReserveCounters[MAGIC_JAR_MAX_MAGIC] = cap;
}


//! Deprecated (already!?)
//These are pointless. Just call the setters above for inits.
void InitMagicJarCap(int cap){
    ReserveCounters[MAGIC_JAR_MAX_MAGIC] = cap;
}

void InitHeartJarCap(int cap) {
    ReserveCounters[HEART_JAR_MAX_HEARTS] = cap;
}
                