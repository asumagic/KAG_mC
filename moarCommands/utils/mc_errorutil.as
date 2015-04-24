//
// moarCommands utility
// Message utility
//
// Various utilities for sending messages, errors and related to players, server console, etc.
//

#include "mc_messageutil.as"

namespace mc
{
	string[][] errorarray =
	{
		{"command_notfound", "Syntax > Command '%' not found. Did you mean : '%'?"},
		{"command_badarguments", "Syntax > Bad arguments for '%'. Syntax : '%'"},

		{"syntax_unexceptedtoken", "Syntax > Unexcepted token '%'"},
		{"syntax_exceptedtoken", "Syntax > Syntax > Excepted token '%'"},

		{"security_norights", "Security > Player % is not allowed to run '%'."},
		{"security_disabled", "Security > Command '%' found, but is disabled."}
	};

	void putError(CPlayer@ player, string err)
	{
		for (uint i = 0; i < errorarray.size(); i++)
		{
			if (errorarray[i][0] == err)
			{
				mc::getMsg(player, true, SColor(255, 200, 0, 0)) << errorarray[i][1] << mc::rdy();
			}
		}
	}
}