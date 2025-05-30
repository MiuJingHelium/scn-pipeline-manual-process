## step 1: calculate read lengths
#for step 1
import gzip
import sys
from collections import Counter
from pathlib import Path
# for step 2
import subprocess
# for step 3
import shutil


args = sys.argv
SRR = sys.argv[1]
fastq_path = sys.argv[2]
whitelist_file = sys.argv[3]

def read_lengths(fq_path, num_reads=10000):
    lengths = []
    open_fn = gzip.open if fq_path.suffix == '.gz' else open
    with open_fn(fq_path, 'rt') as f:
        for i, line in enumerate(f):
            if i % 4 == 1:  # Sequence line
                lengths.append(len(line.strip()))
                if len(lengths) >= num_reads:
                    break
    count = Counter(lengths)
    print(f"{fq_path.name}: {count.most_common(3)}")


for fq_file in fastq_path.glob("*fastq*"):
    read_lengths(fq_file)

with open(whitelist_file) as f:
    bc_length = len(f.readline().strip('\n'))

## step 2: trim sequence length if necessary

# trim _R1.fastq (move original copy to a subdirectory)

R1_file = fastq_path.glob("*_1.fastq*")


#Name output file
# credit: https://github.com/alexkychen/FASTQ_tools/blob/master/B1_trim.py
# 
outfile_name=R1_file.rstrip('.fastq.gz')+'_'+bc_length+'.fastq.gz'

trim_command = "cutadapt -l " + bc_length + " -o "+ outfile_name + " " + R1_file
subprocess.run(trim_command, capture_output=True, shell=True)

command = "cd "+ fastq_path + "; mkdir untrimmed_R1; mv " + R1_file + " untrimmed_R1/"
subprocess.run(command, shell=True)

## step 3: rename files

# may provide expected structure as an argument

expected_structure = {
    'R1': (26, 30),
    'R2': (90, 200),
    'I1': (8, 16),
    'I2': (8, 16),
}

def match_read_type(length):
    for read, (min_len, max_len) in expected_structure.items():
        if min_len <= length <= max_len:
            return read
    return None

renamed = {}

for fq_file in fastq_path.glob("*fastq*"):
    lengths = []
    open_fn = gzip.open if fq_file.suffix == '.gz' else open
    with open_fn(fq_file, 'rt') as f:
        for i, line in enumerate(f):
            if i % 4 == 1:
                lengths.append(len(line.strip()))
                if len(lengths) >= 1000:
                    break
    most_common = Counter(lengths).most_common(1)[0][0]
    read_type = match_read_type(most_common)
    if read_type:
        new_name = fq_file.parent / f"{SRR}_S1_L001_{read_type}_001.fastq.gz"
        renamed[fq_file.name] = new_name.name
        shutil.copy(fq_file, new_name)

print("Renamed files:")
for old, new in renamed.items():
    print(f"{old} → {new}")

# 