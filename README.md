# NCEPLIBS

## Introduction

This is a collection of libraries commonly known as NCEPLIBS that are
required for several NCEP applications, e.g., UFS, GSI, UPP, etc. For
general information about NCEPLIBS, the user is referred to the
[Wiki](https://github.com/NOAA-EMC/NCEPLIBS/wiki).

For full documentation of each package see
https://noaa-emc.github.io/NCEPLIBS/.

For installing NCEPLIBS on [NOAA HPC
systems](https://spack-stack.readthedocs.io/en/latest/PreConfiguredSites.html),
see the
[documentation](https://spack-stack.readthedocs.io/en/latest/Overview.html#getting-started)
for the [spack-stack](https://github.com/JCSDA/spack-stack) project. The
documentation provides instructions for using spack-stack to [build software
stacks from
scratch](https://spack-stack.readthedocs.io/en/latest/CreatingEnvironments.html#creatingenvironment),
as well as to [build stacks that are chained to existing
environments](https://spack-stack.readthedocs.io/en/latest/AddingTestPackages.html#add-test-packages)
in order to re-use dependencies already provided by official spack-stack
deployments. **Note** that users are recommended to use existing spack-stack
installations as much as possible when using NOAA R&D systems, and to use
spack-stack as much as possible when developing for applications that
spack-stack is intended to support, namely, UFS applications, Global Workflow,
and JEDI applications (i.e., users developing the UFS Weather Model on a
personal machine are recommended to use their own installation of spack-stack).
Outside of these platforms and applications, users are recommended to install
NCEPLIBS either through CMake or through regular Spack (not spack-stack); see
instructions below.

NCEPLIBS is comprised of the following libraries:

 NCEP library         | Spack package name | Description
----------------------|--------------------|-----------------------------------------------------
[NCEPLIBS-bacio](https://github.com/NOAA-EMC/NCEPLIBS-bacio)             | bacio              | Binary I/O for the NCEP models
[NCEPLIBS-bufr](https://github.com/NOAA-EMC/NCEPLIBS-bufr)               | bufr               | Working with the BUFR format
[NCEPLIBS-g2](https://github.com/NOAA-EMC/NCEPLIBS-g2)                   | g2                 | Coding/decoding GRIB2 messages
[NCEPLIBS-g2c](https://github.com/NOAA-EMC/NCEPLIBS-g2c)                 | g2c                | C decoder/encoder routines for GRIB edition 2
[NCEPLIBS-g2tmpl](https://github.com/NOAA-EMC/NCEPLIBS-g2tmpl)           | g2tmpl             | Utilities for GRIB2 templates
[NCEPLIBS-gfsio](https://github.com/NOAA-EMC/NCEPLIBS-gfsio)             | gfsio              | Convert GFS Gaussian output into grib output
[NCEPLIBS-ip](https://github.com/NOAA-EMC/NCEPLIBS-ip)                   | ip                 | General interpolation library 
[NCEPLIBS-landsfcutil](https://github.com/NOAA-EMC/NCEPLIBS-landsfcutil) | landsfcutil        | Initializing land-surface states
[NCEPLIBS-ncio](https://github.com/NOAA-EMC/NCEPLIBS-ncio)               | ncio               | Read the GFS forecast files
[NCEPLIBS-nemsio](https://github.com/NOAA-EMC/NCEPLIBS-nemsio)           | nemsio             | I/O for the NCEP models using NEMS
[NCEPLIBS-nemsiogfs](https://github.com/NOAA-EMC/NCEPLIBS-nemsiogfs)     | nemsiogfs          | I/O for the NEMS-GFS model
[NCEPLIBS-sfcio](https://github.com/NOAA-EMC/NCEPLIBS-sfcio)             | sfcio              | Surface files I/O
[NCEPLIBS-sigio](https://github.com/NOAA-EMC/NCEPLIBS-sigio)             | sigio              | I/O on the sigma restart file of the global spectral model
[NCEPLIBS-sp](https://github.com/NOAA-EMC/NCEPLIBS-sp)                   | sp                 | Spectral transform library 
[NCEPLIBS-w3emc](https://github.com/NOAA-EMC/NCEPLIBS-w3emc)             | w3emc              | Decoder/encoder routines for GRIB edition 1
[NCEPLIBS-wrf_io](https://github.com/NOAA-EMC/NCEPLIBS-wrf_io)           | wrf-io             | Lightweight WRF-IO API library for Unified Post Processor (UPP)

The [NCEPLIBS-w3nco](https://github.com/NOAA-EMC/NCEPLIBS-w3nco) and
[NCEPLIBS-ip2](https://github.com/NOAA-EMC/NCEPLIBS-ip2) libraries
('w3nco' and 'ip2' in Spack, respectively) are deprecated, and
NCEPLIBS-w3emc and NCEPLIBS-ip, respectively, should be used instead.

The following projects are also related to the NCEPLIBS project:
 - [NCEPLIBS-grib_util](https://github.com/NOAA-EMC/NCEPLIBS-grib_util) ('grib-util' in Spack)
 - [NCEPLIBS-prod_util](https://github.com/NOAA-EMC/NCEPLIBS-prod_util) ('prod-util' in Spack)
 - [UFS_UTILS](https://github.com/NOAA-EMC/UFS_UTILS) ('ufs-utils' in Spack)

## Required Software

 - A supported C/C++ and Fortran compiler (see table below).  Other
versions may work, in particular if close to the versions listed
below.

| Compiler vendor | Supported (tested) versions                                |
|-----------------|------------------------------------------------------------|
| Intel           | 18.0.3.222, 18.0.5.274, 19.0.2.187, 19.0.5.281, 19.1.0.166 |
| GNU             | 8.3.0, 9.X.0                                               |

 - A supported MPI library (see table below).  Other versions may work,
in particular if close to the versions listed below.

| MPI library     | Supported (tested) versions                                |
|-----------------|------------------------------------------------------------|
| MPICH           | 3.3.1, 3.3.2                                               |
| MVAPICH2        | 2.3.3                                                      |
| Open MPI        | 3.1.5, 4.0.2                                               |
| Intel MPI       | 2018.0.4, 2019.6.154, 2020.0.166                           |
| SGI MPT         | 2.19                                                       |

 - A software stack consisting of the following third-party libraries,
compiled with the same compiler and MPI library (where
applicable). Other versions may work, in particular if close to the
versions listed below. To install the third-party libraries needed by
NCEPLIBS, see
[NCEPLIBS-external](https://github.com/NOAA-EMC/NCEPLIBS-external).

| Library         | Supported (tested) versions                                |
|-----------------|------------------------------------------------------------|
| CMake           | cmake-3.16.3                                               |
| zlib            | zlib-1.2.11                                                |
| libpng          | libpng-1.6.35                                              |
| libjpeg         | jpeg-9.1                                                   |
| Jasper          | jasper-2.0.16                                              |
| HDF5            | hdf5-1.10.4                                                |
| NetCDF          | netcdf-c-4.7.3, netcdf-fortran-4.5.2                       |

The [NCEPLIBS-external](https://github.com/NOAA-EMC/NCEPLIBS-external)
project provides an convenient way to install the required third-party libraries
on supported platforms such as generic Linux/macOS systems.

## Obtaining, Building, and Using NCEPLIBS

### With Spack
All of the NCEPLIBS can be installed through the [Spack](https://spack.io/)
package manager. One significant benefit of using Spack is that it will
automatically install any dependencies needed, including CMake, or even
compilers. See the [Spack
documentation](https://spack.readthedocs.io/en/latest/basic_usage.html) for
details of configuring and executing Spack installations. Spack also has
extensive capabilities including source and build caching, parallel
installation, dynamically generating Tcl and Lmod environment modules,
and creating Docker and Singularity container images.

In the simplest case, with the `spack` command loaded into the current
environment, run, for example, `spack install ip` to install the latest release
of the NCEPLIBS-ip library along with any needed dependencies. See the above
table for each package's name in Spack. The develop branch for each library can
be installed by specifying the 'develop' version, i.e., `spack install
w3emc@develop`.

Here is a typical set of steps for installing and using NCEPLIBS using Spack,
assuming that Spack's
[prerequisites](https://spack.readthedocs.io/en/latest/getting_started.html#system-prerequisites)
are already installed:
```
git clone https://github.com/spack/spack
. spack/share/spack/setup-env.sh # assuming bash, zsh, or dash shell
spack external find cmake gmake # find external packages to save time
spack install ip@develop precision=4 ^sp@2.4.0 precision=4
spack load ip
```
The `spack load` command configures the $CMAKE_PREFIX_PATH variable,
in this example making the ip library available to downstream CMake builds.

For any bugs or other issues with Spack-based installations, such as incorrect
dependencies in a package's recipe, please file an issue under the appropriate
NCEPLIBS repository.

### With CMake
#### External dependencies
See [NCEPLIBS-external](https://github.com/NOAA-EMC/NCEPLIBS-external) for
building external dependencies.

#### Obtaining the code

Clone the repository:

`git clone https://github.com/NOAA-EMC/NCEPLIBS`

#### Building the libraries

`CMake` employs an out-of-source build.  Create a directory for
configuring the build and cd into it:

`mkdir -p build && cd build`

Set the compilers, if needed, to match those being used for compiling
the third-party libraries listed above: `FC`, `CC`, and `CXX` environment variables can
be used to point to the desired Fortran, C, and C++ compilers.

Execute `cmake` from inside your build directory.

`cmake -DCMAKE_INSTALL_PREFIX=<nceplibs-prefix> ../NCEPLIBS`

If the third-party libraries are not located in a path recognized by `cmake`
e.g. `/usr/local`, it may be necessary to provide the appropriate
environment variables e.g. `<package_ROOT>` or `CMAKE_PREFIX_PATH` so
that `cmake` is able to locate these dependencies.

The installation prefix for NCEPLIBS is provided by the `cmake`
command-line argument `-DCMAKE_INSTALL_PREFIX=<nceplibs-prefix>`

To build and install:

```
make -j<x>
```

This will build and install all the NCEPLIBS and place them into the
installation prefix `<nceplibs-prefix>`.

Additional `cmake` command-line options while configuring NCEPLIBS:

`-DFLAT=ON|OFF` - determines the installation tree heirarchy

`-DDEPLOY=ON|OFF` - prepares and deploys Lua modulefiles for each of
the NCEPLIBS libraries.  To deploy modulefiles:

```
make deploy
```

[LMod](https://lmod.readthedocs.io/en/latest/) Environment module
system is required to load/unload these modules.

Some HPC systems use Tcl based Environment modules.  NCEPLIBS provides
a means to deploy Tcl module files and can be exercised as follows:

`-DTCLMOD=ON` - enables option to change Lua modulefiles to Tcl modulefiles for each of the NCEPLIBS libraries.  To make the change:
```
make tcl
```

On machines that do not provide access to Github, a `DOWNLOAD_ONLY`
and `USE_LOCAL` option is provided.  To download the NCEPLIBS without
building them use the cmake command line option `-DDOWNLOAD_ONLY=ON`.
This will download all the NCEPLIBS in a local `download` folder.
`make tarball` will tar and zip this folder into `nceplibs.tgz` which
can then be transferred to the machine without GitHub access.  Untar
the tarball, and use the cmake command line option `USE_LOCAL` as
`-DUSE_LOCAL=ON`.  This will use the source code from the download
directory.

## Usage

NCEPLIBS can be used in any application that uses `cmake` to
configure and build by adding `-DCMAKE_PREFIX_PATH=<nceplibs-prefix>`
to the cmake command line during configuration. Note that if NCEPLIBS
are installed through Spack, loading the packages, either through
Spack-built environment modules or using the `spack load` command,
will populate the `$CMAKE_PREFIX_PATH` environment variable with
the appropriate paths.

## Disclaimer

The United States Department of Commerce (DOC) GitHub project code is
provided on an "as is" basis and the user assumes responsibility for
its use. DOC has relinquished control of the information and no longer
has responsibility to protect the integrity, confidentiality, or
availability of the information. Any claims against the Department of
Commerce stemming from the use of its GitHub project will be governed
by all applicable Federal law. Any reference to specific commercial
products, processes, or services by service mark, trademark,
manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation or favoring by the Department of
Commerce. The Department of Commerce seal and logo, or the seal and
logo of a DOC bureau, shall not be used in any manner to imply
endorsement of any commercial product or activity by DOC or the United
States Government.
