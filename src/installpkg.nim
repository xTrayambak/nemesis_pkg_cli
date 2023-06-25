import history, databases, pkginfo, syncrepos, download, parsetoml, colors, 
       std/[strformat, os, osproc]

proc nemesisInstallPkg*(db: Database, pkg: string, isRetry: bool = false) =
 try:
  let packageVersion = db.getVersion(pkg)

  echo fmt"{GREEN}info{RESET}: installing {pkg}@{packageVersion}"

  let buildFile = getBuildInfo(db.name, pkg).getTable()

  if buildFile["core"]["version"].getStr() != packageVersion:
   echo fmt"{ORANGE}warning{RESET}: {pkg}@{packageVersion} is currently inside the local repositories, however another version is available in the online repositories."
   echo fmt"{ORANGE}warning{RESET}: this indicates a clear desynchronization. Please run 'sudo nemesis-pkg sync' and try again."
   quit 1

  let path = downloadSource(buildFile["core"]["source"].getStr())
  putEnv("NEMESIS_PKG_BUILD_DIR", path)

  let res = execCmdEx(buildFile["build"]["command"].getStr())
  if res.exitCode != 0:
   echo fmt"{RED}{res.output}{RESET}"
   echo fmt"{RED}error{RESET}: compilation of package failed! If this is an official NemesisOS package, report it to the devs!"
   writeHistory(fmt"failed to install package {pkg}@{packageVersion}; error is thrown in stdout")
  elif res.exitCode == 0:
   echo fmt"{GREEN}success{RESET}: {pkg}@{packageVersion} successfully downloaded!"
   writeHistory(fmt"installed package {pkg}@{packageVersion}")
 except KeyError:
  if not isRetry:
   nemesisSync()
   nemesisInstallPkg(db, pkg, true)
  else:
   echo fmt"{RED}error{RESET}: unable to find package: {pkg}"
   quit 1
 
proc nemesisInstallPkgs*(pkgs: seq[string]) =
 let database = createDatabase("release")

 for pkg in pkgs:
  nemesisInstallPkg(database, pkg)