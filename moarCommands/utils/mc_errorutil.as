//
// moarCommands utility
// Message utility
//
// Various utilities for sending messages, errors and related to players, server console, etc.
//

#include "mc_messageutil.as"

#include "asulib.as"

namespace mc
{
	string[][] errorarray =
	{
		{"command_notfound", "Syntax > Command '%' not found. Did you mean : '%'?"},
		{"command_badarguments", "Syntax > Bad arguments for '%'. Syntax : '%'"},

		{"syntax_unexceptedtoken", "Syntax > Unexcepted token '%'"},
		{"syntax_exceptedtoken", "Syntax > Excepted token '%'"},
		{"syntax_invalidnumber", "Syntax > Invalid number '%'"},

		{"security_norights", "Security > Player % is not allowed to perform action : %."},
		{"security_disabled", "Security > Command '%' found, but is disabled."},

		{"player_blobunknown", "Player > Your blob was not found. '%' as this requires you to have a blob attached (i.e. being alive)."},

		{"player_unknown", "Player > The player you requested ('%') couldn't be found."},
		{"blob_unknown", "Blob > The blob you requested ('%') couldn't be spawned. It most likely doesn't exists or can't be created now."}
	};

	void putError(CPlayer@ player, string err, string[] completion)
	{
		for (uint i = 0; i < errorarray.size(); i++)
		{
			if (errorarray[i][0] == err)
			{
				mc::getMsg(player, true, SColor(255, 200, 0, 0)) << replacetokensby(errorarray[i][1], '%', completion) << mc::rdy();
			}
		}
	}
}