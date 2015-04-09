#include "mc_commandutil.as"
#include "mc_messageutil.as"

#include "mc_pl_std_doc_common.as"

void onInit(CRules@ this)
{
	mc::registerCommand("demomsg", cmd_demomsg);
	mc::registerDoc("demomsg", "Part of the demolib - Prints a list showing up mC's msg classes capacities.");

	mc::registerCommand("demoargs", cmd_demoargs);
	mc::registerDoc("demoargs", "Part of the demolib - Prints a list of the entered arguments.");
}

void onReload(CRules@ this)
{
	onInit(this);
}

void cmd_demomsg(string[] arguments, CPlayer@ player)
{
	string[] stringarray = {"0", "1", "2", "3"};

	mc::getMsg(player) << "== mC demo : Message class overloads ==" << mc::rdy()
					   << "= Printing double : " << 36.7 << mc::rdy()
					   << "= Printing stringarray : " << stringarray << mc::rdy()
					   << "= Printing vector : " << Vec2f(364.6, 498.4) << mc::rdy()
					   << "= Printing color : " << SColor(255, 37, 79, 67) << mc::rdy()
					   << "= Printing player : " << player << mc::rdy()
					   << "= Printing map : " << getMap() << mc::rdy()
					   << "= Printing rules : " << getRules() << mc::rdy();
}

void cmd_demoargs(string[] arguments, CPlayer@ player)
{
	mc::getMsg(player) << "== mC demo : Arguments ==" << mc::rdy()
					   << "= Arguments : " << arguments.size() << mc::rdy()
					   << "= Argument listing : '" << arguments << "'" << mc::rdy();
}

void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}