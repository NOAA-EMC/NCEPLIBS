help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("sfcio_ROOT", pathJoin(base,"sfcio"))
setenv("sfcio_VERSION", pkgVersion)
setenv("SFCIO_INC", pathJoin(base,"sfcio/include"))
setenv("SFCIO_LIB", pathJoin(base,"sfcio/lib/libsfcio.a"))
