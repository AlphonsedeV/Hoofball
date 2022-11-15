///////////////////////////////////////////////////
//                      VARS                    //
/////////////////////////////////////////////////

string Check = "Aball";
integer Team2 = FALSE;


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
        llVolumeDetect(TRUE);
    }

    collision_start( integer _ )
    {
        if (!(llDetectedType(0) & 10))  return;
        key target = llDetectedKey(0);
        if (llList2String(llGetObjectDetails(target, [OBJECT_DESC]),0) == Check)
        {llRegionSayTo(target, -155875, "GOAL " + (string)Team2);}
    }
}