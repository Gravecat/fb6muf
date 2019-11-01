( Kat-DoorCommands.muf -- Copyright 2003-2006 Raine 'Gravecat' Simmons <raine@moxx.net>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE. )


$def MAJOR_VERSION 1
$def MINOR_VERSION 0
$def PATCH_VERSION 2
 
: ver display_version ;
 
PUBLIC ver

lvar arg
lvar target
lvar orig

$include $lib/reflist
$include $lib/case
$include $lib/ansify

$def DOOR_LOCK #5931

: banner
  " " .tell
  "~&160.--------------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|     ~&120Kat-Doorcommands     ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|        ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-       ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'--------------------------'-~&170\"\"~&160-----~&170\"\"~&160--." ansi-tell
  "~&160|    Copyright (C) 2003-2006 Gravecat   |" ansi-tell
  "~&160'---------------------------------------'" ansi-tell
  " " .tell
;

: help
  banner
  "  ~&120open <exit>             ~&R: Opens the door <exit>." ansi-tell
  "  ~&120open <exit>=<player>    ~&R: Adds <player> to the guest list." ansi-tell
  " " .tell
  "  ~&120close <exit>            ~&R: Closes the door <exit>." ansi-tell
  "  ~&120close <exit>=<player>   ~&R: Removes <player> from the guest list." ansi-tell
  " " .tell
  "  ~&120makedoor <exit>         ~&R: Creates a 'door' for that exit and its twin." ansi-tell
  "  ~&120knock <exit>            ~&R: Knock on the door!" ansi-tell
  " " .tell
;

: find-backlink ( d -- d' )
  exits_array dup not if pop #-1 exit then
  dup array_count 0 swap 1 - 1 for
    over swap array_getitem dup getlink loc @ = if swap pop exit else pop then
  repeat pop #-1
;

: makedoor
  arg @ match arg !
  arg @ #-1 = if "I don't see anything like that here." .tell exit then
  arg @ #-2 = if "I'm not sure which one you mean." .tell exit then
  arg @ #-3 = if "Danger! Danger, Will Robinson!" .tell exit then
  arg @ exit? not if "You can only use this command on exits." .tell exit then
  arg @ getlink room? not if "The exit must lead to a room." .tell exit then
  "Making ~&120" arg @ name "~&R into a door. Attempting to find reverse link..." strcat strcat ansi-tell
  arg @ getlink find-backlink target !
  target @ #-1 = not if
    "Reverse link ~&120" target @ name "~&R found." strcat strcat ansi-tell
  else
    "No reverse link found." .tell
  then
  arg @ DOOR_LOCK setlockstr pop
  arg @ "_door/status" "closed" setprop
  arg @ "_/fl" "That door is currently closed. You may 'knock' on the door to alert the inhabitants." setprop
  target @ #-1 = not if
    arg @ "_door/reverse" target @ setprop
    target @ "_door/main" arg @ setprop
    target @ DOOR_LOCK setlockstr pop
    target @ "_/fl" "That door is currently closed." setprop
  then
  "All done! Check 'makedoor #help' for a complete list of commands." .tell
;

: allowed? ( d -- i )
  dup owner me @ dbcmp if pop 1 exit then
  dup "_door/guests" me @ REF-inlist? if pop 1 exit then
  pop 0
;

: opendoor+
  arg @ owner me @ = not if "Permission denied." .tell exit then
  target @ match target !
  target @ #-1 = if "I don't see anything like that here." .tell exit then
  target @ #-2 = if "I'm not sure which one you mean." .tell exit then
  target @ #-3 = if "Danger! Danger, Will Robinson!" .tell exit then
  target @ player? not if "You may only add players to the guest list." .tell exit then
  arg @ "_door/guests" target @ REF-inlist? if "They're already in the guest list!" .tell exit then
  arg @ "_door/guests" target @ REF-add
  "Added " target @ name " to the guest list." strcat strcat .tell
;

: closedoor+
  arg @ owner me @ = not if "Permission denied." .tell exit then
  target @ match target !
  target @ #-1 = if "I don't see anything like that here." .tell exit then
  target @ #-2 = if "I'm not sure which one you mean." .tell exit then
  target @ #-3 = if "Danger! Danger, Will Robinson!" .tell exit then
  arg @ "_door/guests" target @ REF-inlist? not if "They aren't even in the guest list!" .tell exit then
  arg @ "_door/guests" target @ REF-delete
  "Removed " target @ name " from the guest list." strcat strcat .tell
;

: opendoor
  arg @ "=" split swap arg ! target !
  arg @ match arg !
  arg @ #-1 = if "I don't see anything like that here." .tell exit then
  arg @ #-2 = if "I'm not sure which one you mean." .tell exit then
  arg @ #-3 = if "Danger! Danger, Will Robinson!" .tell exit then
  arg @ exit? not if "You can't open that!" .tell exit then
  arg @ "_door" propdir? not if "That's not a door!" .tell exit then
  arg @ getlink room? not if "That's not a door!" .tell exit then
  arg @ orig !
  arg @ "_door/main" getprop dup if arg ! else pop then
  arg @ allowed? not if "Permission denied." .tell exit then
  target @ if opendoor+ exit then
  arg @ "_door/status" getpropstr "open" strcmp not if "That door is already open!" .tell exit then
  "You open the door to " orig @ getlink name "." strcat strcat .tell
  loc @ me @ dup name " opens the door to " orig @ getlink name "." strcat strcat strcat notify_except
  orig @ getlink #-1 me @ name " opens the door from " loc @ name "." strcat strcat strcat notify_except
  arg @ "_door/status" "open" setprop
;

: closedoor
  arg @ "=" split swap arg ! target !
  arg @ match arg !
  arg @ #-1 = if "I don't see anything like that here." .tell exit then
  arg @ #-2 = if "I'm not sure which one you mean." .tell exit then
  arg @ #-3 = if "Danger! Danger, Will Robinson!" .tell exit then
  arg @ exit? not if "You can't close that!" .tell exit then
  arg @ "_door" propdir? not if "That's not a door!" .tell exit then
  arg @ getlink room? not if "That's not a door!" .tell exit then
  arg @ orig !
  arg @ "_door/main" getprop dup if arg ! else pop then
  arg @ allowed? not if "Permission denied." .tell exit then
  target @ if closedoor+ exit then
  arg @ "_door/status" getpropstr "closed" strcmp not if "That door is already closed!" .tell exit then
  "You close the door to " orig @ getlink name "." strcat strcat .tell
  loc @ me @ dup name " closes the door to " orig @ getlink name "." strcat strcat strcat notify_except
  orig @ getlink #-1 me @ name " closes the door from " loc @ name "." strcat strcat strcat notify_except
  arg @ "_door/status" "closed" setprop
;

: knock
  arg @ match arg !
  arg @ #-1 = if "I don't see anything like that here." .tell exit then
  arg @ #-2 = if "I'm not sure which one you mean." .tell exit then
  arg @ #-3 = if "Danger! Danger, Will Robinson!" .tell exit then
  arg @ exit? not if "You can't knock on that!" .tell exit then
  arg @ "_door" propdir? not if "That's not a door!" .tell exit then
  arg @ getlink room? not if "That's not a door!" .tell exit then
  "You knock on the door to " arg @ getlink name "." strcat strcat .tell
  loc @ me @ dup name " knocks on the door to " arg @ getlink name "." strcat strcat strcat notify_except
  arg @ getlink #-1 me @ name " knocks on the door from " loc @ name "." strcat strcat strcat notify_except
;

: main
  command @ tolower command ! arg !
  arg @ not if "You need to specify a target." .tell exit then
  arg @ tolower "#help" strcmp not if help exit then
  command @ case
    "makedoor" strcmp not if pop makedoor exit end
    "open" strcmp not if pop opendoor exit end
    "close" strcmp not if pop closedoor exit end
    "knock" strcmp not if pop knock exit end
    default "Danger! Danger, Will Robinson!" .tell exit end
  endcase
;
