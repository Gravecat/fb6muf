( Kat-OOC.muf -- By Raine 'Gravecat' Simmons [2003-2006] <raine@moxx.net>
This software is released copyright-free into the public domain. Do with it as you wish! )


$def MAJOR_VERSION 1
$def MINOR_VERSION 1
$def PATCH_VERSION 2
 
: ver display_version ;
 
PUBLIC ver

$include $lib/ansify

: banner
  " " .tell
  "~&160.--------------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|       ~&120OOC Say/Pose       ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|        ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-       ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'--------------------------'-~&170\"\"~&160-----~&170\"\"~&160--." ansi-tell
  "~&160|  Created by Tom 'Gravecat' Simmons.  |" ansi-tell
  "~&160'---------------------------------------'" ansi-tell
  " " .tell
;

: help
  banner
  "OOC Say/Pose is just like it implies - if you are IC and want to say something" .tell
  "OOCly, simply type 'OOC' followed by your message. You can OOCly pose too, by" .tell
  "preceeding the message with a colon." .tell
  " " .tell
;

: sayoprop
  me @ "_say/def/osay" getpropstr
  dup not if pop "says" then
;

: sayprop
  me @ "_say/def/say" getpropstr
  dup not if pop "say" then
;

: ooc-say
  dup
  "~&130<OOC> ~&070" me @ name " " sayoprop ", \"" strcat strcat strcat strcat swap "\"" strcat strcat
  loc @ me @ rot ansi-notify_except
  "~&130<OOC> ~&070You " sayprop ", \"" strcat strcat swap "\"" strcat strcat me @ swap ansi-notify
;

: ooc-pose
  ":" split strip dup
  "~&130<OOC> ~&070" me @ name " " strcat strcat swap strcat loc @ #-1 rot ansi-notify_except
;

: main
  strip dup tolower "#help" strcmp not if help exit then
  dup not if "I don't understand. (ooc #help for usage info)" .tell exit then
  dup ":" instr 1 = if ooc-pose else ooc-say then
;
