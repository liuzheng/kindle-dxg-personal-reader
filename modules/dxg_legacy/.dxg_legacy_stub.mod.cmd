savedcmd_dxg_legacy_stub.mod := printf '%s\n'   dxg_legacy_stub.o | awk '!x[$$0]++ { print("./"$$0) }' > dxg_legacy_stub.mod
