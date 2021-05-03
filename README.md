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
Include usage examples for common use cases in the **Usage** section. Show your
users how to use your module to solve problems, and be sure to include code
examples. Include three to five examples of the most important or common tasks a
user can accomplish with your module. Show users how to accomplish more complex
tasks that involve different types, classes, and functions working in tandem.

## Limitations
Only distributions listed in `metadata.json` are supported.

## Development
Open a pull request on [GitHub](https://github.com/UniStuttgart-VISUS/visus-nvdarepo).
