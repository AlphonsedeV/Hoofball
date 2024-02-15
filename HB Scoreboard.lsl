///////////////////////////////////////////////////
//                      VARS                    //
/////////////////////////////////////////////////


// Counters
integer T1;
integer T2;

// Dialog
integer DChan;


///////////////////////////////////////////////////
//                   FUNCTIONS                  //
/////////////////////////////////////////////////


UpdateScoreHover()
{
    string message = "Score is currently\n   Team 1 : [" + (string)T1 + "]\n   Team 2 : [" + (string)T2+"]";
    llSetText(message, <1,1,1>, 1);
}


///////////////////////////////////////////////////
//                     STATE                    //
/////////////////////////////////////////////////

default
{
    state_entry()
    {
        DChan = (integer)llFrand(DEBUG_CHANNEL-1)+1;
        llListen(DChan,"",NULL_KEY,"");
        llListen(-155875,"",NULL_KEY,"");
        UpdateScoreHover();
    }

    touch_start(integer _)
    {
        string msg = "Score is currently\n   Team 1 : " + (string)T1 + "\n   Team 2 : " + (string)T2;
        llDialog(llDetectedKey(0), msg , ["T1 -","T2 -","Reset","T1 +","T2 +","Start"], DChan);
    }

    listen( integer chan, string _, key id, string msg )
    {
        if (chan == -155875)
        {
            if (msg == "GOAL 0") T1++;
            else T2++;
            UpdateScoreHover();
        }

        else if (chan == DChan)
        {
            list split = llParseString2List(msg, [" "], []);
            string Team = llList2String(split,0);
            if (Team == "Reset")
            {llShout(1,"HOOF STOP");llResetScript();}

            else if (Team == "Start")
            {
                llShout(1,"HOOF START");
            }

            else if (Team == "T1")
            {
                if (llList2String(split,1) == "+") T1++;
                else T1--;
            }
            else if (Team == "T2")
            {
                if (llList2String(split,1) == "+") T2++;
                else T2--;
            }
            UpdateScoreHover();
        }
    }
}

//By Alphonse de V
//This work is licensed under the Creative Commons Attribution 4.0 International License.
//To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.