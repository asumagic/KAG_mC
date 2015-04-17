// This is the script ran on CBlob. For command definitions see mc_pl_me_brushes.as

#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_pl_me_brushes_common.as"

void onInit( CBlob@ this )
{
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick( CBlob@ this )
{
	CPlayer@ player = this.getPlayer();

	if(player is null)
	{
		this.getCurrentScript().runFlags |= Script::remove_after_this;
		return;
	}

	bool left_click = this.isKeyPressed( key_action1 );
	uint size = player.get_u8("brush size");
	uint type = player.get_u8("brush type");

	bool tilemode = player.get_bool("brush mode");
	uint tile = player.get_u8("brush tile");
	string blobname = player.get_string("brush blob");

	meTile rtile;
	rtile.type = tilemode;
	rtile.id = tile;
	rtile.blob = blobname;
	rtile.team = player.getBlob().getTeamNum();

	if(left_click)
	{
		if (type == BrushTypes::Pixel)
		{
			setTile(rtile, this.getAimPos());
		}
		else if (type == BrushTypes::Circle)
		{
			FillCircle(this.getAimPos(), rtile, size);
		}
		else if (type == BrushTypes::Square)
		{
			FillSquare(this.getAimPos(), rtile, size);
		}
		else if (type == BrushTypes::Picture)
		{
			CFileImage picturebrush(player.get_string("brush picture"));
			if (picturebrush.isLoaded())
			{
				FillPicture(this.getAimPos(), picturebrush, rtile, Vec2f(size, size));
			}
		}
	}
}

void onDie( CBlob@ this )
{
	CPlayer@ player = this.getPlayer();
	if(player !is null)
	{
		player.set_bool("brush on", false);		
		mc::getMsg(player) << "Brush deactivated." << mc::rdy();
	}
}