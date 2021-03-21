RamCart 64/128
==============

# Ram Cart's background
I have been asked what that RamCart mentioned elsewhere on this site is because there is hardly
any information about it in the Internet. Hence this page.

RamCart is a memory expansion module with battery backup for C64/128 that was designed and produced
in Poland. At start there was only Atari version, in 1993 a C64/128 cartridge appeared.
It was produced in two flavours: 64KB and 128KB.

# Firmware
Provided firmware allowed to use RamCart as a memory disk, a device number 7.
You could load and save files there, load directory and delete files. Note that only LOAD and SAVE
worked. It wasn't possible to use BASIC command OPEN to create a file. Firmware took over control
right after hardware reset and presented user with a list of stored files. By pressing a letter
key it was possible to quickload a file and execute it. Hence RamCart was ideal for storing
frequently used tools.

Here is a .d64 image of a disk with RamCart 128KB firmware.
```
rc128um.d64.gz
```

# Hardware
As seen on pictures below, RamCart is built with 32KB SRAM chips and some glue logic. The memory
is seen in a 256-byte window, placed at $DF00-FF. The upper bits of address are set by writing
page number to $DE00 (and the lowest bit of $DE01 in 128KB version).

Additionaly, there is a switch that protects the memory contents from overwriting. If the switch
is set to Read-Only and bit 7 of $DE01 is cleared (default), then contents of memory window are
also visible in $8000-$80ff area. This allows to emulate usual cartridge takeover after hardware
reset by placing boot code with magic CBM80 string in the very first page of RamCart memory.

# Links

Patent: https://ewyszukiwarka.pue.uprp.gov.pl/search/pwp-details/P.294628

Patent description: https://api-ewyszukiwarka.pue.uprp.gov.pl/api/collection/0ec8b3953714150b285e7f17a3313c57#search=294628 (page 31)

Announcement from 2019 about new batch being produced: http://atarionline.pl/v01/index.php?subaction=showfull&id=1576034129&archive&start_from=0&ucat=1&ct=nowinki

# Pictures
Front view:

![RamCart front](/photos/rc-01-front.jpg?raw=true) 

Elements side of the board and the back of case (hey, my guarantee has expired :)

![RamCart inside front and back of case](/photos/rc-02-inside-front.jpg?raw=true) 

Solder side of the board

![RamCart inside back](/photos/rc-03-inside-back.jpg?raw=true)

RamCart manual and a tape with firmware. There was also a floppy, but it's missing.

![RamCart manual and firmware tape](/photos/rc-04-manual-tape.jpg?raw=true)

Maciej 'YTM/Elysium' Witkowiak
2003-12-06
