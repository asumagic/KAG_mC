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
		rdy() {}
	};

	class msgout
	{
		msgout() {}

		private string istr;

		msgout@ opShl(const string &in toput)
		{
			istr += toput;
			return this;
		}

		msgout@ opShl(const rdy &in readytok)
		{
			put();
			return this;
		}

		void put() {}
	};

	class svout : msgout
	{
		svout() {}
		void put()
		{
			if (getNet().isServer())
			{
				print(noticeprefix + istr);
			}
			else
			{
				print("Cannot print server text clientside!");
			}
		}
	};

	class clout : msgout
	{
		clout(CPlayer@ player, bool outmode)
		{
			@pointedplayer = player;
			textoutmode = outmode;
		}
		void put()
		{
			CBitStream textstream;
			textstream.write_string(istr);
			textstream.write_bool(textoutmode);

			CRules@ rules = getRules();
			rules.SendCommand(rules.getCommandID("mc_strsend"), textstream, pointedplayer);
		}

		private CPlayer@ pointedplayer;
		private bool textoutmode;
	};
}