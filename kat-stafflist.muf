( Kat-StaffList.muf -- By Tom 'Gravecat' Simmons [2003-2006] <http://gravec.at/>
Based on Area-Commands.muf by Stelard Actek and Wizzes.muf by Keet
This software is released copyright-free into the public domain. Do with it as you wish! )


$def MAJOR_VERSION 1
$def MINOR_VERSION 0
$def PATCH_VERSION 7
 
: ver display_version ;
 
PUBLIC ver
 
$include $lib/ansify
$include $lib/case
$include $lib/strings
$include $lib/kat
 
lvar type
lvar current
lvar show-all
lvar arg1
lvar arg2
 
: allowed? ( d -- i )
  intostr "#" swap strcat
  dup trig "_wizzes" getpropstr swap instring if pop 1 exit then
  pop 0
;
 
: banner
  " " .tell
  "~&160.--------------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|         ~&120StaffList        ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|        ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-       ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'--------------------------'-~&170\"\"~&160-----~&170\"\"~&160----." ansi-tell
  "~&160|    Created by Tom 'Gravecat' Simmons    |" ansi-tell
  "~&160| Based on code by Stelard Actek and Keet |" ansi-tell
  "~&160'-----------------------------------------'" ansi-tell
  " " .tell
;
 
: remove-dbref ( d s -- )
  trig "_" type @ strcat getpropstr
  "" "#" current @ intostr " " strcat strcat subst
  trig "_" type @ strcat rot setprop
;
 
: display ( s -- )
  type !
  trig "_" type @ strcat getpropstr dup not if pop exit then
  " " explode 1 swap 1 for
    pop stod current !
    current @ player? not if
      current @ type @ remove-dbref
    else
      current @ awake? current @ "D" flag? not and show-all @ or if
        current @ "_prefs/staff/stat" getpropstr "off" strcmp not if
          " ~&110OFF  "
        else
          " ~&120ON!  "
        then
        current @ awake? not current @ "D" flag? or if
          pop " ~&110ZZZ  "
        else
          current @ dbleastidle 600 > if
            pop " ~&130IDL  "
          then
        then
        "  " current @ awake? if "~&120" else "~&020" then
        swap strcat strcat
        current @ name 17 cut-at strcat   
        current @ "_prefs/staff/spec" getpropstr
        dup not if pop " -- Unset --" then
        51 cut-at "~&070" swap strcat strcat
        ansi-tell
      then
    then
  repeat
;
 
: show-staff
  "~&170-~&130Duty~&170---~&130Name~&170-------------~&130Speciality~&170-----------------------------------------" ansi-tell
  "wizzes" display
  "~&170----------------------------------------------------------------------------" ansi-tell
  "Staff listed as ~&130IDL ~&070are idle and may be slow to respond. Any staff listed as" ansi-tell
  "~&110OFF ~&070are off-duty do not wish to be disturbed." ansi-tell
;
 
: help
  banner
  "This command lists all the wizards (staff members) on the MUCK, and their" .tell
  "current availability." .tell
  " " .tell
  "~&170Normal commands:" ansi-tell
  "  ~&120wizzes #HELP          ~&070- This help screen." ansi-tell
  "  ~&120wizzes #ALL           ~&070- List all staff." ansi-tell
  "  ~&120wizzes                ~&070- List online staff." ansi-tell
  " " .tell
  me @ "W" flag? me @ allowed? or not if exit then
  "~&170Wizard commands:" ansi-tell
  "  ~&120wizzes #ON            ~&070- Go On-Duty." ansi-tell
  "  ~&120wizzes #OFF           ~&070- Go Off-Duty." ansi-tell
  "  ~&120wizzes #SET <string>  ~&070- Set your speciality." ansi-tell
  "  ~&120wizzes #ADD <player> ~&070- Adds a wizard to the list." ansi-tell
  "  ~&120wizzes #DEL <player> ~&070- Removes a wizard from the list." ansi-tell
  " " .tell
;
 
: parse-arg2 ( -- )
  arg2 @ pmatch arg2 !
;
 
: add-staff ( -- )
  me @ "W" flag? not if "Sorry, only wizards can do that." .tell exit then
  parse-arg2
  arg2 @ #-1 dbcmp if "I don't recognize that name." .tell exit then
  trig "_" type @ strcat getpropstr dup
  arg2 @ intostr "#" swap strcat " " strcat dup rot swap instring if "That player is already on the list!" .tell exit then
  strcat trig "_" type @ strcat rot setprop
  "Added!" .tell
;
 
: del-staff ( -- )
  me @ "W" flag? not if "Sorry, only wizards can do that." .tell exit then
  parse-arg2
  arg2 @ #-1 dbcmp if "I don't recognize that name." .tell exit then
  trig "_" type @ strcat getpropstr dup
  arg2 @ intostr "#" swap strcat " " strcat dup rot swap instring not if "That player is not on the list!" .tell exit then
  "" swap subst
  trig "_" type @ strcat rot setprop
  "Deleted!" .tell
;
 
: on-duty ( -- )
  me @ allowed? not if "You're not a staff member!" .tell exit then
  me @ "_prefs/staff/stat" "on" setprop
  "You go On-Duty." .tell
;
 
: off-duty ( -- )
  me @ allowed? not if "You're not a staff member!" .tell exit then
  me @ "_prefs/staff/stat" "off" setprop
  "You go Off-Duty." .tell
;
 
: set-duty ( -- )
  me @ allowed? not if "You're not a staff member!" .tell exit then
  arg2 @ not if
    me @ "_prefs/staff/spec" remove_prop
    "You clear your speciality." .tell exit
  then
  me @ "_prefs/staff/spec" arg2 @ setprop
  "Speciality updated." .tell
;
 
: main ( s -- )
  STRparse pop arg2 ! tolower arg1 !
  arg1 @ "all" strcmp not if 1 show-all ! else 0 show-all ! then
  arg1 @ "help" strcmp not if help exit then
  arg1 @ "add" strcmp not if "wizzes" type ! add-staff exit then
  arg1 @ "del" strcmp not if "wizzes" type ! del-staff exit then
  arg1 @ "on" strcmp not if on-duty exit then
  arg1 @ "onduty" strcmp not if on-duty exit then
  arg1 @ "off" strcmp not if off-duty exit then
  arg1 @ "offduty" strcmp not if off-duty exit then
  arg1 @ "set" strcmp not if set-duty exit then
  show-staff
;
 
