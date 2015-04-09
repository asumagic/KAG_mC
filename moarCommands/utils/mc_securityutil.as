//
// moarCommands utility
// Security utility
//
// Manages security levels.
//

namespace mc
{
	bool isCommandAllowed(string command, CPlayer@ player)
	{
		CSecurity@ security = getSecurity();
		if (security.checkAccess_Feature(player, "mc_all") ||
			security.checkAccess_Feature(player, "mc_cmd_" + command) ||
			security.checkAccess_Command(player, "ALL"))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}