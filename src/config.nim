import parsetoml

proc getConfig*: TomlValueRef =
 parsetoml.parseFile("default.toml")