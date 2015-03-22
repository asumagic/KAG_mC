//
// moarCommands server handler
// Catches server-sided events.
//

#define SERVER_ONLY

#include "mc_messageutil.as"

void onInit(CRules@ this)
{
	print("Loading server script...");
}

void onReload(CRules@ this)
{
	onInit(this);
	mc::getMsg("AsuMagic") << "Hello, Asu!" << mc::rdy() << "This is yet another message. Cool, eh?" << mc::rdy();
}