( Kat-Teleport.muf -- Copyright 2004-2006 Raine 'Gravecat' Simmons <raine@moxx.net>

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
$def PATCH_VERSION 4
 
: ver display_version ;
 
PUBLIC ver

$def DEFAULT_SUCC "Teleporting..."
$def DEFAULT_OSUCC "disappears with a mild flash of light."
$def DEFAULT_ODROP "appears with a *pop*."

$include $lib/ansify
$include $lib/kat

lvar target
lvar global

: tport-succ ( -- s )
  me @ "_tel/succ" getpropstr dup not if pop DEFAULT_SUCC then
;

: tport-osucc ( -- s )
  me @ "_tel/osucc" getpropstr dup not if pop DEFAULT_OSUCC then
  me @ name " " strcat swap strcat
;

: tport-odrop ( -- s )
  me @ "_tel/odrop" getpropstr dup not if pop DEFAULT_ODROP then
  me @ name " " strcat swap strcat
;

: region-propdir ( -- s )
  "_tel/dests/" me @ "~region" envpropstr swap pop strcat "/" strcat
;

: dest-ok? ( d -- i )	( Checks whether we have permission to teleport to a certain location. )
  dup ok? not if pop 0 exit then	( Sanity check. )
  dup me @ swap controls if pop 1 exit then	( If we control the room, return 1. )
  dup "J" flag? if pop 1 exit then	( Is the room set J? It's okay to tport in, then. )
  dup "_tel/ok?" getpropstr .yes? if pop 1 exit then	( is the room set _tel/ok?:yes )
  pop 0 	( No entry. )
;

: do-teleport ( -- )	( Let's go! )
  tport-succ .tell
  loc @ me @ tport-osucc notify_except
  me @ target @ moveto	( Move us to where we want to go, yessss. )
  me @ location me @ tport-odrop notify_except
;

: tport-to-room ( d -- )
  target !	( Store target destination. )
  target @ #-1 = if "I don't recognize that teleport destination." .tell exit then
  target @ #-2 = if "Sorry, I'm not sure where you want to teleport to." .tell exit then
  target @ #-3 = if me @ getlink target ! then	( If HOME, set to where the player is linked to. )
  target @ room? not if "That's not a room!" .tell exit then
  target @ dest-ok? not if "Destination does not allow teleport." .tell exit then
  do-teleport
;

: add-dest ( s -- )
  "" "#gadd" subst
  "" "#add" subst strip
  "=" split
  dup not if "You need to specify a destination for the alias." .tell exit then
  swap dup not if "You need to specify a name for the alias." .tell exit then
  swap match target !
  target @ room? not if "You can only add an alias for a room." .tell exit then
  target @ dest-ok? not if "Permission denied." .tell exit then
  global @ if
    prog region-propdir rot strcat target @ setprop
    "Global teleport alias added." .tell
  else
    me @ "_tel/dests/" rot strcat target @ setprop
    "Teleport alias added." .tell
  then
;

: del-dest ( -- )
  "" "#gdel" subst
  "" "#del" subst strip
  dup not if "You need to specify an alias to delete." .tell exit then
  global @ if
    prog region-propdir 3 pick strcat
  else
    me @ "_tel/dests/" 3 pick strcat
  then
  getprop not if pop "That alias does not exist." .tell exit then
  global @ if
    prog region-propdir rot strcat
  else
    me @ "_tel/dests/" rot strcat
  then
  remove_prop "Alias deleted." .tell
;

: show-alias ( s -- )
  dup "/" split "/" split swap pop swap pop 21 cut-at
  me @ 3 pick getprop name strcat .tell
;

: show-global-alias ( s -- )
  dup "/" split swap pop
  "/" split swap pop
  ( "/" split swap pop )
  21 cut-at
  prog 3 pick getprop name strcat .tell
;

: list-dests ( -- )
  " " .tell
  me @ "_tel/dests/" nextprop dup if
    "~&170## Personal Aliases:" ansi-tell
    " " .tell
    "~&120Alias Name           Location" ansi-tell
    "~&170-------------------- -------------------------------" ansi-tell
    show-alias
    begin
      me @ swap nextprop dup not if pop break then
      show-alias
    repeat
    " " .tell
  then
  ( "~&170## Destinations in " me @ "~region" envpropstr swap pop strcat ":" strcat ansi-tell )
  "~&170## Global Aliases:" ansi-tell
  " " .tell
  "~&120Alias Name           Location" ansi-tell
  "~&170-------------------- -------------------------------" ansi-tell
  ( "_tel/dests/" me @ "~region" envpropstr swap pop strcat "/" strcat begin )
  "_tel/dests/" begin
    prog swap nextprop dup not if pop break then
    show-global-alias
  repeat
  " " .tell
;

: banner ( -- )
  " " .tell
  "~&160.----------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|   ~&120Kat-Teleport.muf   ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|      ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-     ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'----------------------'-~&170\"\"~&160-----~&170\"\"~&160-." ansi-tell
  "~&160| Copyright (C) 2004-2006 Gravecat |" ansi-tell
  "~&160'----------------------------------'" ansi-tell
  " " .tell
;

: help ( -- )
  banner
  "~&120Options:" ansi-tell
  " #dbref, $regname," .tell
  " ~&170or~&R teleport alias        -- Teleports you to this destination." ansi-tell
  " #help                    -- This screen." .tell
  " #props                   -- Displays properties used by teleport." .tell
  " #add <name>=<place>      -- Adds an alias to your personal list." .tell
  " #del <name>              -- Removes an alias from your personal list." .tell
  " " .tell
  "~&120Wizard Options:" ansi-tell
  " #gadd <name>=<place>     -- Adds an alias to the global list." .tell
  " #gdel <name>             -- Removes an alias from the global list." .tell
  " " .tell
;

: help-props ( -- )
  banner
  "~&120Properties:" ansi-tell
  " " .tell
  " ~&160On you:" ansi-tell
  "  _tel/succ   -- Message you see where and when you teleport out." .tell
  "  _tel/osucc  -- Message others when and where see you teleport out." .tell
  "  _tel/odrop  -- Message others see when you teleport in." .tell
  " " .tell
  " ~&160On room/parent room:" ansi-tell
  "  The JUMP_OK flag will be used to allow/deny teleport permission." .tell
  "  If J is unset, _tel/ok? may be used instead." .tell
  "  _tel/ok?    -- If yes, allows teleport." .tell
  " " .tell
;

: main ( s -- )
  tolower
  dup 1 5 midstr "#help" strcmp not if help exit then
  dup 1 6 midstr "#props" strcmp not if help-props exit then
  dup 1 4 midstr "#add" strcmp not if 0 global ! add-dest exit then
  dup 1 5 midstr "#gadd" strcmp not if
    me @ "W" flag? not if "Permission denied." .tell exit then
    1 global ! add-dest exit
  then
  dup 1 4 midstr "#del" strcmp not if 0 global ! del-dest exit then
  dup 1 5 midstr "#gdel" strcmp not if
    me @ "W" flag? not if "Permission denied." .tell exit then
    1 global ! del-dest exit
  then
  dup 1 5 midstr "#list" strcmp not if list-dests exit then
  dup 1 1 midstr "#" strcmp not if match tport-to-room exit then
  dup 1 1 midstr "$" strcmp not if match tport-to-room exit then
  dup "home" strcmp not if match tport-to-room exit then
  me @ "_tel/dests/" 3 pick strcat getprop dup if swap pop tport-to-room exit else pop then
  ( region-propdir swap strcat
  prog swap getprop dup if tport-to-room exit else pop then )
  prog "_tel/dests/" 3 pick strcat getprop dup if swap pop tport-to-room exit else pop then
  "Sorry, that's not a valid teleport destination." .tell
;
