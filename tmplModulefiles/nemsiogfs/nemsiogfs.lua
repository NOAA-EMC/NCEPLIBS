help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName,pkgVersion)

setenv("nemsiogfs_ROOT", base)
setenv("nemsiogfs_VERSION", pkgVersion)
setenv("NEMSIOGFS_INC", pathJoin(base,"include"))
setenv("NEMSIOGFS_LIB", pathJoin(base,"lib/libnemsiogfs.a"))
