// This is the script defining command functions. For the script describing brushing mechanics check mc_pl_me_brush_script.as

#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_pl_me_common.as"

enum BrushTypes
{
	Pixel,
	Circle,
	Square,
	Picture
}

string[] BrushNames = 
{
	"pixel",
	"circle",
	"square",
	"picture"
};

enum BrushFlags
{
	Regular,
	Fix,
	Grass,
	Overlay
}

string[] BrushFlagNames = 
{
	"regular"
	"fix",
	"grass",
	"overlay"
};

bool snapBlob(CBlob@ this)
{
	CMap@ map = getMap();

	Vec2f blobpos = map.getTileWorldPosition(map.getTileSpacePosition(this.getPosition()));
	this.setPosition(Vec2f(blobpos.x + (this.getWidth() / 2), blobpos.y + (this.getHeight() / 2)));

	if (this.isSnapToGrid())
	{
		return true;
	}
	else
	{
		return false;
	}
}

void setTile(meTile@ tile, Vec2f pos)
{
	if (tile.type == false) // tile
	{
		getMap().server_SetTile(pos, tile.id);
	}
	else // blob
	{
		CBlob@ blobrem = getMap().getBlobAtPosition(pos);
		if (blobrem !is null && blobrem.isSnapToGrid())
		{
			blobrem.server_Die();
		}

		CBlob@ placedblob = server_CreateBlob(tile.blob, tile.team, pos);
		if (snapBlob(placedblob))
		{
			CShape@ shape = placedblob.getShape();
			if (shape !is null)
			{
				shape.SetStatic(true);
			}
		}
	}
}

class meTile
{
	bool type;

	string blob;
	int id;

	int team;
};

void FillSquare(Vec2f pos, meTile@ tile, int size)
{
	CMap@ map = getMap();
	for(int y = -size; y <=size; y++)
	{
		for(int x = -size; x <= size; x++)
		{
			setTile(tile, pos + Vec2f(8*x, 8*y));
		}
	}
}

void FillCircle(Vec2f pos, meTile@ tile, int size)
{
	CMap@ map = getMap();
	for(int y = -size; y <=size; y++)
	{
		for(int x = -size; x <= size; x++)
		{
			if(Vec2f(x, y).LengthSquared() <= size ^ 2) setTile(tile, pos + Vec2f(8*x, 8*y));
		}
	}
}

void FillPicture(Vec2f pos, CFileImage@ picture, meTile@ tile, Vec2f crop)
{
	Vec2f picturemiddle = Vec2f(picture.getWidth() / 2, picture.getHeight() / 2);
	Vec2f cropmiddle = Vec2f(crop.x / 2, crop.y / 2);

	for(uint i = picturemiddle.x - cropmiddle.x; i < picturemiddle.x + cropmiddle.x; i++)
	{
		for(uint j = picturemiddle.y - cropmiddle.y; j < picturemiddle.y + cropmiddle.y; j++)
		{
			picture.setPixelPosition(Vec2f(i, j));

			if (picture.readPixel().getRed() != 0) // Only red matters since we just have booleans, e.g. there is a tile there or there is no tile there. No need to check other channels
			{
				setTile(tile, pos + Vec2f((i * 8) - picturemiddle.x * 8, (j * 8) - picturemiddle.y * 8));
			}
		}
	}
}