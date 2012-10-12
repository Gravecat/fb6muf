( Kat-DoorLock.muf -- By Tom 'Gravecat' Simmons [2003-2006] <http://gravec.at/>
This software is released copyright-free into the public domain. Do with it as you wish! )


$def MAJOR_VERSION 1
$def MINOR_VERSION 0
$def PATCH_VERSION 2
 
: ver display_version ;
 
PUBLIC ver

lvar target

: main
  trig target !
  trig "_door/main" getprop dup if target ! else pop then
  target @ "_door/status" getpropstr "open" strcmp not
;
