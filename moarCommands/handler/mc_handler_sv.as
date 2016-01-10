//
// moarCommands server handler
// Catches server-sided events.
//

#define SERVER_ONLY

#include "mc_messageutil.as"
#include "mc_pluginutil.as"
#include "mc_errorutil.as"
#include "mc_modifierparse.as"

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
	mc::pluginList@ list = mc::getPluginList();
	list.hook_onChat(textIn, textOut, player);

	if (textIn[0] == 33) // 33 = '!'. TODO: Parameter
	{
		string command = mc::getCommand(textIn);

		mc::getMsg() << "Received command : " << command << " from player " << player << " (Whole : " << textIn << ")" << mc::endl;

		if (list.hook_onCommand(command, mc::parseModifiers(textIn), player))
			return false;

		string[] errorargs = {command, getCommandSuggestionFor(command)};
		mc::putError(player, "command_notfound", errorargs);

		return false;
	}
	
	return true;
}