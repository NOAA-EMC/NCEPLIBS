help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("nemsiogfs_ROOT", pathJoin(base,"nemsiogfs"))
setenv("nemsiogfs_VERSION", pkgVersion)
setenv("NEMSIOGFS_INC", pathJoin(base,"nemsiogfs/include"))
setenv("NEMSIOGFS_LIB", pathJoin(base,"nemsiogfs/lib/libnemsiogfs.a"))
