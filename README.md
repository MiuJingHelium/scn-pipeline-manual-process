
###### MAY 22 2024: 
The original snakemake pipeline is available at https://github.com/clevermx/scn-pipeline. This repo includes (several versions of) scripts that should be able to process GEO dataset in a similar manner for those datasets that failed the automated pipeline. I'll try my best to optimize the pipeline :) and clean up the repo.

The first version and the fourth version have different organization for the pipeline output, where the fourth version is closer to the original snakemake pipeline. I'll remove the first version to a branch later. Although it is no longer used, it may be helpful for troubleshooting the ealier processed datatset in case there are issues with the data quality.
###### Nov 20 2024:
The fourth version finally renamed to "scripts" to prevent bugs. The previous version named as "scripts_prev". The pipeline should be able to run with interaction of the main scripts directly under scripts. The path to all scripts are somewhat harded because the working directory for generating the results are assumed to be one level above "scripts."



