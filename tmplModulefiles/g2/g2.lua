help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName,pkgName .. '-' .. pkgVersion)

setenv("g2_ROOT", base)
setenv("g2_VERSION", pkgVersion)
setenv("g2_INC4", pathJoin(base,"include_4"))
setenv("G2_INCd", pathJoin(base,"include_d"))
setenv("G2_LIB4", pathJoin(base,"lib/libg2_4.a"))
setenv("G2_LIBd", pathJoin(base,"lib/libg2_d.a"))
