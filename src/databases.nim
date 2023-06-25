import history, std/[os, marshal, strformat, tables]

type Database* = ref object of RootObj
 name*: string # eg. release, security, backports
 packages*: Table[string, string] # pkg name, pkg version

proc getVersion*(db: Database, packagename: string): string =
 db.packages[packagename]

proc save*(database: Database) =
 writeHistory(fmt"Saving database '{database.name}'")
 let
  nemesisPath = fmt"/etc/.nemesis-pkg"
  computedDBPath = fmt"{nemesisPath}/{database.name}.nemdb"

 if not dirExists(nemesisPath):
  createDir(nemesisPath)

 let file = open(computedDBPath, fmWrite)
 defer: file.close()

 file.write($$database)

proc createDatabase*(name: string): Database =
 let
  nemesisPath = fmt"/etc/.nemesis-pkg"
  computedDBPath = fmt"{nemesisPath}/{name}.nemdb"
 to[Database](readFile(computedDBPath))