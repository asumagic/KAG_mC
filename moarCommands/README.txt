/// moarCommands readme ///

This readme will teach you everything you may need to know to use, modify or extend moarCommands.

/// I. License ///
This mod is distrbuted in the zlib/libpng license you can find there :

// Copyright (c) 2015 Zen Laboratories
// 
// This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
// 
// Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
// 
//     1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
// 
//     2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
// 
//     3. This notice may not be removed or altered from any source distribution.

Shortened, it means :
- You can share it, modify it, etc, as want, for once you DO NOT REMOVE THE UPPER NOTICE FROM ANY SOURCE DISTRIBUTION!
- If you modify the mod, you must specify it only is a fork and is NOT the original software.

/// II. Setup instructions ///
Installing moarCommands should be pretty easy.
1. Copy the moarCommands folder in /Mods/ in the KAG directory.
2. In your gamemode.cfg file, in the scripts part, put 'mc.as;' (Without the 's obviously) instead of 'ChatCommands.as'
3. Open mods.cfg on the KAG folder, put on a new line and write 'moarCommands'.
4. Run KAG, you're ready!

/// II.2 Plugin setup instructions ///
Plugins are usually following the same step by step install, though, some has specific installation conditions.
If you think that's the case, please refer to its setup instructions, those might not be revealant.
Please do NOT mix moarCommands mod folder with plugins: This is not a good way to proceed!
A 20mb plugin would need to be redownloaded everytime a player is going on a different server with moarCommands.
1. Say we have a plugin HelloWorld.
   Copy HelloWorld into /Mods/
2. In your gamemode.cfg file, in the scripts part, put 'HelloWorld.as;'
3. Open mods.cfg on the KAG folder, put on a new line and write 'HelloWorld'.
4. Run KAG and you should be done. If it doesn't, please contact the plugin creator!

/// III. Configuration instructions ///
!!! PLEASE DO NOT EMBARK YOUR CONFIG FILES IN THE MOARCOMMANDS MOD FOLDER !!!
This would override client configuration which often should not be done!
They also don't need to know your server configuration, for safety reasons.

Configuration files are located in /Cache/moarCommands/.

Server config : mc_sv.cfg
Client config : mc_cl.cfg
Properly done plugin config : mc_pl_pluginname.cfg
Standard plugins : mc_pl_std.cfg

Players can change their settings directly from the game using the std (Plugin 'mc_pl_std_uisettings.as').
You should NOT be modifying the moarCommands folder in /Mods/, unless you need to modify something hardcoded or to fix a bug, for example.

/// IV. Various uses of moarCommands ///
moarCommands can be used for other stuff than commands. For example, a map editor built around it is being worked on, moarEdit, which will allow editing maps commandline and using a GUI.
It has powerful utils that can be used in various kinds of mods, since you can make C++ std::cout like outputs a clean way ('mc::getMsg("AsuMagic") << "Hello Asu!" << mc::rdy; will send a message to AsuMagic from the server) for example :
The moarCommands' util lib is meant to be comfortable, complete and easy to use.
