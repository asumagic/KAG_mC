# moarCommands
moarCommands is a powerful KAG mod and library designed for extensibility and simplicity.
It will allow server makers to extend their servers for new commands for their admins, but also modders (even beginning ones) to start creating new commands in a simple, comfortable way, using the complete mC library and the std plugin database. Look below if you're interested to see how it will look!

### Plugin example

For example, you'll be allowed to send up text to a player with a single piece of code such as this :

```c++
#include "mc_messageutil.as"

void onInit(CRules@ this)
{
   mc::getMsg("AsuMagic") << "Hello, AsuMagic!" << mc::rdy();
}
```

You also are (already) ready to make on some basic plugins (it is subject to change, so don't make large plugins).
It will later be shortened for easier use.
Basic plugin example :
```c++
// This will register the command to the mC API.
void onReload(CRules@ this)
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
Then make it load in some rule file. (Or use CRules::AddScript()).

###TODO list :
- [ ] Core functionnality
  - [x] Message class
  - [x] **Command handling**
  - [x] **Command registering**
  - [x] Security (seclevs support, etc) - Not tested yet (even if it's basic), but should work.
  - [ ] Aliases
  - [ ] Errors
- [ ] Most of the planned commands
  - [ ] **moarCore**
  - [x] moarSpawn
  - [ ] moarSecurity
  - [ ] moarGUI
  - [x] moarEdit (Under heavy modfications, but it's doing basic stuff.)
- [ ] Documentation

Feel free to suggest new features and to improve the code!
