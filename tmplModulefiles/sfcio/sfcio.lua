help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName .. '-' .. pkgVersion)

setenv("sfcio_ROOT", base)
setenv("sfcio_VERSION", pkgVersion)
setenv("SFCIO_INC", pathJoin(base,"include"))
setenv("SFCIO_LIB", pathJoin(base,"lib/libsfcio.a"))
