#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_pl_me_common.as"
#include "mc_pl_me_brushes.as"

void onInit(CRules@ this)
{
	mc::registerCommand("me", cmd_me);
	mc::registerCommand("blockhelp", cmd_blockhelp); // defined in common
	mc::registerCommand("setblock", cmd_setblock);
	
	mc::registerCommand("brush", cmd_brush);
	mc::registerCommand("bsize", cmd_bsize);
	mc::registerCommand("btype", cmd_btype);
	mc::registerCommand("btile", cmd_btile);
}

void onReload(CRules@ this)
{
	onInit(this);
}

void cmd_me(string[] arguments, CPlayer@ fromplayer)
{
	mc::getMsg(fromplayer) << "== Welcome to moarEdit. ==" << mc::rdy()
						   << "= Fear not, child; thou shan't despair." << mc::rdy()
						   << "= For help with tile names use !blockhelp" << mc::rdy();
}

void cmd_setblock(string[] arguments, CPlayer@ fromplayer)
{
	CBlob@ blob = fromplayer.getBlob();
	if(blob is null)
	{
		mc::getMsg(fromplayer) << "Could not process command (player has no blob)" << mc::rdy(); //TODO: Use error classes after so it can be found easily
		return;
	}
	if(arguments.size() == 2)
	{
		int tile = StringToTile(arguments[1]);
		if(tile == -1)
			{mc::getMsg(fromplayer) << arguments[1] + " is not a proper tile" << mc::rdy(); return;}

		getMap().server_SetTile(blob.getAimPos(), tile);
	}
	else if(arguments.size() == 4)
	{
		int tile = StringToTile(arguments[1]);
		if(tile == -1)
			{mc::getMsg(fromplayer) << arguments[1] + " is not a proper tile" << mc::rdy(); return;}

		getMap().server_SetTile(Vec2f(parseFloat(arguments[2]), parseFloat(arguments[3])), tile);
	}
	else
	{
		mc::getMsg(fromplayer) << "Invalid arguments; proper usage: !setblock [tile] <x> <y>" << mc::rdy();
	}
}

void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}