project('pyRemapping', ['c', 'fortran'],
  version: '1.2.4',
  default_options: [
    'buildtype=release',
    'warning_level=0',
    'fortran_std=legacy',
  ],
)

py = import('python').find_installation(pure: false)
py_dep = py.dependency()

# Locate numpy and f2py include directories at configure time
incdir_numpy = run_command(py,
  ['-c', 'import numpy; print(numpy.get_include())'],
  check: true,
).stdout().strip()

incdir_f2py = run_command(py,
  ['-c', 'import numpy.f2py; print(numpy.f2py.get_include())'],
  check: true,
).stdout().strip()

numpy_inc = include_directories(incdir_numpy)
f2py_inc  = include_directories(incdir_f2py)

# Fortran flags matching the original Makefile
add_project_arguments(
  [
    '-fdefault-real-8',
    '-fno-second-underscore',
    '-fbacktrace',
    '-fno-align-commons',
    '-fbounds-check',
  ],
  language: 'fortran',
)

# Header/module include paths required by MOM6 sources
fortran_inc = include_directories(
  '../MOM6/config_src/memory/dynamic_symmetric',
  '../MOM6/src/framework',
)

# All supporting Fortran sources (deduplicated from Makefile SRCS)
remap_srcs = files(
  'MOM_io.F90',
  'MOM_error_handler.F90',
  '../MOM6/src/ALE/polynomial_functions.F90',
  '../MOM6/src/framework/MOM_string_functions.F90',
  '../MOM6/src/ALE/regrid_solvers.F90',
  '../MOM6/src/ALE/regrid_edge_values.F90',
  '../MOM6/src/ALE/regrid_consts.F90',
  '../MOM6/src/ALE/P1M_functions.F90',
  '../MOM6/src/ALE/PCM_functions.F90',
  '../MOM6/src/ALE/P3M_functions.F90',
  '../MOM6/src/ALE/PLM_functions.F90',
  '../MOM6/src/ALE/PPM_functions.F90',
  '../MOM6/src/ALE/PQM_functions.F90',
  '../MOM6/src/ALE/regrid_interp.F90',
  '../MOM6/src/ALE/MOM_remapping.F90',
)

# Generate the f2py C and Fortran wrapper sources from the interface file
remap_f2py = custom_target('remap_f2py',
  input: 'remap.f90',
  output: ['remapmodule.c', 'remap-f2pywrappers2.f90'],
  command: [
    py, '-m', 'numpy.f2py',
    '@INPUT@',
    '-m', 'remap',
    '--lower',
    '--build-dir', '@OUTDIR@',
  ],
)

# Build the Python extension module
py.extension_module('remap',
  sources: [remap_f2py, incdir_f2py / 'fortranobject.c', 'remap.f90'] + remap_srcs,
  include_directories: [numpy_inc, f2py_inc, fortran_inc],
  dependencies: [py_dep],
  install: true,
)
