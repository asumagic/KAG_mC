#include "mc_commandutil.as"
#include "mc_messageutil.as"

#include "mc_pl_std_doc_common.as"

void onInit(CRules@ this)
{
	mc::registerCommand("settod", cmd_tod);
	mc::registerDoc("settod", "Sets the time of day.");

	
}

void onReload(CRules@ this)
{
	onInit(this);
}

void cmd_tod(string[] arguments, CPlayer@ fromplayer)
{
	if (arguments.size() != 1)
	{
		mc::getMsg(fromplayer) << "Usage : !settod [time]" << mc::rdy();
	}
	else
	{
		if (arguments[0].find("h") != -1)
		{
			float time = parseFloat(arguments[0]) / 24;

			mc::getMsg(fromplayer) << "Time set to " << time * 24 << " hours" << mc::rdy();
			getMap().SetDayTime(time);
		}
		else
		{
			float time = parseFloat(arguments[0]);

			mc::getMsg(fromplayer) << "Time set to " << time * 24 << " hours" << mc::rdy();
			getMap().SetDayTime(time);
		}
	}
}

void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}