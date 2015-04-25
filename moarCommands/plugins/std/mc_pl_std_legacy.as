#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_errorutil.as"

#include "mc_pl_std_doc_common.as"

// as ugly as the original ChatCommands.as. what did ya except :D

void onInit(CRules@ this)
{
	mc::registerCommand("killme", cmd_killme);
	mc::registerDoc("killme", "Kills the player calling the command.");

	mc::registerCommand("bot", cmd_spawnbot);
	mc::registerDoc("bot", "Spawns a bot.");

	mc::registerCommand("printblobs", cmd_printblobs);
	mc::registerDoc("printblobs", "Prints a blob list server side.");

	mc::registerCommand("spawnwater", cmd_spawnwater);
	mc::registerDoc("spawnwater", "Floods the tile at the player position.");

	mc::registerCommand("spawnfire", cmd_spawnfire);
	mc::registerDoc("spawnfire", "Burns the tile at the player position.");

	mc::registerCommand("coins", cmd_givecoins);
	mc::registerDoc("coins", "Gives coins to the player.");

	mc::registerCommand("team", cmd_team);
	mc::registerDoc("team", "Sets the current player team");

}

void onReload(CRules@ this)
{
	onInit(this);
}

void cmd_killme(string[] arguments, CPlayer@ fromplayer)
{
	CBlob@ blob = fromplayer.getBlob();

	if (blob !is null)
	{
		blob.server_Die();
	}
}

void cmd_spawnbot(string[] arguments, CPlayer@ fromplayer)
{
	if (arguments.size() == 0)
	{
		AddBot(getRandomName());
	}
	else
	{
		AddBot(arguments[0]);
	}
}

string getRandomName()
{
	const string[] names = {"Lance",
							"Henry",
							"Martin",
							"Claude",
							"Jean-Pierre",
							"Dildoman",
							"Nameless",
							"Bottybot",
							"Not a bot",
							"Sylvestre",
							"Arthur",
							"Lancelot",
							"Stanley",
							"Standing",
							"[Insert a cool name]",
							"Jacques",
							"Marie-Antoinnette",
							"Jean-Jean",
							"Jean Dujardin",
							"Wonderman",
							"Sandwich",
							"Fry",
							"Isaac",
							"Louis",
							"François",
							"John",
							"Max",
							"Ponyman",
							"Galen is pink",
							"Hellman"};

	return names[XORRandom(names.size())];
}

void cmd_printblobs(string[] arguments, CPlayer@ fromplayer)
{
	CBlob@[] all;
	getBlobs(@all);

	for (u32 i = 0; i < all.length; i++)
	{
		CBlob@ blob = all[i];
		CPlayer@ evplayer = blob.getPlayer();
		print("> "+blob.getName()+" [" + blob.getNetworkID() + "] " + ((evplayer !is null) ? ("(" + evplayer.getUsername() + ")") : ("")));
	}
}

void cmd_spawnwater(string[] arguments, CPlayer@ fromplayer)
{
	CBlob@ blob = fromplayer.getBlob();
	if (blob !is null)
	{
		getMap().server_setFloodWaterWorldspace(blob.getPosition(), true);
	}
	else
	{
		string[] errorargs = {"spawnwater"};
		mc::putError(fromplayer, "player_blobunknown", errorargs);
	}
}

void cmd_spawnfire(string[] arguments, CPlayer@ fromplayer)
{
	CBlob@ blob = fromplayer.getBlob();
	if (blob !is null)
	{
		getMap().server_setFireWorldspace(blob.getPosition(), true);
	}
	else
	{
		string[] errorargs = {"spawnfire"};
		mc::putError(fromplayer, "player_blobunknown", errorargs);
	}
}

void cmd_givecoins(string[] arguments, CPlayer@ fromplayer)
{
	if (arguments.size() == 0)
	{
		fromplayer.server_setCoins(fromplayer.getCoins() + 100);
	}
	else if (arguments.size() == 1)
	{
		fromplayer.server_setCoins(fromplayer.getCoins() + parseInt(arguments[0]));
	}
	else
	{
		string[] errorargs = {"coins", "!coins (amount)"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
	}
}

void cmd_team(string[] arguments, CPlayer@ fromplayer)
{
	if (arguments.size() == 0)
	{
		string[] errorargs = {"team", "!team [number]"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
	}
	else
	{
		CBlob@ blob = fromplayer.getBlob();
		if (blob !is null)
		{
			blob.server_setTeamNum(parseInt(arguments[0]));
		}
	}
}

void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}