WD=$1
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa"
cd $WD
LEVEL="dataset"
PATTERN="GSE222007"
DATASET="GSE222007"
SAMPLE="holder"
DESC="info/GSE222007_description.txt"
LINK="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE198835"
TOKEN="GSE222007"
SPEC="hs"
#mkdir -p outs/R_outs/revPCA/


 LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -J R_makeup -n 8 -M 96GB -o R_makeup.out \
	-e R_makeup.err -R 'select[mem>64MB] rusage[mem=96GB] span[hosts=1]' \
        -a "docker(kalisaz/scrna-extra:r4.3.0)" /bin/bash -c \
	"scripts/R_steps/R_merge_wrapper.sh `pwd` $DATASET"
# $LEVEL $PATTERN $DATASET $SAMPLE $DESC $LINK $TOKEN $SPEC