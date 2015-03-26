# King Arthur's Gold mod : moarCommands
A powerful KAG mod and library designed for extensibility and simplicity.
It will allow server makers to extend their servers for new commands for their admins, but also modders (even beginning modders) to start creating simple mods in a simple, comfortable way, using the mC library and the std plugin database.

For example, you'll be allowed to send up text to a player with a single piece of code such as this :

```
#include "mc_messageutil.as"

void onInit(CRules@ this)
{
   mc::getMsg("AsuMagic") << "Hello, AsuMagic!" << mc::rdy();
}
```

You also are (already) ready to make on some basic plugins (it is subject to change, so don't make large plugins).
It will later be shortened for easier use.
Basic plugin example :
```
// This will register the command to the mC API.
void onInit(CBlob@ this)
{
	mc::registerCommand("hw", cmd_helloworld);
}

// This will be called once the player writes !hw.
bool cmd_helloworld(string[] arguments, CPlayer@ player)
{
	mc::getMsg(player) << "Hello World!" << mc::rdy();
	return false;
}

// This allows catching the command event.
void onCommand(CRules@ this, u8 cmd, CBitStream@ data)
{
	mc::catchCommand(this, cmd, data);
}
```
Then, add the script into scriptloader.cfg. This is, for now, required, because of a KAG bug, which makes KAG ignore modded scripts put into gamemode.cfg.

Feel free to suggest new features and to improve the code!
