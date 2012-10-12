( Kat-Fruit.muf -- Copyright 2003-2006 Tom 'Gravecat' Simmons <http://gravec.at/>

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


$def MAJOR_VERSION 3
$def MINOR_VERSION 0
$def PATCH_VERSION 2
 
: ver display_version ;
 
PUBLIC ver

$include $lib/ansify
$include $lib/kat

var wheel1
var wheel1n
var wheel2
var wheel2n
var wheel3
var wheel3n
var count
var wheel

: text_only?
  me @ "_prefs/fruit/text?" getpropstr
  "yes" strcmp if 0 else 1 then
;

: help
  " " .tell
  "~&160.--------------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|      ~&120Kat-Fruit.muf       ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|       ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-        ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'--------------------------'-~&170\"\"~&160-----~&170\"\"~&160-." ansi-tell
  "~&160|   Copyright (C) 2003-2006 Gravecat   |" ansi-tell
  "~&160| Fruit ASCII art by www.ascii-art.com |" ansi-tell
  "~&160'--------------------------------------'" ansi-tell
  " " .tell
  "This is a pretty standard fruit machine - you put money in, spin the wheels, and" .tell
  "if you're lucky, you'll win anything from a handful to a sackful of money." .tell
  " " .tell
  "It's pretty straightforward to use, but I've added a text-only mode for those" .tell
  "who think the machine is too spammy, and would like to be able to hold a" .tell
  "conversation while they play. To enable text mode, type: ~&120spin #text" ansi-tell
  "And to go back to graphics: ~&120spin #!text" ansi-tell
  " " .tell
  "Want to know what the costs and prizes are on this machine? Type: ~&120spin #prizes" ansi-tell
  " " .tell
;

: setbig ( i -- )
  trig location "~bignum" rot setprop
  "%d-%B-%Y" systime timefmt trig location "~bigtime" rot setprop
  trig location "~bigwho" me @ setprop
;

: payout ( i -- )
  dup me @ swap addpennies
  trig location "~payout" getprop + trig location "~payout" rot setprop
;

: set_text
  me @ "_prefs/fruit/text?" "yes" setprop
  "~&020[~&120-~&020] ~&070Text-only mode enabled! You will no longer see the fruit graphics." ansi-tell
;

: remove_text
  me @ "_prefs/fruit/text?" remove_prop
  "~&020[~&120-~&020] ~&070Text-only mode disabled! You will see the fruit graphics again." ansi-tell
;

: display_none
  count @ 1 =
  count @ 5 = or if
    "~&170   | | | | |  " exit
  then
  count @ 2 =
  count @ 4 = or
  count @ 6 = or
  count @ 8 = or if
    "              " exit
  then
  count @ 3 =
  count @ 7 = or if
    "~&170  | | | | |   " exit
  then
;

: display_apple
  count @ 1 = if
    "   ~&020<}\\        " exit
  then
  count @ 2 = if
    "   ~&110.--~&020\\~&110--.    " exit
  then
  count @ 3 = if
    "  ~&110/   `   \\   " exit
  then
  count @ 4 = if
    "  ~&110|       |   " exit
  then
  count @ 5 = if
    "   ~&110\\     /    " exit
  then
  count @ 6 = if
    "    ~&110'-'-'     " exit
  then
  count @ 7 = if
    "              " exit
  then
  count @ 8 = if
    "~&170    APPLE     "
  then
;

: display_banana
  count @ 2 = if
    "     ~&130_        " exit
  then
  count @ 3 = if
    "   ~&130_ \\'-_,#   " exit
  then
  count @ 4 = if
    "  ~&130_\\'--','`|  " exit
  then
  count @ 5 = if
    "  ~&130\\`---`  /   " exit
  then
  count @ 6 = if
    "   ~&130`----'`    " exit
  then
  count @ 1 =
  count @ 7 = or if
    "              " exit
  then
  count @ 8 = if
    "~&170    BANANA    "
  then
;

: display_raspberry
  count @ 2 = if
    "     ~&110.~&020\\V/~&110,    " exit
  then
  count @ 3 = if
    "    ~&110()_()_)   " exit
  then
  count @ 4 = if
    "   ~&110(.(_)()_)  " exit
  then
  count @ 5 = if
    "    ~&110(_(_).)'  " exit
  then
  count @ 6 = if
    "     ~&110`'\"'`    " exit
  then
  count @ 1 =
  count @ 7 = or if
    "              " exit
  then
  count @ 8 = if
    "~&170   RASPBERRY  "
  then
;

: display_strawberry
  count @ 1 = if
    "     ~&020\\VW/     " exit
  then
  count @ 2 = if
    "   ~&110.::::::.   " exit
  then
  count @ 3 = if
    "   ~&110::::::::   " exit
  then
  count @ 4 = if
    "   ~&110'::::::'   " exit
  then
  count @ 5 = if
    "    ~&110'::::'    " exit
  then
  count @ 6 = if
    "     ~&110`\"`      " exit
  then
  count @ 7 = if
    "              " exit
  then
  count @ 8 = if
    "~&170  STRAWBERRY  "
  then
;

: display_pineapple
  count @ 1 =
  count @ 2 = or if
    "     ~&120\\||/     " exit
  then
  count @ 3 = if
    "   ~&130.<><><>.   " exit
  then
  count @ 4 = if
    "  ~&130.<><><><>.  " exit
  then
  count @ 5 = if
    "  ~&130'<><><><>'  " exit
  then
  count @ 6 = if
    "   ~&130'<><><>'   " exit
  then
  count @ 7 = if
    "              " exit
  then
  count @ 8 = if
    "~&170  PINEAPPLE   "
  then
;

: display_pumpkin
  count @ 4 = if
    "      ~&030_~&020)~&030_     " exit
  then
  count @ 5 = if
    "    ~&030/`/\"\\`\\   " exit
  then
  count @ 6 = if
    "    ~&030\\_\\_/_/   " exit
  then
  count @ 1 =
  count @ 2 = or
  count @ 3 = or
  count @ 7 = or if
    "              " exit
  then
  count @ 8 = if
    "    ~&170PUMPKIN   " exit
  then
;

: display_lemon
  count @ 3 = if
    "    ~&130,.--.     " exit
  then
  count @ 4 = if
    "   ~&130// .  \\    " exit
  then
  count @ 5 = if
    "   ~&130\\\\  . /    " exit
  then
  count @ 6 = if
    "    ~&130`'--'     " exit
  then
  count @ 1 =
  count @ 2 = or
  count @ 7 = or if
    "              " exit
  then
  count @ 8 = if
    "    ~&170LEMON     "
  then
;

: display_seven

  wheel @ 1 = if "~&110" then
  wheel @ 2 = if "~&130" then
  wheel @ 3 = if "~&120" then
  
  count @ 1 =
  count @ 7 = or if
    "              " strcat exit
  then
  count @ 2 = if
    "     ___      " strcat exit
  then
  count @ 3 = if
    "   //   / /   " strcat exit
  then
  count @ 4 = if
    "       / /    " strcat exit
  then
  count @ 5 = if
    "      / /     " strcat exit
  then
  count @ 6 = if
    "     / /      " strcat exit
  then
  count @ 8 = if
    text_only? not if pop then
    "    ~&170SEVEN     "
  then
;

: display_bar

  wheel @ 1 = if "~&160" then
  wheel @ 2 = if "~&140" then
  wheel @ 3 = if "~&150" then

  count @ 7 =
  count @ 3 = or if
    "              " strcat exit
  then
  count @ 1 =
  count @ 6 = or if
    "  _________   " strcat exit
  then
  count @ 2 =
  count @ 5 = or if
    " ___________  " strcat exit
  then
  count @ 4 = if
    "   B  A  R    " strcat exit
  then
  count @ 8 = if
    text_only? not if pop then
    "     ~&170BAR      "
  then
;

: display_line
  dup "NUL" strcmp not if pop display_none exit then
  dup "APL" strcmp not if pop display_apple exit then
  dup "BAN" strcmp not if pop display_banana exit then
  dup "RAS" strcmp not if pop display_raspberry exit then
  dup "STR" strcmp not if pop display_strawberry exit then
  dup "PIN" strcmp not if pop display_pineapple exit then
  dup "PUM" strcmp not if pop display_pumpkin exit then
  dup "LEM" strcmp not if pop display_lemon exit then
  dup "SVN" strcmp not if pop display_seven exit then
  dup "BAR" strcmp not if pop display_bar exit then
;

: process_wheel1

  wheel1n @ not if
    "NUL" wheel1 ! exit
  then

  wheel1n @ 0 >
  wheel1n @ 6 < and if
    "APL" wheel1 ! exit
  then
  
  wheel1n @ 5 >
  wheel1n @ 10 < and if
    "BAN" wheel1 ! exit
  then
  
  wheel1n @ 9 >
  wheel1n @ 13 < and if
    "RAS" wheel1 ! exit
  then
  
  wheel1n @ 12 >
  wheel1n @ 16 < and if
    "STR" wheel1 ! exit
  then
  
  wheel1n @ 16 = if
    "PIN" wheel1 ! exit
  then
  
  wheel1n @ 17 = if
    "BAR" wheel1 ! exit
  then
  
  wheel1n @ 18 = if
    "SVN" wheel1 ! exit
  then
  
  "LEM" wheel1 !
;

: process_wheel2

  wheel2n @ not if
    "NUL" wheel2 ! exit
  then
  
  wheel2n @ 1 =
  wheel2n @ 2 = or if
    "APL" wheel2 ! exit
  then
  
  wheel2n @ 2 >
  wheel2n @ 7 < and if
    "BAN" wheel2 ! exit
  then
  
  wheel2n @ 6 >
  wheel2n @ 11 < and if
    "RAS" wheel2 ! exit
  then
  
  wheel2n @ 10 >
  wheel2n @ 14 < and if
    "STR" wheel2 ! exit
  then
  
  wheel2n @ 14 = if
    "PIN" wheel2 ! exit
  then
  
  wheel2n @ 17 = if
    "BAR" wheel2 ! exit
  then
  
  wheel2n @ 18 = if
    "SVN" wheel2 ! exit
  then
  
  "LEM" wheel2 !
;

: process_wheel3

  wheel3n @ not if
    "NUL" wheel3 ! exit
  then
  
  wheel3n @ 0 >
  wheel3n @ 4 < and if
    "APL" wheel3 ! exit
  then
  
  wheel3n @ 3 >
  wheel3n @ 8 < and if
    "BAN" wheel3 ! exit
  then
  
  wheel3n @ 7 >
  wheel3n @ 12 < and if
    "RAS" wheel3 ! exit
  then
  
  wheel3n @ 12 = if
    "STR" wheel3 ! exit
  then
  
  wheel3n @ 13 = if
    "PIN" wheel3 ! exit
  then
  
  wheel3n @ 14 = if
    "BAR" wheel3 ! exit
  then
  
  wheel3n @ 15 = if
    "SVN" wheel3 ! exit
  then

  "LEM" wheel3 !
;

: show_prizes
  " " .tell
  "~&170Each game costs......................~&1201 " "penny" sysparm strcat ansi-tell
  " " .tell
  "~&170Apple-Any-Any........................~&1202 " "pennies" sysparm strcat ansi-tell
  "~&170Apple-Apple-Any......................~&1205 " "pennies" sysparm strcat ansi-tell
  "~&170Three Apples.........................~&12010 " "pennies" sysparm strcat ansi-tell
  "~&170Three Bananas........................~&12015 " "pennies" sysparm strcat ansi-tell
  "~&170Three Raspberries....................~&12020 " "pennies" sysparm strcat ansi-tell
  "~&170Three Strawberries...................~&12050 " "pennies" sysparm strcat ansi-tell
  "~&170Three Bars (LESSER JACKPOT)..........~&120100 " "pennies" sysparm strcat ansi-tell
  "~&170Three Pineapples (JACKPOT)...........~&120500 " "pennies" sysparm strcat ansi-tell
  "~&170Three Sevens (GRAND JACKPOT).........~&1201000 " "pennies" sysparm strcat ansi-tell
  " " .tell
  "This fruit machine has been fed ~&120"
  trig location "~spins" getprop intostr strcat " " "pennies" sysparm strcat strcat
  "~&R, and paid out a total of ~&120" strcat
  trig location "~payout" getprop intostr strcat "~&R." strcat

  trig location "~bigwho" getprop if
    " The last big payout was ~&120"
    trig location "~bignum" getprop intostr strcat
    " " "pennies" sysparm strcat "~&R to ~&120" strcat strcat
    trig location "~bigwho" getprop name strcat
    "~&R, on ~&120" strcat
    trig location "~bigtime" getprop strcat
    "~&R." strcat strcat
  then

  trig location "~jpwho" getprop if
    " The last jackpot was ~&120"
    trig location "~jpnum" getprop intostr strcat
    " " "pennies" sysparm strcat "~&R, won by ~&120" strcat strcat
    trig location "~jpwho" getprop name strcat
    "~&R, on ~&120" strcat
    trig location "~jptime" getprop strcat
    "~&R." strcat strcat
  then
  
  ansi-tell " " .tell
;

: process_wheels
  process_wheel1
  process_wheel2
  process_wheel3
;

: display
  process_wheels
  text_only? if
    8 count !
    wheel1 @ display_line
    wheel2 @ display_line
    wheel3 @ display_line
    strcat strcat ansi-tell
  else
    " " .tell
    1 8 1 for
      count !
      1 wheel ! wheel1 @ display_line
      2 wheel ! wheel2 @ display_line
      3 wheel ! wheel3 @ display_line
      strcat strcat ansi-tell
    repeat
  then
  " " .tell
;

: prize_3
  wheel1 @ "LEM" strcmp not if
    "~&020[~&120-~&020] ~&070Three lemons! You get a free spin!" ansi-tell
    " " .tell
    1 payout exit
  then
  wheel1 @ "APL" strcmp not if
    "~&020[~&120-~&020] ~&070Three apples! You win ~&12010~&070 " "pennies" sysparm "!" strcat strcat ansi-tell
    " " .tell
    10 payout exit
  then
  wheel1 @ "BAN" strcmp not if
    "~&020[~&120-~&020] ~&070Three bananas! You win ~&12015~&070 " "pennies" sysparm "!" strcat strcat ansi-tell
    " " .tell
    15 payout exit
  then
  wheel1 @ "RAS" strcmp not if
    "~&020[~&120-~&020] ~&070Three raspberries! You win ~&12020~&070 " "pennies" sysparm "!" strcat strcat ansi-tell
    " " .tell
    20 payout exit
  then
  wheel1 @ "STR" strcmp not if
    "~&020[~&120-~&020] ~&070Three strawberries! You win ~&12050~&070 " "pennies" sysparm "!" strcat strcat ansi-tell
    " " .tell
    50 setbig
    50 payout exit
  then
  ( wheel1 @ "PIN" strcmp not if
    "~&020[~&120-~&020] ~&070Three pineapples! You win ~&120100~&070 " "pennies" sysparm "!" strcat strcat ansi-tell
    " " .tell
    100 setbig
    100 payout exit
  then )
  wheel1 @ "BAR" strcmp not if
    "~&020[~&120-~&020] ~&110J~&130A~&120C~&160K~&150P~&110O~&120T~&130!~&160!~&150!~&170 You win the lesser jackpot prize of ~&120100~&170 " "pennies" sysparm "!!" strcat strcat ansi-tell
    " " .tell
    me @ location me @ "~&020[~&120-~&020] ~&070A truckload of coins falls out of a nearby fruit machine, at " me @ name "'s feet!"
    strcat strcat ansi-notify_except
    "%d-%B-%Y" systime timefmt trig location "~jptime" rot setprop
    trig location "~jpwho" me @ setprop
    trig location "~jpnum" 100 setprop
    100 setbig
    100 payout exit
  then
  wheel1 @ "PIN" strcmp not if
    "~&020[~&120-~&020] ~&110J~&130A~&120C~&160K~&150P~&110O~&120T~&130!~&160!~&150!~&170 You win the jackpot prize of ~&120500~&170 " "pennies" sysparm "!!" strcat strcat ansi-tell
    " " .tell
    me @ location me @ "~&020[~&120-~&020] ~&070A truckload of coins falls out of a nearby fruit machine, at " me @ name "'s feet!"
    strcat strcat ansi-notify_except
    "%d-%B-%Y" systime timefmt trig location "~jptime" rot setprop
    trig location "~jpwho" me @ setprop
    trig location "~jpnum" 500 setprop
    500 setbig
    500 payout exit
  then
  wheel1 @ "SVN" strcmp not if
    "~&020[~&120-~&020] ~&110J~&130A~&120C~&160K~&150P~&110O~&120T~&130!~&160!~&150!~&170 You win the grand jackpot prize of ~&1201000~&170 " "pennies" sysparm "!!" strcat strcat ansi-tell
    " " .tell
    me @ location me @ "~&020[~&120-~&020] ~&070A truckload of coins falls out of a nearby fruit machine, at " me @ name "'s feet!"
    strcat strcat ansi-notify_except
    "%d-%B-%Y" systime timefmt trig location "~jptime" rot setprop
    trig location "~jpwho" me @ setprop
    trig location "~jpnum" 1000 setprop
    1000 setbig
    1000 payout exit
  then
;

: prize_2
  "~&020[~&120-~&020] ~&070First two wheels are apples! You win ~&1205~&070 " "pennies" sysparm "!" strcat strcat ansi-tell
  " " .tell
  5 payout
;

: prize_1
  "~&020[~&120-~&020] ~&070First wheel is an apple! You win ~&1202~&070 " "pennies" sysparm "!" strcat strcat ansi-tell
  " " .tell
  2 payout
;

: process_prizes
  wheel1 @ wheel2 @ strcmp not
  wheel2 @ wheel3 @ strcmp not and if prize_3 exit then
  wheel1 @ "APL" strcmp not
  wheel2 @ "APL" strcmp not and if prize_2 exit then
  wheel1 @ "APL" strcmp not if prize_1 then
;

: main
  dup "#help" strcmp not if help exit then
  dup "#text" strcmp not if set_text exit then
  dup "#!text" strcmp not if remove_text exit then
  dup "#prizes" strcmp not if show_prizes exit then
  me @ pennies not if
    "Sorry, you don't have enough money left!" .tellbad exit
  then
  me @ -1 addpennies
  trig location "~spins" getprop ++ trig location "~spins" rot setprop
  random 21 % ++ wheel1n !
  display 2 sleep
  random 21 % ++ wheel2n !
  display 2 sleep
  random 21 % ++ wheel3n !
  display 1 sleep
  process_prizes
;
