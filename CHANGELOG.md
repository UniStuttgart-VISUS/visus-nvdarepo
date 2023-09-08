# Changelog
All notable changes to this project will be documented in this file.

## Release 0.1.0
* Initial release of the module.

## Release 0.1.1
* Updated documentation.

## Release 0.1.2
* Adapted location from where GPG keys are downloaded.
* Source of GPG key can now be fully overriden via key_src_override.

## Release 0.1.3
* Installation of GPG key is now mandatory.
* Added ordered_install feature to allow for automating the installation of CUDA along with the DKMS-variant of the driver as described on NVIDIA's website.
* Updated documentation.

## Release 0.1.4
* Updated documentation.

## Release 0.1.5
* Added the option to disable conflicting repositories, notably rpmfusion-nonfree on Fedora.
* Updated NVIDIA's repository keys to be installed.

## Release 0.1.6
* Added the option to write environment modules for CUDA versions being installed.

## Release 0.1.7
* Fix generation of module files.

## Release 0.1.8
* Added the ability to have ordered_install remove conflicting packages from other sources.