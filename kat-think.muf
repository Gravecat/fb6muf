( Kat-Think.muf -- Copyright 2002-2006 Raine 'Gravecat' Simmons <raine@moxx.net>

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
$def MINOR_VERSION 2
$def PATCH_VERSION 2
 
: ver display_version ;
 
PUBLIC ver

$include $lib/ansify

lvar count
lvar count2
lvar message
lvar temp

: help
  " " .tell
  " " .tell
  "~&160.--------------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|      ~&120Kat-Think.muf       ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|       ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-        ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'--------------------------'-~&170\"\"~&160-----~&170\"\"~&160-." ansi-tell
  "~&160|   Copyright (C) 2002-2006 Gravecat   |" ansi-tell
  "~&160'--------------------------------------'" ansi-tell
  " " .tell
  "Usage:" .tell
  "   ~&120think ~&170<message>~&070 -- broadcasts a message to psionically active players in" ansi-tell
  "                      the room." .tell
  "   ~&120think all = ~&170<message>~&070 -- If you are a 'blaster', broadcasts to all players in" ansi-tell
  "                            the room regardless of their individual talents;" .tell
  "                            otherwise defaults to the previous case." .tell
  "   ~&120think ~&170<name> ~&120= ~&170<message>~&070 -- Broadcasts a message to your target. If you are" ansi-tell
  "                               not a blaster, they must have sufficient" .tell
  "                               ability to receive the message." .tell
  "   ~&120think = ~&170<message> ~&070-- Broadcasts a message to the same group you" ansi-tell
  "                        specified last time." .tell
  " " .tell
  "   ~&120think #help~&070 -- Shows this screen." ansi-tell
  "   ~&120think #scan~&070 -- Scans for all psionically-inclined people in the room." ansi-tell
  "   ~&120think #set ~&170<level>~&070 -- Sets your psionic level, where <level> is none," ansi-tell
  "                         sensitive, active, or blaster." .tell
  "   ~&120think #format ~&170<string>~&070 -- Sets your psionic message string." ansi-tell
  " " .tell
  "Psi formats automatically begin with your name, and can contain any text. The" .tell
  "message itself is placed wherever you put \"%m\". For example:" .tell
  " " .tell
  "   ~&120think #format thinks, <<%m>>!" ansi-tell
  "   ~&120think Woo and yay" ansi-tell
  " " .tell
  "Would display your psychic messages as something like:" .tell
  " " .tell
  "   ~&130" me @ name " thinks, <<Woo and yay>>!" strcat strcat ansi-tell
  " " .tell
;

: get-psi-level
  "_psi" getpropstr
  dup not if pop "none" exit then
  
;

: get-psi-format
  me @ "_psi_format" getpropstr
  dup not if pop "thinks, '%m'" exit then
;

: parse-psi-format
  swap "%m" subst
  me @ name " " strcat swap strcat
;

: change-status
  " " explode
  dup 1 = if
    "You need to specify what to set. Valid settings are: none, sensitive, active, blaster."
    .tell exit
  then
  dup 2 = not if
    "I'm sorry, I don't understand. Valid settings are: none, sensitive, active, blaster."
    .tell exit
  then
  pop pop
  dup "none" strcmp not if
    me @ "_psi" remove_prop
    "Psi status removed." .tell exit
  then
  dup "sensitive" strcmp not if
    me @ "_psi" "sensitive" setprop
    "Psi status set to sensitive." .tell exit
  then
  dup "active" strcmp not if
    me @ "_psi" "active" setprop
    "Psi status set to active." .tell exit
  then
  dup "blaster" strcmp not if
    me @ "_psi" "blaster" setprop
    "Psi status set to blaster." .tell exit
  then
  "I'm sorry, I don't understand. Valid settings are: none, sensitive, active, blaster." .tell exit
;

: implode
  dup 2 = not if
    dup 3 = if
      pop swap " " swap strcat strcat
    else
      2 -
      1 swap 1 for
        pop swap " " swap strcat strcat
      repeat
    then
  else
    pop
  then
;

: implode2
  dup 2 = not if
    dup 3 = if
      pop swap "=" swap strcat strcat
    else
      2 -
      1 swap 1 for
        pop swap "=" swap strcat strcat
      repeat
    then
  then
;

: change-format
  " " explode
  dup 1 = if
    me @ "_psi_format" remove_prop
    "Psi format reset to default!" .tell exit
  then
  swap pop implode
  dup me @ swap "_psi_format" swap setprop
  "Psi format set to: " me @ name " " strcat strcat swap strcat .tell
;

: is-psi?
  dup player? not if pop 0 exit then
  "_psi" getpropstr
  dup "active" strcmp not if pop 1 exit then
  dup "blaster" strcmp not if pop 1 exit then
  "sensitive" strcmp not if 2 exit then
  0
;

: psi-list
  "" count !
  "" count2 !
  loc @ contents
  dup is-psi? 1 = if dup name count ! then
  dup is-psi? 2 = if dup name count2 ! then
  begin
    next
    dup #-1 = not if
      dup is-psi? 1 = if
        count @ not if
          dup name count !
        else
          dup name " " swap strcat count @ swap strcat count !
        then
      then
      dup is-psi? 2 = if
        count2 @ not if
          dup name count2 !
        else
          dup name " " swap strcat count2 @ swap strcat count2 !
        then
      then
    then
  dup not until
  pop
;

: psi-scan
  psi-list
  count @ not if
    count2 @ count !
  else
    count2 @ if
      count @ " " count2 @ strcat strcat count !
    then
  then
  count @ not if
    "You sense no psychic activity in the room." .tell
  else
    "You scan for psychics: " count @ strcat .tell
  then
;

: think-normal
  get-psi-format
  parse-psi-format
  message !
  psi-list count @ " " explode
  1 swap 1 for
    pop pmatch dup #-1 = not if
      message @ notify
    then
  repeat
  
  count2 @ dup if
    " " explode
    1 swap 1 for
      pop pmatch dup #-1 = not if
        "You sense psychic activity from " me @ name "." strcat strcat notify
      then
    repeat
  then
;

: think-all
  me @ "_psi/last" "all" setprop
  me @ get-psi-level "blaster" strcmp if
    think-normal exit
  then
  get-psi-format
  parse-psi-format
  loc @ swap #-1 swap notify_except
;

: think-at
  dup name me @ swap "_psi/last" swap setprop
  me @ get-psi-level "blaster" strcmp if
    dup get-psi-level
    dup "none" strcmp not swap
    "sensitive" strcmp not or if
      "Your target has insufficient psionic abilities." .tell exit
    then
  then
  swap get-psi-format parse-psi-format message ! temp !
  temp @ message @ " [to you]" strcat notify
  message @ " [to " temp @ name "]" strcat strcat strcat .tell
;

: parse-message
  "=" explode
  dup 2 = not if
    swap temp ! implode2 temp @
  else
    pop
  then
  strip swap strip swap
  dup not if
    me @ "_psi/last" getpropstr
    dup not if
      "You need to specify a target!" .tell exit
    then
    swap pop
  then
  dup "all" strcmp not if
    pop think-all exit
  then
  pmatch dup #-1 = if "I don't know who you mean!" .tell exit then
  swap dup 1 1 midstr ":" strcmp not if
    dup strlen 2 swap midstr me @ name " " rot strcat strcat
  then swap
  think-at
;

: main
  dup "#help" instring if help exit then
  dup "#set" instring if change-status exit then
  dup "#format" instring if change-format exit then
  dup "#scan" instring if psi-scan exit then
  
  dup not if "For usage, type: psi #help" .tell exit then
  me @ get-psi-level
  dup "none" strcmp not swap "sensitive" strcmp not or if
    "You have insufficient psionic abilities." .tell exit
  then
  
  dup "=" instring if parse-message exit then
  
  think-normal
;
