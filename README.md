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
| `nvdarepo::cuda::key_file_name`     | The name of the GPG key file. This file will be searched in the individual repository directory. | 7fa2af80.pub |
| `nvdarepo::cuda::key_id`            | The ID of NVIDIA's GPG key. | 0xF60F4B3D7FA2AF80 |
| `nvdarepo::cuda::version_field`     | The OS version fact used to compose the repository URL. | major |
| `nvdarepo::cuda::distro_override`   | Forces the specified distribution name instead of the OS name fact to be used in the repository URL. | rhel or fedora, respectively |
| `nvdarepo::cuda::repo_src_override` | Overrides the whole repository URL. Nothing will be computed automatically. | false |
| `nvdarepo::cuda::key_src_override`  | Overrides the whole URL of the GPG key. Nothing will be computed automatically. | false |

Furthermore, the following parameters can be used to configure the local behaviour of the module, i.e. where the repository file is stored:

| Name                         | Description                                                  | Default          |
| -----------------------------| ------------------------------------------------------------ | ---------------- |
| `nvdarepo::cuda::repo_dir`   | The directory where the repository files are stored.         | /etc/yum.repos.d |
| `nvdarepo::cuda::repo_ext`   | The file name extension of the repostiry files.              | .repo            |
| `nvdarepo::cuda::repo_owner` | User name or ID of the owner of the repository file.         | root             |
| `nvdarepo::cuda::repo_group` | Group name or ID of the owning group of the repository file. | root             |
| `nvdarepo::cuda::key_dir`    | The directory where the GPG keys are stored.                 | /etc/pki/rpm-gpg |
| `nvdarepo::cuda::key_prefix` | A prefix that is prepended to the GPG key file.              | RPM-GPG-KEY-     |

### Installing CUDA
[NVIDIA's instructions](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) for installing CUDA suggest a specific order in which packages are to be installed. As of now, if this order is not followed, the DKMS driver packages cannot be installed, because the CUDA package installed different ones. This module provides the defined resource type `nvdarepo::ordered_install` to help with this problem. `nvdarepo::ordered_install` allows you to specify a specific order of packages by means of lexical order, which will be translated into Puppet dependencies by the defined resource type. It is a reasonable approach to use numbers to establish this lexical order. For instance, you could do something like this

```puppet
class profile::cuda(Hash $packages) {
    # Ensure that NVIDIA repositories are present.
    require nvdarepo

    # Make sure that dependencies for building the kernel module are present.
    ensure_packages([ 'gcc', 'epel-release', 'kernel-devel' ] )

    # Install packages configured via Hiera.
    nvdarepo::ordered_install { 'cuda':
        packages => $packages
    }

    # Make sure that NVIDIA module is installed.
    ~> exec { '/usr/sbin/dkms autoinstall -m nvidia': }    
}
```

and specify the packages and their order in Hiera as

```yaml
profile::cuda::packages:
  00-nvidia-driver-latest-dkms:
    name: nvidia-driver-latest-dkms
    ensure: installed
  01-cuda:
    name: cuda
    ensure: installed
  02-cuda-drivers:
    name: cuda-drivers
    ensure: installed
  03-libcudnn8-devel:
    name: libcudnn8-devel
    ensure: installed
```

## Limitations
Only distributions listed in `metadata.json` are supported.

## Development
Open a pull request on [GitHub](https://github.com/UniStuttgart-VISUS/visus-nvdarepo).
