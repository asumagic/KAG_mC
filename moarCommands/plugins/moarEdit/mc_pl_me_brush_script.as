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
	uint tile = player.get_u8("brush tile");

	if(left_click)
	{
		if(type == BrushTypes::Pixel)
		{
			getMap().server_SetTile(this.getAimPos(), tile);
		}
		else if(type == BrushTypes::Circle)
		{
			FillCircle(this.getAimPos(), tile, size);
		}
		else if(type == BrushTypes::Square)
		{
			FillSquare(this.getAimPos(), tile, size);
		}
	}
}