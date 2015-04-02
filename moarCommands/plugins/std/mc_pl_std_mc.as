#include "mc_commandutil.as"
#include "mc_messageutil.as"

void onInit(CRules@ this)
{
	mc::registerCommand("mc", cmd_mc);
	mc::registerCommand("help", cmd_help);
	mc::registerCommand("commands", cmd_commands);
}

void onReload(CRules@ this)
{
	onInit(this);
}

void cmd_mc(string[] arguments, CPlayer@ fromplayer)
{
	mc::getMsg(fromplayer) << "== Welcome to a moarCommands powered server. ==" << mc::rdy()
						   << "= If you see this, mC is active and working." << mc::rdy()
						   << "= For help, type !help." << mc::rdy();
}

void cmd_help(string[] arguments, CPlayer@ fromplayer)
{
	mc::getMsg(fromplayer) << "== Help ==" << mc::rdy()
						   << "= Type !commands for a list of commands." << mc::rdy()
						   << "= moarCommands can be used the same way as the regular commands." << mc::rdy();
}

void cmd_commands(string[] arguments, CPlayer@ fromplayer)
{
	mc::syncGetCommands();
	string commands = "";

	mc::getMsg(fromplayer) << "== Commands ==" << mc::rdy()
						   << "= Listing commands [" << mc::commands.size() << "] : " << mc::commands << mc::rdy();
}

void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}