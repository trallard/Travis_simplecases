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

chmod +x miniconda.sh
./miniconda.sh -b
export PATH=/home/travis/miniconda/bin:$PATH
conda update --yes conda

# Useful for debugging any issues with conda
conda info -a
