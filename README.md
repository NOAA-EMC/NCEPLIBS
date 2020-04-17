# NCEPLIBS

## Introduction

This is a compilation of libraries known as NCEPLIBS that are required for building and running the UFS weather model. For general information about NCEPLIBS and the UFS weather model, the user is referred to the [Wiki](https://github.com/NOAA-EMC/NCEPLIBS/wiki).

It includes the following libraries:

| NCEP library         | Version                                               |
|----------------------|-------------------------------------------------------|
| NCEPLIBS-bacio       | 2.2.0                                                 |
| NCEPLIBS-bufr        | not included in this release                          |
| NCEPLIBS-crtm        | 2.3.0                                                 |
| NCEPLIBS-g2          | 3.2.0                                                 |
| NCEPLIBS-g2tmpl      | 1.7.0                                                 |
| NCEPLIBS-gfsio       | 1.2.0                                                 |
| NCEPLIBS-grib_util   | 1.2.0                                                 |
| NCEPLIBS-ip          | 3.1.0                                                 |
| NCEPLIBS-landsfcutil | 2.2.0                                                 |
| NCEPLIBS-nemsio      | 2.3.0                                                 |
| NCEPLIBS-nemsiogfs   | 2.3.0                                                 |
| EMC_post             | 1.0.0                                                 |
| NCEPLIBS-prod_util   | 1.2.0                                                 |
| NCEPLIBS-sfcio       | 1.2.0                                                 |
| NCEPLIBS-sigio       | 2.2.0                                                 |
| NCEPLIBS-sp          | 2.1.0                                                 |
| NCEPLIBS-w3emc       | 2.5.0                                                 |
| NCEPLIBS-w3nco       | 2.1.0                                                 |
| UFS_UTILS            | 1.0.0                                                 |

## Building, Requirements, Troubleshooting, Support

### Required Software 

1. CMake version 3.15 or newer. If the existing CMake version is too old, you need to install a newer version. The NCEPLIBS-external code contains a recent version of cmake that users can install (see https://github.com/NOAA-EMC/NCEPLIBS-external and below).

2. A supported C/C++ and Fortran compiler, see table below. Other versions may work, in particular if close to the versions listed below. If the chosen compiler is not the default compiler on the system, set the environment variables `export CC=...`, `export CXX=...`, `export FC=...`, before invoking `cmake`.

| Compiler vendor | Supported (tested) versions                                |
|-----------------|------------------------------------------------------------|
| Intel           | 18.0.3.222, 18.0.5.274, 19.0.2.187, 19.0.5.281, 19.1.0.166 |
| GNU             | 8.3.0, 9.1.0, 9.2.0                                        |

3. A supported MPI library unless installed as part of NCEPLIBS-external, see table below. Other versions may work, in particular if close to the versions listed below. It is recommended to compile the MPI library with the same compilers used to compile NCEPLIBS-external, NCEPLIBS and the UFS applications.

| MPI library     | Supported (tested) versions                                |
|-----------------|------------------------------------------------------------|
| MPICH           | 3.3.1, 3.3.2                                               |
| MVAPICH2        | 2.3.3                                                      |
| Open MPI        | 4.0.2                                                      |
| Intel MPI       | 2018.0.4, 2019.6.154, 2020.0.166                           |
| SGI MPT         | 2.19                                                       |

4. A software stack consisting of the following libraries, preferably compiled with the same compiler and MPI library (where applicable). Other versions may work, in particular if close to the versions listed below. The [NCEPLIBS-external project](https://github.com/NOAA-EMC/NCEPLIBS-external) provides an easy and convenient way to install the required libraries on supported platforms such as generic Linux/macOS systems. It is also possible to skip installing certain components and set the appropriate environment variables so that the NCEPLIBS build system finds them. This is also discussed in detail on the NCEPLIBS-external project.

| Library         | Supported (tested) versions                                |
|-----------------|------------------------------------------------------------|
| CMake           | cmake-3.16.3                                               |
| MPI             | openmpi-4.0.2                                              |
| zlib            | zlib-1.2.11                                                |
| HDF5            | hdf5-1.10.4                                                |
| NetCDF          | netcdf-c-4.7.3, netcdf-fortran-4.5.2                       |
| libpng          | libpng-1.6.35                                              |
| libjpeg         | jpeg-9.1                                                   |
| Jasper          | jasper-2.0.16                                              |
| WGRIB2          | wgrib-2.0.8                                                |
| ESMF            | esmf-8.0.0                                                 |

### Prepare to Build 

The [NCEPLIBS-external documentation](https://github.com/NOAA-EMC/NCEPLIBS-external) describes how to install the required dependencies and the NCEPLIBS on supported platforms, and how preconfigured platforms have been set up for the users. The definitions of the different support levels (e.g. pre-configured, configurable) are on the [Supported Platforms and Compilers](https://github.com/ufs-community/ufs/wiki/Supported-Platforms-and-Compilers) page. The following section provides general instructions for building the NCEPLIBS.

### Get and Build the Code

**Obtaining the code**

Clone the repository and its submodules:

`git clone -b ufs-v1.0.0 --recursive https://github.com/NOAA-EMC/NCEPLIBS`

**Building**

CMake uses an out-of-source build, so create a directory for the build:

`mkdir build`

`cd build`

Set the compilers, if needed, to match those being used for compiling NCEPLIBS-external and the UFS applications later: `FC`, `CC`, and `CXX` environment variables can be used to point to the desired Fortran, C, and C++ compilers.

Then, run CMake from inside your build directory and pass it the location of the NCEPLIBS-external install directory (if using).

`cmake .. -DEXTERNAL_LIBS_DIR=<path-to-external-libs-install>`

For libraries that are installed by NCEPLIBS-external, no additional settings are required for building the NCEPLIBS other than the `-DEXTERNAL_LIBS_DIR` flag (but see the note on static builds below). For libraries that were installed separately from NCEPLIBS-external, it may be necessary to set the appropriate environment variables so that CMake is able to find them. Please refer to the [NCEPLIBS-external documentation](https://github.com/NOAA-EMC/NCEPLIBS-external) for details.

The default install location is `<build_dir>/install`, but it can be modified by adding:

`-DCMAKE_INSTALL_PREFIX=<path>` when running CMake

When static linking is the default option on a given system (e.g. Cray), add
```
-DSTATIC_IS_DEFAULT=ON
```
to the `cmake` call.

Then, finally run:

```
make -j<x>
make install
```

This will make and install all the NCEPLIBS and place them into the install directory.

**Setting your environment to build the UFS Weather Model**

NCEPLIBS produces a shell script that can be sourced to setup your environment to build the UFS Weather Model. Located in `<install>/bin` are `setenv_nceplibs.sh` and `setenv_nceplibs.csh`. Sourcing them will set environment variables that tell the model where to find various libraries such as NCEPLIBS and NetCDF:

`. <install>/bin/setenv_nceplibs.sh`

or, if running C shell,

`source <install>/bin/setenv_nceplibs.csh`

### Troubleshooting

Make sure to check the [troubleshooting section of the NCEPLIBS-external documentation](https://github.com/NOAA-EMC/NCEPLIBS-external).

## Disclaimer

The United States Department of Commerce (DOC) GitHub project code is provided on an "as is" basis and the user assumes responsibility for its use. DOC has relinquished control of the information and no longer has responsibility to protect the integrity, confidentiality, or availability of the information. Any claims against the Department of Commerce stemming from the use of its GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
