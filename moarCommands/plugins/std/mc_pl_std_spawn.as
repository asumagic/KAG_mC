#include "mc_commandutil.as"
#include "mc_messageutil.as"
#include "mc_errorutil.as"

#include "asulib.as"

#include "mc_pl_std_doc_common.as"

void onInit(CRules@ this)
{
	mc::registerCommand("s", cmd_spawn);
	mc::registerDoc("s", "Spawns a blob.\nSyntax - !s [blobname] (team) (x - y) (scripts)");
}

void onTick(CRules@ this)
{
	onInit(this);
}

// !s [blobname] <team> <x> <y> (scripts)
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
			if (isNumber(arguments[1]))
			{
				teamid = parseInt(arguments[1]);
			}
			else
			{
				string[] errorargs = {arguments[1]};
				mc::putError(fromplayer, "syntax_invalidnumber", errorargs);
				return;
			}
			pos = blob.getPosition();
		}
	}
	else if (arguments.size() >= 4)
	{
		name = arguments[0];
		if (isNumber(arguments[1]))
		{
			teamid = parseInt(arguments[1]);
		}
		else
		{
			string[] errorargs = {arguments[1]};
			mc::putError(fromplayer, "syntax_invalidnumber", errorargs);
			return;
		}

		float pos1;
		if (isNumber(arguments[2]))
		{
			pos1 = parseFloat(arguments[2]);
		}
		else
		{
			string[] errorargs = {arguments[2]};
			mc::putError(fromplayer, "syntax_invalidnumber", errorargs);
			return;
		}

		float pos2;
		if (isNumber(arguments[3]))
		{
			pos2 = parseFloat(arguments[3]);
		}
		else
		{
			string[] errorargs = {arguments[3]};
			mc::putError(fromplayer, "syntax_invalidnumber", errorargs);
			return;
		}

		pos = Vec2f(pos1, pos2);
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