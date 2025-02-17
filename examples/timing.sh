#!/bin/zsh

export PYOPENCL_CTX=0:1
export LOOPY_NO_CACHE=1
export PYOPENCL_NO_CACHE=1
export POCL_KERNEL_CACHE=0
export CUDA_CACHE_DISABLE=1

export ARGS="--nsteps 100 -l -d 3 -n -b -m -x 1"
export SUFFIX="nbmx1"

orders=(1 2 4 5)  # skip order = 3 to avoid bad reshape logic

echo "testing TP cases"
for i in "${orders[@]}"
do
    echo "testing order $i"
    eval "python -m mpi4py gas-in-box.py -t -y $i $ARGS" 2>&1 | \
        grep -a "step walltime" > timing/timing-$SUFFIX/tp-timing-d3-p$i-$SUFFIX.txt
    cat timing/timing-$SUFFIX/tp-timing-d3-p$i-$SUFFIX.txt
    echo "done testing with order $i"
done
echo "done testing TP cases\n"


echo "testing smp cases"
for i in "${orders[@]}"
do
    echo "testing order $i"

    eval "python -m mpi4py gas-in-box.py -y $i $ARGS" 2>&1 | \
        grep -a "step walltime" > timing/timing-$SUFFIX/smp-timing-d3-p$i-$SUFFIX.txt

    cat timing/timing-$SUFFIX/smp-timing-d3-p$i-$SUFFIX.txt

    echo "done testing with order $i"
done
echo "done testing smp cases\n"

rm *.pvtu *.vtu *.sqlite*
