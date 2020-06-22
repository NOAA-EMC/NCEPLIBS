help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName,pkgName .. '-' .. pkgVersion)

setenv("g2tmpl_ROOT", base)
setenv("g2tmpl_VERSION", pkgVersion)
setenv("G2TMPL_INC", pathJoin(base,"include"))
setenv("G2TMPL_LIB", pathJoin(base,"lib/libg2tmpl.a"))
