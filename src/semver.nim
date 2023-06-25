import std/[strutils, strformat]

type SemanticVersion* = ref object of RootObj
 major*: uint
 minor*: uint
 patch*: string

proc `$`*(semver: SemanticVersion): string =
 fmt"{semver.major}.{semver.minor}.{semver.patch}"

proc biggest*(semseq: seq[SemanticVersion]): SemanticVersion =
 var curr: SemanticVersion = semseq[0]
 for semver in semseq:
  if semver.major > curr.major:
   curr = semver
   continue
  elif semver.major == curr.major:
    if semver.minor > curr.minor:
     curr = semver
     continue
    elif semver.minor == curr.minor:
     if semver.patch[semver.patch.len-1].toLowerAscii() in {'a'..'z'} and curr.patch[curr.patch.len-1].toLowerAscii() notin {'a'..'z'}:
      curr = semver
      continue
     elif semver.patch[semver.patch.len-1].toLowerAscii() in {'a'..'z'} and curr.patch[curr.patch.len-1].toLowerAscii() in {'a'..'z'}:
       let 
        a0 = semver.patch[semver.patch.len]
        a1 = curr.patch[curr.patch.len]

       if a0 > a1:
        curr = semver
        continue

 curr

proc parse*(semver: string): SemanticVersion =
 let
  version = semver.split('.')
  major = version[0].parseUint()
  minor = version[1].parseUint()
  patch = version[2]

 SemanticVersion(major: major, minor: minor, patch: patch)