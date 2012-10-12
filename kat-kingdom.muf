( Kat-Kingdom.muf -- Copyright 2004-2006 Tom 'Gravecat' Simmons <http://gravec.at/>
Based on Yellow River Kingdom for the BBC Micro by Tom Hartley, Jerry Temple-Fry and Richard G Warner

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


( To anyone reading this code:
Yes, I'm quite aware that it's messy, and many of the variables have extremely vague names.
This code was ported directly from the highly obfuscated BBC Micro version, which was written
in BASIC. As we all know, BASIC and MUF are hardly similar, hence the heavy emphasis on
variables, and oddly-structured code. All efforts were made to preserve the original
behaviour of the BBC Micro code.
  
Some variables seem to have a purpose, and were renamed. For example, A was changed to
river, and B was changed to fields. However, some variables -- such as I, or T -- seem to
have no fixed purpose, and are simply used for temporary calculations. )


$def MAJOR_VERSION 1
$def MINOR_VERSION 0
$def PATCH_VERSION 3
 
: ver display_version ;
 
PUBLIC ver

$include $lib/ansify
$include $lib/case
$include $lib/kat

var food
var population
var season
var river
var village
var fields
var grain
var year
var fs
var op
var vf
var i
var t
var f1
var f2
var flood_food
var flood_deaths
var thief_food
var thief_deaths
var starvation
var flooded?
var attacked?
var failure

$def NOBODY_LEFT 1
$def ALL_STARVED 2
$def NUCLEAR 3

: village-peaceful ( -- )
  " " .tell
  "~&160~~&140||                              ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                               ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||         ~&120#*#                  ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||         ~&120*#*                   ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                              ~&010/\\/\\~&110TT~&010/\\/\\/\\" ansi-tell
  "~&160~~&140||                               ~&010/\\~&110THIEVES~&010\\/\\" ansi-tell
  "~&160~~&140||                ~&120#*#           ~&010/\\/\\~&110T~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                ~&120*#*            ~&010/\\/\\~&110T~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                              ~&010/\\/\\/~&110T~&010/\\/\\/\\" ansi-tell
  "~&160~~&140||                               ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                 ~&120*#*          ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                 ~&120#*#           ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                              ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                               ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                              ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&170RIVER         VILLAGES             MOUNTAINS" ansi-tell
  " " .tell
;

: village-flood ( -- )
  " " .tell
  "~&160~~&140||                              ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                               ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||         ~&160~&120#*#~&160~~                ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||         ~&160~~~~~~~               ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||    ~&160~~~~~~~~~~                ~&010/\\/\\~&110TT~&010/\\/\\/\\" ansi-tell
  "~&160~~~~~~~~~~~~~~~                   ~&010/\\~&110THIEVES~&010\\/\\" ansi-tell
  "~&160~~~~~~~~~~~~~~~~~   ~&120#*#          ~&010/\\/\\~&110T~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||  ~&160~~~~~~~~~~~~~~~~&120#*#           ~&010/\\/\\~&110T~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||     ~&160~~~~~   ~~~~~~~          ~&010/\\/\\/~&110T~&010/\\/\\/\\" ansi-tell
  "~&160~~&140||       ~&160~~~~                    ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||        ~&160~~~~~~   ~&120*#*          ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||           ~&160~~~~~~~~&120*#           ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||              ~&160~~              ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                               ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                              ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&170RIVER         VILLAGES             MOUNTAINS" ansi-tell
  " " .tell
;

: village-thieves ( -- )
  " " .tell
  "~&160~~&140||                              ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                               ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||         ~&120#~&110TT                  ~&010/~&110T~&010/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||         ~&120*#*       ~&110T   T T     ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                              ~&010/\\/\\~&110TT~&010/\\/\\/\\" ansi-tell
  "~&160~~&140||                               ~&010/\\~&110THIEVES~&010\\/\\" ansi-tell
  "~&160~~&140||                ~&120#~&110T~&120#           ~&010/\\/\\~&110T~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                ~&120*~&110TT            ~&010/\\/\\~&110T~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                          ~&110T  T~&010/\\/\\/~&110T~&010/\\/\\/\\" ansi-tell
  "~&160~~&140||                               ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                 ~&120*#*          ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                 ~&120#*~&110T           ~&010/\\~&110T~&010\\~&110T~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                           ~&110T  ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                              ~&110T~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                              ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&170RIVER         VILLAGES             MOUNTAINS" ansi-tell
  " " .tell
;

: village-flood-thieves ( -- )
  " " .tell
  "~&160~~&140||                              ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                               ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||         ~&160~&120#~&110TT~&160~~                ~&010/~&110T~&010/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||         ~&160~~~~~~~    ~&110T   T T    ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||    ~&160~~~~~~~~~~                ~&010/\\/\\~&110TT~&010/\\/\\/\\" ansi-tell
  "~&160~~~~~~~~~~~~~~~                   ~&010/\\~&110THIEVES~&010\\/\\" ansi-tell
  "~&160~~~~~~~~~~~~~~~~~   ~&120#~&110T~&120#          ~&010/\\/\\~&110T~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||  ~&160~~~~~~~~~~~~~~~~&120#~&110TT           ~&010/\\/\\~&110T~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||     ~&160~~~~~   ~~~~~~~      ~&110T  T~&010/\\/\\/~&110T~&010/\\/\\/\\" ansi-tell
  "~&160~~&140||       ~&160~~~~                    ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||        ~&160~~~~~~   ~&120*#*          ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||           ~&160~~~~~~~~&120*~&110T           ~&010/\\~&110T~&010\\~&110T~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||              ~&160~~           ~&110T  ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                              ~&110T~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                              ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&170RIVER         VILLAGES             MOUNTAINS" ansi-tell
  " " .tell
;

: apocalypse ( -- )
  " " .tell
  "~&160~~&140||      ~&130.t;              ;t.    ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||     ~&130tRBR.            ;RBRt    ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||   ~&130:RBBBBR.          :RBBBBR: ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||  ~&130:RBBBBBBX         .RBBBBBBR: ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140|| ~&130.RBBBBBBBBY        VBBBBBBBBR.~&010\\/\\~&110MM~&010/\\/\\/\\" ansi-tell
  "~&160~~&140|| ~&130XBBBBBBBBBBi      YBBBBBBBBBBX~&010/\\~&110MUTANTS~&010\\/\\" ansi-tell
  "~&160~~&140||~&130;BBBBBBBBBBBR:    ;RBBBBBBBBBBB;~&010/\\~&110M~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||~&130tBBBBBBBBBBR. :+=: .RBBBBBBBBBBi~&010\\/\\~&110M~&010\\/\\/\\/\\" ansi-tell
  "~&160~~&140||~&130XBBBBBBBBBB; ;BBBR; ;BBBBBBBBBBY~&010/\\/~&110M~&010/\\/\\/\\" ansi-tell
  "~&160~~&140||~&130:::::::::::  tBBBBt  :::::::::::~&010\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||             ~&130.XBBX.           ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||                               ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||             ~&130tI++tt           ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||           ~&130 iBBBBBBi           ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||           ~&130;BBBBBBBB;         ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||          ~&130;RBBBBBBBBR;         ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||         ~&130:RBBBBBBBBBBR:       ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||        ~&130.RBBBBBBBBBBBBR.       ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||        ~&130;RBBBBBBBBBBBBR;      ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  "~&160~~&140||          ~&130:;iYXVVXIt;:         ~&010/\\/\\/\\/\\/\\/\\" ansi-tell
  " " .tell
  "  ~&130N U C L E A R   A P O C A L Y P S E" ansi-tell
  " " .tell
;

: seasonname ( i -- s )
  case
    1 = when "Winter" end
    2 = when "Growing" end
    3 = when "Harvest" end
    default "Error: Unknown season!" abort end
  endcase
;

: getjobs ( -- )
  "How many people should defend the river?" .tell
  begin
    read atoi river !
    river @ population @ > if
      "You don't even have that many villagers! Please try again: How many people should defend the river?" .tell
    else
      river @ 2 + population @ > if
        "If you did that, you wouldn't have anyone left to guard the village and work in the fields. Please try again: How many people should defend the river?" .tell
      else
        river @ 1 < if
          "You need at least one person guarding the river. Please try again: How many people should defend the river?" .tell
        else
          break
        then
      then
    then
  repeat
  
  "How many people should work in the fields?" .tell
  begin
    read atoi fields !
    fields @ population @ river @ - > if
      "You don't even have that many villagers left to go around! Please try again: How many people should work in the fields?" .tell
    else
      fields @ 1 + population @ river @ - > if
        "If you did that, you wouldn't have anyone left to guard the village. Please try again: How many people should work in the fields?" .tell
      else
        fields @ 1 < if
          "You need at least one person working in the fields. Please try again: How many people should work in the fields?" .tell
        else
          break
        then
      then
    then
  repeat

  population @ fields @ - river @ - village !  
  "Very well, " river @ intostr strcat " people will defend the river, " strcat fields @ intostr strcat " people will work in the fields, and " strcat village @ intostr strcat " people will guard the village." strcat .tell
  " " .tell
  
  season @ 2 = if
    "How many baskets of rice will be planted in the fields?" .tell
    begin
      read atoi grain !
      grain @ food @ > if
        "You don't have that much to plant! Please try again: How many baskets of rice will be planted in the fields?" .tell
      else
        break
      then
    repeat
    " " .tell
  then
  
  "Press enter to continue." .tell read pop
  " " .tell
;

: newseason ( -- )
  " " .tell
  year @ 0 = if
    "You have inherited this situation from your unlucky predecessor. It is the start of the Winter Season. "
    1 year !
  else
    "At the start of the " season @ seasonname strcat " Season of year " year @ intostr strcat " of your reign, this is the situation. " strcat strcat
  then
  "Allowing for births and deaths, the population is " population @ intostr strcat ". There are " food @ intostr strcat " baskets of rice in the village stores. You must decide how mnay people are to defend the river, work in the fields, and protect the villages." strcat strcat strcat .tell
  " " .tell
  getjobs
;

: flood ( -- )
  season @ 3 = if exit then
  season @ 1 = if 330 rnd river @ 1 + / fs ! then
  season @ 2 = if 100 rnd 60 + river @ 1 + / fs ! then
  fs @ not if exit then
  fs @ 1 = if 2 else 4 then rnd fs !
  3 rnd vf !
  river @ fields @ village @ + + op !
  river @ 10 / 10 fs @ - * river !
  fields @ 10 / 10 fs @ - * fields !
  village @ 6 / 6 vf @ - * village !
  food @ vf @ * 6 / flood_food !
  flood_food @ 1 < if 1 flood_food ! then
  food @ flood_food @ - food !
  op @ river @ - fields @ - village @ - flood_deaths !
  flood_deaths @ 1 < if 1 flood_deaths ! then
  season @ 2 = if 20 fs @ float - 20 / grain @ * ftoi grain ! then
  season @ 3 = if 10 fs @ float - 10 / grain @ * ftoi grain ! then
  1 flooded? !
;

: attack ( -- )
  season @ case
    1 = when 5 end
    2 = when 2 end
    3 = when 6 end
  endcase
  random 10 % swap < if exit then
  vf @ 3 = if exit then
  season @ case
    1 = when 200 70 rnd + village @ - i ! end
    2 = when 30 200 rnd + village @ - i ! end
    3 = when 400 rnd village @ - i ! end
  endcase
  i @ village @ * 400 / thief_deaths !
  thief_deaths @ 1 < if 1 thief_deaths ! then
  village @ thief_deaths @ - village !
  i @ food @ * 729 / 2000 village @ - rnd + thief_food !
  thief_food @ 1 < if 1 thief_food ! then
  thief_food @ 2000 > if 200 rnd 1900 + thief_food ! then
  food @ thief_food @ - food !
  1 attacked? !
;

: calculate ( -- )
  fields @ not if
    0 grain !
  else
    season @ case
      2 = when
        grain @ 1000 > if 1000 grain ! then
        fields @ 10 - grain @ * fields @ / grain !
      end
      3 = when
        grain @ if
          3 rnd 11 + 18 * 0.05 1.0 fields @ / - * grain @ * ftoi grain !
          grain @ if
            food @ grain @ + food !
          then
        then
      end
      default pop end
    endcase
  then
  0 starvation !
  river @ fields @ village @ + + population !
  population @ 3 < if NOBODY_LEFT failure ! exit then
  food @ population @ / t !
  t @ 5 > if
    4 t !
  else
    t @ 2 < if ALL_STARVED failure ! exit then
    t @ 4 > if
      3.5 t !
    else
      7 t @ - population @ * 7 / ftoi starvation ! 3 t !
    then
  then
  population @ starvation @ - population !
  food @ population @ t @ * - starvation @ t @ * 2 / - ftoi food !
  food @ 0 <= if ALL_STARVED failure ! then
;

: fail-message ( -- )
  failure @ case
    NOBODY_LEFT = when
      "There is nobody left! They have all been killed off by your decisions after only "
      year @ intostr " years of misrule." strcat strcat .tell
    end
    ALL_STARVED = when
      "There was no food left. All of the people have run off and joined up with the thieves after "
      year @ intostr " years of your misrule." strcat strcat .tell
    end
    NUCLEAR = when
      "Everybody dies in a freak nuclear apocalypse. Sheltered in the mountains, the thieves suffer only minor casualties, but the nuclear fallout causes many to die and others mutate into hideous monsters which hunt down and slaughter the last few remaining villagers. Nobody is sure how the nuclear accident happened, but it is rumored to be related in some way to jaffa cakes." .tell
    end
  endcase
  " " .tell
  "     ~&110- =   G A M E   O V E R   = -" ansi-tell
  " " .tell
;

: endseason ( -- )
  population @ flood_deaths @ thief_deaths @ starvation @ 1 + + + / f1 !
  food @ thief_food @ flood_food @ 1 + + / f2 !
  f2 @ f1 @ < if f2 @ f1 ! then
  f2 @ 2 < if
    "Disastrous Losses!"
  else
    f1 @ 4 < if
      "Worrying losses!"
    else
      f1 @ 8 < if
        "You got off lightly!"
      else
        food @ population @ / 2 < if
          "Starvation Imminent!"
        else
          food @ population @ / 4 < if
            "Food supply is low."
          else
            starvation @ flooded? @ attacked? @ + + 0 > if
              "Nothing to worry about."
            else
              "A quiet season."
            then
          then
        then
      then
    then
  then
  " " .tell
  "Village Leader's Report: " swap strcat .tell
  "In the " season @ seasonname strcat " Season of year " strcat year @ intostr strcat
  " of your reign, the kingdom has suffered these losses:" strcat .tell
  "Deaths from floods.................... ~&170" flood_deaths @ intostr strcat ansi-tell
  "Deaths from the attacks............... ~&170" thief_deaths @ intostr strcat ansi-tell
  "Deaths from starvation................ ~&170" starvation @ intostr strcat ansi-tell
  "Baskets of rice lost during floods.... ~&170" flood_food @ intostr strcat ansi-tell
  "Baskets of rice lost during attacks... ~&170" thief_food @ intostr strcat ansi-tell
  " " .tell
;

: addthieves ( -- )
  "Thieves have come out of the mountains to join you. They have decided that it will be easier to grow the rice than to steal it!" .tell
  100 rnd 50 + population @ + population !
;

: winner ( -- )
  "The villagers have survived for 20 years under your glorious control. By ancient custom you are finally offered the chance to lay down this terrible burden and resume an ordinary life. Congratulations! By way of reward, a small hatch opens near the bottom of the machine, and a pouch filled with 100 emeralds falls out." .tell
  " " .tell
  "     ~&120- =   Y O U   H A V E   W O N   = -" ansi-tell
  " " .tell
  me @ 100 addpennies
;

: begin-loop ( -- )
  begin
    season ++ season @ 4 = if 1 season ! year ++ then
    0 flood_food ! 0 flood_deaths ! 0 thief_food ! 0 thief_deaths !
    newseason
    random 1000 % year @ 1 = or not if apocalypse NUCLEAR failure ! fail-message exit then
    0 flooded? ! 0 attacked? !
    random 2 % if flood attack else attack flood then
    
    flooded? @ if
      attacked? @ if
        village-flood-thieves
      else
        village-flood
      then
    else
      attacked? @ if
        village-thieves
      else
        village-peaceful
      then
    then
    
    calculate
    endseason
    population @ 1.045 * ftoi population !
    population @ 200 < 3 rnd 1 = and if addthieves then
    year @ 20 = if winner exit then
    failure @ if fail-message exit then
  repeat
;

: intro ( -- )
  me @ "_prefs/kingdom/intro" getpropstr .no? if exit then
  " " .tell
  "The Kingdom is three villages, located between the river and the mountains. You have been chosen to make all the important decisions, and lead your people to prosperity. Your poor predecessor was executed by thieves who live in the nearby mountains. These thieves live off the villagers and often attack. The rice stored in the villages must be protected at all costs." .tell
  " " .tell
  "The year consists of three long seasons; Winter, Growing, and Harvest. Rice is planted every Growing Season. You must decide how much is planted. The river is likely to flood the fields and villages. The high dam between the river and the fields must be kept up to prevent a serious flood." .tell
  " " .tell
  "The people will live off the rice they have grown. It is a very poor living. You must decide what work to assign the people at each season, so that they may prosper under your leadership." .tell
  " " .tell
  "MUCK Kingdom is a MUF port of \"Yellow River Kingdom\" version 5 for the BBC Microcomputer, by Tom Hartley, Jerry Temple-Fry and Richard G Warner. MUF coding and ANSI graphics by The Indomitable Gravecat." .tell
  " " .tell
  "Hit enter to continue, or if you do not wish to ever see this introduction again, type 'never' now." .tell
  read tolower "never" strcmp if exit then
  me @ "_prefs/kingdom/intro" "no" setprop
  " " .tell
  ">> You will never see the introduction message again." .tell
;

: start-game ( -- )
  intro
  2000 rnd 5000 + food !
  100 rnd 300 + population !
  0 season ! 0 year ! 0 grain !
  begin-loop
;

: main ( s -- )
  pop read_wants_blanks
  me @ pennies 5 < if "You can't afford to play this game, sorry." .tell exit then
  "This game costs 5 emeralds to play. Do you wish to continue? [y/n]" .tell
  read .yes? not if "Okay. Maybe another time." .tell exit then
  me @ -5 addpennies
  start-game
;
