# King Arthur's Gold mod : moarCommands
A powerful KAG mod and library designed for extensibility and simplicity.
It will allow server makers to extend their servers for new commands for their admins, but also modders (even beginning modders) to start creating simple mods in a simple, comfortable way, using the mC library and the std plugin database.

For example, you'll be allowed to send up text to a player with a single piece of code such as this :

```
#include "mc_messageutil.as"

void onInit(CRules@ this)
{
   mc::getMsg("AsuMagic") << "Hello, AsuMagic!" << mc::rdy;
}
```

Feel free to suggest new features and to improve the code!
