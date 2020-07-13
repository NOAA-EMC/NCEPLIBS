help([[
]])

local pkgName = myModuleName()
local pkgVersion = myModuleVersion()

conflict(pkgName)

local prefix = "#NCEPLIBS_ROOT#"
local base = pathJoin(prefix,pkgName .. '-' .. pkgVersion)

setenv("bufr_ROOT", base)
setenv("bufr_VERSION", pkgVersion)
setenv("BUFR_INC4",    pathJoin(base,"include_4"))
setenv("BUFR_INC8",    pathJoin(base,"include_8"))
setenv("BUFR_INCd",    pathJoin(base,"include_d"))
setenv("BUFR_LIB4",    pathJoin(base,"lib/libbufr_4.a"))
setenv("BUFR_LIB8",    pathJoin(base,"lib/libbufr_8.a"))
setenv("BUFR_LIBd",    pathJoin(base,"lib/libbufr_d.a"))
setenv("BUFR_INC4_DA", pathJoin(base,"include_4_DA"))
setenv("BUFR_INC8_DA", pathJoin(base,"include_8_DA"))
setenv("BUFR_INCd_DA", pathJoin(base,"include_d_DA"))
setenv("BUFR_LIB4_DA", pathJoin(base,"lib/libbufr_4_DA.a"))
setenv("BUFR_LIB8_DA", pathJoin(base,"lib/libbufr_8_DA.a"))
setenv("BUFR_LIBd_DA", pathJoin(base,"lib/libbufr_d_DA.a"))
