// This is the script defining command functions. For the script describing brushing mechanics check mc_pl_me_brush_script.as

#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_pl_me_common.as"
#include "mc_pl_me_brushes_common.as"

void cmd_brush(string[] arguments, CPlayer@ fromplayer)
{
	CBlob@ blob = fromplayer.getBlob();
	if(blob is null) mc::getMsg(fromplayer) << "Could not turn on brush; Player has no blob" << mc::rdy();
	if(!fromplayer.exists("brush on"))
	{
		blob.AddScript("mc_pl_me_brush_script.as");
		fromplayer.set_bool("brush on", true);
		mc::getMsg(fromplayer) << "Brush activated." << mc::rdy();
	}
	else if(fromplayer.get_bool("brush on"))
	{
		blob.RemoveScript("mc_pl_me_brush_script.as");
		fromplayer.set_bool("brush on", false);		
		mc::getMsg(fromplayer) << "Brush deactivated." << mc::rdy();
	}
	else 
	{
		blob.AddScript("mc_pl_me_brush_script.as");
		fromplayer.set_bool("brush on", true);
		mc::getMsg(fromplayer) << "Brush activated." << mc::rdy();
	}
}

void cmd_bsize(string[] arguments, CPlayer@ fromplayer)
{
	if(arguments.size() != 2)
	{
		mc::getMsg(fromplayer) << "Invalid arguments; proper usage: !bsize [size]" << mc::rdy();
		return;
	}

	int size = parseInt(arguments[1]);

	if(size < 1 || size > 10)
	{
		mc::getMsg(fromplayer) << "Brush size invalid (must be an integer from 1 to 10)" << mc::rdy();
		return;
	}

	fromplayer.set_u8("brush size", size);
	mc::getMsg(fromplayer) << "Brush size set to " + size + "." << mc::rdy();
}

void cmd_btype(string[] arguments, CPlayer@ fromplayer)
{
	if(arguments.size() != 2)
	{
		mc::getMsg(fromplayer) << "Invalid arguments; proper usage: !btype [type]. Available types are: " << BrushNames << mc::rdy();
		return;
	}

	int type = BrushNames.find(arguments[1]);

	if(type == -1 || type >= BrushNames.size())
	{
		mc::getMsg(fromplayer) << "Invalid brush type. Available types are: " << BrushNames << mc::rdy();
		return;
	}

	fromplayer.set_u8("brush type", type);
	mc::getMsg(fromplayer) << "Brush type set to " +BrushNames[type]+ "." << mc::rdy();
}

void cmd_btile(string[] arguments, CPlayer@ fromplayer)
{
	if(arguments.size() != 2)
	{
		mc::getMsg(fromplayer) << "Invalid arguments; proper usage: !btile [tile]. Available types are: " << tilenames << mc::rdy();
		return;
	}

	int tile = StringToTile(arguments[1]);

	if(tile == -1)
	{
		mc::getMsg(fromplayer) << "Invalid tile type. Type !blockhelp for a list of types." << mc::rdy();
		return;
	}

	fromplayer.set_u8("brush tile", tile);
	mc::getMsg(fromplayer) << "Brush tile set to " +tile+ "." << mc::rdy();
}