namespace mc
{
	shared class argument
	{
		argument() {}

		string manEntry = "[unspecified argument]", defaultValue = "", value;
	};

	shared class command
	{
		command() {}

		void onCommand(CPlayer@ caster) {}

		string name, manEntry;

		argument@[] arguments;
		string[] aliases;

		bool restrictArgumentCount = true;
		int[] acceptedCount = {0}; // Accepted argument count. Set to 0 if you want the function to have no argument.
	};

	shared class plugin
	{
		plugin() {}

		void onPluginInit() {}
		void onPluginStop() {}

		bool onChat(const string& in textIn, string& out textOut, CPlayer@ caster) { textOut = textIn; return true; }

		string name = "Default plugin";
		string description = "This is a default plugin.\nIf you are a modder, good job! Now implement your own plugin. :)\nElse, this may be caused by a faulty plugin or a problem in mC. :(";

		command@[] commands;
	};
}