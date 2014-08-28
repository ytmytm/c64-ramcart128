
This is RamCart128K Burst Backup. It's a normal burst backup program which uses
additional memory provided by RamCart 128K cartridge so it can copy a full disk
in just two passes.

The source is a text file for Turbo Assembler Macro. However it seems that I
didn't use any of its extensions so Turbo Asm v5.x can be used to build it.
You need also disk drive code which is in binary file only (I couldn't find
the source code). It should be loaded as usual - at the address provided by
two first bytes in file.

This source is released under GNU GPL license.

Maciej 'YTM/Elysium' Witkowiak <ytm@elysium.pl>
07.08.1997, 29.07.2001
