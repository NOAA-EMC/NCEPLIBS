help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName .. '-' .. pkgVersion)

setenv("sigio_ROOT", base)
setenv("sigio_VERSION", pkgVersion)
setenv("SIGIO_INC", pathJoin(base,"include"))
setenv("SIGIO_LIB", pathJoin(base,"lib/libsigio.a"))
