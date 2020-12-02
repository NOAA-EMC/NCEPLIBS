help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName .. '-' .. pkgVersion)

setenv("g2c_ROOT", base)
setenv("g2c_VERSION", pkgVersion)
setenv("G2C_INC", pathJoin(base,"include"))
setenv("G2C_LIB", pathJoin(base,"lib/libg2c.a"))

