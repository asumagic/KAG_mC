//
// moarCommands utility
// Message utility
//
// Various utilities for sending messages, errors and related to players, server console, etc.
//

namespace mc
{
	string noticeprefix = "[mC] ";

	// If player is null, this will set out the output to server automatically, so 'getMsg() << "Hello World" << rdy;' will work.
	// Else, if out is false, the message will be sent to the console, otherwise in the chat.
	mc::msgout getMsg(CPlayer@ player = null, bool outmode = true)
	{
		if (player is null)
		{
			return svout();
		}
		else
		{
			return clout(player, outmode);
		}
	}

	// This is kind of a line jump but more generally it's sending the message and flushing the internal string.
	// So everytime you're putting text in the msgout, you *must* put in a rdy too!
	// It doesn't have any other point.
	// This is completly valid and will show up correctly : 'getMsg("AsuMagic") << "Hello, Asu!" << rdy << "How's things going?" << rdy;'.
	class rdy
	{

	};

	protected class msgout
	{
		private string istr;

		opShl(string toput)
		{
			istr += toput;
		}

		opShl(&rdy readytok)
		{
			put();
		}

		void put();
	};

	class svout : msgout
	{
		svout() {}
	};

	class clout : msgout
	{
		clout(CPlayer@ player, bool outmode)
		{
			pointedplayer = player;
			textoutmode = outmode;
		}

		private CPlayer@ pointedplayer;
		private bool textoutmode;
	};
}