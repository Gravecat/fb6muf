( Kat-ToadStub.muf -- By Raine 'Gravecat' Simmons [2002-2006] <gc@gravecat.com>
This software is released copyright-free into the public domain. Do with it as you wish! )
 
$def MAJOR_VERSION 1
$def MINOR_VERSION 3
$def PATCH_VERSION 3
 
: ver display_version ;
 
PUBLIC ver
 
$include $lib/ansify
$include $lib/kat
 
lvar doomed
 
: toad-help
  " " .tell
  "~&160.--------------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|       ~&120Kat-ToadStub       ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|        ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-       ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'--------------------------'-~&170\"\"~&160-----~&170\"\"~&160-." ansi-tell
  "~&160| Created by Raine 'Gravecat' Simmons. |" ansi-tell
  "~&160'--------------------------------------'" ansi-tell
  " " .tell
  "This is a simple stub program, to allow confirmation of @toading (in case of a" .tell
  "typo), and automatically @chowns the @toaded player's possessions to a holding" .tell
  "character, Toad." .tell
  " " .tell
  "Usage: ~&120@toad <player>" ansi-tell
  " " .tell
;
 
: main
  me @ "W" flag? not if "Permission denied." badtell exit then
  tolower dup dup "#help" strcmp not swap strlen not or if toad-help exit then
  pmatch dup #-1 = if "That player does not exist." badtell exit then
  doomed !
  doomed @ "W" flag? if "You can't turn a wizard into a toad!" badtell exit then
  "Player to @toad: " doomed @ ansify-unparseobj strcat ansi-tell
  "Toad? (y/n)" .tell
  read .yes not if "Aborted!" badtell exit then
  "You turned " doomed @ name strcat " into a toad!" strcat goodtell
  #900 "@toad " doomed @ name "=Toad" strcat strcat force
  #900 "@chown #" doomed @ intostr "=Toad" strcat strcat force
;
