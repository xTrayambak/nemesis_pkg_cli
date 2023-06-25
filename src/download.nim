import std/[osproc, strformat], uuids

proc downloadSource*(url: string): string =
 let path = fmt"/tmp/{genUUID()}-nembuild"
 discard execCmdEx("git clone " & url & " " & path)
 path