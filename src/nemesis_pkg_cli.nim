import std/[strformat, strutils, os, times], utils, history

const ANSI_CODES = (
    red: "\x1b[31m",
    green: "\x1b[32m",
    orange: "\x1b[33m",
    lightGreen: "\x1b[34m",
    reset: "\x1b[0m"
)

proc showHelp =
  echo "usage: nemesis-pkg [options] [arguments]"
  echo "install <pkg>\t\tinstall a package"
  echo "uninstall <pkg>\tremove a package"
  echo "sync\t\tsynchronize package databases"

proc getAction: string =
  if paramCount() > 0:
    paramStr(1)
  else:
    showHelp()
    quit 1

proc getPackageArg: string =
  if paramCount() > 1:
    paramStr(2)
  else:
    showHelp()
    quit 1

proc nemesisInstall* =
  let pkgName = getPackageArg()
  writeHistory(fmt"install {pkgName}")
  echo fmt"{ANSI_CODES.red}error{ANSI_CODES.reset}: this feature is not yet implemented. :("
  quit 0

proc nemesisUninstall* =
  let pkgName = getPackageArg()
  writeHistory(fmt"install {pkgName}")
  echo fmt"{ANSI_CODES.red}error{ANSI_CODES.reset}: this feature is not yet implemented. :("
  quit 0

proc nemesisSync* =
  writeHistory(fmt"sync repositories")
  echo fmt"{ANSI_CODES.red}error{ANSI_CODES.reset}: this feature is not yet implemented. :("
  quit 0

proc main =
  let action = getAction()

  if action.actionRequiresRoot() and not isAdmin():
    echo fmt"{ANSI_CODES.red}error{ANSI_CODES.reset}: this action requires superuser privileges (under the root user on most systems)."
    quit 1

  if action.toLowerAscii() == "install":
    nemesisInstall()
  elif action.toLowerAscii() == "uninstall":
    nemesisUninstall()
  elif action.toLowerAscii() == "sync":
    nemesisSync()
    
when isMainModule: main()