#include "mc_modifierparse.as"
#include "mc_version.as"

void onInit(CRules@ this)
{
	mc::registerModifier(mod_getversion());
	mc::registerModifier(mod_getAPIname());
}

class mod_getversion : mc::modifierFunctionHolder
{
	mod_getversion()
	{
		name = "version";
		manEntry = "Returns the current moarCommands version.";
	}

	string f(string[] arguments) override
	{
		return mc::version;
	}
}

class mod_getAPIname : mc::modifierFunctionHolder
{
	mod_getAPIname()
	{
		name = "getAPIName";
		manEntry = "Returns the plugin API name.";
	}

	string f(string[] arguments) override
	{
		return mc::apiname;
	}
}