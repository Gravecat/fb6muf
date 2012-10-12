( Kat-AnsiToggle -- By Tom 'Gravecat' Simmons [2002-2006] <http://gravec.at/>
This software is released copyright-free into the public domain. Do with it as you wish! )


$include $lib/ansify
 
$def MAJOR_VERSION 1
$def MINOR_VERSION 2
$def PATCH_VERSION 4
 
: ver display_version ;
 
PUBLIC ver
 
: help
  " " .tell
  "~&160.--------------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|        ~&120AnsiToggle        ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|        ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-       ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'--------------------------'-~&170\"\"~&160-----~&170\"\"~&160-." ansi-tell
  "~&160|  Created by Tom 'Gravecat' Simmons.  |" ansi-tell
  "~&160'--------------------------------------'" ansi-tell
  " " .tell
  "Usage: ~&120colour ~&170[on|off]" ansi-tell
  " " .tell
  "Some programs in Spork support tilde ANSI. To use an ANSI string, you insert" .tell
  "codes within the text to tell the system where to put the colour. The codes are" .tell
  "in the format of ~&xFB - x being 0 or 1 for normal or bold text, F being the" .tell
  "foreground colour, and B being the background colour. For example, the string" .tell
  "\"~&110Hello!\" would be displayed as: \""
  "Hello!" "bold,red" textattr "\"" strcat strcat .tell
  " "
  "The list of available colours is as follows:" .tell
  " " .tell
  "0 - Black    \[[30m[Normal]  ~&100[Bold]" ansi-tell
  "1 - Red      ~&010[Normal]  ~&110[Bold]" ansi-tell
  "2 - Green    ~&020[Normal]  ~&120[Bold]" ansi-tell
  "3 - Yellow   ~&030[Normal]  ~&130[Bold]" ansi-tell
  "4 - Blue     ~&040[Normal]  ~&140[Bold]" ansi-tell
  "5 - Magenta  ~&050[Normal]  ~&150[Bold]" ansi-tell
  "6 - Cyan     ~&060[Normal]  ~&160[Bold]" ansi-tell
  "7 - White    ~&070[Normal]  ~&170[Bold]" ansi-tell
  " " .tell
  "Please note, colours may not look exactly the same in all MU* clients." .tell
  " " .tell
;
 
 
: colour-off
  #900 "@set #" me @ intostr strcat "=!C" strcat force
  "ANSI colour disabled. You will now live in a monochrome world." .tell
;
 
: colour-on
  #900 "@set #" me @ intostr strcat "=C" strcat force
  "~&170ANSI colour enabled! ~&110T~&130a~&120s~&160t~&140e ~&150t~&110h~&130e ~&120r~&160a~&140i~&150n~&110b~&130o~&120w~&160!" ansi-tell
;
 
: main
  tolower dup dup "#help" strcmp not swap strlen not or if help exit then
  dup "off" strcmp not if colour-off exit then
  dup "on" strcmp not if colour-on exit then
  "I don't recognize that command! Type '~&120colour #help~&R' for usage." ansi-tell
;
