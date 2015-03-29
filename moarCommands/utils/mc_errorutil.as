//
// moarCommands utility
// Message utility
//
// Various utilities for sending messages, errors and related to players, server console, etc.
//

#include "mc_messageutil.as"

namespace mc
{
	enum standarderrors
	{
		command_notfound = 0,

		security_norights,
		security_disabled
	};

	string[] standarderrors_strings =
	{
		"Command '%c' not found.",

		"Player %p is not allowed to run '%c'.",
		"Command '%c' found, but is disabled."
	};

	void putError(CPlayer@ player, u16 errorid)
	{
		
	}
}