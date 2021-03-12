# A Lineage reconstruction method for DREAM challenge
This is team Jasper06's submission to [Allen Institute Cell Lineage Reconstruction DREAM Challenge](https://www.synapse.org/#!Synapse:syn20692755/wiki/595096)

## Method description
We used probability-based hierarchical clustering to reconstruct the cell lineage tree. In short, the transition rate of the initial state to altered states are derived using the ground truth. Next, we derived the probability of cells arising from different parents using transition rates. Then, the pairwise cell distance is calculated using the probability. Finally, we used hierarchical clustering (UPGMA) to reconstruct the cell lineage.

<image src="schematic.png">

## Usage

### Download data
This repository only provides 1 example dataset from each subchallenge. Download the complete dataset from [here](https://www.synapse.org/#!Synapse:syn20692755/files/).

Running this lineage reconstruction algorithm takes the exact 4 steps for each subchallenge. 

### Step 1: 
Use Jupyter notebook to run `01_mutation_summary.ipynb`

### Step 2: Derive mutation rate
`Rscript 02_mutation_rate.R`

### Step 3: Use probability-based hierarchical clustering to reconstruct lineage tree
Use Jupyter notebook to run `03_probability_HC.ipynb`

### Step 4: Evaluate reconstruction result by calculating the RF score and Triplet score
`Rscript 04_evaluation.R`


