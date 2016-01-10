//
// moarCommands utility
// Plugin
//
// Those are utils you may need to use when making your own command plugin.
// It allows you to register your plugin into the moarCommands engine.
//

#include "mc_messageutil.as"
#include "mc_securityutil.as"
#include "mc_pluginbase.as"

namespace mc
{
	string makeCommandManual(command@ cmd)
	{
		string ret = "!" + cmd.name;
		for (int i = 0; i < cmd.arguments.size(); i++)
		{
			ret += " " + cmd.arguments[i].manEntry;
		}
		return ret;
	}

	class pluginList
	{
		pluginList() {}

		plugin@[] plugins;

		command@ getMatchingCommand(const string command)
		{
			for (int i = 0; i < plugins.size(); i++)
			{
				for (int j = 0; j < plugins[i].commands.size(); j++)
				{
					if (plugins[i].commands[j].name == command)
					{
						return plugins[i].commands[j];
					}
					else
					{
						for (int k = 0; k < plugins[i].commands[j].aliases.size(); k++)
						{
							if (plugins[i].commands[j].aliases[k] == command)
							{
								return plugins[i].commands[j];
							}
						}
					}
				}
			}

			return null;
		}

		// @todo : An actual universal hook bridge would be better... Maybe a little hard to do in angelscript?
		bool hook_onChat(const string& in textIn, string& out textOut, CPlayer@ caster)
		{
			bool shouldDisplay = true;
			for (int i = 0; i < plugins.size(); i++)
				if (!plugins[i].onChat(textIn, textOut, caster))
					shouldDisplay = false;

			return shouldDisplay;
		}

		bool hook_onCommand(const string command, const string wholecommand, CPlayer@ caster)
		{
			command@ cmd = getMatchingCommand(command);

			if (cmd !is null)
			{
				if (isCommandAllowed(command, caster))
				{
					string[] arguments = getArguments(wholecommand);
					if (cmd.restrictArgumentCount)
					{
						if (cmd.acceptedCount.find(arguments.size()) == -1)
						{
							string[] errorargs = {command, makeCommandManual(cmd)};
							mc::putError(caster, "command_badarguments", errorargs);
							return true;
						}

						for (int i = 0; i < cmd.arguments.size(); i++)
						{
							if (i < arguments.size())
							{
								cmd.arguments[i].value = arguments[i];
							}
							else
							{
								cmd.arguments[i].value = cmd.arguments[i].defaultValue;
							}
						}
					}
					cmd.onCommand(caster);
				}
				else
				{
					string[] errorargs = {caster.getUsername(), "execute command " + command};
					mc::putError(caster, "security_norights", errorargs);
					return true;
				}

				return true;
			}
			
			return false;
		}
	};

	void registerPlugin(plugin@ plug)
	{
		pluginList@ list = getPluginList();

		getMsg() << "Registering plugin " << plug.name << " with " << plug.commands.size() << " command(s)" << endl;
		list.plugins.push_back(plug);

		setPluginList(list);

		plug.onPluginInit();
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
			string[] arguments = splitIgnoreQuotes(commandin, 0x20);

			return arguments;
		}
	}

	pluginList@ getPluginList()
	{
		pluginList@ list;
		getRules().get("mc_pluginlist", @list);
		return list;
	}

	void setPluginList(pluginList@ list)
	{
		getRules().set("mc_pluginlist", @list);
	}
}