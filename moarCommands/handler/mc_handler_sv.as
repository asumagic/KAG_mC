//
// moarCommands server handler
// Catches server-sided events.
//

#define SERVER_ONLY

#include "mc_messageutil.as"
#include "mc_commandutil.as"

void onInit(CRules@ this)
{
	print("Loading server script...");
}

void onReload(CRules@ this)
{
	onInit(this);
}

bool onServerProcessChat(CRules@ this, const string &in textIn, string &out textOut, CPlayer@ player)
{
	if (textIn[0] == 33) // 33 = '!'. TODO: Parameter
	{
		string command = mc::getCommand(textIn);
		warn("Received command : '" + command + "'");

		mc::sendCommand(command, textIn, player);
	}

	return true;
}