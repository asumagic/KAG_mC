// Bison taming
#include "AnimalConsts.as";

// Returns whether the entered string is a boolean value or not.
bool isNumber(string tocheck)
{
	for (uint i = 0; i < tocheck.size(); i++)
	{
		if ((tocheck[i] < 0x30 || tocheck[i] > 0x39) && (tocheck[i] != 0x2E)) // If it isn't a number or a dot
		{
			return false;
		}
	}
	return true;
}

// Tames a bison in the specified radius.
void TameInRadius(Vec2f position, float maxradius, CBlob@ owner)
{
	CBlob@[] bisons;
	getBlobsByName("bison", bisons); // y geri y

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

// Replaces tokens from a string by another string.
string replacetokensby(string tochange, string tok, string[] tokreplace)
{
	string[] splitted = tochange.split(tok);

	for (uint i = 0; i < splitted.size() && i < tokreplace.size(); i++)
	{
		splitted[i] += tokreplace[i];
	}

	return mix(splitted);
}

// Mixes up a string array into a single string.
string mix(string[] splitted)
{
	string ret;

	for (uint i = 0; i < splitted.size(); i++)
	{
		ret += splitted[i];
	}

	return ret;
}