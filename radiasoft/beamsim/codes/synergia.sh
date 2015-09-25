#!/bin/bash
#
# You need 2GB RAM at least or mpicxx will run out of virtual memory
#
# Testing
#     synergia=$(pwd)/install/bin/synergia
#     cd build/synergia2/examples/fodo_simple1
#     LD_LIBRARY_PATH=/usr/lib64/openmpi/lib $synergia fodo_simple1.py
#
#     cd build/synergia2
#     make test
#     Expect:
#         100% tests passed, 0 tests failed out of 177
#         Total Test time (real) = 421.95 sec
#
# Debugging:
#     full clean: git clean -dfx
#     partial clean: rm -rf db/*/chef-libs build/chef-libs
#     ./contract.py
#
# Once bootstrap is installed, you can do this to see what's what:
#     rm -rf config; DEBUG_CONFIG=1 ./contract.py --list-targets

# We can't the stock RPMs from Fedora, because...
#
#     libpng: tries to import libpng.h directly, instead of /usr/include/libpng16/png.h
#
#     NLopt: finds it, but then causes a crash in "else" (!nlopt_internal):
#          File "/home/vagrant/tmp/contract-synergia2/packages/nlopt.py", line 26, in <module>
#            nlopt_lib = Option(local_root,"nlopt/lib",default_lib,str,"NLOPT library directory")
#          NameError: name 'default_lib' is not defined
#
#     fftw3: doesn't work, b/c packages/fftw3.py looks for libfftw3.so, not libfftw3.so.3
#
#     bison: This is bison 3 so incompatible; force to bison_internal
#         xsif_yacc.ypp:158:30: error: ‘yylloc’ was not declared in this scope
#
#     tables: always uses synergia's own tables (see below for bug with that)
#
#     boost-openmpi-devel: when running synergia:
#         ImportError: /lib64/libboost_python.so.1.55.0: undefined symbol: PyUnicodeUCS4_FromEncodedObject
#
# This was happening at one point:
#     fetching https://compacc.fnal.gov/projects/attachments/download/20/tables-2.1.2.tar.gz
#     [...]
#     File "/home/vagrant/.pyenv/versions/2.7.10/lib/python2.7/ssl.py", line 808, in do_handshake
#       self._sslobj.do_handshake()
#     IOError: [Errno socket error] [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed (_ssl.c:590)
#
# So copied to apa11, download the file and install in depot/foss
#     wget --no-check-certificate https://compacc.fnal.gov/projects/attachments/download/20/tables-2.1.2.tar.gz
#     chmod 444 tables-2.1.2.tar.gz
#     perl -pi -e 's{https://compacc.fnal.gov/projects/attachments/download/20}{https://depot.radiasoft.org/foss}' packages/pytables_pkg.py
#
# The "git clone --depth 1" doesn't work in this case:
#     fatal: dumb http transport does not support --depth

codes_dependencies mpi4py
codes_yum install flex cmake eigen3-devel glib2-devel
pip install pyparsing nose
git clone -q http://cdcvs.fnal.gov/projects/contract-synergia2
cd contract-synergia2
git checkout -b devel origin/devel
./bootstrap

# declare as function so can use local vars
synergia_configure() {
    # Turn off parallel make
    local f
    local -a x=()
    local cpus=2
    for f in bison chef-libs fftw3 freeglut libpng nlopt qutexmlrpc qwt synergia2; do
        x+=( "$f"/make_use_custom_parallel=1 "$f"/make_custom_parallel="$cpus")
    done
    for f in bison fftw3 libpng nlopt; do
        x+=( "$f"_internal=1 )
    done
    x+=(
        #NOT in master: boost/parallel="$cpus"
        chef-libs/repo=https://github.com/radiasoft/accelerator-modeling-chef.git
        #chef-libs/branch=5277ecbbdec02e9394eca4e079a651053b6a0ab4
        chef-libs/branch=radiasoft-devel
    )
    ./contract.py --configure "${x[@]}"
}
synergia_configure
unset -f synergia_configure

./contract.py

synergia_install() {
    # openmpi should be added automatically (/etc/ld.so.conf.d), but there's
    # a conflict with hdf5, which has same library name as in /usr/lib64 as in
    # /usr/lib64/openmpi/lib.
    perl -pi -e 's{(?=ldpathadd ")}{ldpathadd /usr/lib64/openmpi/lib\n}s' install/bin/synergia
    local d=$(python -c 'import sys; sys.stdout.write(sys.executable)')
    d=$(dirname "$(dirname "$d")")
    (cd install && cp -a bin include lib "$d")
    return $?
}
synergia_install
unset -f synergia_install