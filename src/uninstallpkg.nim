import databases, colors, std/[os, strformat]

proc nemesisUninstallPkg*(pkg: string) =
 var installedDb = createDatabase("nemesis-installed")
 if not installedDb.isInstalled(pkg):
  echo fmt"{RED}error{RESET}: cannot uninstall '{pkg}': package not found!"
  quit 1

 var idxToDelete = -1
 for idx, package in installedDb.packages:
  if package.name == pkg:
   idxToDelete = idx
   for file in package.files:
    echo fmt"{GREEN}info{RESET}: removing '{file}'"
    removeFile(file)
   echo fmt"{GREEN}info{RESET}: removed package {package.name}@{package.version} successfully!"

 installedDB.packages.delete(idxToDelete)
 installedDB.save()

proc nemesisUninstallPkgs*(pkgs: seq[string]) =
 for pkg in pkgs:
  nemesisUninstallPkg(pkg)