import ../src/semver, os

let
 s = @[parse(paramStr(1)), parse(paramStr(2))]

echo $s[0]
echo $s[1]
echo $biggest(s)