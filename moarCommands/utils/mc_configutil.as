//
// moarCommands utility
// Message utility
//
// Config-related utils
//

namespace mc
{
	void LoadConfig(string file)
	{
		ConfigFile cfg;
		if (!cfg.loadFile(file))
		{
			mc::getMsg() << "Config file '" << file << "' not found." << endl;
		}
	}
}