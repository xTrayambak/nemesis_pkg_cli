import std/[osproc, strformat], uuids, config, parsetoml

proc downloadSource*(url: string): string =
 let
  storePath = getConfig().getTable()["build"].getTable()
  filesPath = storePath["files_path"].getStr()
  path = fmt"{filesPath}/{genUUID()}-nembuild"
 discard execCmdEx("git clone " & url & " " & path)
 path