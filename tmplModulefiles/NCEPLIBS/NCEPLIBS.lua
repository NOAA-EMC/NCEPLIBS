help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"

setenv("NCEPLIBS_ROOT", prefix)

setenv("CC", "#CC#")
setenv("CXX", "#CXX#")
setenv("FC", "#FC#")
