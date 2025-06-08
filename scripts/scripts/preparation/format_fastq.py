# I want to give up
## step 1: calculate read lengths
#for step 1
import gzip
import sys
import glob
from collections import Counter
from pathlib import Path
# for step 2
import subprocess
# for step 3
import shutil
import os

# try arg.parse
args = sys.argv
SRR = sys.argv[1]
fastq_path = sys.argv[2]
chemistry = sys.argv[3]

def read_lengths(fq_path, num_reads=10000):
    lengths = []
    open_fn = gzip.open if fq_path.endswith('.gz') else open
    with open_fn(fq_path, 'rt') as f:
        for i, line in enumerate(f):
            if i % 4 == 1:  # Sequence line
                lengths.append(len(line.strip()))
                if len(lengths) >= num_reads:
                    break
    count = Counter(lengths)
    print(f"{fq_path}: {count.most_common(3)}")
    return count


print(fastq_path)
fq_files = glob.glob(fastq_path + "*fastq*")
# fq_files = [fastq_path + f for f in os.listdir(fastq_path)]

fq_length = [read_lengths(fq_file) for fq_file in fq_files] 
# instead of array; a dictionary may be needed
# possible solution: 1) rank files by alphabetical and numerical order
# 2) assign numeric read length
# 3) reoder based on both read length and alphabetical order
# extract R1 and perfor renaming using the dictionary


# trim _R1.fastq (move original copy to a subdirectory)

R1_file = str(glob.glob(fastq_path + "*_1.fastq*")) # R1 may be actually files with "_2" depending on the uploader. 
print(R1_file)

if chemistry == "v2":
    R1_length = 26
else if chemistry == "v3":
    R1_length = 28
else:
    raise Exception("Only v2 and v3 supported. Provided chemistry unrecognized.")

#Name output file
# credit: https://github.com/alexkychen/FASTQ_tools/blob/master/B1_trim.py
# 

if 
outfile_name=R1_file.rstrip('.fastq.gz')+ '_' + str(R1_length) +'.fastq.gz'

trim_command = "cutadapt -l " + str(R1_length) + " -o "+ outfile_name + " " + R1_file
subprocess.run(trim_command, capture_output=True, shell=True)

#command = "cd "+ fastq_path + "; mkdir untrimmed_R1; mv " + R1_file + " untrimmed_R1/"
#subprocess.run(command, shell=True)

## step 3: rename files

# may provide expected structure as an argument
# ChatGPT code requires debugging
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

for fq_file in fq_files: #note attribute errors
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