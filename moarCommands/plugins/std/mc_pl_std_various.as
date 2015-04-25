#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_errorutil.as"

#include "mc_pl_std_doc_common.as"

// Bison taming
#include "AnimalConsts.as";

void onInit(CRules@ this)
{
	mc::registerCommand("settod", cmd_tod);
	mc::registerDoc("settod", "Sets the time of day.");

	mc::registerCommand("tame", cmd_tame);
	mc::registerDoc("tame", "Tames bisons in radius.");

	mc::registerCommand("matchstate", cmd_matchstate);
	mc::registerDoc("matchstate", "Sets the match state.");
}

void onReload(CRules@ this)
{
	onInit(this);
}

void cmd_tod(string[] arguments, CPlayer@ fromplayer)
{
	if (arguments.size() != 1)
	{
		string[] errorargs = {"tod", "!tod [time](h)"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
	}
	else
	{
		if (arguments[0].find("h") != -1)
		{
			float time = parseFloat(arguments[0]) / 24;

			mc::getMsg(fromplayer) << "Time set to " << time * 24 << " hours" << mc::rdy();
			getMap().SetDayTime(time);
		}
		else
		{
			float time = parseFloat(arguments[0]);

			mc::getMsg(fromplayer) << "Time set to " << time * 24 << " hours" << mc::rdy();
			getMap().SetDayTime(time);
		}
	}
}

void TameInRadius(Vec2f position, float maxradius, CBlob@ owner)
{
	CBlob@[] bisons;
	getBlobsByName("bison", bisons); // y geri y

	float poslength = position.getLength();

	for (uint i = 0; i < bisons.size(); i++)
	{
		if (Maths::Abs(bisons[i].getPosition().getLength() - poslength) < maxradius)
		{
			bisons[i].set_u8(state_property, MODE_FRIENDLY);
			bisons[i].set_netid(friend_property, owner.getNetworkID());
		}
	}
}

void cmd_tame(string[] arguments, CPlayer@ fromplayer)
{
	if (arguments.size() == 0)
	{
		CBlob@ playerblob = fromplayer.getBlob();
		if (playerblob !is null)
		{
			TameInRadius(playerblob.getPosition(), 256.f, playerblob);
		}
		else
		{
			string[] errorargs = {"tame"};
			mc::putError(fromplayer, "player_blobunknown", errorargs);
		}
	}
	else if (arguments.size() == 1)
	{
		// code copy paste? n-no
		CBlob@ playerblob = fromplayer.getBlob();
		if (playerblob !is null)
		{
			TameInRadius(playerblob.getPosition(), parseFloat(arguments[0]), playerblob);
		}
		else
		{
			string[] errorargs = {"tame"};
			mc::putError(fromplayer, "player_blobunknown", errorargs);
		}
	}
	else
	{
		string[] errorargs = {"tame", "!tame (radius)"};
		mc::putError(fromplayer, "player_blobunknown", errorargs);
	}
}

void cmd_matchstate(string[] arguments, CPlayer@ fromplayer)
{
	if (arguments.size() == 1)
	{
		uint state = GAME;

		if 		(arguments[0] == "warmup")		state = WARMUP;
		else if (arguments[0] == "gameover")	state = GAME_OVER;
		else									state = GAME;

		getRules().SetCurrentState(state);

		mc::getMsg(fromplayer) << "Match state set to " << arguments[0] << mc::rdy();
	}
	else
	{
		string[] errorargs = {"matchstate", "!matchstate [warmup|gameover|game]"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
	}
}

void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}