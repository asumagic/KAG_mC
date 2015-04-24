//
// moarCommands utility
// Message utility
//
// Various utilities for sending messages, errors and related to players, server console, etc.
//

#include "mc_errorutil.as"

namespace mc
{
	string noticeprefix = "[mC] ";

	// If player is null, this will set out the output to server automatically, so 'getMsg() << "Hello World" << rdy();' will work.
	// Else, if out is false, the message will be sent to the console, otherwise in the chat.
	mc::msgout getMsg(CPlayer@ player, bool outmode = true, SColor color = SColor(255, 0, 127, 0))
	{
		if (player is null)
		{
			return svout();
		}
		else
		{
			return clout(player, outmode, color);
		}
	}

	mc::msgout getMsg(string player, bool outmode = true, SColor color = SColor(255, 0, 127, 0))
	{
		CPlayer@ pointedplayer = getPlayerByUsername(player);
		if (pointedplayer is null)
		{
			return svout();
		}
		else
		{
			return clout(pointedplayer, outmode, color);
		}
	}

	// Console output
	mc::msgout getMsg()
	{
		return msgout();
	}

	

	// This is kind of a line jump but more generally it's sending the message and flushing the internal string.
	// So everytime you're putting text in the msgout, you *must* put in a rdy too!
	// It doesn't have any other point.
	// This is completly valid and will show up correctly : 'getMsg("AsuMagic") << "Hello, Asu!" << rdy() << "How's things going?" << rdy();'.
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

		msgout@ opShl(const string[] &in stringarray)
		{
			for(u16 i = 0; i < stringarray.size(); i++)
			{
				istr += stringarray[i] + ", ";
			}

			istr = istr.substr(0, istr.size()-2);

			return this;
		}

		msgout@ opShl(const Vec2f &in toput)
		{
			istr += "" + toput.x + "; " + toput.y;
			return this;
		}

		msgout@ opShl(const SColor &in toput)
		{
			istr += "ARGB : " + toput.getAlpha() + ", " + toput.getRed() + ", " + toput.getGreen() + ", " + toput.getBlue();
			return this;
		}

		msgout@ opShl(CPlayer@ toput)
		{
			if (toput !is null)
			{
				istr += toput.getUsername();
			}
			else
			{
				istr += "null player";
			}

			return this;
		}

		msgout@ opShl(CMap@ toput)
		{
			if (toput !is null)
			{
				istr += toput.getMapName();
			}
			else
			{
				istr += "null map";
			}
			return this;
		}

		msgout@ opShl(CRules@ &in toput)
		{
			if (toput !is null)
			{
				istr += toput.gamemode_name;
			}
			else
			{
				istr += "null rules";
			}
			return this;
		}

		msgout@ opShl(const double &in toput)
		{
			istr += "" + toput; // seems ugly to me, feel free to improve
			return this;
		}

		msgout@ opShl(const float &in toput)
		{
			istr += "" + toput;
			return this;
		}

		msgout@ opShl(const int &in toput)
		{
			istr += "" + toput;
			return this;
		}

		msgout@ opShl(const uint &in toput)
		{
			istr += "" + toput;
			return this;
		}

		void put()
		{
			print(istr);
			istr = "";
		}
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

			istr = "";
		}
	};

	class clout : msgout
	{
		clout(CPlayer@ player, bool outmode, SColor color)
		{
			@pointedplayer = player;
			textoutmode = outmode;
			textcolor = color;
		}

		void put()
		{
			CBitStream textstream;
			textstream.write_string(istr);
			textstream.write_bool(textoutmode);

			textstream.write_u8(textcolor.getRed());
			textstream.write_u8(textcolor.getGreen());
			textstream.write_u8(textcolor.getBlue());


			CRules@ rules = getRules();
			rules.SendCommand(rules.getCommandID("mc_strsend"), textstream, pointedplayer);

			istr = "";
		}

		private CPlayer@ pointedplayer;
		private bool textoutmode;
		private SColor textcolor(255, 0, 127, 0);
	};
}