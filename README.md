## Interstation12: Warfare

**Website:** http://is12wiki.xyz/index.php/Main_Page

**Main source code:** https://github.com/mattroks101/IS12-Warfare

**Discord:**  https://discord.gg/FVRctMD

## Terms of service

**Please carefully read the following statement:**

If you desire to host your own server based off of IS12 Warfare source code - you may not pretend to be an "Official IS12 Warfare" server.

**By our terms and conditions we require any potential host to specify that they are an unofficial server in announcements and the Byond HUB.**

Stated terms of service fully comply with the AGPL v3 license.

### LICENSE
Code is licensed under the [GNU Affero General Public License v3](http://www.gnu.org/licenses/agpl.html).

If you wish to license under GPL v3 please make this clear in the commit message and any added files.

The major change here is that if you host a server using any code licensed under AGPLv3 you are required to provide full source code for your servers users as well including addons and modifications you have made.

**All original art assets are © 2020 Interstation12.  All rights reserved. You may not rip the original art assets and use them in your project without consent.**


## How do I get this to compile?

You can do this one of two ways. First way is to go into your DME, and find the line that contains `#include "__non-agpl-warfare/__secret.dme"`, comment this out. Your code will now compile, but it may not be compatible with the main repo anymore, only do this if you have simply downloaded the codebase, and do not plan to contribute or keep up to date with it's changes.

The proper method is to go into the folder called `__non-agpl-warfare` and create a DME called `__secret.dme`. Make sure it is titled exactly that, in exactly that folder, and that the DME is completely blank with no files included. Now go back to the IS12Warfare.dme and compile again. It will compile correctly.


## Why do I have to do that?

Due to license restrictions on certain independent systems referenced in this code, certain parts of the codebase were not able to be released to the public. A dummy file system has been created to account for this. The codebase will still compile and run without the independent systems.