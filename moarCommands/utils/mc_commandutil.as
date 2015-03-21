//
// moarCommands utility
// Command utility
//
// Those are utils you may need to use when making your own command.
// It allows you to register your command into the moarCommands engine.
//

#include "mc_messageutil.as"

string[] commands = {""};

namespace mc
{
	funcdef bool cmd_callback(string[] arguments, CPlayer@ fromplayer);
	
	void registerCommand(string commandname, cmd_callback@ function)
	{
		
	}

	void unregisterCommand(string commandname)
	{

	}
}