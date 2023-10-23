function klu_make
%KLU_MAKE compiles the KLU mexFunctions
%
% Example:
%   klu_make
%
% KLU relies on AMD, COLAMD, and BTF for its ordering options, and can
% optionally use CHOLMOD, CCOLAMD, CAMD, and METIS as well.
%
% You must type the klu_make command while in the KLU/MATLAB directory.
%
% See also klu.

% KLU, Copyright (c) 2004-2022, University of Florida.  All Rights Reserved.
% Authors: Timothy A. Davis and Ekanathan Palamadai.
% SPDX-License-Identifier: LGPL-2.1+

metis_path = '../../CHOLMOD/SuiteSparse_metis' ;
with_cholmod = exist (metis_path, 'dir') ;

details = 0 ;       % if 1, print details of each command

d = '' ;
if (~isempty (strfind (computer, '64')))
    % 64-bit MATLAB
    d = '-largeArrayDims' ;
end

% MATLAB 8.3.0 now has a -silent option to keep 'mex' from burbling too much
if (~verLessThan ('matlab', '8.3.0'))
    d = ['-silent ' d] ;
end

fprintf ('Compiling KLU ') ;
kk = 0 ; 

include = '-I. -I../../AMD/Include -I../../COLAMD/Include -I../Include -I../../SuiteSparse_config -I../../BTF/Include' ;

if (with_cholmod)
    fprintf ('with CHOLMOD, CAMD, CCOLAMD, and METIS\n') ;
    include = [include ' -I../../CCOLAMD/Include -I../../CAMD/Include -I../../CHOLMOD/Include -I../User -I../../CHOLMOD'] ;
    include = [include ' -I' metis_path '/include'] ;
    include = [include ' -I' metis_path '/GKlib'] ;
    include = [include ' -I' metis_path '/libmetis'] ;
    include = ['-DNSUPERNODAL -DNMODIFY -DNMATRIXOPS -DNCHECK ' include] ;
else
    fprintf ('without CHOLMOD, CAMD, CCOLAMD, and METIS\n') ;
    include = ['-DNCHOLMOD ' include] ;
end

% do not attempt to compile CHOLMOD with large file support (not needed)
include = [include ' -DNLARGEFILE'] ;

suitesparse_src = { '../../SuiteSparse_config/SuiteSparse_config' } ;

amd_src = { ...
    '../../AMD/Source/amd_l1', ...
    '../../AMD/Source/amd_l2', ...
    '../../AMD/Source/amd_l_aat', ...
    '../../AMD/Source/amd_l_control', ...
    '../../AMD/Source/amd_l_defaults', ...
    '../../AMD/Source/amd_l_dump', ...
    '../../AMD/Source/amd_l_info', ...
    '../../AMD/Source/amd_l_order', ...
    '../../AMD/Source/amd_l_postorder', ...
    '../../AMD/Source/amd_l_post_tree', ...
    '../../AMD/Source/amd_l_preprocess', ...
    '../../AMD/Source/amd_l_valid' } ;

colamd_src = {
    '../../COLAMD/Source/colamd_l' } ;

if (with_cholmod)

    camd_src = { ...
        '../../CAMD/Source/camd_l1', ...
        '../../CAMD/Source/camd_l2', ...
        '../../CAMD/Source/camd_l_aat', ...
        '../../CAMD/Source/camd_l_control', ...
        '../../CAMD/Source/camd_l_defaults', ...
        '../../CAMD/Source/camd_l_dump', ...
        '../../CAMD/Source/camd_l_info', ...
        '../../CAMD/Source/camd_l_order', ...
        '../../CAMD/Source/camd_l_postorder', ...
        '../../CAMD/Source/camd_l_preprocess', ...
        '../../CAMD/Source/camd_l_valid' } ;

    ccolamd_src = {
        '../../CCOLAMD/Source/ccolamd_l' } ;

    cholmod_src = {
        '../../CHOLMOD/Utility/cholmod_l_aat', ...
        '../../CHOLMOD/Utility/cholmod_l_add', ...
        '../../CHOLMOD/Utility/cholmod_l_add_size_t', ...
        '../../CHOLMOD/Utility/cholmod_l_allocate_dense', ...
        '../../CHOLMOD/Utility/cholmod_l_allocate_factor', ...
        '../../CHOLMOD/Utility/cholmod_l_allocate_sparse', ...
        '../../CHOLMOD/Utility/cholmod_l_allocate_triplet', ...
        '../../CHOLMOD/Utility/cholmod_l_allocate_work', ...
        '../../CHOLMOD/Utility/cholmod_l_alloc_factor', ...
        '../../CHOLMOD/Utility/cholmod_l_alloc_work', ...
        '../../CHOLMOD/Utility/cholmod_l_band', ...
        '../../CHOLMOD/Utility/cholmod_l_band_nnz', ...
        '../../CHOLMOD/Utility/cholmod_l_calloc', ...
        '../../CHOLMOD/Utility/cholmod_l_change_factor', ...
        '../../CHOLMOD/Utility/cholmod_l_clear_flag', ...
        '../../CHOLMOD/Utility/cholmod_l_copy', ...
        '../../CHOLMOD/Utility/cholmod_l_copy_dense2', ...
        '../../CHOLMOD/Utility/cholmod_l_copy_dense', ...
        '../../CHOLMOD/Utility/cholmod_l_copy_factor', ...
        '../../CHOLMOD/Utility/cholmod_l_copy_sparse', ...
        '../../CHOLMOD/Utility/cholmod_l_copy_triplet', ...
        '../../CHOLMOD/Utility/cholmod_l_cumsum', ...
        '../../CHOLMOD/Utility/cholmod_l_dbound', ...
        '../../CHOLMOD/Utility/cholmod_l_defaults', ...
        '../../CHOLMOD/Utility/cholmod_l_dense_nnz', ...
        '../../CHOLMOD/Utility/cholmod_l_dense_to_sparse', ...
        '../../CHOLMOD/Utility/cholmod_l_divcomplex', ...
        '../../CHOLMOD/Utility/cholmod_l_ensure_dense', ...
        '../../CHOLMOD/Utility/cholmod_l_error', ...
        '../../CHOLMOD/Utility/cholmod_l_eye', ...
        '../../CHOLMOD/Utility/cholmod_l_factor_to_sparse', ...
        '../../CHOLMOD/Utility/cholmod_l_finish', ...
        '../../CHOLMOD/Utility/cholmod_l_free', ...
        '../../CHOLMOD/Utility/cholmod_l_free_dense', ...
        '../../CHOLMOD/Utility/cholmod_l_free_factor', ...
        '../../CHOLMOD/Utility/cholmod_l_free_sparse', ...
        '../../CHOLMOD/Utility/cholmod_l_free_triplet', ...
        '../../CHOLMOD/Utility/cholmod_l_free_work', ...
        '../../CHOLMOD/Utility/cholmod_l_hypot', ...
        '../../CHOLMOD/Utility/cholmod_l_malloc', ...
        '../../CHOLMOD/Utility/cholmod_l_maxrank', ...
        '../../CHOLMOD/Utility/cholmod_l_mult_size_t', ...
        '../../CHOLMOD/Utility/cholmod_l_nnz', ...
        '../../CHOLMOD/Utility/cholmod_l_ones', ...
        '../../CHOLMOD/Utility/cholmod_l_pack_factor', ...
        '../../CHOLMOD/Utility/cholmod_l_ptranspose', ...
        '../../CHOLMOD/Utility/cholmod_l_reallocate_column', ...
        '../../CHOLMOD/Utility/cholmod_l_reallocate_factor', ...
        '../../CHOLMOD/Utility/cholmod_l_reallocate_sparse', ...
        '../../CHOLMOD/Utility/cholmod_l_reallocate_triplet', ...
        '../../CHOLMOD/Utility/cholmod_l_realloc', ...
        '../../CHOLMOD/Utility/cholmod_l_realloc_multiple', ...
        '../../CHOLMOD/Utility/cholmod_l_sbound', ...
        '../../CHOLMOD/Utility/cholmod_l_score_comp', ...
        '../../CHOLMOD/Utility/cholmod_l_set_empty', ...
        '../../CHOLMOD/Utility/cholmod_l_sort', ...
        '../../CHOLMOD/Utility/cholmod_l_sparse_to_dense', ...
        '../../CHOLMOD/Utility/cholmod_l_sparse_to_triplet', ...
        '../../CHOLMOD/Utility/cholmod_l_speye', ...
        '../../CHOLMOD/Utility/cholmod_l_spzeros', ...
        '../../CHOLMOD/Utility/cholmod_l_start', ...
        '../../CHOLMOD/Utility/cholmod_l_transpose', ...
        '../../CHOLMOD/Utility/cholmod_l_transpose_sym', ...
        '../../CHOLMOD/Utility/cholmod_l_transpose_unsym', ...
        '../../CHOLMOD/Utility/cholmod_l_triplet_to_sparse', ...
        '../../CHOLMOD/Utility/cholmod_l_version', ...
        '../../CHOLMOD/Utility/cholmod_l_xtype', ...
        '../../CHOLMOD/Utility/cholmod_l_zeros', ...
        '../../CHOLMOD/Utility/cholmod_mult_uint64_t', ...
        '../../CHOLMOD/Utility/cholmod_memdebug', ...
        '../../CHOLMOD/Check/cholmod_l_check', ...
        '../../CHOLMOD/Cholesky/cholmod_l_amd', ...
        '../../CHOLMOD/Cholesky/cholmod_l_analyze', ...
        '../../CHOLMOD/Cholesky/cholmod_l_colamd', ...
        '../../CHOLMOD/Cholesky/cholmod_l_etree', ...
        '../../CHOLMOD/Cholesky/cholmod_l_postorder', ...
        '../../CHOLMOD/Cholesky/cholmod_l_rowcolcounts', ...
        '../../CHOLMOD/Partition/cholmod_l_ccolamd', ...
        '../../CHOLMOD/Partition/cholmod_l_csymamd', ...
        '../../CHOLMOD/Partition/cholmod_l_camd', ...
        '../../CHOLMOD/Partition/cholmod_l_metis', ...
        '../../CHOLMOD/Partition/cholmod_metis_wrapper', ...
        '../../CHOLMOD/Partition/cholmod_l_nesdis' } ;

else
    camd_src = { } ;
    ccolamd_src = { } ;
    cholmod_src = { } ;
end

btf_src = {
    '../../BTF/Source/btf_l_maxtrans', ...
    '../../BTF/Source/btf_l_order', ...
    '../../BTF/Source/btf_l_strongcomp' } ;

klu_src = {
    '../Source/klu_l_free_symbolic', ...
    '../Source/klu_l_defaults', ...
    '../Source/klu_l_analyze_given', ...
    '../Source/klu_l_analyze', ...
    '../Source/klu_l_memory' } ;

if (with_cholmod)
    klu_src = [klu_src { '../User/klu_l_cholmod' }] ;                       %#ok
end

klu_zlsrc = {
    '../Source/klu_zl', ...
    '../Source/klu_zl_kernel', ...
    '../Source/klu_zl_dump', ...
    '../Source/klu_zl_factor', ...
    '../Source/klu_zl_free_numeric', ...
    '../Source/klu_zl_solve', ...
    '../Source/klu_zl_scale', ...
    '../Source/klu_zl_refactor', ...
    '../Source/klu_zl_tsolve', ...
    '../Source/klu_zl_diagnostics', ...
    '../Source/klu_zl_sort', ...
    '../Source/klu_zl_extract', ...
    } ;

klu_lsrc = {
    '../Source/klu_l', ...
    '../Source/klu_l_kernel', ...
    '../Source/klu_l_dump', ...
    '../Source/klu_l_factor', ...
    '../Source/klu_l_free_numeric', ...
    '../Source/klu_l_solve', ...
    '../Source/klu_l_scale', ...
    '../Source/klu_l_refactor', ...
    '../Source/klu_l_tsolve', ...
    '../Source/klu_l_diagnostics', ...
    '../Source/klu_l_sort', ...
    '../Source/klu_l_extract', ...
    } ;

try
    % ispc does not appear in MATLAB 5.3
    pc = ispc ;
catch
    % if ispc fails, assume we are on a Windows PC if it's not unix
    pc = ~isunix ;
end

if (pc)
    obj_extension = '.obj' ;
else
    obj_extension = '.o' ;
end

% compile each library source file
obj = ' ' ;

source = [suitesparse_src amd_src btf_src klu_src colamd_src] ;
if (with_cholmod)
    source = [ccolamd_src camd_src cholmod_src source] ;
end
source = [source klu_zlsrc] ;
source = [source klu_lsrc] ;

for f = source
    ff = f {1} ;
    slash = strfind (ff, '/') ;
    if (isempty (slash))
        slash = 1 ;
    else
        slash = slash (end) + 1 ;
    end
    o = ff (slash:end) ;
    % fprintf ('%s\n', o) ;
    o = [o obj_extension] ;
    obj = [obj  ' ' o] ;					            %#ok
    s = sprintf ('mex %s -O %s -c %s.c', d, include, ff) ;
    kk = do_cmd (s, kk, details) ;
end

% compile the KLU mexFunction
s = sprintf ('mex %s -O %s -output klu klu_mex.c', d, include) ;
s = [s obj] ;                                                               %#ok

if (~(ispc || ismac))
    % for POSIX timing routine
    s = [s ' -lrt'] ;
end

kk = do_cmd (s, kk, details) ;

% clean up
s = ['delete ' obj] ;
do_cmd (s, kk, details) ;

fprintf ('\nKLU successfully compiled\n') ;

%-------------------------------------------------------------------------------

function rmfile (file)
% rmfile:  delete a file, but only if it exists
if (length (dir (file)) > 0)                                                %#ok
    delete (file) ;
end

%-------------------------------------------------------------------------------
function kk = do_cmd (s, kk, details)
%DO_CMD: evaluate a command, and either print it or print a "."
if (details)
    fprintf ('%s\n', s) ;
else
    if (mod (kk, 60) == 0)
        fprintf ('\n') ;
    end
    kk = kk + 1 ;
    fprintf ('.') ;
end
eval (s) ;

