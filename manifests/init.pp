# @summary (Un-) Installs NVIDIA package repositories.
#
# Installs all known NVIDIA repositories, which is at the moment only the CUDA
# repository which provides CUDA tools and appropriate drivers.
#
# @param repo_dir The directory where to install the repository files, ie
#                 "/etc/yum.repos.d" for RedHat-based systems.
# @param repo_owner The name or UID of the owning user of the repository files.
# @param repo_group The name or UID of the owning group of the repository files.
# @param key_dir The directory where the key should be installed. This is only
#                used on RedHat-based systems.
# @param key_prefix An additional prefix string that is added before the
#                   name of the key file. This is only used on RedHat-based
#                   systems and should be something like "RPM-GPG-KEY-".
# @param ensure Determines whether the repositories should be present or absent.
#               This defaults to "present".
#
# @author Christoph Müller
class nvdarepo(
        String $repo_dir,
        Variant[String, Integer] $repo_owner,
        Variant[String, Integer] $repo_group,
        String $key_dir,
        String $key_prefix,
        String $ensure = present) {

    nvdarepo::cuda { 'nvidia-cuda':
        repo_dir => $repo_dir,
        repo_owner => $repo_owner,
        key_dir => $key_dir,
        key_prefix => $key_prefix,
        ensure => $ensure
    }

}