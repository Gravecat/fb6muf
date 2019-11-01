( Lib-Kat -- Copyright 2003-2006 Raine 'Gravecat' Simmons <raine@moxx.net>

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

 
$def MAJOR_VERSION 3
$def MINOR_VERSION 0
$def PATCH_VERSION 3
 
: ver display_version ;
 
PUBLIC ver
 
$include $lib/ansify
$include $lib/strings
 
$def SPIDER #5167
 
lvar cut-at-string
lvar cut-at-length
: cut-at ( s i -- s' )
  ( When given a string and a desired length, this routine will either cut or pad the string to match the length. )
  ( Tilde ANSI is taken into account and does not count as part of the string's length. )
  swap cut-at-string !
  cut-at-length !
  cut-at-string @ libansi-strlen cut-at-length @ > if
    cut-at-string @ cut-at-length @ libansi-strcut pop
  else
    cut-at-string @ strlen
    cut-at-string @ libansi-strlen -
    cut-at-length @ +
    cut-at-string @ swap STRleft
  then
;
 
: spaces ( i -- s )
  ( Returns the specified amount of spaces. )
  "" swap 1 swap 1 for pop " " strcat repeat
;
 
lvar sp-str
lvar sp-pad
lvar sp-len
: strpad ( s1 s2 i -- s' )
  ( Pads string s1 to a specified length, with the specified character s2. )
  sp-len ! sp-pad ! sp-str !
  sp-str @ strlen sp-len @ = if sp-str @ exit then
  sp-len @ sp-str @ strlen -
  sp-str @ 1 rot 1 for
    pop sp-pad @ swap strcat
  repeat
;
 
lvar sp-str
lvar sp-pad
lvar sp-len
: strpad_right ( s1 s2 i -- s' )
  ( Pads string s1 to a specified length, with the specified character s2. )
  sp-len ! sp-pad ! sp-str !
  sp-str @ strlen sp-len @ = if sp-str @ exit then
  sp-len @ sp-str @ strlen -
  sp-str @ 1 rot 1 for
    pop sp-pad @ strcat
  repeat
;
 
$libdef strpad_right
 
: kat_srand ( -- i )
  ( Same as srand, but only give a positive integer. )
  srand abs
;
 
: array_removeitem ( a ? -- a' )
  ( Removes an item from an array, without knowing its index. )
  swap dup rot array_findval dup not if pop exit then
  0 array_getitem array_delitem
;
 
: array_getrandom ( a -- ? )
  ( Takes a random item from an array. )
  dup array_count random swap % array_getitem
;
 
: array_getsrand ( a -- ? )
  ( Takes a random item from an array, with srand. )
  dup array_count kat_srand swap % array_getitem
;
 
: vowel? ( s -- i )
  ( Returns 1 if string is a vowel, 0 if it's a consonant. )
  dup strlen 1 = "aeiou" rot tolower instr and
;
 
lvar kmatch-target
: kmatch ( s -- d )
  ( First checks the player's location, then their inventory, for a match. )
  dup match me @ = if pop me @ exit then
  dup me @ location swap rmatch kmatch-target !
  dup kmatch-target @ #-1 = if me @ swap rmatch kmatch-target ! else pop then
  kmatch-target @ #-1 = if match kmatch-target ! else pop then
  kmatch-target @
;
 
: lmatch ( d s -- d )
  ( First checks the object's location, then does an rmatch, then an ordinary match. )
  over location over rmatch
  dup #-1 > if swap pop swap pop exit else pop then
  over over rmatch dup #-1 > if swap pop exit else pop swap pop then
  match
;
 
: publicroom? ( d -- i )
  ( Returns 1 if the specified dbref is a public room, 0 if not. )
  SPIDER "_spider/public/" rot intostr strcat getpropstr .yes?
;
 
: randomroom ( -- d )
  ( Returns the dbref of a random public room. )
  begin
    random dbtop int % dbref dup publicroom? if exit else pop then
  repeat
;
 
: randomroom_seed ( s -- d )
  ( Returns the dbref of a random public room, based on a seed. )
  strip dup if setseed then
  begin
    srand dbtop int % dbref dup publicroom? if exit else pop then
  repeat
;
 
: swapsign ( i -- i' )
  ( Converts a positive number to negative, or vice-versa. )
  -1 *
;
 
lvar cp-src
lvar cp-dest
lvar cp-val
: chargepennies ( d1 d2 i1 -- i2 )
  ( Charges i1 amount of pennies to d1, and gives them to d2. If d2 is #-1, the pennies are simply removed, rather )
  ( than transferred. i2 returns an error code as follows: )
  ( 0 - Operation successful. )
  ( 1 - d1 hasn't enough pennies. )
  ( 2 - i1 is a negative or zero number. )
  cp-val ! cp-dest ! cp-src !
  cp-val @ 0 > not if 2 exit then
  cp-src @ pennies cp-val @ >= not if 1 exit then
  cp-src @ cp-val @ swapsign addpennies
  cp-dest @ #-1 = not if
    cp-dest @ cp-val @ addpennies
  then 0
;
 
: goodtell ( s -- )
  ( Displays 'good' or informative messages. )
  "~&020[~&120-~&020] ~&R" swap strcat ansi-tell
;
 
: warntell ( s -- )
  ( Displays warning messages. )
  "~&030[~&130/~&030] ~&R" swap strcat ansi-tell
;
 
: badtell ( s -- )
  ( Displays error messages. )
  "~&010[~&110|~&010] ~&R" swap strcat ansi-tell
;
 
: zombie? ( d -- i )
  ( Returns 1 if object is a zombie, 0 if not. )
  dup thing? swap "Z" flag? and
;
 
: array_chown ( a d -- )
  ( Chowns all items in specified array to the dbref. )
  swap dup array_count 0 swap 1 - 1 for
    2 pick swap array_getitem
    3 pick setown
  repeat pop pop
;
 
: array_ansi_strip ( a -- a' )
  ( Like ansi_strip, but works on every item in a given array. )
  dup array_count 0 swap 1 - 1 for
    dup 3 pick swap array_getitem ansi_strip rot rot array_setitem
  repeat
;
 
: graphicbar ( s i -- s )
  ( Takes the name of a colour [red, green, etc.] and the number of units, and
    displays a pseudo-graphical data bar. If colour is disabled, the bar is
    replaced by a line of |'s. )
  me @ "C" flag? if " " else "|" then ""
  1 4 rotate 1 for
    pop over strcat
  repeat
  swap pop swap "bg_" swap strcat textattr
;
 
: commas ( sn ... s1 n -- s )
  ( Takes a list of strings, the amount specified by n, and turns them into a
    nicer-looking comma list. For example:
    
      "an apple" "a pear" "a banana" 3 commas
    
    Would give the result: "an apple, a pear, and a banana" )
  
  ( Original code, now unused:
  
  dup 1 = if pop exit then
  ", and " rot strcat rot swap strcat
  swap dup 2 = if pop exit then
  1 swap 2 - 1 for
    pop ", " swap strcat strcat
  repeat )
  
  dup not if pop "" exit then
  array_make dup array_count -- dup if
    array_cut 0 [] swap ", " array_join
      () ", and " rot strcat strcat
  else [] then
;
 
: rnd ( i -- i ) ( Returns a random number between 1 and i. )
  random swap % 1 +
;
 
: list-random ( s d -- s ) ( Takes a listname without the hash and a dbref, and returns a random item in the list. )
  "#" rot swap strcat ( d s ) ( Just puts a # on the end of the string. )
  over over ( d s d s ) getprop atoi ( d s i ) ( Gets the number of items in the list. )
  rnd intostr ( d s s ) ( Picks a random item on the list, and turns that into a string. )
  
  "/" swap strcat strcat ( d s ) ( Combines this all into one string, so we now have a string like "basic#/16" or
                                          whatever random prop it picked. )
  getpropstr ( s ) ( And finally gets the prop, cleaning up the two redundant items on the stack. Woot! )
;
 
: ftoi ( f -- i ) ( Turns a float into an integer, rounding up or down as appropriate. This can be done with 'int',
     but while 'int' rounds down even at .9, ftoi will round up when appropriate. )
  dup int? if exit then
  0 round int
;
 
: xtoi ( ? -- i ) ( Makes sure the result is always an integer. )
  dup int? if exit then
  dup string? if atoi exit then
  int
;
 
lvar places
lvar newstr
: numfmt ( i -- s ) ( Formats a number, from something like 1234567 to 1,234,567 )
  dup 1000 < if intostr exit then ( No need to work on any number smaller than 1000. )
  intostr ( Turn the number into a string, as it's gonna be needed that way, one way or another. )
  dup strlen 1 - 3.0 / int places ! ( Figure out how many commas are needed. )
  places @ not if exit then ( If no places are needed, just exit. )
  "" swap
  1 places @ 1 for
    pop dup strlen 3 - strcut "," swap strcat rot strcat swap
  repeat
  swap strcat
;
 
: fastroll ( i1 i2 -- i' ) ( Calculates the results from rolling i2-sided dice i1 times [i1di2]. )
  swap var! low ( Stores the number of dice -- this is the minimum possible result. )
  low @ * var! high ( Multiplies the two to calculate the highest possible result. )
  random high @ low @ 1 - - % low @ + ( Gets a random number between 1 and high-[low-1], then adds low-1. )
;
 
: fastroll2 ( i1 i2 -- i' ) ( Same as fastroll, but gives an artificial result that leans more towards the middle. )
  swap var! low ( Stores the number of dice -- this is the minimum possible result. )
  low @ * var! high ( Multiplies the two to calculate the highest possible result. )
  random high @ low @ 1 - - % low @ + ( Gets a random number between 1 and high-[low-1], then adds low-1. )
  random 10 % not if exit then ( 1 in 10 times, the normalizing doesn't happen -- this allows for occasional
        lucky or unlucky rolls. )
  dup high @ 2 / > if high @ 4 / - else high @ 4 / + then ( NORMALIZE! )
  dup low @ < if pop low @ then dup high @ > if pop high @ then ( Ensure that it doesn't break boundaries. )
;
 
: fastroll3 ( i -- i' ) ( Similar to fastroll2, but simplified. This routine simply returns a normalized average
      based around the number given -- so, 500 fastroll3 will give a normalized value between
      1 and 1000. However, due to the heavy normalizing done in this routine [four times as
      much as in fastroll2], it'll give a result around 375-625. This routine takes roughly
      twice the CPU cycles as fastroll2, and four times as much as fastroll. )
  2 * var! num
  random num @ % 1 + ( First, get a random number as always. )
  1 4 1 for pop dup num @ 2 / > if num @ 8 / - else num @ 8 / + then repeat ( NORMALIZE! )
;
 
: main ( -- )
  0 pop
;
 
PUBLIC cut-at
PUBLIC spaces
PUBLIC strpad
PUBLIC array_removeitem
PUBLIC array_getrandom
PUBLIC array_getsrand
PUBLIC vowel?
PUBLIC kmatch
PUBLIC publicroom?
PUBLIC randomroom
PUBLIC randomroom_seed
PUBLIC swapsign
PUBLIC goodtell
PUBLIC warntell
PUBLIC badtell
PUBLIC zombie?
PUBLIC kat_srand
PUBLIC array_ansi_strip
PUBLIC graphicbar
PUBLIC commas
PUBLIC rnd
PUBLIC list-random
PUBLIC ftoi
PUBLIC xtoi
PUBLIC lmatch
PUBLIC numfmt
PUBLIC fastroll
PUBLIC fastroll2
PUBLIC fastroll3
PUBLIC strpad_right
 
WIZCALL chargepennies
WIZCALL array_chown
