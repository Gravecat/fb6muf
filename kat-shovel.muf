( Kat-Shovel.muf -- By Tom 'Gravecat' Simmons [2003-2006] <http://gravec.at/>
This software is released copyright-free into the public domain. Do with it as you wish! )


$def MAJOR_VERSION 1
$def MINOR_VERSION 0
$def PATCH_VERSION 2
 
: ver display_version ;
 
PUBLIC ver

$include $lib/reflist
$include $lib/kat

$def BURIED #5563
$def DIGTIME 30

lvar target

: bury
  tolower dup not if "You need to specify an item to bury!" .tell exit then
  me @ swap rmatch target !
  target @ #-1 = if "You're not carrying anything like that." .tell exit then
  target @ #-2 = if "I don't know which one you mean!" .tell exit then
  target @ #-3 = if "Don't be ridiculous." .tell exit then
  target @ thing? not if "That's not something you can bury." .tell exit then
  target @ "Z" flag? if "You can't bury zombies!" .tell exit then
  me @ "@kat/lastdig" systime setprop
  "You dig a hole, and quickly bury " target @ name " nearby." strcat strcat .tell
  loc @ me @ dup name " digs a hole, and quickly buries something nearby." strcat notify_except
  loc @ "@buried" target @ REF-add
  target @ BURIED moveto
;

: failmessage
  "You dig a few holes in the ground, but don't find anything of interest." .tell
  loc @ me @ dup name " digs a few holes in the ground, but finds nothing of interest." strcat notify_except exit
;

: dig
  me @ "@kat/lastdig" getprop dup not if pop else
    systime swap - dup DIGTIME < if
      "Sorry, you can't dig again so soon. Try again in about "
      DIGTIME rot - 10 / 10 * 10 +
      intostr " seconds." strcat strcat .tell exit
    else pop
    then
  then
  me @ "@kat/lastdig" systime setprop
  pop loc @ "@buried" REF-first dup #-1 dbcmp if failmessage exit then
  target !
  target @ ok? not if
  loc @ "@buried" target @ REF-delete
    failmessage exit
  then
  target @ location BURIED = not if
    loc @ "@buried" target @ REF-delete
    failmessage exit
  then
  random 4 % if failmessage exit then
  "You dig for a while, then find " target @ name " buried!" strcat strcat .tell
  loc @ me @ dup name " digs for a while, then finds " target @ name " buried!" strcat strcat strcat notify_except
  target @ me @ moveto
  loc @ "@buried" target @ REF-delete
;

: main
  loc @ "_nodig" envpropstr .yes? if "Sorry, you may not dig here." .tell exit then pop
  command @ tolower "bury" strcmp not if bury else dig then
;
