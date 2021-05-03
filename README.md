# nvdarepo
The nvdarepo module installs NVIDIA repository sources that in turn enable the installation of CUDA tools and drivers via the package manager.

## Table of Contents
1. [Description](#description)
1. [Setup – The basics of getting started with nvdarepo](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nvdarepo](#beginning-with-nvdarepo)
1. [Usage – Configuration options and additional functionality](#usage)
1. [Limitations – OS compatibility, etc.](#limitations)
1. [Development – Guide for contributing to the module](#development)

## Description
This module installs the NVIDIA CUDA repository to RedHad-based systems, which provides packages for CUDA tooling, CUDA libraries and NVIDIA's proprietary drivers.

## Setup
### Setup Requirements
This module requires `puppet-yum` being installed.

### Beginning with nvdarepo
Just add `include ndvarepo` to add all configured repositories at their default location.

## Usage
Using `include nvdarepo` should be sufficient to achive everything this module supports. Currently, only the CUDA repository is installed, which can be installed separately via `include nvdarepo::cuda` to make sure that no other repositories get installed if additional ones are added in future version.

If the automatic computation of the repository properties does not work, it is best customising the behaviour of the module via Hiera. Most notably, the automatically computed repository URLs of the CUDA repository depend on the following parameters:

| Name                                | Description | Default |
| ----------------------------------- | ------------| --------|
| `nvdarepo::cuda::base_url`          | The base URL where all OS-dependent subdirectories are located. | https://developer.download.nvidia.com/compute/cuda/repos |
| `nvdarepo::cuda::key_src`           | The URL of NVIDIA's GPG key. | https://developer.download.nvidia.com/compute/cuda/repos/7fa2af80.pub |
| `nvdarepo::cuda::key_id`            | The ID of NVIDIA's GPG key. | 0xF60F4B3D7FA2AF80 |
| `nvdarepo::cuda::version_field`     | The OS version fact used to compose the repository URL. | major |
| `nvdarepo::cuda::distro_override`   | Forces the specified distribution name instead of the OS name fact to be used in the repository URL. | rhel or fedora, respectively |
| `nvdarepo::cuda::repo_src_override` | Overrides the whole repository URL. Nothing will be computed automatically. | false |

Furthermore, the following parameters can be used to configure the local behaviour of the module, i.e. where the repository file is stored:

| Name                         | Description                                                  | Default          |
| -----------------------------| ------------------------------------------------------------ | ---------------- |
| `nvdarepo::cuda::repo_dir`   | The directory where the repository files are stored.         | /etc/yum.repos.d |
| `nvdarepo::cuda::repo_ext`   | The file name extension of the repostiry files.              | .repo            |
| `nvdarepo::cuda::repo_owner` | User name or ID of the owner of the repository file.         | root             |
| `nvdarepo::cuda::repo_group` | Group name or ID of the owning group of the repository file. | root             |
| `nvdarepo::cuda::key_dir`    | The directory where the GPG keys are stored.                 | /etc/pki/rpm-gpg |
| `nvdarepo::cuda::key_prefix` | A prefix that is prepended to the GPG key file.              | RPM-GPG-KEY-     |



## Limitations
Only distributions listed in `metadata.json` are supported.

## Development
Open a pull request on [GitHub](https://github.com/UniStuttgart-VISUS/visus-nvdarepo).
