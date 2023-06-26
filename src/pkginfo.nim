import curly, parsetoml, colors, std/strformat

proc getBuildInfo*(repo, pkg: string): TomlValueRef =
 let 
  url = fmt"https://raw.githubusercontent.com/Nemesis-OS/packages-{repo}/main/{pkg}/build"
  response = newCurlPool(1).get(url)

 if response.code == 404:
  echo fmt"{RED}error{RESET}: encountered 404 when finding {pkg}; perhaps the package is deleted?"
  quit 1

 if response.body.len < 1:
  echo fmt"{RED}error{RESET}: endpoint returned empty payload when finding {pkg}"
  quit 1

 parsetoml.parseString(response.body)