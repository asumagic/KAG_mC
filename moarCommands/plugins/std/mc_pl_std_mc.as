#include "mc_commandutil.as"
#include "mc_messageutil.as"

void onInit(CBlob@ this)
{
	mc::registerCommand("mc", cmd_mc);
	mc::registerCommand("help", cmd_help);
	mc::registerCommand("commands", cmd_commands);
}

void onReload(CBlob@ this)
{
	onInit(this);
}

bool cmd_mc(string[] arguments, CPlayer@ fromplayer)
{
	mc::getMsg(fromplayer) << "== Welcome to a moarCommands powered server. ==" << mc::rdy()
						   << "= If you see this, mC is active and working." << mc::rdy()
						   << "= For help, type !help." << mc::rdy();
	return true;
}

bool cmd_help(string[] arguments, CPlayer@ fromplayer)
{
	mc::getMsg(fromplayer) << "== Help ==" << mc::rdy()
						   << "= No help yet. Sorry! Type !commands for a list of commands." << mc::rdy();
	return true;
}

bool cmd_commands(string[] arguments, CPlayer@ fromplayer)
{
	mc::syncGetCommands();
	string commands = "";

	for(u16 command = 0; command < mc::commands.size(); command++)
	{
		commands += mc::commands[command];
		commands += ", ";
	}

	mc::getMsg(fromplayer) << "== Commands ==" << mc::rdy()
						   << "= Commands : " << ""+mc::commands.size() << mc::rdy()
						   << "= " << commands << mc::rdy();

	return true;
}

void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}