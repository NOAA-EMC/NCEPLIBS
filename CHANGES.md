## v1.2.0

Re-factored and cleaned up CMake build for all libraries to create proper package configs and use imported targets

Removed `-xHost` flag from some libraries which caused portability issues

Added user-settable flags through `CMAKE_<LANG>_FLAGS`

Fixed bug building with GCC 10 by ignoring compiler warnings related to mismatched argument types and boz formatting that were previously allowed in earlier version of GCC.

Fixed `find_dependency` in some libraries to properly propagate OpenMP and MPI dependencies


## v1.1.0

Fixed installation of scripts using INSTALL command instead of copying them

Updated submodules for grib\_util, post, prod\_util, UFS\_UTILS

Remove unnecessary `STATIC_IS_DEFAULT` in build options



## v1.0.0

CMake-based build for NCEPLIBS public release
