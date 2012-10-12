FuzzBall 6 MUF
==============

The following programs were originally written for the now-defunct SporkMUCK, but should work on any FuzzBall 6-based MUCK with some tweaking. I’ve long-since retired from MUCK development and don’t plan on returning, so all programs here are provided without warranty or support.

The 'lib' folder contains a couple of third-party libraries that I did not write, but many of these MUF programs rely on.

lib-kat.muf -- A set of nonsensical and situational functions which are mostly used internally by my own code. This library probably isn’t much use to anyone on its own (and comes with minimal documentation), but is required for using many of my MUF programs.

kat-fruit.muf -- A fully-functional slot machine with full ANSI support, complete with variable cost/payouts, statistics, text or ASCII art modes, and more! This one was very popular with the SporkMUCK residents, and is now being released to the world for the first time.

kat-kingdom.muf -- A MUF port of the BBC Micro game “Yellow River Kingdom”, which appeared on the welcome disk. The code is more or less directly translated from BBC BASIC, so may be a little messy.

kat-recycle.muf -- A stub program to replace the in-server @recycle command, which asks for confirmation before recycling an object, refuses to recycle anything set with the ~protected:yes wizprop, and has a few security checks to ensure that, unlike some other @recycle stub programs, it will never delete the wrong object.

kat-look.muf -- A replacement for the default “look” program, mainly because I just couldn’t find one that I liked elsewhere. Designed to be used with the Cityscape exits-lister (http://mufden.fuzzball.org/)

kat-scan.muf -- A builder’s tool, which can be used by wizards and non-wizards alike, which scans everything you own and tells you of obvious mistakes made when building, such as missing descriptions, unlinked exits, and so on.

kat-teleport.muf -- A simple teleport command, which supports user-set destinations as well as wizard-created global dests.

kat-toadstub.muf -- A very basic stub to add extra confirmation when @toading someone.

kat-socialsii.muf -- A MUCK socials program, based loosely on Socials v2.2 by Katt.

kat-ansitoggle.muf -- A very simple program that provides a command for toggling ANSI colour on and off.

kat-think.muf -- A “think” command, used to communicate with players who have psychic powers.

kat-ooc.muf -- A very simple OOC chat command.

kat-stafflist.muf -- A customizable staff/wizards list based on Area-Commands.muf by Stelard Actek and Wizzes.muf by Keet.

kat-doorcommands.muf and kat-doorlock.muf -- A simple system to create doors which can be opened, closed, locked, unlocked, and knocked on.

kat-hookshot.muf -- Create a Zelda-like hookshot, which can steal items from adjacent rooms.

kat-shovel.muf -- Create a shovel which can bury objects in a room, and dig up previously-buried loot.

kat-pinfo.muf -- A simple, customizable pinfo/cinfo program.
