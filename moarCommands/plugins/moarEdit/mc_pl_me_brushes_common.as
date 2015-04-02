// This is the script defining command functions. For the script describing brushing mechanics check mc_pl_me_brush_script.as

#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_pl_me_common.as"

enum BrushTypes
{
	Pixel,
	Circle,
	Square
}

string[] BrushNames = 
{
	"pixel",
	"circle",
	"square"
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

void FillSquare(Vec2f pos, int tile, int size)
{
	CMap@ map = getMap();
	for(int y = -size; y <=size; y++)
	{
		for(int x = -size; x <= size; x++)
		{
			map.server_SetTile(pos + Vec2f(8*x, 8*y), tile);
		}
	}
}

void FillCircle(Vec2f pos, int tile, int size)
{
	CMap@ map = getMap();
	for(int y = -size; y <=size; y++)
	{
		for(int x = -size; x <= size; x++)
		{
			if(Vec2f(x, y).LengthSquared() <= size * size)map.server_SetTile(pos + Vec2f(8*x, 8*y), tile);
		}
	}
}

