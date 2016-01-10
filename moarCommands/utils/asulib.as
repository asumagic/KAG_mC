// Bison taming
#include "AnimalConsts.as";

// Returns whether the entered string is a boolean value or not.
bool isNumber(string tocheck)
{
	int signcount = countOf(tocheck, "-");

	if ((tocheck.size() == 0) || (countOf(tocheck, ".") > 1) || signcount > 1 || ((signcount == 1) && (tocheck[0] != 0x2D)))
		return false;

	for (uint i = 0; i < tocheck.size(); i++)
	{
		if ((tocheck[i] < 0x30 || tocheck[i] > 0x39) && (tocheck[i] != 0x2D) && (tocheck[i] != 0x2E))
		{
			return false;
		}
	}
	return true;
}

// Tames bisons in the specified radius.
void TameInRadius(Vec2f position, float maxradius, CBlob@ owner)
{
	CBlob@[] bisons;
	getBlobsByName("bison", bisons);

	float poslength = position.getLength();

	for (uint i = 0; i < bisons.size(); i++)
	{
		if (Maths::Abs(bisons[i].getPosition().getLength() - poslength) < maxradius)
		{
			bisons[i].set_u8(state_property, MODE_FRIENDLY);
			bisons[i].set_netid(friend_property, owner.getNetworkID());
		}
	}
}

// Returns the count of a char in a string
int countOf(const string str, const string tocount)
{
	int c = 0;
	for (int i = 0; i < str.size(); i++)
	{
		if (str[i] == tocount[0])
			c++; // hidden propaganda
	}
	return c;
}

// Replaces tokens from a string by another string.
string replacetokensby(const string tochange, const string tok, const string[] tokreplace)
{
	string[] splitted = tochange.split(tok);

	for (uint i = 0; i < splitted.size() && i < tokreplace.size(); i++)
	{
		splitted[i] += tokreplace[i];
	}

	return mix(splitted);
}

// Mixes up a string array into a single string.
string mix(const string[] splitted)
{
	string ret;

	for (uint i = 0; i < splitted.size(); i++)
	{
		ret += splitted[i];
	}

	return ret;
}

bool isSpace(const int16 char)
{
	const int16[] eliminate = { 0x20, 0x09, 0x10, 0x13 }; // space, tab, line jump, carriage return
	for (int i = 0; i < eliminate.size(); i++)
		if (eliminate[i] == char)
			return true;

	return false;
}

// Trims a string (remove space, tabulations, etc. on string borders)
// Because KAG's trim() is broken af
string trimstr(const string str)
{
	int trimlow = 0;
	int trimhigh = str.size() - 1;

	while (isSpace(str[trimlow++]));
	while (isSpace(str[trimhigh--]));

	return str.substr(trimlow - 1, trimhigh - trimlow + 3);
}

int findIgnoreQuotes(string str, int16 toSearch)
{
	bool isIgnored = false;

	for (int i = 0; i < str.size(); i++)
	{
		if (str[i] == 0x22) // "
		{
			isIgnored = !isIgnored;
		}

		if (!isIgnored && str[i] == toSearch)
		{
			return i;
		}
	}
	return -1;
}

string[] splitIgnoreQuotes(string str, int16 spliton) // note : will remove quotes as well!
{
	string[] splitted;
	bool isIgnored = false;
	int firsttok = 0;

	for (int i = 0; i < str.size(); i++)
	{
		if (str[i] == 0x22) // "
		{
			isIgnored = !isIgnored;
		}

		if (!isIgnored && str[i] == spliton)
		{
			splitted.push_back(str.substr(firsttok, i - firsttok));
			firsttok = i + 1;
		}
	}

	string last = str.substr(firsttok, -1);
	if (last != "")
	{
		splitted.push_back(last);
	}

	for (int i = 0; i < splitted.size(); i++) // @todo : integrate in the algorithm itself
	{
		for (int j = 0; j < splitted[i].size(); j++)
		{
			if (splitted[i][j] == 0x22)
			{
				splitted[i] = splitted[i].substr(0, j) + splitted[i].substr(j + 1, -1);
			}
		}
	}

	return splitted;
}