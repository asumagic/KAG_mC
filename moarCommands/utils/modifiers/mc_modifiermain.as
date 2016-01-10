//
// moarCommands modifier script
// Main functions & main classes
//

#include "asulib.as"
#include "mc_messageutil.as"

namespace mc
{
	shared class modifierFunctionHolder
	{
		string name, manEntry;
		modifierFunctionHolder() {}
		string f(string[] arguments) { return ""; }
	};

	void registerModifier(modifierFunctionHolder@ holder)
	{
		modifierList@ list = getModifierList();

		mc::getMsg() << "Registering modifier " << holder.name << "..." << endl;
		list.holders.push_back(holder);

		setModifierList(list);
	}

	string getModifierResult(modifier@ mod)
	{
		modifierList list = getModifierList();
		return list.getResult(mod);
	}

	modifierList@ getModifierList()
	{
		modifierList@ list;
		getRules().get("mc_modlist", @list);
		return list;
	}

	void setModifierList(modifierList@ list)
	{
		getRules().set("mc_modlist", @list);
	}

	class modifierList
	{
		modifierList() {}

		modifierFunctionHolder@[] holders;

		string getResult(modifier@ mod)
		{
			for (int i = 0; i < holders.size(); i++)
			{
				if (holders[i].name == mod.function)
				{
					return holders[i].f(mod.arguments);
				}
			}

			error("Modifier interpreter error : function callback " + mod.function + " not found.");
			return "null";
		}

	};

	shared class modifier
	{
		modifier() {}

		string function;
		string[] arguments;
	};

	shared class modifierContext
	{
		modifierContext() {}

		int b1, b2; // Bounds
	};
}