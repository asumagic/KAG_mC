#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_errorutil.as"

#include "asulib.as"

#include "mc_pl_std_doc_common.as"

#include "mc_pl_me_common.as"
#include "mc_pl_me_brushes.as"

void onInit(CRules@ this)
{
	mc::registerCommand("me", cmd_me);
	mc::registerDoc("me", "moarEdit's main command. Features, for now, a little tutorial on using.");

	mc::registerCommand("blockhelp", cmd_blockhelp); // defined in common
	mc::registerDoc("blockhelp", "Prints a list of available blocks.");

	mc::registerCommand("picturebrushhelp", cmd_picturehelp);
	mc::registerDoc("picturebrushhelp", "Prints a list of available brushes, based on filename.");

	mc::registerCommand("setblock", cmd_setblock);
	mc::registerDoc("setblock", "Sets the specified block (You can get a list of those using !blockhelp) at the specified coordinates.");

	
	mc::registerCommand("brush", cmd_brush);
	mc::registerDoc("brush", "Toggles the mouse brush.");

	mc::registerCommand("bsize", cmd_bsize);
	mc::registerDoc("bsize", "Changes the mouse brush size.");

	mc::registerCommand("btype", cmd_btype);
	mc::registerDoc("btype", "Changes the mouse brush type. Available types : pixel, circle, square and picture.");

	mc::registerCommand("bpicture", cmd_bpic);
	mc::registerDoc("bpicture", "Changes the current image");

	mc::registerCommand("btile", cmd_btile);
	mc::registerDoc("btile", "Changes the mouse brush tile (You can get a list of those using !blockhelp).");

	mc::registerCommand("btileblob", cmd_bblob);
	mc::registerDoc("btileblob", "Changes the mouse brush tile (blob).");


	string[] err = {"block_notfound", "The block you specified ('%') was not found. Type !blockhelp to get a list of blocks."};
	mc::errorarray.push_back(err);

	string[] err2 = {"invalid_size", "The number you specified ('%') is invalid. Range : (% - %)"};
	mc::errorarray.push_back(err2);

	string[] err3 = {"invalid_brush", "The brush you specified ('%') was not found. Available brushes : %"};
	mc::errorarray.push_back(err3);
}

void onReload(CRules@ this)
{
	onInit(this);
}

void cmd_me(string[] arguments, CPlayer@ fromplayer)
{
	mc::getMsg(fromplayer) << "== Welcome to moarEdit. ==" << mc::rdy()
						   << "= Quick tutorial : " << mc::rdy()
						   << "= !brush allows you to turn on the mouse brush." << mc::rdy()
						   << "= !bsize [size] allows you to tweak the mouse brush size; from 1 to 10." << mc::rdy()
						   << "= !btype [brushmode] allows you to change the brush filling system. Type !btype alone to see the available ones." << mc::rdy()
						   << "= !btile [tile] allows you to change the mouse brush tile. Type !blockhelp for a list of those." << mc::rdy()
						   << "= !btileblob [blob] will also allow you to change the tile, but this time specifing a blob (i.e. spikes, etc.)." << mc::rdy()
						   << "= !setblock [tile] <x> <y> allows you to set a tile at the specified coordinates." << mc::rdy();
}

void cmd_setblock(string[] arguments, CPlayer@ fromplayer)
{
	CBlob@ blob = fromplayer.getBlob();
	if(blob is null)
	{
		string[] errorargs = {"setblock"};
		mc::putError(fromplayer, "player_blobunknown", errorargs);
		return;
	}
	if(arguments.size() == 1)
	{
		int tile = StringToTile(arguments[0]);
		if (tile == -1)
		{
			string[] errorargs = {arguments[0]};
			mc::putError(fromplayer, "block_notfound", errorargs);
		}

		getMap().server_SetTile(blob.getAimPos(), tile);
	}
	else if(arguments.size() == 3)
	{
		int tile = StringToTile(arguments[0]);
		if (tile == -1)
		{
			string[] errorargs = {arguments[0]};
			mc::putError(fromplayer, "block_notfound", errorargs);
		}

		if (!isNumber(arguments[1]))
		{
			string[] errorargs = {arguments[1]};
			mc::putError(fromplayer, "syntax_invalidnumber", errorargs);
			return;
		}
		else if (!isNumber(arguments[2]))
		{
			string[] errorargs = {arguments[2]};
			mc::putError(fromplayer, "syntax_invalidnumber", errorargs);
			return;
		}
		else
		{		
			getMap().server_SetTile(Vec2f(parseFloat(arguments[1]), parseFloat(arguments[2])), tile);
		}
	}
	else
	{
		string[] errorargs = {"setblock", "!setblock [tile] (x - y)"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
	}
}

void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}