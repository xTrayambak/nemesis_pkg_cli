const ROOT_REQUIRED_ACTIONS = @[
 "install",
 "uninstall"
]

proc actionRequiresRoot*(action: string): bool {.inline.} =
 action in ROOT_REQUIRED_ACTIONS