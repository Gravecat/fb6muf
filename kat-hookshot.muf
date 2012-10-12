( Kat-Hookshot.muf -- By Tom 'Gravecat' Simmons [2003-2006] <http://gravec.at/>
This software is released copyright-free into the public domain. Do with it as you wish! )


$def MAJOR_VERSION 1
$def MINOR_VERSION 0
$def PATCH_VERSION 2
 
: ver display_version ;
 
PUBLIC ver

$include $lib/case
$include $lib/kat

lvar target1
lvar target2

: main
  trig location "@kat/hookshot" getpropstr .yes? not if "Permission denied." .tell exit then
  dup not if "You need to specify a direction and target!" .tell exit then
  "=" split target1 ! target2 !
  target1 @ not if "You need to specify something to shoot the hookshot at!" .tell exit then
  target2 @ not if "You need to specify a direction to shoot the hookshot in!" .tell exit then
  target2 @ match target2 !
  target2 @ #-1 = if "I don't see any exits by that name." .tell exit then
  target2 @ #-2 = if "I'm not sure which exit you mean." .tell exit then
  target2 @ #-3 = if "Don't be silly." .tell exit then
  target2 @ exit? not if "You need to specify an exit!" .tell exit then
  target2 @ getlink room? not if "That's not a valid exit to aim through." .tell exit then
  me @ target2 @ locked? if "You can't aim through that exit, it's locked." .tell exit then
  target2 @ getlink target1 @ rmatch target1 !
  target1 @ #-1 = if "I don't see anything by that name in the target room." .tell exit then
  target1 @ #-2 = if "I'm not sure which one you mean." .tell exit then
  target1 @ #-3 = if "Don't be silly." .tell exit then
  target1 @ thing? not if "You can't hookshot that!" .tell exit then
  me @ target1 @ locked? if
    "You fire your hookshot at " target1 @ name ", but it bounces off with a *tink*!" strcat strcat .tell
    loc @ me @ dup name " fires %p hookshot through an exit at " target1 @ name ", but it bounces off with a *tink*!"
    strcat strcat strcat me @ swap pronoun_sub notify_except
    "A grappling hook on a chain flies into the room, hits " target1 @ name ", and bounces off with a *tink*!"
    strcat strcat target1 @ getlink #-1 rot notify_except exit
  then
  "You fire your hookshot at " target1 @ name ", which is quickly snagged and pulled back into your waiting hands!"
  strcat strcat .tell
  loc @ me @ dup name " fires %p hookshot through an exit at " target1 @ name
  ", and it is dragged back a moment later, into %p waiting hands!" strcat strcat strcat
  me @ swap pronoun_sub notify_except
  "A grappling hook on a chain fires into the room, snags " target1 @ name ", and drags it out of the room!" strcat strcat
  target2 @ getlink #-1 rot notify_except
  target1 @ me @ moveto
;
