#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_errorutil.as"

#include "mc_pl_std_doc_common.as"

void onInit(CRules@ this)
{
	mc::registerCommand("s", cmd_spawn);
	mc::registerDoc("s", "Spawns a blob.");
}

void onReload(CRules@ this)
{
	onInit(this);
}

// !s [blobname] <team> <x> <y>
void cmd_spawn(string[] arguments, CPlayer@ fromplayer)
{
	Vec2f pos = Vec2f_zero;
	int teamid = -1;
	string name;

	if (arguments.size() == 1)
	{
		name = arguments[0];
		CBlob@ blob = fromplayer.getBlob();
		if (blob !is null)
		{
			teamid = blob.getTeamNum();
			pos = blob.getPosition();
		}
	}
	else if (arguments.size() == 2)
	{
		name = arguments[0];
		CBlob@ blob = fromplayer.getBlob();
		if (blob !is null)
		{
			teamid = parseInt(arguments[1]);
			pos = blob.getPosition();
		}
	}
	else if (arguments.size() == 4)
	{
		name = arguments[0];
		CBlob@ blob = fromplayer.getBlob();
		if (blob !is null)
		{
			teamid = parseInt(arguments[1]);
			pos = Vec2f(parseFloat(arguments[2]), parseFloat(arguments[3]));
		}
	}
	else if (arguments.size() > 4)
	{
		name = arguments[0];
		CBlob@ blob = fromplayer.getBlob();
		if (blob !is null)
		{
			teamid = parseInt(arguments[1]);
			pos = Vec2f(parseFloat(arguments[2]), parseFloat(arguments[3]));
		}
	}
	else
	{
		string[] errorargs = {"s", "!s [blobname] (team) (x - y) (scripts)"};
		mc::putError(fromplayer, "command_badarguments", errorargs);
		return;
	}

	if (!getSecurity().checkAccess_Feature(fromplayer, "mc_restrict_" + name))
	{
		CBlob@ spawned = server_CreateBlob(name, teamid, pos);

		if (spawned is null)
		{
			string[] errorargs = {name};
			mc::putError(fromplayer, "blob_unknown", errorargs);
		}
		else
		{
			for(uint i = 4; i < arguments.size(); i++)
			{
				spawned.AddScript(arguments[i]);
			}
		}
	}
	else
	{
		string[] errorargs = {fromplayer.getUsername(), "create blob " + name};
		mc::putError(fromplayer, "security_norights", errorargs);
	}
}

void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}