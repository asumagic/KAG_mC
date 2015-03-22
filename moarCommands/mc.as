//
// moarCommands main file
// You should not include this file in a script, else you may encounter script errors, such as function conflict.
// To install the mod, you simply need to add 'moarCommands' in a new line in Mods.cfg
// Then, you need to add 'mc.as' in the script part of your gamemode.cfg
//
// This mC build was designed for build : 1387
//

//#include "mc_handler_cl.as"
//#include "mc_handler_sv.as"

namespace mc
{
	void setupCommonCommands(CRules@ this)
	{
		this.addCommandID("mc_strsend");
	}
}

void onInit(CRules@ this)
{
	warn("moarCommands is initializing...");

	mc::setupCommonCommands(this);

	if (getNet().isServer())
	{
		// We're removing the script first so we don't get a script running twice
		getRules().RemoveScript("mc_handler_sv.as");
		getRules().AddScript("mc_handler_sv.as");
	}
	
	// This is required for localhost parties, where the player can be the server and the client at the same time.
	// Else we'd get odd issues, such as sending messages but never receiving them.
	if (getNet().isClient())
	{
		getRules().RemoveScript("mc_handler_cl.as");
		getRules().AddScript("mc_handler_cl.as");
	}

	warn("moarCommands initialized.");
}

void onReload(CRules@ this)
{
	warn("moarCommands is reloading...");
	onInit(this);
}