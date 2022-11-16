///////////////////////////////////////////////////
//                      VARS                    //
/////////////////////////////////////////////////

vector Dpos;
vector Rpos;
key REFEREE = NULL_KEY; //PUT THE REFEREE KEY HERE
float epsilon=2;
integer NoSpam = FALSE;

integer isgoal = FALSE;
list NonPhy = [PRIM_PHANTOM,TRUE,PRIM_PHYSICS,FALSE];
list Phy = [PRIM_PHANTOM,FALSE,PRIM_PHYSICS,TRUE];

float SFRICTION = 0.2;
float VFRICTION = 0.02;
float BUCKFACT = 20;
float KICKFACT = 9;


list Trail = [
    //PSYS_PART_FLAGS,            PSYS_PART_EMISSIVE_MASK | PSYS_PART_RIBBON_MASK,
    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_DROP,
    PSYS_SRC_TEXTURE,           TEXTURE_BLANK,
    PSYS_PART_START_ALPHA,      0.7,
    PSYS_SRC_MAX_AGE,           0,
    PSYS_PART_MAX_AGE,          3,
    PSYS_SRC_BURST_RATE,        0.03,
    PSYS_SRC_BURST_PART_COUNT,  2
];

list Goal = [
    //PSYS_PART_FLAGS,            PSYS_PART_BOUNCE_MASK | PSYS_PART_TARGET_POS_MASK | PSYS_PART_EMISSIVE_MASK
    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE,
    //PSYS_SRC_TARGET_KEY,        llGetKey(),
    PSYS_SRC_TEXTURE,           "d7fef845-4c20-3500-ec1c-3aea1d44cdef",
    PSYS_SRC_MAX_AGE,           1,
    PSYS_PART_MAX_AGE,          5,
    PSYS_SRC_BURST_RATE,        0,
    PSYS_SRC_BURST_PART_COUNT,  50,
    PSYS_SRC_BURST_SPEED_MAX,   10,
    PSYS_SRC_BURST_SPEED_MIN,   5
];


///////////////////////////////////////////////////
//                   FUNCTIONS                  //
/////////////////////////////////////////////////




///////////////////////////////////////////////////
//                     STATE                    //
/////////////////////////////////////////////////

default
{
    state_entry()
    {
        Trail += [PSYS_PART_FLAGS,PSYS_PART_EMISSIVE_MASK | PSYS_PART_RIBBON_MASK];
        Goal += [PSYS_SRC_TARGET_KEY,llGetKey(),PSYS_PART_FLAGS,PSYS_PART_BOUNCE_MASK | PSYS_PART_TARGET_POS_MASK | PSYS_PART_EMISSIVE_MASK];
        vector scale = llGetScale();
        epsilon = scale.x/2*epsilon;
        Dpos = llGetPos();
        Rpos = Dpos;
        state inert;
    }
}

state inert
{
    state_entry()
    {
        llSetTimerEvent(0);
        llParticleSystem([]);
        llSetObjectDesc("Iball");
        llSetPrimitiveParams(NonPhy);
        llSetRegionPos(Dpos);
        llListen(1, "", REFEREE, "HOOF START");
        llListen(1,"",REFEREE,"HOOF STOP");
    }

    touch_start( integer _ )
    {
        if (REFEREE == NULL_KEY) state active;
        if (llDetectedKey(0) == REFEREE) state active;
    }

    listen( integer chan, string _, key __, string msg )
    {
        if (msg == "HOOF STOP") llSetRegionPos(Rpos);
        else state active;
    }
}

state active
{
    state_entry()
    {
        NoSpam = FALSE;
        isgoal = FALSE;
        llSetObjectDesc("Aball");
        llListen(1, "", REFEREE, "HOOF STOP");
        llListen(-155875,"",NULL_KEY,"GOAL 0");
        llListen(-155875,"",NULL_KEY,"GOAL 1");
        llListen(-19,"",NULL_KEY,"buck");
        llListen(-563,"",NULL_KEY,"punch");
        llShout(0, "3");
        llSleep(1);
        llShout(0, "2");
        llSleep(1);
        llShout(0, "1");
        llSleep(1);
        llSetLinkPrimitiveParamsFast(LINK_THIS, Phy);
        llParticleSystem(Trail);
        llShout(0,"GO !");
        llSetTimerEvent(0.2);
    }

    listen( integer chan, string _, key id, string msg )
    {
        if (chan == 1)  state inert;
        else if (chan == -19)
        {
            list attr = llGetObjectDetails(id,[OBJECT_POS,OBJECT_ROT]);
            vector posi = llList2Vector(attr, 0);
            vector fwd = llRot2Fwd(llList2Rot(attr, 1));
            fwd = llVecNorm(<fwd.x,fwd.y,0>);

            if (llVecDist(llGetPos(), posi-fwd) <= epsilon && !NoSpam)
            {
                //NoSpam = TRUE;
                llApplyImpulse(llGetMass()*-BUCKFACT*(fwd+<0,0,-0.5>), FALSE);
                llSetTimerEvent(0);
                llSetTimerEvent(1);
            }
        }
        else if (chan == -563)
        {
            list attr = llGetObjectDetails(id,[OBJECT_POS,OBJECT_ROT]);
            vector posi = llList2Vector(attr, 0);
            vector fwd = llRot2Fwd(llList2Rot(attr, 1));
            fwd = llVecNorm(<fwd.x,fwd.y,0>);

            if (llVecDist(llGetPos(), posi+fwd) <= epsilon && !NoSpam)
            {
                //NoSpam = TRUE;
                llApplyImpulse(llGetMass()*KICKFACT*(fwd+<0,0,0.5>), FALSE);
                llSetTimerEvent(0);
                llSetTimerEvent(0.8);
            }
        }
        else
        {
            isgoal = TRUE;
            if (msg == "GOAL 0")  
            {llShout(0,"Team 1 Scores !");llShout(-155875,"GOAL 0");}
            else  
            {llShout(0,"Team 2 Scores !");llShout(-155875,"GOAL 1");}
            list goalattr = llGetObjectDetails(id,[OBJECT_POS,OBJECT_ROT]);
            vector goalpos = llList2Vector(goalattr,0);
            vector fwd = <0,0,-1>*llList2Rot(goalattr,1);
            fwd = llVecNorm(<fwd.x,fwd.y,0>);
            Dpos =  goalpos+fwd*10+<0,0,2>;
            
            state inert;
        }
    }

    state_exit()
    {
        if (isgoal)
        {
            llSetObjectDesc("Iball");
            vector a = llGetPos();
            llParticleSystem(Goal);
            llPlaySound("2553d8ee-0746-0426-150d-9e836c277652", 1);
            llTriggerSound("3c3ab527-c40d-df29-55fe-d3d48c387a62", 1);
            llTriggerSound("3c3ab527-c40d-df29-55fe-d3d48c387a62", 1);
            llTriggerSound("3c3ab527-c40d-df29-55fe-d3d48c387a62", 1);
            llSleep(1);
            llMoveToTarget(a, 5);
            llSleep(3);
            llStopMoveToTarget();
            
        }
        else 
        {llShout(0,"Ball Stopped by referee");Dpos=Rpos;}

    }
    
    timer()
    {
        NoSpam = FALSE;
        vector a = llGetPos();
        llSleep(0.05);
        llSetTimerEvent(0.2);
        vector b = llGetPos();
        vector speed = (b-a)/0.05;
        float m = llGetMass();
        llApplyImpulse(m*speed*-VFRICTION, FALSE);
        if (llVecMag(speed) < SFRICTION*2 || (b.z - llGround(ZERO_VECTOR)) >= epsilon/1.7) return ;
        speed = llVecNorm(<speed.x,speed.y,0>);
        llApplyImpulse(m*speed*-SFRICTION,FALSE);
    }
}
