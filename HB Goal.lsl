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

//By Alphonse de V
//This work is licensed under the Creative Commons Attribution 4.0 International License.
//To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.