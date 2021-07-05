( Kat-PInfo.muf -- By Raine 'Gravecat' Simmons [2004-2006] <gc@gravecat.com>
This software is released copyright-free into the public domain. Do with it as you wish! )


$def MAJOR_VERSION 1
$def MINOR_VERSION 0
$def PATCH_VERSION 8
 
: ver display_version ;
 
PUBLIC ver

lvar target

$include $lib/kat
$include $lib/strings
$include $lib/case
$include $lib/ansify

: help
  " " .tell
  "~&160.---------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|       ~&120Kat-PInfo     ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|      ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-     ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'--------------------'-~&170\"\"~&160-------~&170\"\"~&160--." ansi-tell
  "~&160|Created By Raine 'Gravecat' Simmons|" ansi-tell
  "~&160'-----------------------------------'" ansi-tell
  " " .tell
  " pinfo <player>         - Shows information for <player>." .tell
  " pinfo #<field> <text>  - Sets one of your pinfo fields." .tell
  " pinfo #extra           - Sets your extra information, with lsedit." .tell
  " pinfo #ic / #ooc       - Sets your IC and OOC information, with lsedit." .tell
  " " .tell
  "Valid field names are: name, job, aliases, alts, email, class, theme, quote," .tell
  "www, extra, ic, ooc. You may also have an optional, custom-named field. Use" .tell
  "#customname to set the name of the field, and #custom to enter the data." .tell
  " " .tell
;

: pprop
  target @ "_prefs/pinfo/" rot strcat getpropstr
;

: pinfo-player
  target @ name strlen 78 swap - spaces
  target @ name strlen 2 + 1 swap 1 for pop "_" strcat repeat .tell
  "" target @ name strlen 77 swap - 1 swap 1 for pop "_" strcat repeat
  "/ " target @ name " " strcat strcat strcat .tell
  " " .tell
  "name" pprop dup if "        Name: " swap strcat .tell else pop then
  "job" pprop dup if "         Job: " swap strcat .tell else pop then
  "aliases" pprop dup if "     Aliases: " swap strcat .tell else pop then
  "alts" pprop dup if "        Alts: " swap strcat .tell else pop then
  "email" pprop dup if "       Email: " swap strcat .tell else pop then
  "www" pprop dup if "     Website: " swap strcat .tell else pop then
  "class" pprop dup if " Class/Level: " swap strcat .tell else pop then
  "theme" pprop dup if "  Theme Song: " swap strcat .tell else pop then
  "quote" pprop dup if "       Quote: " swap strcat .tell else pop then
  target @ "_prefs/pinfo/customname" getpropstr dup if
    12 strcut pop ": " strcat 14 STRright
    target @ "_prefs/pinfo/custom" getpropstr dup if strcat .tell else pop pop then
  else pop then

  target @ "_prefs/pinfo/ic#" getpropstr atoi dup if
    " " .tell
    "      IC Information:" .tell
    1 swap 1 for
      target @ "_prefs/pinfo/ic#/" rot intostr strcat getpropstr .tell
    repeat
  else pop then

  target @ "_prefs/pinfo/ooc#" getpropstr atoi dup if
    " " .tell
    "     OOC Information:" .tell
    1 swap 1 for
      target @ "_prefs/pinfo/ooc#/" rot intostr strcat getpropstr .tell
    repeat
  else pop then

  target @ "_prefs/pinfo/extra#" getpropstr atoi dup if
    " " .tell
    "   Extra Information:" .tell
    1 swap 1 for
      target @ "_prefs/pinfo/extra#/" rot intostr strcat getpropstr .tell
    repeat
  else pop then

  "________________________________________________________________________________" .tell
;

: setpinfo
  "_prefs/pinfo/" swap strcat swap me @ swap rot swap
  dup if "PInfo field updated." .tell else "PInfo field cleared." .tell then setprop
;

: setlist
  me @ "lsedit me=_prefs/pinfo/" rot strcat force	( KLUDGE, yes. But it saves a hell of a lot of coding. )
;

: main
  strip dup dup tolower "#help" strcmp not swap not or if pop help exit then
  dup pmatch dup if target ! pop pinfo-player exit else pop then
  dup 1 1 midstr "#" strcmp if "I don't know any players by that name." .tell exit then
  " " split swap tolower case
    "#name" strcmp not when "name" setpinfo end
    "#job" strcmp not when "job" setpinfo end
    "#aliases" strcmp not when "aliases" setpinfo end
    "#alts" strcmp not when "alts" setpinfo end
    "#email" strcmp not when "email" setpinfo end
    "#www" strcmp not when "www" setpinfo end
    "#class" strcmp not when "class" setpinfo end
    "#theme" strcmp not when "theme" setpinfo end
    "#quote" strcmp not when "quote" setpinfo end
    "#customname" strcmp not when "customname" setpinfo end
    "#custom" strcmp not when "custom" setpinfo end
    "#extra" strcmp not when "extra" setlist end
    "#ooc" strcmp not when "ooc" setlist end
    "#ic" strcmp not when "ic" setlist end
    default "Unknown command: " swap strcat .tell pop end
  endcase
;
