help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName .. '-' .. pkgVersion)

setenv("crtm_ROOT", base)
setenv("crtm_VERSION", pkgVersion)
setenv("CRTM_INC", pathJoin(base,"include"))
setenv("CRTM_LIB", pathJoin(base,"lib/libcrtm.a"))
