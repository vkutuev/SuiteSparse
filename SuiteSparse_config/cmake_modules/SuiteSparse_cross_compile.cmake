#-------------------------------------------------------------------------------
# SuiteSparse/SuiteSparse_config/cmake_modules/SuiteSparseBLAS.cmake
#-------------------------------------------------------------------------------

# SuiteSparse_config, Copyright (c) 2012-2023, Timothy A. Davis.
# All Rights Reserved.
# SPDX-License-Identifier: BSD-3-clause

#-------------------------------------------------------------------------------

# This module implements cross-compilation for SuiteSparse:
# set the CMAKE_PREFIX_PATH cache variable to tell cmake to search 
# dependencies for SuiteSparse build in the directory where  
# the target environment is located

set ( CMAKE_PREFIX_PATH $ENV{CROSS_SYSROOT} )