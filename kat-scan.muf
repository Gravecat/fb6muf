( Kat-Scan -- Copyright 2002-2006 Tom 'Gravecat' Simmons <http://gravec.at/>

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
$def MINOR_VERSION 3
$def PATCH_VERSION 4
 
: ver display_version ;
 
PUBLIC ver

$include $lib/ansify
$include $lib/kat

var current
var errors
var ignored
var ignore-succ
var target
var count

: help
  " " .tell
  "~&160.--------------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|       ~&120Kat-Scan.muf       ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|        ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-       ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'--------------------------'-~&170\"\"~&160-----~&170\"\"~&160-." ansi-tell
  "~&160|   Copyright (C) 2002-2006 Gravecat   |" ansi-tell
  "~&160'--------------------------------------'" ansi-tell
  " " .tell
  "~&170Kat-Scan~&070 is a builder's tool, which is designed to warn you of any problems" ansi-tell
  "with objects you own. It scans through your possessions and points out any" .tell
  "errors (serious problems) or warnings (minor issues) that it finds. It's" .tell
  "designed to target the most common mistakes people make when building, and" .tell
  "will scan for more things as Grave upgrades it." .tell
  " " .tell
  "There are a few properties you can set, which affects the way the program" .tell
  "behaves. Firstly, while Grave believes that @osucc and @odrop are practically" .tell
  "essential for building (they just make an area feel more professional), some" .tell
  "people prefer not to use them. If you wish to automatically block any errors" .tell
  "related to @succ, @osucc or @odrop, simply type:" .tell
  " " .tell
  "  ~&120@set me=_katscan/ignoresucc:yes" ansi-tell
  " " .tell
  "If you want Kat-Scan to ignore an object entirely - for example, if you had" .tell
  "a button that just doesn't need a @desc - you can type:" .tell
  " " .tell
  "  ~&120@set <object>=_katscan/warnings:no" ansi-tell
  " " .tell
  "This will add the object to the 'ignored' list, and no warnings or errors" .tell
  "will be shown. More properties and commands will be added to Kat-Scan in" .tell
  "later versions." .tell
  " " .tell
;

: scan-player

  current @ "_/de" getpropstr strlen not if
    "You have no description set!" badtell errors ++
  then

  current @ "X" flag? if
    current @ "@/flk" getpropstr strlen not
    current @ "@/flk" getpropstr "*UNLOCKED*" strcmp not or if
      "You are set X-FORCIBLE. This means other players can control your actions. You can remove this with \"@set me=!X\"." warntell errors ++
    then
  then

;

: scan-room

  current @ "_/de" getpropstr strlen not if
    "Room " current @ name "(#" current @ intostr ") has no description set!" strcat strcat strcat strcat badtell errors ++
  then

  current @ "C" flag? if
    current @ "_/chlk" getpropstr strlen not if
      "Room " current @ name "(#" current @ intostr ") is set CHOWN_OK and has no @chlock set. This is bad, as it means anyone can steal it." strcat strcat strcat strcat badtell errors ++
    then
  then

;

: scan-thing

  current @ "_/de" getpropstr strlen not if
    "Object " current @ name "(#" current @ intostr ") has no description set!" strcat strcat strcat strcat badtell errors ++
  then

  current @ "C" flag? if
    current @ "_/chlk" getpropstr strlen not if
      "Object " current @ name "(#" current @ intostr ") is set CHOWN_OK and has no @chlock set. This is bad, as it means anyone can steal it." strcat strcat strcat strcat warntell errors ++
    then
  then

;

: scan-prog
;

: scan-exit-to-room

  ignore-succ @ not if
    current @ "D" flag? not if
      current @ "_/odr" getpropstr strlen not if
        "Room exit " current @ name "(#" current @ intostr ") has no @odrop!" strcat strcat strcat strcat warntell errors ++
      then
      current @ "_/osc" getpropstr strlen not if
        "Room exit " current @ name "(#" current @ intostr ") has no @osucc!" strcat strcat strcat strcat warntell errors ++
      then
    then
  then
;

: scan-exit-mpi

  ignore-succ @ not if

    current @ "_/sc" getpropstr strlen not if
      current @ "_/fl" getpropstr strlen not if
        "$nothing exit " current @ name "(#" current @ intostr ") has no @succ or @fail!" strcat strcat strcat strcat warntell errors ++
      then
    then

  then

;

: scan-exit-to-muf
;

: scan-exit

  current @ getlink

  dup #-1 = if
    "Exit " current @ name "(#" current @ intostr ") is unlinked!" strcat strcat strcat strcat badtell errors ++
  then

  current @ "C" flag? if
    "Exit " current @ name "(#" current @ intostr ") is set CHOWN_OK. This is bad, as it means anyone can steal it." strcat strcat strcat strcat warntell errors ++
  then

  dup room? if scan-exit-to-room pop exit then

  dup #80 = if scan-exit-mpi pop exit then

  dup program? if scan-exit-to-muf pop exit then

  pop

;

: scan-obj
  current @ "_katscan/warnings" getpropstr "no" strcmp not if ignored ++ exit then
  current @ player? if scan-player exit then
  current @ room? if scan-room exit then
  current @ thing? if scan-thing exit then
  current @ program? if scan-prog exit then
  current @ exit? if scan-exit exit then
;

: end-scan
  count @ intostr " objects scanned. " strcat
  errors @ 0 = if "No errors/warnings found. " else
    errors @ 1 = if "One error/warning found. " else
      errors @ intostr " errors/warnings found. " strcat
    then
  then
  ignored @ 0 = if "No objects ignored." else
    ignored @ 1 = if "One object ignored." else
      ignored @ intostr " objects ignored." strcat
    then
  then
  strcat strcat goodtell
  " " .tell
;

: start-scan
  0 errors !
  0 ignored !
  me @ "_katscan/ignoresucc" getpropstr "yes" strcmp not if
    1 ignore-succ !
  else
    0 ignore-succ !
  then
  target @ nextowned
  #-1 = if "You don't own any objects!" badtell exit then
  " " .tell
  "Starting Kat-Scan"
  me @ target @ dbcmp not if
    " for " target @ name strcat strcat
  then
  "..." strcat goodtell
  target @ current !
  0 count !
  begin
    scan-obj count ++
    current @ nextowned current !
    #-1 current @ = if end-scan exit then
  repeat
;

: main
  dup toupper "#HELP" strcmp not if help exit then
  me @ "W" flag?
  swap dup rot and if
    pmatch dup #-1 dbcmp if
      "That's not a player!" badtell exit
    then
    target !
  else
    me @ target !
  then
  start-scan
;
