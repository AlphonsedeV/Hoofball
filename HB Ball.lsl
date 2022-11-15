///////////////////////////////////////////////////
//                      VARS                    //
/////////////////////////////////////////////////

vector Dpos;
key REFEREE = "f3fb943d-20d8-48dd-9413-c1ab046ea8a8"; //PUT THE REFEREE KEY HERE
float epsilon=0.5;

integer isgoal = FALSE;
list NonPhy = [PRIM_PHANTOM,TRUE,PRIM_PHYSICS,FALSE];
list Phy = [PRIM_PHANTOM,FALSE,PRIM_PHYSICS,TRUE];


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
        Dpos = llGetPos();
        state inert;
    }
}

state inert
{
    state_entry()
    {
        llSetObjectDesc("Iball");
        llSetPrimitiveParams(NonPhy);
        llSetRegionPos(Dpos);
        llListen(1, "", REFEREE, "HOOF START");
    }

    touch_start( integer _ )
    {
        if (llDetectedKey(0) == REFEREE) state active;
    }

    listen( integer chan, string _, key __, string msg )
    {
        state active;
    }
}

state active
{
    state_entry()
    {
        isgoal = FALSE;
        llSetObjectDesc("Aball");
        llListen(1, "", REFEREE, "HOOF STOP");
        llListen(-155875,"",NULL_KEY,"GOAL 0");
        llListen(-155875,"",NULL_KEY,"GOAL 1");
        llListen(-19,"",NULL_KEY,"buck");
        llShout(0, "3");
        llSleep(1);
        llShout(0, "2");
        llSleep(1);
        llShout(0, "1");
        llSleep(1);
        llSetLinkPrimitiveParamsFast(LINK_THIS, Phy);
        llShout(0,"GO !");
    }

    listen( integer chan, string _, key id, string msg )
    {
        if (chan == 1)  state inert;
        else if (chan == -19)
        {
            list attr = llGetObjectDetails(id,[OBJECT_POS,OBJECT_ROT]);
            vector posi = llList2Vector(attr, 0);
            vector fwd = llRot2Fwd(llList2Rot(attr, 1));
            fwd = <fwd.x,fwd.y,0>;
            if (llVecDist(llGetPos(), posi-fwd) <= epsilon)
            {
                llApplyImpulse(llGetMass()*-6*(fwd+<0,0,-0.2>), FALSE);
            }
        }
        else
        {
            isgoal = TRUE;
            if (msg == "GOAL 0")  llShout(0,"Team 1 Scores !");
            else  llShout(0,"Team 2 Scores !");
            
            state inert;
        }
    }

    state_exit()
    {
        if (isgoal)
        {
            llSetObjectDesc("Iball");
            vector a = llGetPos();
            llTriggerSound("3c3ab527-c40d-df29-55fe-d3d48c387a62", 1);
            llTriggerSound("3c3ab527-c40d-df29-55fe-d3d48c387a62", 1);
            llTriggerSound("3c3ab527-c40d-df29-55fe-d3d48c387a62", 1);
            llSleep(1);
            llMoveToTarget(a, 6);
            //Do particle/Sound stuff.
            llSleep(3);
            llStopMoveToTarget();
        }
        else llShout(0,"Ball Stopped by referee");
    }
}
