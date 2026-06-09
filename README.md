# NCEPLIBS

## Introduction

NCEPLIBS is a collection of libraries used by a range of NCEP R&D and
operational applications, including UFS (Weather Model, SRW, etc.), GSI/Global
Workflow, UFS_UTILS, and UPP. General information about NCEPLIBS, including
code best practices, contributor expectations, and continuous integration
methods, can be found in the [NCEPLIBS
wiki](https://github.com/NOAA-EMC/NCEPLIBS/wiki).

For using NCEPLIBS on [NOAA HPC
systems](https://spack-stack.readthedocs.io/en/latest/PreConfiguredSites.html),
see the [spack-stack](https://github.com/JCSDA/spack-stack) project's [Getting
Started
documentation](https://spack-stack.readthedocs.io/en/latest/Overview.html#getting-started)
and [wiki](https://github.com/JCSDA/spack-stack/wiki). The spack-stack
framework is used to install a range of libraries, including all currently
supported NCEPLIBS codes, on [RDHPCS](https://docs.rdhpcs.noaa.gov/) systems in
locations available to all users. The documentation also provides instructions
for using spack-stack to [build software stacks from
scratch](https://spack-stack.readthedocs.io/en/latest/CreatingEnvironments.html#creatingenvironment),
as well as to [build stacks that are chained to existing
environments](https://spack-stack.readthedocs.io/en/latest/AddingTestPackages.html#add-test-packages)
in order to re-use dependencies already provided by official spack-stack
deployments.

NCEPLIBS is comprised of the following libraries. *Italicization* indicates a
repository that as of Summer 2025 is no longer actively developed, therefore
NOAA developers are suggested to avoid using them, or to confer with the NCEPLIBS
team before beginning any development work with them.

 NCEP library         | Spack package name | Description
----------------------|--------------------|-----------------------------------------------------
[NCEPLIBS-bacio](https://github.com/NOAA-EMC/NCEPLIBS-bacio)               | bacio              | Binary I/O for the NCEP models
[NCEPLIBS-bufr](https://github.com/NOAA-EMC/NCEPLIBS-bufr)                 | bufr               | Working with the BUFR format
[NCEPLIBS-g2](https://github.com/NOAA-EMC/NCEPLIBS-g2)                     | g2                 | Coding/decoding GRIB2 messages
[NCEPLIBS-g2c](https://github.com/NOAA-EMC/NCEPLIBS-g2c)                   | g2c                | C decoder/encoder routines for GRIB edition 2
[NCEPLIBS-g2tmpl](https://github.com/NOAA-EMC/NCEPLIBS-g2tmpl)             | g2tmpl             | Utilities for GRIB2 templates
*[NCEPLIBS-gfsio](https://github.com/NOAA-EMC/NCEPLIBS-gfsio)*             | gfsio              | Convert GFS Gaussian output into grib output
*[NCEPLIBS-grib_util](https://github.com/NOAA-EMC/NCEPLIBS-grib_util)*     | grib-util          | Utilities for working with GRIB2 files
[NCEPLIBS-ip](https://github.com/NOAA-EMC/NCEPLIBS-ip)                     | ip                 | General interpolation library 
*[NCEPLIBS-landsfcutil](https://github.com/NOAA-EMC/NCEPLIBS-landsfcutil)* | landsfcutil        | Initializing land-surface states
[NCEPLIBS-ncio](https://github.com/NOAA-EMC/NCEPLIBS-ncio)                 | ncio               | Read the GFS forecast files
*[NCEPLIBS-nemsio](https://github.com/NOAA-EMC/NCEPLIBS-nemsio)*           | nemsio             | I/O for the NCEP models using NEMS
*[NCEPLIBS-nemsiogfs](https://github.com/NOAA-EMC/NCEPLIBS-nemsiogfs)*     | nemsiogfs          | I/O for the NEMS-GFS model
*[NCEPLIBS-prod_util](https://github.com/NOAA-EMC/NCEPLIBS-prod_util)*     | prod-util          | EMC copy of NCO's utilities for misc. date & file manipulation
*[NCEPLIBS-sfcio](https://github.com/NOAA-EMC/NCEPLIBS-sfcio)*             | sfcio              | Surface files I/O
*[NCEPLIBS-sigio](https://github.com/NOAA-EMC/NCEPLIBS-sigio)*             | sigio              | I/O on the sigma restart file of the global spectral model
[NCEPLIBS-w3emc](https://github.com/NOAA-EMC/NCEPLIBS-w3emc)               | w3emc              | Decoder/encoder routines for GRIB edition 1
*[NCEPLIBS-wrf_io](https://github.com/NOAA-EMC/NCEPLIBS-wrf_io)*           | wrf-io             | Lightweight WRF-IO API library for Unified Post Processor (UPP)
[wgrib2](https://github.com/NOAA-EMC/wgrib2)                               | wgrib2             | Utility for working with GRIB2 files

For information on maintainers, documentation, and bug and feature requests,
refer to each package repository listed above.

The [NCEPLIBS-w3nco](https://github.com/NOAA-EMC/NCEPLIBS-w3nco),
[NCEPLIBS-ip2](https://github.com/NOAA-EMC/NCEPLIBS-ip2),
and [NCEPLIBS-sp](https://github.com/NOAA-EMC/NCEPLIBS-sp) libraries
('w3nco', 'ip2', and 'sp' in Spack, respectively) are deprecated.
NCEPLIBS-w3emc replaces NCEPLIBS-w3nco, and NCEPLIBS-ip replaces NCEPLIBS-ip2
and NCEPLIBS-sp.

## Supported compilers and required software

NCEPLIBS codes are tested with and intended to support GCC, Intel Classic, and
Intel oneAPI compilers. Older versions of each of these may not be compatible.
Refer to individual code repositories (including GitHub Issues) for more
specific information on compiler conflicts, and please submit issues if
previously unknown conflicts emerge. Contributions of modified code and CMake
configurations to allow for the use of other compilers are welcome, but
compilers other than those listed above are not officially supported.

All NCEPLIBS codes use the CMake build system, therefore CMake and at least one
of GMake and Ninja are necessary to build them. 

## Obtaining, building, and using NCEPLIBS

> [!NOTE]  
> Users are recommended to use existing spack-stack installations as much
as possible when using NOAA R&D systems, and to use spack-stack as much as
possible when developing the applications that spack-stack is intended to
support, namely, UFS applications, Global Workflow, and JEDI applications
(for instance, users developing the UFS Weather Model on a personal machine are
recommended to build a local copy of spack-stack). Outside of these
platforms and applications, users are recommended to install NCEPLIBS either
through CMake or through regular Spack (not spack-stack); see instructions
below.

### With Spack

All of the NCEPLIBS codes can be installed through the [Spack](https://spack.io/)
package manager. One significant benefit of using Spack is that it will
automatically install any dependencies needed, including CMake, and even
compilers. See the [Spack
documentation](https://spack.readthedocs.io/en/latest/basic_usage.html) for
details of configuring and executing Spack installations. Spack also has
extensive capabilities including source and build caching, parallel
installation, dynamically generating Tcl and Lmod environment modules,
and creating Docker and Singularity container images.

In the simplest case, with the `spack` command loaded into the current
environment, run, for example, `spack install ip` to install the latest release
of the NCEPLIBS-ip library; Spack will take care of installing all necessary
dependencies. See the above table for each package's name in Spack. The develop
branch for each library can be installed by specifying the 'develop' version,
i.e., `spack install w3emc@develop`.

Here is a typical set of steps for installing and using NCEPLIBS using Spack,
assuming that Spack's own
[prerequisites](https://spack.readthedocs.io/en/latest/getting_started.html#system-prerequisites)
are already installed:
```
git clone https://github.com/spack/spack
. spack/share/spack/setup-env.sh # assuming bash, zsh, or dash shell
spack external find cmake gmake openblas # optionally find external packages to save time
spack install ip@develop precision=4,d,8
spack load ip
```
The `spack load` command configures the `$CMAKE_PREFIX_PATH` variable, in this
example making the ip library available to downstream CMake projects (e.g., UFS
Weather Model).

For any bugs or other issues with Spack-based installations, such as incorrect
dependencies in a package's recipe, please file an issue under the main Spack
repository.

### With CMake

For CMake build instructions, including software prerequisities and build
options, refer to each NCEPLIBS repository's README and ReadTheDocs page. The
GitHub Actions workflows under .github/workflows/ in each NCEPLIBS repository
may be useful references for possible approaches to obtaining software prerequisites.

## Usage

NCEPLIBS can be used in any application that uses `cmake` to configure and
build by adding `-DCMAKE_PREFIX_PATH=<nceplibs-prefix>` to the CMake command
line during configuration. Note that if NCEPLIBS codes are installed through
Spack, loading the packages, either through Spack-built environment modules or
using the `spack load` command, will by default populate the
`$CMAKE_PREFIX_PATH` environment variable with the appropriate paths.

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
