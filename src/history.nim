import std/[os, strformat, times]

const nextline = "\n"

proc writeHistory*(currentOpr: string) =
 let histfile = fmt"{getHomeDir()}/.nemesis-pkg_history"
 if fileExists(histfile):
  let file = open(histfile, fmAppend)
  defer: file.close()
  file.write(fmt"{nextline}{now()} {currentOpr}")
 else:
  let file = open(histfile, fmWrite)
  defer: file.close()
  file.write(fmt"{now()} {currentOpr}")