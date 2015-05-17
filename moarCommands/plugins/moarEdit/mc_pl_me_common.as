#include "mc_commandutil.as"
#include "mc_messageutil.as"

int[] tiles = 
{
	CMap::tile_empty,
    CMap::tile_ground,
    CMap::tile_ground_back,
    CMap::tile_grass,
    CMap::tile_castle,
    CMap::tile_castle_moss,
    CMap::tile_castle_back,
    CMap::tile_castle_back_moss,
    CMap::tile_gold,
    CMap::tile_stone,
    CMap::tile_thickstone,
    CMap::tile_bedrock,
    CMap::tile_wood
};

string[] tilenames = 
{
	"empty",
	"ground",
	"ground_back",
	"grass",
	"castle",
	"castle_moss",
	"castle_back",
	"castle_back_moss",
	"gold",
	"stone",
	"thickstone",
	"bedrock",
	"wood"
};

int StringToTile(string tilename)
{
	for(int i = 0; i<tiles.size(); i++)
	{
		if(tilename == tilenames[i])
		{
			return tiles[i];
		}
	}
	return -1;
}

void cmd_blockhelp(string[] arguments, CPlayer@ fromplayer)
{
	mc::getMsg(fromplayer) << "Block names [" +tilenames.size()+"]: " << tilenames << mc::rdy();
}

void cmd_picturehelp(string[] arguments, CPlayer@ fromplayer) // broken.
{
	string[] picturebrushes;
	CFileMatcher brushmatcher("brush_");

	while (brushmatcher.iterating())
	{
		picturebrushes.push_back(brushmatcher.getCurrent());
	}

	mc::getMsg(fromplayer) << "Block names [" +picturebrushes.size()+"]: " << picturebrushes << mc::rdy();
}