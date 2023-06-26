# Package

version       = "0.1.0"
author        = "xTrayambak"
description   = "Package manager for NemesisOS"
license       = "GPL-3.0"
srcDir        = "src"
bin           = @["nemesis_pkg_cli"]


# Dependencies

requires "nim >= 1.6.12"
requires "curly"
requires "parsetoml"
requires "uuids"
requires "zippy"