//
// moarCommands server handler
// Catches server-sided events.
//

#define SERVER_ONLY

#include "mc_messageutil.as"
#include "mc_commandutil.as"
#include "mc_errorutil.as"

void onInit(CRules@ this)
{
	print("Loading server script...");
}

string getCommandSuggestionFor(string command)
{
	// TODO : Make this wayyy better (recongizion engine?)
	return "!s " + command;
}

bool onServerProcessChat(CRules@ this, const string &in textIn, string &out textOut, CPlayer@ player)
{
	if (textIn[0] == 33) // 33 = '!'. TODO: Parameter
	{
		string command = mc::getCommand(textIn);
		warn("Received command : '" + command + "'");

		mc::syncGetCommands();
		for(u16 ccom = 0; ccom < mc::commands.size(); ccom++)
		{
			if (mc::commands[ccom] == command)
			{
				mc::sendCommand(command, textIn, player);
				return false;
			}
		}

		string[] errorargs = {command, getCommandSuggestionFor(command)};
		mc::putError(player, "command_notfound", errorargs);

		return false;
	}


	return true;
}