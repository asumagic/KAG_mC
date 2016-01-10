//
// moarCommands modifier script
// Modifiers interpreter
//

// Modifier structure :
// [functionWithNoArguments]
// [functionWithArguments: argument, argument, argument]
// [functionWithArgumentsIncludingSpaces: "argument", "argument", "argument"]
// [functionA: [functionB: text]]

#include "asulib.as"
#include "mc_modifiermain.as"

namespace mc
{
	modifier@ makeModifierIfPresent(string str)
	{
		if (str[0] == 0x5B) // [
		{
			if (str[str.size()-1] == 0x5D) // ]
			{
				return makeModifier(str.substr(1, str.size() - 2));
			}
		}

		return null;
	}

	modifier makeModifier(string str)
	{
		modifier[] nestedModifiers;

		if (str.size() == 0)
		{
			error("Modifier interpreter error : modifier string size is 0, possible crash incoming");
		}

		modifier ret;
		int argpos = findIgnoreQuotes(str, 0x3A); // :
		if (argpos == -1) // No argument
		{
			string trimmed = trimstr(str);

			modifier@ nestedmod = makeModifierIfPresent(trimmed);
			if (nestedmod !is null)
			{
				return nestedmod;
			}
			else
			{
				ret.function = trimmed;
			}
		}
		else // Argument(s)
		{
			string funcexpr = str.substr(0, argpos - 1);

			modifier@ nestedmod = makeModifierIfPresent(funcexpr);
			if (nestedmod !is null)
			{
				ret.function = getModifierResult(nestedmod);
			}
			else
			{
				ret.function = funcexpr;
			}

			string postfunc = str.substr(argpos + 1, -1);

			string[] splitted = splitIgnoreQuotes(postfunc, 0x2C);

			for (int i = 0; i < splitted.size(); i++)
			{
				string trimmed = trimstr(splitted[i]);
				modifier@ nestedmod = makeModifierIfPresent(trimmed);
				if (nestedmod !is null)
				{
					ret.arguments.push_back(getModifierResult(nestedmod));
				}
				else
				{
					ret.arguments.push_back(trimmed);
				}
			}
		}

		return ret;
	}

	modifierContext makeModifierContext(int b1, int b2)
	{
		modifierContext mcont;
		mcont.b1 = b1; mcont.b2 = b2;
		return mcont;
	}

	string parseModifiers(string str) // Gets main modifiers and parse them
	{
		int inID = 0;
		int modifBegin = 0;
		bool isIgnored = false;

		modifier[] modifiers;
		modifierContext[] modifierContexts;

		for(int i = 0; i < str.size(); i++)
		{
			if (str[i] == 0x22) // "
			{
				isIgnored = !isIgnored;
			}

			if (!isIgnored)
			{
				if (str[i] == 0x5B) // [
				{
					inID++;
					if (inID == 1)
					{
						modifBegin = i;
					}
				}
				else if (str[i] == 0x5D) // ]
				{
					inID--;
					if (inID == 0)
					{
						modifiers.push_back(makeModifier(str.substr(modifBegin + 1, i - modifBegin - 1)));
						modifierContexts.push_back(makeModifierContext(modifBegin, i));
					}
					else if (inID < 0)
					{
						error("Modifier parser warning : inID < 0, broken modifier? Except further errors or crash");
					}
				}
			}
		}

		if (inID != 0)
		{
			error("Modifier parser warning : inID != 0, broken modifier?");
		}

		if (modifiers.size() == 0)
			return str;

		string ret;

		ret += str.substr(0, modifierContexts[0].b1);

		for (int i = 0; i < modifiers.size() - 1; i++)
		{
			ret += getModifierResult(modifiers[i]);
			ret += str.substr(modifierContexts[i].b2 + 1, modifierContexts[i + 1].b1 - modifierContexts[i].b2 - 1);
		}

		ret += getModifierResult(modifiers[modifiers.size() - 1]);
		ret += str.substr(modifierContexts[modifierContexts.size() - 1].b2 + 1, -1);

		return ret;
	}
}