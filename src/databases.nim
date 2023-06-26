import history, std/[os, marshal, strformat, tables]

type
 Package* = ref object of RootObj
  name*: string
  version*: string
  files*: seq[string]
  
 Database* = ref object of RootObj
  name*: string # eg. release, security, backports
  packages*: seq[Package]

proc isInstalled*(db: Database, packagename: string): bool =
 for pkg in db.packages:
  if pkg.name == packagename:
   return true

 return false

proc set*(db: Database, pkg, version: string, files: seq[string]) =
 db.packages.add(Package(name: pkg, version: version, files: files))

proc getVersion*(db: Database, packagename: string): string =
 for pkg in db.packages:
  if pkg.name == packagename:
   return pkg.version

 "0.0.1"

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
 try:
  to[Database](readFile(computedDBPath))
 except IOError:
  Database(name: name, packages: @[])