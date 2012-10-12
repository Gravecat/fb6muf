$ifdef __fuzzball__
  $pragma comment_recurse
$endif
 
( lib-guid: globally unique object identifiers
  This attempts to resolve the problem of programs not having a good
  way to distinguish between two objects that have the same dbref but
  are referenced at different times and have different identities.
 
  Interface:
    objguid ( d -- s )
      Obtain the GUID of an existing object.
    guidobj ( s -- d )
      Obtain the object associated with a given GUID, or #-1.
)
 
: str++ ( s -- s )
  dup not if pop " " exit then
  dup strlen -- strcut ctoi ++
  dup 127 = if pop 32 swap str++ swap then
  itoc strcat
;
 
: next-guid ( -- s )
  prog "~last_guid" getpropstr
  str++
  prog "~last_guid" 3 pick setprop
;
 
: objguid ( d -- s )
  dup ok? not if "Invalid object." abort then
  dup var! obj "~guid" getpropstr var! str
  str @ if str @ exit then
  next-guid obj @ int "%i!%s" fmtstring
  obj @ "~guid" 3 pick setprop
;
public objguid $libdef objguid
 
: guidobj ( s -- d )
  dup string? not if "Not a string." abort then
  dup var! str atoi dbref var! obj
  obj @ ok? not if #-1 exit then
  obj @ "~guid" getpropstr str @ strcmp if #-1 exit then
  obj @
;
public guidobj $libdef guidobj
