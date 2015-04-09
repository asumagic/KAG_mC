#include "mc_commandutil.as"
#include "mc_messageutil.as"

#include "mc_pl_std_doc_common.as"

void onInit(CRules@ this)
{
	mc::registerCommand("man", cmd_man);
	mc::registerDoc("man", "I have no idea why are you doing that.");
}

void onReload(CRules@ this)
{
	onInit(this);
}

void cmd_man(string[] arguments, CPlayer@ fromplayer)
{
	if (arguments.size() != 1)
	{
		mc::getMsg(fromplayer) << "Please use !man [command]" << mc::rdy(); // shout at him
	}
	else
	{
		string man = mc::getMan(arguments[0]);
		mc::getMsg(fromplayer) << "= Command manual for : " << arguments[0] << mc::rdy() << man << mc::rdy();
	}
}

void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}