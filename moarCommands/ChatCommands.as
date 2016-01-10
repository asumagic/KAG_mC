//
// moarCommands main file
// You should not include this file in a script, else you may encounter script errors, such as function conflict.
// To install the mod, you simply need to add 'moarCommands' in a new line in Mods.cfg
// Then, you need to add 'mc.as' in the script part of your gamemode.cfg
//
// This mC build was designed for build : 1714
//

#include "mc_pluginutil.as"
#include "mc_modifierparse.as"

string[] std_scripts = {
						"mc_pl_cmd_helloworld",
						"mc_pl_cmd_core"
					   };

string[] std_modifier_scripts = {
						"mc_pl_mod_mc"
					   };

namespace mc
{
	void setupCommonCommands(CRules@ this)
	{
		this.addCommandID("mc_strsend");
	}

	void setupScripts(CRules@ this)
	{
		for (uint i = 0; i < std_scripts.size(); i++)
			this.AddScript(std_scripts[i]);

		for (uint i = 0; i < std_modifier_scripts.size(); i++)
			this.AddScript(std_modifier_scripts[i]);
	}

	void cleanScripts(CRules@ this)
	{
		for (uint i = 0; i < std_scripts.size(); i++)
			this.RemoveScript(std_scripts[i]);

		for (uint i = 0; i < std_modifier_scripts.size(); i++)
			this.RemoveScript(std_modifier_scripts[i]);
	}
}

void onInit(CRules@ this)
{
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
	// @todo localhost fucked up...
	if (getNet().isClient())
	{
		getRules().RemoveScript("mc_handler_cl.as");
		getRules().AddScript("mc_handler_cl.as");
	}

	print("Preparing plugins...");
	mc::setPluginList(mc::pluginList());

	print("Preparing modifiers...");
	mc::setModifierList(mc::modifierList());

	print("Loading scripts...");
	mc::setupScripts(this);

	warn("moarCommands initialized.");
}