help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("sigio_ROOT", pathJoin(base,"sigio"))
setenv("sigio_VERSION", pkgVersion)
setenv("SIGIO_INC", pathJoin(base,"sigio/include"))
setenv("SIGIO_LIB", pathJoin(base,"sigio/lib/libsigio.a"))
