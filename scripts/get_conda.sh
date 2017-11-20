# This will get the appropriate conda environment make sure
# to put this in the install step of the CI

sudo apt-get update
# We do this conditionally because it saves us some downloading if the
# version is the same.
if [[ "$TRAVIS_PYTHON_VERSION" == "2.7" ]]; then
    wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh;
else
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
fi
bash miniconda.sh -b -p $HOME/miniconda
export PATH="$HOME/miniconda/bin:$PATH"
hash -r
conda config --set always_yes yes --set changeps1 no
conda update -q conda

# Useful for debugging any issues with conda
conda info -a

# creating the conda environment
conda create -f env scripts/notebooks.yml

# activating the environment
source activate notebooks
