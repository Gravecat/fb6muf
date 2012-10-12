( Kat-Recycle -- By Tom 'Gravecat' Simmons [2002-2006] <http://gravec.at/>
This software is released copyright-free into the public domain. Do with it as you wish! )


$def MAJOR_VERSION 2
$def MINOR_VERSION 8
$def PATCH_VERSION 1
: ver display_version ;
PUBLIC ver

$include $lib/ansify
$include $lib/kat
$include $lib/guid

lvar doomed
lvar doomedid
 
: help ( -- )
  " " .tell
  "~&160.--------------------------.   ~&170/\\_/\\" ansi-tell
  "~&160|       ~&120Kat-Recycle        ~&160| ~&170=( ~&120o~&150.~&120O ~&170)=" ansi-tell
  "~&160|       ~&130-= v" MAJOR_VERSION intostr "." MINOR_VERSION intostr PATCH_VERSION intostr
  " =-        ~&160|   ~&170)   (" strcat strcat strcat strcat strcat ansi-tell
  "~&160'--------------------------'-~&170\"\"~&160-----~&170\"\"~&160-." ansi-tell
  "~&160|  Created by Tom 'Gravecat' Simmons.  |" ansi-tell
  "~&160'--------------------------------------'" ansi-tell
  " " .tell
  "Usage: ~&120@recycle <object>" ansi-tell
  " " .tell
  "  Destroy an object and remove all references to it within the database." .tell
  "The object is then added to a free list, and newly created objects are" .tell
  "assigned from the pool of recycled objects first.  You *must* own the" .tell
  "object being recycled. Unquelled wizards may recycle objects regardless" .tell
  "of their owners." .tell
  " " .tell
;
 
: objname ( -- )
  "Object to @recycle: "
  doomed @ ansify-unparseobj strcat .tell
;
 
: recycle-it ( -- )
  preempt
  doomed @ ok? not if "You cannot @recycle garbage!" badtell exit then
  doomed @ "~protected" getpropstr .yes? if
    objname "This object is protected and may not be @recycled." badtell exit
  then
  me @ "W" flag? not if
    doomed @ me @ controls not if "Permission denied!" badtell exit then
  then
  doomed @ objguid doomedid @ strcmp if
    "This object is no longer valid for recycling. Aborted." badtell exit
  then
  ( Kill processes, especially MPI processes, so they don't hang around
    and maybe retrigger themselves on a later object of the same reference
    number. -- Premchaia )
  doomed @ getpids foreach swap pop kill pop repeat
  doomed @ recycle
  "Recycled!" goodtell
;

: main ( s -- )
  tolower dup dup "#help" strcmp not swap not or if help exit then
  match doomed !
  doomed @ #-1 = if "I don't see that here." badtell exit then
  doomed @ #-2 = if "I don't know which one you mean." badtell exit then
  doomed @ #-3 = if "That's a silly thing to recycle." badtell exit then
  doomed @ player? if
    doomed @ me @ = if
      "Don't do it! There's so much left to live for!" .tell exit
    else
      "You glare angrily at " doomed @ name ", thinking murderous thoughts." strcat strcat .tell exit
    then
  then
  doomed @ ok? not if "You cannot @recycle garbage!" badtell exit then
  doomed @ #0 = if "Permission denied!" badtell exit then
  doomed @ "~protected" getpropstr .yes? if
    objname "This object is protected and may not be @recycled." badtell exit
  then
 
  doomed @ owner me @ = not if
    me @ "W" flag? if
      objname "This object belongs to ~&120" doomed @ owner ansify-unparseobj strcat
      ". Recycle it anyway? (y/n)" strcat ansi-tell
    else
      "Permission denied!" badtell exit
    then
  else
    objname "Recycle? (y/n)" .tell
  then
 
  doomed @ objguid doomedid ! read .yes? not if "Aborted!" badtell exit then
  recycle-it
;
