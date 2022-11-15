///////////////////////////////////////////////////
//                      VARS                    //
/////////////////////////////////////////////////

vector Dpos;
key REFEREE = NULL_KEY; //PUT THE REFEREE KEY HERE


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
        llShout(0, "3");
        llSleep(1);
        llShout(0, "2");
        llSleep(1);
        llShout(0, "1");
        llSleep(1);
        llSetLinkPrimitiveParamsFast(LINK_THIS, Phy);
        llShout(0,"GO !");
    }

    listen( integer chan, string _, key __, string msg )
    {
        if (chan == 1)  state inert;
        else
        {
            isgoal = TRUE;
            if (msg == "GOAL 0")  llShout("Team 1 Scores !");
            else  llShout("Team 2 Scores !");
            
            state inert;
        }
    }

    state_exit()
    {
        if (isgoal)
        {
            //Do particle/Sound stuff.
        }
        else llShout("Ball Stopped by referee");
    }
}
