#include "mc_pluginbase.as"
#include "mc_pluginutil.as"
#include "mc_messageutil.as"

void onInit(CRules@ this)
{
	mc::registerPlugin(plugin_helloworld());
}

class command_helloworld : mc::command
{
	command_helloworld()
	{
		name = "helloworld";
		manEntry = "Prints an hello world message";
	}

	void onCommand(CPlayer@ caster) override
	{
		mc::getMsg(caster, true) << "Hello, " << caster.getUsername() << "!" << mc::endl;
	}
};

class plugin_helloworld : mc::plugin
{
	plugin_helloworld()
	{
		name = "Hello World";
		description = "This is a simple hello world plugin. !helloworld should print 'Hello, <username>!'";

		commands.push_back(command_helloworld());
	}
};