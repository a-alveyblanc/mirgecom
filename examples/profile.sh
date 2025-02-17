#!/bin/zsh

export PYOPENCL_NO_CACHE=1
export LOOPY_NO_CACHE=1
export POCL_KERNEL_CACHE=0
export CUDA_CACHE_DISABLE=1

export PYOPENCL_CTX=0:1

orders=(1 2 4 5)

ARGS="-l -d 3 -n -b -m -x 1 -e"
SUFFIX="no-unr"
PATTERNS="my_rhs_part_0.*completed|pyopencl.*my_rhs_part_0|walltime|system"
# PATTERNS="walltime|system"

echo "Testing TP cases"
for i in "${orders[@]}"
do
    echo "testing order $i"
    eval "time python -m mpi4py gas-in-box.py $ARGS -y $i -t" 2>&1 | \
        grep -a -E $PATTERNS > processing-and-step-times-$i-$SUFFIX-tp.txt

        cat processing-and-step-times-$i-$SUFFIX-tp.txt
done
echo "done testing TP cases\n"

echo "Testing simplicial cases"
for i in "${orders[@]}"
do
    echo "testing order $i"
    eval "time python -m mpi4py gas-in-box.py $ARGS -y $i" 2>&1 | \
        grep -a -E $PATTERNS > processing-and-step-times-$i-$SUFFIX-smp.txt

        cat processing-and-step-times-$i-$SUFFIX-smp.txt
done
echo "done testing simplicial cases\n"

rm *.vtu *.pvtu *.sqlite
