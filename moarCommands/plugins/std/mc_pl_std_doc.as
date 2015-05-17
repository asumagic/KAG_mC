#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_errorutil.as"

#include "mc_pl_std_doc_common.as"

void onInit(CRules@ this)
{
	mc::registerCommand("man", cmd_man);
	mc::registerDoc("man", "I have no idea why are you doing that.\nSyntax - !man [command]");
}

void onTick(CRules@ this)
{
	onInit(this);
}

void cmd_man(string[] arguments, CPlayer@ fromplayer)
{
	if (arguments.size() != 1)
	{
		string[] errorargs = {"man", "!man [command]"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
	}
	else
	{
		string man = mc::getMan(arguments[0]);
		mc::getMsg(fromplayer) << "= Manual entry for : " << arguments[0] << mc::rdy() << man << mc::rdy();
	}
}

void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}