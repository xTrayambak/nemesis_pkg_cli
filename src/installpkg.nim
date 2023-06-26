import history, databases, pkginfo, syncrepos, download, parsetoml, colors, 
       std/[strformat, os, osproc]

proc nemesisInstallPkg*(db: Database, pkg: string, isRetry: bool = false) =
 try:
  let packageVersion = db.getVersion(pkg)

  echo fmt"{GREEN}info{RESET}: installing {pkg}@{packageVersion}"

  let buildFile = getBuildInfo(db.name, pkg).getTable()
  var installedDb = createDatabase("nemesis-installed")
 
  if installedDb.isInstalled(pkg):
   if buildFile["core"]["version"].getStr() == packageVersion:
    echo fmt"{GREEN}info{RESET}: {pkg}@{packageVersion} is already up-to-date. Ignoring."
    return

  let path = downloadSource(buildFile["core"]["source"].getStr())
  putEnv("NEMESIS_PKG_BUILD_DIR", path)

  let res = execCmd(buildFile["build"]["command"].getStr())
  if res != 0:
   echo fmt"{RED}error{RESET}: compilation of package failed! If this is an official NemesisOS package, report it to the devs!"
   writeHistory(fmt"failed to install package {pkg}@{packageVersion}; error is thrown in stdout")
  elif res == 0:
   var files: seq[string] = @[]
   for fileTNode in buildFile["build"]["files"].getElems():
     files.add(fileTNode.getStr())
   installedDb.set(pkg, packageVersion, files)
   installedDb.save()
   echo fmt"{GREEN}success{RESET}: {pkg}@{packageVersion} successfully installed! Updating package databases..."
   writeHistory(fmt"installed package {pkg}@{packageVersion}")
 except KeyError:
  if not isRetry:
   nemesisSync()
   nemesisInstallPkg(db, pkg, true)
  else:
   echo fmt"{RED}error{RESET}: unable to find package: {pkg}"
   quit 1

proc nemesisInstallPkgs*(pkgs: seq[string]) {.inline.} =
 var database: Database
 try:
  database = createDatabase("release")
 except IOError:
  nemesisSync()
  nemesisInstallPkgs(pkgs)

 for pkg in pkgs:
  nemesisInstallPkg(database, pkg)