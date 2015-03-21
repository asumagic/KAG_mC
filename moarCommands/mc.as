//
// moarCommands main file
// You should not include this file in a script, else you may encounter script errors, such as function conflict.
// To install the mod, you simply need to add 'moarCommands' in a new line in Mods.cfg
// Then, you need to add 'mc.as' in the script part of your gamemode.cfg
//
// This mC build was designed for build : 1387
//

#include "mc_handler_cl.as"
#include "mc_handler_sv.as"

#include "mc_messageutil.as"

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

	if (getNet().isClient())
	{
		onClInit(this);
	}
	else
	{
		onSvInit(this);
	}

	mc::getMsg() << "Hello world" << mc::rdy();
	mc::getMsg(getPlayerByUsername("AsuMagic")) << "Hello, mate!" << mc::rdy();

	warn("moarCommands initialized.");
}

void onReload(CRules@ this)
{
	warn("moarCommands reloading...");
	onInit(this);
}