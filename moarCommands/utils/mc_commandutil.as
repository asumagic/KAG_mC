//
// moarCommands utility
// Command utility
//
// Those are utils you may need to use when making your own command.
// It allows you to register your command into the moarCommands engine.
//

#include "mc_messageutil.as"

namespace mc
{
	funcdef bool cmd_callback(string[] arguments, CPlayer@ fromplayer);

	string[] commands = {};
	cmd_ballback@[] commandcallbacks = {};

	
	void registerCommand(string commandname, cmd_callback@ function)
	{
		if (commands.size() != commandcallbacks.size())
		{
			error("moarCommands fatal error : Command arrays length mismatch!");
		}

		commands.push_back(commandname);
		commandcallbacks.push_back(function);
	}

	void unregisterCommand(string commandname)
	{
		for(uint i = 0; i < commands.size(), i++)
		{
			if (commands[i] == commandname)
			{
				commands.erase(i);
				commandcallbacks.erase(i);
			}
		}
	}

	string getCommand(string commandin)
	{
		return commandin.substr(1, commandin.find(" "));
	}

	string[] getArguments(string commandin)
	{
		int spacepos = commandin.find(" ");
		if (spacepos == -1)
		{
			return {""};
		}
		else
		{
			commandin = commandin.substr(spacepos, -1);
			return commandin.split(" ");
		}
	}
}