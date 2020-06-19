help([[
]])

local pkgVersion = myModuleVersion()
local pkgName = myModuleName()

conflict(pkgName)

local base = "@NCEPLIBS_ROOT@"

setenv("crtm_ROOT", pathJoin(base,"crtm"))
setenv("crtm_VERSION", pkgVersion)
setenv("CRTM_INC", pathJoin(base,"crtm/include"))
setenv("CRTM_LIB", pathJoin(base,"crtm/lib/libcrtm.a"))
