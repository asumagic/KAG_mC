//
// moarCommands main file
// You should not include this file in a script, else you may encounter script errors, such as function conflict.
// To install the mod, you simply need to add 'moarCommands' in a new line in Mods.cfg
// Then, you need to add 'mc.as' in the script part of your gamemode.cfg
//
// This mC build was designed for build : 1387
//

namespace mc
{
	void setupCommonCommands(CRules@ this)
	{
		this.addCommandID("mc_strsend");
		this.addCommandID("mc_cmdsend");
	}

	void setupLoadSTD(CRules@ this)
	{
		this.AddScript("mc_pl_std_mc.as");
		this.AddScript("mc_pl_std_apidemo.as");
		this.AddScript("mc_pl_std_doc.as");
		this.AddScript("mc_pl_std_legacy.as");
		this.AddScript("mc_pl_std_spawn.as");
	}

	void setupLoadmE(CRules@ this)
	{
		this.AddScript("mc_pl_me_base.as");
	}
}

void onInit(CRules@ this)
{
	//CRules@ this = getRules();

	warn("moarCommands is initializing...");

	print("Initializing common commands");
	mc::setupCommonCommands(this);

	print("Loading handlers");

	if (getNet().isServer())
	{
		// We're removing the script first so we don't get a script running twice (not sure if done automatically)
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

	print("Initializing STD");
	mc::setupLoadSTD(this);
	print("Initializing moarEdit");
	mc::setupLoadmE(this);

	warn("moarCommands initialized.");
}

void onReload(CRules@ this)
{
	onInit(this);
}