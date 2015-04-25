//
// moarCommands server handler
// Catches client-sided events.
//

#define CLIENT_ONLY

void onInit(CRules@ this)
{
	print("Loading client script...");
}

void onReload(CRules@ this)
{
	onInit(this);
}

void onCommand(CRules@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("mc_strsend"))
	{
		string textoutput = params.read_string();
		bool outmode = params.read_bool();

		if (outmode)
		{
			u8 r = params.read_u8();
			u8 g = params.read_u8();
			u8 b = params.read_u8();

			client_AddToChat(textoutput, SColor(255, r, g, b));
		}
		else
		{
			print(textoutput);
		}
	}
}