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
			string[] none; // seems like there's no workaround to do this. that's not too ugly but i don't like that, duh.
			return none;
		}
		else
		{
			commandin = commandin.substr(spacepos + 1, -1);
			string[] arguments = commandin.split(" ");

			// Modifiers works like that : %modifier:arg1,arg2,arg3%

			for(u16 i = 0; i < arguments.size(); i++)
			{
				bool inmodifier = false;
				int modifierpos = -1;
	
				bool waitforval = false;
				int valpos = -1;

				bool waitforotherval = false;
				int othervalpos = -1;

				string modifiername;

				string[] modifierarguments;

				for (u16 j = 0; j < arguments[i].size(); j++)
				{
					if (arguments[i][j] == 37) // %
					{
						if (inmodifier)
						{
							if (modifiername != "")
							{
								modifiername == arguments[i].substr(modifierpos, j - modifierpos);
							}

							string modif;
							arguments[i] = arguments[i].substr(0, modifierpos) + modif + arguments[i].substr(modifierpos + modif.size() - 2, -1);

							if (waitforval)
							{
								string[] noarg;
								modif = getModifier(commandin.substr(modifierpos + 1, j - modifierpos - 1), noarg);
							}
							else
							{
								modif = getModifier(commandin.substr(modifierpos + 1, j - modifierpos - 1), modifierarguments);
							}

							j = modifierpos + modif.size() - 1;

							print(arguments[i]);

							// reset
							inmodifier = false;
							modifierpos = -1;

							waitforval = false;
							valpos = -1;

							waitforotherval = false;
							othervalpos = -1;
						}
						else
						{
							inmodifier = true;
							modifierpos = j;
	
							waitforval = true;
						}
					}
					else if (arguments[i][j] == 58) // :
					{
						if (inmodifier)
						{
							if (waitforval == false)
							{
								warn("Modifier parse error : Unexcepted token ':'");
							}
							else
							{
								modifiername = arguments[i].substr(modifierpos, j - modifierpos);

								waitforval = false;
								valpos = j;
							}
						}
					}
					else if (arguments[i][j] == 44) // ,
					{
	
					}
					else if (j == arguments[i].size() - 1)
					{
						if (inmodifier)
						{
							warn("Modifier parse error : Excepted token '%'");
						}
					}
				}
			}

			return arguments;
		}
	}

	string getModifier(string modifier, string[] arguments)
	{
		getMsg(null) << "Modifier detected. Modifier name : '" << modifier << "'. Arguments [" << arguments.size() << "] : " << arguments << rdy();
		return "nothing";
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