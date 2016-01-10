# moarCommands
moarCommands is a powerful KAG mod and library designed for extensibility and simplicity.
It allows modders to create commands without hassle using polymorphic classes, and server hosters to use these plugins and manage them easily.

NB : You are on an alpha branch. Currently, a lot of commands are missing and being implemented back after the massive recode.

### API overview

It is possible to create plugins an easy way using a class inheriting from mc::plugin.
Previously, function handlers were used, but they were limiting, so we migrated to this architecture.
Here is a fully functionnal hello world example, which can be used with !helloworld :
```c++
#include "mc_pluginbase.as"
#include "mc_pluginutil.as"
#include "mc_messageutil.as"

void onInit(CRules@ this)
{
  // This registers the plugin so it can be used
  mc::registerPlugin(plugin_helloworld());
}

class command_helloworld : mc::command
{
  command_helloworld()
  {
    name = "helloworld"; // We set the command name as we call it
    manEntry = "Prints an hello world message"; // And its documentation.
  }

  void onCommand(CPlayer@ caster) override // caster is the CPlayer@ that sent the command.
  {
    // mc::getMsg can take no argument if you want to put a message to the server console.
    // It can take a CPlayer@ or a string as the first argument if you want to send the message to an user. If the player is null, the message will be a broadcast (unless you pulled a string for the username).
    // The second argument chooses whether you want to put the message in the console (false) or to the chat (true)
    // The last argument specifies the color in which the message should appear (chat-only). By default, it's R:0, G:200, B:0.
    mc::getMsg(caster, true) << "Hello, " << caster.getUsername() << "!" << mc::endl;
  }
};

class plugin_helloworld : mc::plugin
{
  plugin_helloworld()
  {
    name = "Hello World"; // We set the plugin name. Don't worry about spaces : The parser allows doing !plugin "Hello World" and sending "Hello World" without quotes as a single argument.
    description = "This is a simple hello world plugin. !helloworld should print 'Hello, <username>!'"; // Now, the description as we can see it using !plugin "Hello World"

    commands.push_back(command_helloworld()); // AngelScript (at least in the version used by KAG) does not support initializations lists on already initialized values. So we either have to passby using a temporary variable (preferred) or using a push_back (unrecommended for more than a command) for every command.
  }
};
```
Note : Later, there will be a configuration file to list plugins to load and various other settings, but as for now, modifying ChatCommands.as is necessary : Just add your script in the script array.
For more complex examples, and on how to use arguments, check a plugin directly, for example 'mc_pl_cmd_core.as'.

###TODO list :
- [x] Core functionnality
  - [x] Message sending classes
  - [x] Command parser
  - [x] Plugin, command and argument classes
  - [x] Error
  - [x] Modifiers (see wiki)
- [ ] Planned plugins
  - [ ] Core
  - [ ] Admin Tools
  - [ ] moarEdit
  - [ ] Legacy commands
- [ ] API Documentation