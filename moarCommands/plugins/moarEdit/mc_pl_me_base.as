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
						   << "= Tutorial on using : " << mc::rdy()
						   << "= !brush allows you to turn on the mouse brush." << mc::rdy()
						   << "= !bsize [size] allows you to tweak the mouse brush size; from 1 to 10." << mc::rdy()
						   << "= !btype [brushmode] allows you to change the brush filling system. There are currently 3 : circle, square and pixel." << mc::rdy()
						   << "= !btile [tile] allows you to change the mouse brush tile. Type !blockhelp for a list of those." << mc::rdy()
						   << "= !setblock [tile] <x> <y> allows you to set a tile at the specified coordinates." << mc::rdy();
}

void cmd_setblock(string[] arguments, CPlayer@ fromplayer)
{
	CBlob@ blob = fromplayer.getBlob();
	if(blob is null)
	{
		mc::getMsg(fromplayer) << "Could not process command (player has no blob)" << mc::rdy(); //TODO: Use error classes after so it can be found easily
		return;
	}
	if(arguments.size() == 1)
	{
		int tile = StringToTile(arguments[0]);
		if(tile == -1)
			{mc::getMsg(fromplayer) << arguments[0] + " is not a proper tile" << mc::rdy(); return;}

		getMap().server_SetTile(blob.getAimPos(), tile);
	}
	else if(arguments.size() == 3)
	{
		int tile = StringToTile(arguments[0]);
		if(tile == -1)
			{mc::getMsg(fromplayer) << arguments[0] + " is not a proper tile" << mc::rdy(); return;}

		getMap().server_SetTile(Vec2f(parseFloat(arguments[1]), parseFloat(arguments[2])), tile);
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