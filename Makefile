FC = gfortran
FCFLAGS = -g -c -fdefault-real-8 -fPIC -fno-second-underscore -fbacktrace -fno-align-commons -fbounds-check -std=legacy
LDFLAGS =

MODDIR := .mod
ifneq ($(MODDIR),)
  $(shell test -d $(MODDIR) || mkdir -p $(MODDIR))
  FCFLAGS+= -J $(MODDIR)
endif

SRCS =  MOM_io.F90 MOM_error_handler.F90 ../MOM6/src/ALE/polynomial_functions.F90\
	../MOM6/src/framework/MOM_string_functions.F90\
	../MOM6/src/ALE/regrid_solvers.F90 ../MOM6/src/ALE/regrid_edge_values.F90\
	../MOM6/src/ALE/regrid_consts.F90 ../MOM6/src/ALE/P1M_functions.F90\
	../MOM6/src/ALE/regrid_consts.F90 ../MOM6/src/ALE/PCM_functions.F90\
	../MOM6/src/ALE/regrid_consts.F90 ../MOM6/src/ALE/P3M_functions.F90\
	../MOM6/src/ALE/regrid_consts.F90 ../MOM6/src/ALE/PLM_functions.F90\
	../MOM6/src/ALE/regrid_consts.F90 ../MOM6/src/ALE/PPM_functions.F90\
	../MOM6/src/ALE/regrid_consts.F90 ../MOM6/src/ALE/PQM_functions.F90\
	../MOM6/src/ALE/regrid_interp.F90 ../MOM6/src/ALE/MOM_remapping.F90\
        ../MOM6/src/ALE/MOM_remapping.F90


OBJECTS = $(SRCS:.F90=.o)
TARGET = libRemap.a


$(TARGET): $(OBJECTS)
	rm -f $@
	ar cr $@ $^
	python setup.py config_fc --f90flags="-g -c -fdefault-real-8 -fPIC -fno-second-underscore -fbacktrace -fno-align-commons -fbounds-check" --fcompiler=gfortran build
	python setup.py install

%.o: %.F90
	$(FC) $(FCFLAGS) -I ../MOM6/config_src/memory/dynamic_symmetric -I ../MOM6/src/framework -c $< -o $@

test: $(TARGET)
	python test.py

clean:
	 rm -f *.o *.mod *.MOD libRemap.a ../MOM6/src/framework/*.o ../MOM6/src/core/*.o ../MOM6/src/ALE/*.o
