#include "mc_pluginbase.as"
#include "mc_pluginutil.as"
#include "mc_messageutil.as"
#include "mc_version.as"

void onInit(CRules@ this)
{
	mc::registerPlugin(plugin_base());
}

class cmd_mc : mc::command
{
	cmd_mc()
	{
		name = "moarcommands";
		manEntry = "Shows basic information about mC and the plugins.";

		string[] aliasesTemp = {"mc"}; aliases = aliasesTemp;
	}

	void onCommand(CPlayer@ caster) override
	{
		mc::pluginList@ list = mc::getPluginList();

		int commandcount = 0;
		for (int i = 0; i < list.plugins.size(); i++)
			commandcount += list.plugins[i].commands.size();

		mc::getMsg(caster) << "moarCommands " << mc::version << " (API registered as " << mc::apiname << ")" << mc::endl
						   << "Plugin count : " << list.plugins.size() << " (" << commandcount << " command(s) in total)" << mc::endl
						   << "Use !help to get basic help and !plugins to get a plugin list." << mc::endl;
	}
};

class argm_page : mc::argument
{
	argm_page()
	{
		manEntry = "(pageid)";
		defaultValue = "1";
	}
};

int verifyPage(string text, int argmcount, CPlayer@ caster)
{
	if (!isNumber(text))
	{
		string[] errorargs = { text };
		mc::putError(caster, "syntax_invalidnumber", errorargs);
		return -1;
	}

	float asFloat = parseFloat(text);
	int i = (asFloat - 1) * 5;

	bool error = true;

	string[] errorargs = { text };

	if ((asFloat % 1) != 0) {
		errorargs.push_back("it is not a natural number");
	} else if (i < 0) {
		errorargs.push_back("it has to be positive and not null");
	} else if (i > argmcount) {
		errorargs.push_back("it is too high");
	} else {
		return i;
	}

	mc::putError(caster, "syntax_badnumber", errorargs);
	return -1;
}

class cmd_pluginlist : mc::command
{
	cmd_pluginlist()
	{
		name = "plugins";
		manEntry = "Lists plugins enabled and disabled";

		const string[] aliasesTemp = {"pluginlist", "plist"};		aliases = aliasesTemp;
		const int[] acceptedTemp = {0, 1};							acceptedCount = acceptedTemp;
		const mc::argument@[] argsTemp = { argm_page() };			arguments = argsTemp;
	}

	void onCommand(CPlayer@ caster) override
	{
		mc::pluginList@ list = mc::getPluginList();

		int at = verifyPage(arguments[0].value, list.plugins.size(), caster);
		if (at == -1)
			return;

		string build = "";

		for (int i = at; (i < list.plugins.size()) && (i < (at + 5)); i++)
		{
			build += "\n" + list.plugins[i].name + " - " + list.plugins[i].commands.size() + " command(s)";
		}

		mc::getMsg(caster) << "Available plugins (" << (at + 1) << " to " << (Maths::Min(list.plugins.size(), (at + 5))) << ")" << build << mc::endl;
	}
};

class argm_plugname : mc::argument
{
	argm_plugname()
	{
		manEntry = "[name]";
	}
};

class cmd_plugininfo : mc::command
{
	cmd_plugininfo()
	{
		name = "plugin";
		manEntry = "Gives general information about plugins";

		const string[] aliasesTemp = {"plugininfo", "pluginfo", "pinfo"};		aliases = aliasesTemp;
		const int[] acceptedTemp = {1, 2};										acceptedCount = acceptedTemp;
		const mc::argument@[] argsTemp = { argm_plugname(), argm_page() };		arguments = argsTemp;
	}

	void onCommand(CPlayer@ caster)
	{
		mc::pluginList@ list = mc::getPluginList();
		mc::plugin@ plug;

		for (int i = 0; i < list.plugins.size(); i++)
		{
			if (list.plugins[i].name == arguments[0].value)
				@plug = list.plugins[i];
		}

		if (plug !is null)
		{
			int at = verifyPage(arguments[1].value, plug.commands.size(), caster);
			if (at == -1)
				return;

			string build = "";
			for (int i = at; (i < plug.commands.size()) && (i < at + 5); i++)
			{
			}

			mc::getMsg(caster) << "Plugin info for '" << plug.name << "' :\nDescription : " << plug.description
							   << "\nAvailable commands (" << (at + 1) << " to " << (Maths::Min(plug.commands.size(), (at + 5))) << ") for the plugin :" << build << mc::endl;
		}
		else
		{
			string[] errorargs = { arguments[0].value };
			mc::putError(caster, "command_notfound_norecommend", errorargs);
			return;
		}
	}
};

class plugin_base : mc::plugin
{
	plugin_base()
	{
		name = "Core";
		description = "moarCommands base commands. It may be disabled since mC's behavior is not relying on this plugin.\nYet, please verify you aren't using its command before disabling it - Some are quite important to manage mC.";

		const mc::command@[] tempCommands = { cmd_mc(), cmd_pluginlist(), cmd_plugininfo() };
		commands = tempCommands;
	}
};