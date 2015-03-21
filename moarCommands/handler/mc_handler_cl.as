//
// moarCommands server handler
// Catches client-sided events.
//

#define CLIENT_ONLY

void onClInit(CRules@ this)
{
	
}

void onCommand(CRules@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("mc_strsend"))
	{
		string textoutput = params.read_string();
		bool outmode = params.read_bool();

		if (outmode)
		{
			// Todo : color
			client_AddToChat(textoutput);
		}
		else
		{
			print(textoutput);
		}
	}
}