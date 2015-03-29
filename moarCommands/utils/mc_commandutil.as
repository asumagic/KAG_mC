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
	funcdef void cmd_callback(string[] arguments, CPlayer@ fromplayer);

	string[] commands;
	string[] localcommands;
	cmd_callback@[] commandcallbacks;
	
	void registerCommand(string commandname, cmd_callback@ function)
	{
		syncGetCommands();

		print("Registering command '" + commandname + "'...");

		if (localcommands.size() != commandcallbacks.size())
		{
			error("moarCommands fatal error : Command arrays length mismatch!");
		}

		unregisterCommand(commandname);

		commands.push_back(commandname);
		localcommands.push_back(commandname);
		commandcallbacks.push_back(function);

		syncSetCommands();
	}

	void unregisterCommand(string commandname)
	{
		syncGetCommands();

		for(uint i = 0; i < commands.size(); i++)
		{
			if (commands[i] == commandname)
			{
				commands.erase(i);
				commandcallbacks.erase(i);
			}
		}

		syncSetCommands();
	}

	void sendCommand(string command, string wholecommand, CPlayer@ invoker)
	{
		if (invoker is null)
		{
			return;
		}

		CBitStream data;
		data.write_string(command);
		data.write_string(wholecommand);
		data.write_u16(invoker.getNetworkID());

		getRules().SendCommand(getRules().getCommandID("mc_cmdsend"), data);
	}

	string getCommand(string commandin)
	{
		return commandin.substr(1, commandin.find(" ") - 1);
	}

	string[] getArguments(string commandin)
	{
		int spacepos = commandin.find(" ");
		if (spacepos == -1)
		{
			string[] none; // workaround
			return none;
		}
		else
		{
			commandin = commandin.substr(spacepos, -1);
			return commandin.split(" ");
		}
	}

	void catchCommand(CRules@ this, u8 cmd, CBitStream@ data)
	{
		if (cmd == this.getCommandID("mc_cmdsend"))
		{
			string commandname = data.read_string();
			for(u16 i = 0; i < mc::localcommands.size(); i++)
			{
				if (commandname == mc::localcommands[i])
				{
					string wholecommand = data.read_string();
					CPlayer@ invoker = getPlayerByNetworkId(data.read_u16());
					
					mc::commandcallbacks[i](mc::getArguments(wholecommand), invoker);
				}
			}
		}
	}

	void syncSetCommands()
	{
		getRules().set("mc_commands", commands);
	}

	void syncGetCommands()
	{
		getRules().get("mc_commands", commands);
	}
}