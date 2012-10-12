( Kat-Look.muf -- Copyright 2004-2006 Tom 'Gravecat' Simmons <http://gravec.at/>
Modified by Premchaia to not show contents of things with an "H" flag.

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
$def PATCH_VERSION 6
 
: ver display_version ;
 
PUBLIC ver
 
$include $lib/ansify
$include $lib/strings
$include $lib/kat

lvar target
lvar r_array
lvar p_array
lvar s_array
lvar c_array
lvar array
lvar count
lvar string
lvar linelength   ( Added by Premchaia 2005-06-28 )
 
: get-linelength ( -- i )
  me @ "_prefs/cityscape/linelength" getprop dup if
    dup string? if atoi then dup float? if int then --
  else pop 79 then
 
  dup 66 < if pop 66 then
;
 
: optional_unparse
  me @ over controls me @ "S" flag? not and if unparseobj else name then
;
 
: do-array ( a s -- )
  ( Modified by Premchaia 2005-06-28 to use linelength @ rather than
    a hardcoded 79 characters. )
  array ! "~&100[ ~&170" swap strcat ": ~&R" strcat
  0 array @ array_count 1 - 1 for
    count !
    array @ count @ array_getitem optional_unparse
    dup strlen 50 > if
      50 cut-at
    then
    over libansi-strlen over libansi-strlen + linelength @ -- > if
      swap linelength @ cut-at "~&100]" strcat ansi-tell
      "~&100[                ~&R" swap strcat
    else
      strcat
    then
    count @ array @ array_count 1 - = not if ", " strcat then
  repeat
  linelength @ cut-at "~&100]" strcat ansi-tell
;
 
: room-look
  " " .tell
  me @ loc @ controls me @ "S" flag? not and if
    loc @ unparseobj "(" split "(" swap strcat swap "bold" textattr swap strcat .tell
  else
    loc @ name "bold" textattr .tell
  then
  loc @ "_/de" getpropstr not if
    "This room has no description set. Use \"@desc here=<description>\" to set one." .tell
  else
    loc @ "_/de" "" 1 parseprop ansi-tell
  then
  loc @ "D" flag? if " " .tell exit then
  loc @ "_/sc" getpropstr not if
    " " .tell
    pr_mode setmode
    loc @ "_/sc" "{cityscape}" setprop
    loc @ "_/sc" "" 1 parseprop pop
    loc @ "_/sc" remove_prop
    bg_mode setmode
  else
    loc @ "_/sc" "" 1 parseprop .tell
  then
  loc @ contents_array r_array !
  { }list p_array !
  { }list s_array !
  { }list c_array !
 
  0 r_array @ array_count 1 - 1 for
    r_array @ swap array_getitem
    dup player? if
      dup awake? if
        dup me @ = if pop else
          p_array @ array_appenditem p_array !
        then
      else
        s_array @ array_appenditem s_array !
      then
    else
      dup "D" flag? not if
        c_array @ array_appenditem c_array !
      then
    then
  repeat
 
  p_array @ array_count if "      Players" p_array @ do-array then
  s_array @ array_count if "     Sleepers" s_array @ do-array then
  c_array @ array_count if "     Contents" c_array @ do-array then
 
  " " .tell
;
 
: look-at-target
  target @ thing? if
    target @ "@gd" propdir? if target @ #9859 "appraise" call exit then	( KLUDGE by Gravecat )
  then
  target @ "_/de" getpropstr not if
    "You see nothing special." .tell
  else
    target @ "_/de" "" 1 parseprop .tell
  then
  target @ exit? target @ program? or if exit then
  target @ contents_array c_array !
  c_array @ array_count not if exit then
  { }list array !
  0 c_array @ array_count 1 - 1 for
    count ! c_array @ count @ array_getitem
    dup "D" flag? if pop else array @ array_appenditem array ! then
  repeat
  array @ array_count not if exit then
 
  ( Modified by Premchaia to not list contents of things with H. )
  target @ thing? target @ "H" flag? and not if
    target @ player? if "Carrying:" else "Contains:" then .tell
    0 array @ array_count 1 - 1 for
      array @ swap array_getitem optional_unparse .tell
    repeat
  then
;
 
: check-details	( d s -- )
  "_details/" swap strcat
  over over getpropstr not if
    "I don't see anything like that here." .tell pop pop exit then
  "(_details)" 1 parseprop .tell
;
 
: main
  "me" match me !
  me @ location loc !
  get-linelength linelength !    ( Added by Premchaia 2005-06-28 )
  dup not if pop room-look exit then
  tolower strip string !
  string @ match dup loc @ = if pop room-look exit then
  target !
  target @ #-1 = if
    string @ "'s" instr string @ "=" instr or if
      string @ "'s" instr if "'s" else "=" then string @ swap split striplead swap match
      dup ok? not if pop pop "I don't see anything like that here." .tell exit then
      dup 3 pick rmatch target !
      target @ #-1 = if
        swap check-details exit
      else pop pop then
      target @ #-2 = if "I'm not sure which one you mean." .tell exit then
      target @ #-3 = if "I'm sorry, Dave. I'm afraid I can't do that." .tell exit then
      look-at-target exit
    else
      me @ location string @ check-details exit
    then
  then
  target @ #-2 = if "I'm not sure which one you mean." .tell exit then
  target @ #-3 = if "I'm sorry, Dave. I'm afraid I can't do that." .tell exit then
  target @ location loc @ = if
    look-at-target
  else
    me @ target @ controls if
      look-at-target
    else
      target @ location me @ = if
        look-at-target
      else
        "I don't see anything like that here." .tell
      then
    then
  then
;
 
