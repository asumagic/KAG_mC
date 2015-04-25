// This is the script defining command functions. For the script describing brushing mechanics check mc_pl_me_brush_script.as

#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_errorutil.as"

#include "asulib.as"

#include "mc_pl_me_common.as"
#include "mc_pl_me_brushes_common.as"

void toggle_brush(CPlayer@ fromplayer)
{
	CBlob@ blob = fromplayer.getBlob();
		if(blob is null)
		{
			string[] errorargs = {"brush"};
			mc::putError(fromplayer, "player_blobunknown", errorargs);
			return;
		}
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

void set_size(string argument, CPlayer@ fromplayer)
{
	int size;

	if (isNumber(argument))
	{
		size = parseInt(argument);
	}
	else
	{
		string[] errorargs = {argument};
		mc::putError(fromplayer, "syntax_invalidnumber", errorargs);
		return;
	}

	if(size < 1 || size > 10)
	{
		string[] errorargs = {"" + size, "0", "10"};
		mc::putError(fromplayer, "invalid_size", errorargs);
	}
	else
	{
		fromplayer.set_u8("brush size", size);
		mc::getMsg(fromplayer) << "Brush size set to " + size + "." << mc::rdy();
	}
}

void set_type(string argument, CPlayer@ fromplayer)
{
	int type = BrushNames.find(argument);

	if(type == -1 || type >= BrushNames.size())
	{
		string put;
		for (uint i = 0; i < BrushNames.size(); i++) {put += BrushNames[i] + ", ";}

		string[] errorargs = {argument, put};
		mc::putError(fromplayer, "invalid_brush", errorargs);
	}
	else
	{
		fromplayer.set_u8("brush type", type);
		mc::getMsg(fromplayer) << "Brush type set to " +BrushNames[type]+ "." << mc::rdy();
	}
}

void set_tile(string argument, CPlayer@ fromplayer)
{
	int tile = StringToTile(argument);

	if(tile == -1)
	{
		string[] errorargs = {argument};
		mc::putError(fromplayer, "block_notfound", errorargs);
	}
	else
	{
		fromplayer.set_u8("brush tile", tile);
		mc::getMsg(fromplayer) << "Brush tile set to " +tile+ " (" + argument +")." << mc::rdy();
	}
}

void set_flag(string argument, CPlayer@ fromplayer)
{
	int flag = BrushFlagNames.find(argument);

	if(flag == -1)
	{
		mc::getMsg(fromplayer) << "Invalid flag type. Type !blockhelp for a list of types." << mc::rdy();
	}
	else
	{
		fromplayer.set_u8("brush flag", flag);
		mc::getMsg(fromplayer) << "Brush flag set to " +flag + "." << mc::rdy();
	}
}

void cmd_brush(string[] arguments, CPlayer@ fromplayer)
{
	if(arguments.size() == 0)
	{
		toggle_brush(fromplayer);
	}
	else if(arguments.size() > 8)
	{
		mc::getMsg(fromplayer, true, SColor(255, 215, 123, 186))	<< "Too many arguments. Like, really, you've used over 8. That's like, much." << mc::rdy()
							   										<< "High chances are your country doesn't have this many centuries." << mc::rdy()
							   										<< "If you had a planet for each argument you used, you could make a planetary system bigger than ours." << mc::rdy()
							   										<< "You'd need a star and some asteroids too, but eight is still much." << mc::rdy()
							   										<< "Just consider setting up your brush with less than 8 arguments, all I'm asking for." << mc::rdy();
	}
	else
	{
		for(int i = 0; i < arguments.size(); i++)
		{
			// mC will give a tool for this. hang in there, son, we're coming!
			if(arguments[i].length < 3)
			{
				mc::getMsg(fromplayer) << "That's not how it works, mate. Arguments are <attribute>:<value>. That requires at least 3 characters if you ask me." << mc::rdy();
			}
			string attribute = arguments[i].substr(0, 1); // the format is !brush <attribute>:<value> in which attribute is 1 letter (s for size for instance)
			string value = arguments[i].substr(2, arguments[i].length - 2); // however value is not one letter
				 if(attribute == "s")
			{
				set_size(value, fromplayer);
			}
			else if(attribute == "t")
			{
				set_type(value, fromplayer);
			}
			else if(attribute == "b")
			{
				set_tile(value, fromplayer);
			}
			else if(attribute == "f")
			{
				set_flag(value, fromplayer);
			}
		}

		CBlob@ blob = fromplayer.getBlob();
		if(blob is null)
		{
			string[] errorargs = {"brush"};
			mc::putError(fromplayer, "player_blobunknown", errorargs);
			return;
		}

		if(!fromplayer.exists("brush on"))
		{
			blob.AddScript("mc_pl_me_brush_script.as");
			fromplayer.set_bool("brush on", true);
			mc::getMsg(fromplayer) << "Brush activated." << mc::rdy();
		}
		else if(fromplayer.get_bool("brush on"))
		{
			//we don't want to have it turn off, only change attributes in case of brush already on
		}
		else 
		{
			blob.AddScript("mc_pl_me_brush_script.as");
			fromplayer.set_bool("brush on", true);
			mc::getMsg(fromplayer) << "Brush activated." << mc::rdy();
		}	
	}
}

void cmd_bsize(string[] arguments, CPlayer@ fromplayer)
{
	if(arguments.size() != 1)
	{
		string[] errorargs = {"bsize", "!bsize [size]"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
		return;
	}

	int size;
	if (isNumber(arguments[0]))
	{
		size = parseInt(arguments[0]);
	}
	else
	{
		string[] errorargs = {arguments[0]};
		mc::putError(fromplayer, "syntax_invalidnumber", errorargs);
		return;
	}

	if(size < 1 || size > 10)
	{
		string[] errorargs = {"" + size, "0", "10"};
		mc::putError(fromplayer, "invalid_size", errorargs);
		return;
	}

	fromplayer.set_u8("brush size", size);
	mc::getMsg(fromplayer) << "Brush size set to " + size + "." << mc::rdy();
}

void cmd_btype(string[] arguments, CPlayer@ fromplayer)
{
	if(arguments.size() != 1)
	{
		string[] errorargs = {"btype", "!btype [type]"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
		return;
	}

	int type = BrushNames.find(arguments[0]);

	if(type == -1 || type >= BrushNames.size())
	{
		string[] errorargs = {arguments[0]};
		mc::putError(fromplayer, "invalid_brush", errorargs);
		return;
	}

	fromplayer.set_u8("brush type", type);
	mc::getMsg(fromplayer) << "Brush type set to " + BrushNames[type] + "." << mc::rdy();
}

void cmd_btile(string[] arguments, CPlayer@ fromplayer)
{
	if(arguments.size() != 1)
	{
		string[] errorargs = {"btile", "!bile [tile]"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
		return;
	}

	int tile = StringToTile(arguments[0]);

	if(tile == -1)
	{
		string[] errorargs = {arguments[0]};
		mc::putError(fromplayer, "block_notfound", errorargs);
		return;
	}

	fromplayer.set_u8("brush tile", tile);
	fromplayer.set_bool("brush mode", false);
	mc::getMsg(fromplayer) << "Brush tile set to " << tile << "." << mc::rdy();
}

void cmd_bblob(string[] arguments, CPlayer@ fromplayer)
{
	if(arguments.size() != 1)
	{
		string[] errorargs = {"bblobtile", "!bblobtile [blobtile]"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
		return;
	}

	CBlob@ blob = server_CreateBlob(arguments[0]);
	if (blob is null)
	{
		string[] errorargs = {"btileblob"};
		mc::putError(fromplayer, "blob_unknown", errorargs);
		return;
	}

	snapBlob(blob);
	
	if (!blob.isSnapToGrid())
	{
		mc::getMsg(fromplayer, true, SColor(255, 150, 100, 25)) << "Blob found, but does not seem to be a proper tile. Still proceeding, even though you may be encountering strange issues." << mc::rdy();
	}

	fromplayer.set_string("brush blob", arguments[0]);
	fromplayer.set_bool("brush mode", true);
	mc::getMsg(fromplayer) << "Brush blob set to " << arguments[0] << "." << mc::rdy();
}

void cmd_bpic(string[] arguments, CPlayer@ fromplayer)
{
	if (arguments.size() != 1)
	{
		string[] errorargs = {"bpicture", "!bpicture [picturebrush]"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
	}
	else
	{
		fromplayer.set_string("brush picture", arguments[0]);
	}
}