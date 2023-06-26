import colors, databases, std/[strformat, tables]

proc nemesisInstalledList* = 
 let db = createDatabase("nemesis-installed")

 echo fmt"{GREEN}Installed packages{RESET}"
 for pkg in db.packages:
  if pkg.name != "":
   echo fmt"{pkg.name}: {pkg.version}"