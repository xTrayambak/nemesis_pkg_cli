import colors, databases, syncrepos, std/[tables, strformat]

proc nemesisRepositoryList*() =
 nemesisSync()
 for db in @["release", "security"]:
  echo fmt"Repository {GREEN}'{db}'{RESET}"
  let database = createDatabase(db)
  for pkg in database.packages:
   if pkg.name != "":
    echo fmt"{pkg.name}: {pkg.version}"

  echo ""