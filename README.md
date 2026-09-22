# BIOI_500_Benchmarking_Project
## Initial repo setup
#### First, clone the repo into your machine and navigate into the project directory. 
```
git clone https://github.com/carolynhicks6/BIOI_500_Benchmarking_Project.git
cd BIOI_500_Benchmarking_Project/
```
## Creating conda environment and installing packages: AutoDock Vina and rDock
#### Create a conda environment with the following command, activate the environment, and lastly install packages. 
```
conda create --name docking_pipeline
conda activate docking_pipeline
conda install -c conda-forge meeko
conda install -c conda-forge vina
conda install -c conda-forge rDock
```
#### To deactivate the conda environment, simply run the following command:
```
conda deactivate docking_pipeline
```
## Colab script: GNINA
#### Because GNINA requires GPU, this tool was run on a colab script. A link to the script can be found here:
#### https://colab.research.google.com/github/MolSSI-Education/iqb-2025/blob/main/04_Cheminfo_crash_course.ipynb 

 
