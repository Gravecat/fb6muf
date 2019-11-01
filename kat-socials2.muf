( Kat-SocialsII.muf -- Copyright 2003-2006 Raine 'Gravecat' Simmons <raine@moxx.net>
Based on Socials v2.2 by Katt@Dreams

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
$def MINOR_VERSION 4
$def PATCH_VERSION 8
 
: ver display_version ;

PUBLIC ver

lvar target
lvar words
lvar pos
lvar string
lvar randomobject
lvar temp

$include $lib/ansify
$include $lib/case
$include $lib/kat

: banner ( -- )
  " " .tell
  "~&160.--------------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|        ~&120Socials-II        ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|        ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-       ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'--------------------------'-~&170\"\"~&160-----~&170\"\"~&160-." ansi-tell
  "~&160|   Copyright (C) 2003-2006 Gravecat   |" ansi-tell
  "~&160| Based on Socials v2.2 by Katt@Dreams |" ansi-tell
  "~&160'--------------------------------------'" ansi-tell
  " " .tell
;

: help ( -- )
  banner
  "   ~&120<social>~&070 - Use a social (e.g. 'dance')" ansi-tell
  "   ~&120<social> <target>~&070 - Use a social on someone (e.g. 'hug Katrina')" ansi-tell
  "   ~&120<social> me~&070 - Use a social on yourself (e.g. 'hug me')" ansi-tell
  " " .tell
  "See '" command @ " #help2' for information on how to make your own socials." strcat strcat .tell
  " " .tell
;

: help2 ( -- )
  " " .tell
  "~&170Making your own socials!" ansi-tell
  "~&170------------------------" ansi-tell
  " " .tell
  "First, you need to create an action for the social or socials to go on. The" .tell
  "action can be a single word (e.g. 'hug') or a list of semicolon-seperated words" .tell
  "(e.g. 'hug;pounce;fuzzle;scritch') to allow multiple socials." .tell
  " " .tell
  "   ~&120@act <social>=<object>,$socials" ansi-tell
  " " .tell
  "<social> is the name of the social or socials on this action, and <object> is" .tell
  "where you want to put it. If the action is on yourself, only you can use these" .tell
  "socials. If it's on an object, anyone holding the object or in the same room as" .tell
  "where it's been left can use them. And if it's in a room, anyone in that room" .tell
  "can use them.".tell
  " " .tell
  "Next, setting up the social messages. If you leave this part blank, your socials" .tell
  "will be pretty generic - for example, \"Katrina pounces Lucar!\"." .tell
  " " .tell
  "   ~&120@set <social>=<social>/target:<target message>" ansi-tell
  "   ~&120@set <social>=<social>/self:<self message>" ansi-tell
  "   ~&120@set <social>=<social>/null:<null message>" ansi-tell
  " " .tell
  "This may look a bit confusing, so here is an example:" .tell
  " " .tell
  "   ~&120@set hug=hug/target:%uN %vpull %tn into a warm hug." ansi-tell
  "   ~&120@set hug=hug/self:%uN %vgive %ur a hug." ansi-tell
  "   ~&120@set hug=hug/null:%uN %vspread %up arms, shouting, \"Group Hug!\"" ansi-tell
  " " .tell
  "The words prefixed with %v are words that should be pluralized to the target and" .tell
  "room. For example, \"%vpull\" will show up as \"pull\" on your screen, but \"pulls\"" .tell
  "on the screens of your target and everyone else in the room. The rest of the" .tell
  "pronouns consist of the defaults ('help pronouns'), prefixed with %u (user) or" .tell
  "%t (target). You may also use %random to specify a random object on the MUCK." .tell
  " " .tell
;

: socialslist ( -- )
  trig name
  "" "socials;" subst
  ", " ";" subst
  "Available socials: " swap strcat "." strcat .tell
;

: ensure ( s -- s' )
  dup me @ name strlen 1 swap midstr  me @ name strcmp not if exit then
  me @ name " " strcat swap strcat
;

: getrandomobject ( -- )
  "" begin pop random dbtop int % dbref dup thing? until
  dup "_nohide" getpropstr .yes? if pop getrandomobject exit then
  dup "@sporkfire" propdir? if pop getrandomobject exit then
  dup "@kat" propdir? if pop getrandomobject exit then
  dup "@active" getpropstr .yes? if pop getrandomobject exit then
  name strip randomobject !
  randomobject @ tolower case
    " plushie" instr when getrandomobject exit end
  endcase
;

: targetmesg ( -- s )
  trig command @ "/target" strcat getpropstr dup if exit then
  pop "%uN %v" command @ " %tn!" strcat strcat
;

: selfmesg ( -- s )
  trig command @ "/self" strcat getpropstr dup if exit then
  pop "%uN %v" command @ " %ur!" strcat strcat
;

: nullmesg ( -- s )
  trig command @ "/null" strcat getpropstr dup if exit then
  pop "%uN %v" command @ " everyone!" strcat strcat
;

: split-vword ( i s -- s s s )
  pos ! " " strcat string !
  string @ 1 pos @ 1 - midstr
  string @ pos @ string @ strlen 1 + pos @ - midstr
  dup " " instring pos !
  dup 1 pos @ 1 - midstr
  swap dup pos @ swap strlen midstr striptail
;

: remove-vwords ( s -- s' )
  dup "%v" instring dup not if pop exit then
  split-vword swap dup strlen 3 swap midstr swap
  strcat strcat remove-vwords
;

: parse-vwords ( s -- s' )
  dup "%v" instring dup not if pop exit then
  split-vword swap dup strlen 3 swap midstr
  dup dup strlen dup midstr case
    "h" strcmp not when "es" end
    "i" strcmp not when "es" end
    "j" strcmp not when "es" end
    "s" strcmp not when "es" end
    "x" strcmp not when "es" end
    "z" strcmp not when "es" end
    default pop "s" end
  endcase
  strcat swap
  strcat strcat parse-vwords
;

: parse-null ( s -- s' )
  me @ name "'s" strcat "%uN's" subst
  me @ name "%uN" subst
  me @ name "'s" strcat "%un's" subst
  me @ name "%un" subst
  target @ name "'s" strcat "%tN's" subst
  target @ name "%tN" subst
  target @ name "'s" strcat "%tn's" subst
  target @ name "%tn" subst

  me @ "%a" pronoun_sub "%ua" subst
  me @ "%s" pronoun_sub "%us" subst
  me @ "%o" pronoun_sub "%uo" subst
  me @ "%p" pronoun_sub "%up" subst
  me @ "%r" pronoun_sub "%ur" subst
  me @ "%A" pronoun_sub "%uA" subst
  me @ "%S" pronoun_sub "%uS" subst
  me @ "%O" pronoun_sub "%uO" subst
  me @ "%P" pronoun_sub "%uP" subst
  me @ "%R" pronoun_sub "%uR" subst

  target @ "%a" pronoun_sub "%ta" subst
  target @ "%s" pronoun_sub "%ts" subst
  target @ "%o" pronoun_sub "%to" subst
  target @ "%p" pronoun_sub "%tp" subst
  target @ "%r" pronoun_sub "%tr" subst
  target @ "%A" pronoun_sub "%tA" subst
  target @ "%S" pronoun_sub "%tS" subst
  target @ "%O" pronoun_sub "%tO" subst
  target @ "%P" pronoun_sub "%tP" subst
  target @ "%R" pronoun_sub "%tR" subst

  randomobject @ "%random" subst
  parse-vwords ensure
;

: parse-self ( s -- s' )
  "Your" "%uN's" subst
  "You" "%uN" subst
  "your" "%un's" subst
  "you" "%un" subst
  target @ name "'s" strcat "%tN's" subst
  target @ name "%tN" subst
  target @ name "'s" strcat "%tn's" subst
  target @ name "%tn" subst

  "yours" "%ua" subst
  "you" "%us" subst
  "you" "%uo" subst
  "your" "%up" subst
  "yourself" "%ur" subst
  "Yours" "%uA" subst
  "You" "%uS" subst
  "You" "%uO" subst
  "Your" "%uP" subst
  "Yourself" "%uR" subst

  target @ "%a" pronoun_sub "%ta" subst
  target @ "%s" pronoun_sub "%ts" subst
  target @ "%o" pronoun_sub "%to" subst
  target @ "%p" pronoun_sub "%tp" subst
  target @ "%r" pronoun_sub "%tr" subst
  target @ "%A" pronoun_sub "%tA" subst
  target @ "%S" pronoun_sub "%tS" subst
  target @ "%O" pronoun_sub "%tO" subst
  target @ "%P" pronoun_sub "%tP" subst
  target @ "%R" pronoun_sub "%tR" subst
  randomobject @ "%random" subst
  remove-vwords
;

: parse-target ( s -- s' )
  target @ name "'s" strcat "%tN's" subst
  me @ name "%uN" subst
  me @ name "'s" strcat "%un's" subst
  me @ name "%un" subst
  "Your" "%tN's" subst
  "You" "%tN" subst
  "your" "%tn's" subst
  "you" "%tn" subst

  me @ "%a" pronoun_sub "%ua" subst
  me @ "%s" pronoun_sub "%us" subst
  me @ "%o" pronoun_sub "%uo" subst
  me @ "%p" pronoun_sub "%up" subst
  me @ "%r" pronoun_sub "%ur" subst
  me @ "%A" pronoun_sub "%uA" subst
  me @ "%S" pronoun_sub "%uS" subst
  me @ "%O" pronoun_sub "%uO" subst
  me @ "%P" pronoun_sub "%uP" subst
  me @ "%R" pronoun_sub "%uR" subst

  "yours" "%ta" subst
  "you" "%ts" subst
  "you" "%to" subst
  "your" "%tp" subst
  "yourself" "%tr" subst
  "Yours" "%tA" subst
  "You" "%tS" subst
  "You" "%tO" subst
  "Your" "%tP" subst
  "Yourself" "%tR" subst

  randomobject @ "%random" subst
  parse-vwords ensure
;

: social ( s -- )
  dup parse-self .tell
  me @ target @ dbcmp not if dup parse-target target @ swap notify then
  parse-null loc @ me @ target @ 2 5 pick notify_exclude
;

: main
  dup tolower "#help" strcmp not if help exit then
  dup tolower "#help2" strcmp not if help2 exit then
  command @ tolower "socials" strcmp not if socialslist exit then
  dup not if
    pop #0 target !
  else
    kmatch target !
    target @ #-1 dbcmp if "I don't see anything like that here." .tell exit then
    target @ #-2 dbcmp if "I'm not sure which one you mean. Please be more specific." .tell exit then
    target @ #-3 dbcmp if "Don't be silly." .tell exit then
    target @ program? target @ exit? or if "That's a silly thing to " command @ "." strcat strcat .tell exit then
  then
  target @ player? if
    target @ location me @ location = not if
      "I don't see that person here." .tell exit
    then
  then
  getrandomobject
  target @ #0 dbcmp if nullmesg social exit then
  target @ me @ dbcmp if selfmesg social exit then
  targetmesg social
;
