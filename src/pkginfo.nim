import curly, utils, parsetoml, std/strformat

proc getBuildInfo*(repo, pkg: string): TomlValueRef =
 let 
  url = fmt"https://raw.githubusercontent.com/Nemesis-OS/packages-{repo}/main/{pkg}/build"
  response = newCurlPool(1).get(url)

 # TODO(xTrayambak): implement 404 handler

 parsetoml.parseString(response.body)