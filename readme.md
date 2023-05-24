Python in Anaconda/Miniconda Container build example
=
The goal of this example is to provide a working example of a dockerfile and associated files that will support python workloads that require Anaconda or Miniconda built from a base Conda container image

This simple Hello World example is provided to assist in containerising python workloads that assume the Conda (Miniconda or Anaconda) runtime. Conda provides support for  multiple environments python environments using the Conda Environments concept, but this can cause issues when used with containers and building docker files can be challenging due to the assumption Conda makes on a single shell instance during setup. This is due to the fact that container builds spawn multiple shell instances with each "RUN" command

This example uses the helpful documentation at https://pythonspeed.com/articles/activate-conda-dockerfile/ 

Setup used
-
- VS Code on Windows
- Docker on Windows
- Docker VS Code extension (from Microsoft)
- Python VS Code extension (from Microsoft)
- Pylint VS Code extension (from Microsoft)
- Flake8 VS Code extension (from Microsoft)

Additional notes & debug tips
-
If using VS Code as development environment, rather than starting development in VS Code, do the following

>- Open Anaconda shell 
>- Create the desired environment using `conda create -n <env-name> python=3.10 flask` or similar using environment.yml
>- Activate the environment with `conda activate <env-name>  
>- Open VS Code from the shell with `code .` command
>- This should ensure that VS Code opens in the correct Conda environment and with the correct runtime assigned (check on bottom right of VS Code gutter when editing a python file to see activated runtime). 

> For more on how VS Code handles python environnments and Conda specifically see https://code.visualstudio.com/docs/python/environments and https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html  

Environment name handling in the dockerfile
-
Note that for easy of undestanding the docker file is using the  hard coded environment creation command `RUN conda create --name condaondocker python=3.10` to create the environment. This approach requires that all the other references to <env-name> match in the script. 

An alternative approach is to build from the environment file with `RUN conda create conda env create --file=environment.yml` however in this approach you muct make sure the environment name in the environment file matches that rfeferred to later in the script (or use reg expressions and env vars to make the env name a variable in the docker file) 

Issues with Requirements install failing in docker image build: 
> - Using `pip freeze > requirements.txt` in your development environment to capture the list of python requirements can lead to the requirements file containing hard coded path links that will break in the docker build with "OSE path not found" type error. 
>- To fix remove the paths from the requirements.txt

Issues with Conda environment related to environment.YAML file failing
> - Issues associated with Conda environment creation failing maybe ude to the fact that the exported environment.yaml file came from local development environment with a slightly different Anaconda/Miniconda setup (as opposed to the yaml from from the docker Anaconda/Miniconda environment
> - Fix use the below steps to export a Conda environment file from the docker environment
> comment out the final ENTRYPOINT command in the docker file (this will produce an image that is ready for interactive shell interrogation)
>  Build the image with the updated docker file
> Run the image in interactive mode `Right click | Run Interactive` if using the VS Code docker extension
> witing the interactive shell of the running image use 
> `conda env export > environment.yml` (if copying from mounted docker volume) or `conda env export` (to copy from shell)
> use the output of this command as the contents of the `environment.yaml` used by your `dockerfile`