# @summary (Un-) Installs the NVIDIA CUDA repository.
#
# This class basically does nothing but instantiating the nvdarepo::repo
# utility. Its main purpose is providing a class to which configuration data
# can be assigned via Hiera.
#
# @param base_url The base URL where NVIDIA's repositories are located. If no
#                 repo_src is provided, the module will construct the URL from
#                 this base URL using the known way NVIDIA is organising their
#                 server.
# @param version_field This parameter determines which of the version facts is
#                      used to automatically construct the URL of the
#                      repository. The parameter defaults to 'major', ie the
#                      major version of the distribution is used to construct
#                      the repository source.
# @param repo_src_override Overrides the generated URL of the repository file
#                          with the specified value. This parameter defaults
#                          to false, which indicates that the repository URL
#                          should be computed automatically.
# @param distro_override Overrides the name in the distribution for the purpose
#                        of generating the repository URL. This value is only
#                        used when repo_src_override is not set. The parameter
#                        defaults to false, which indicates that the OS name
#                        from Puppet facts is used in lower case.
# @param repo_dir The directory where to install the repository file, ie
#                 "/etc/yum.repos.d" for RedHat-based systems.
# @param repo_ext The extension of the repository file, typically ".repo".
# @param repo_owner The name or UID of the owning user of the repository file.
# @param repo_group The name or UID of the owning group of the repository file.
# @param key_id The ID of the GPG key used by the repository.
# @param key_file_name The name of the GPG key file to be installed.
# @param key_src_override Override the full URL of from which the GPG key is
#                         retrieved. Otherwise, the key is searched in the
#                         repository directory.
# @param key_dir The directory where the key should be installed. This is only
#                used on RedHat-based systems.
# @param key_prefix An additional prefix string that is added before the
#                   name of the key file. This is only used on RedHat-based
#                   systems.
# @param ensure Determines whether the repository should be present or absent.
#               This defaults to "present".
#
# @author Christoph Müller
class nvdarepo::cuda(
        String $base_url,
        String $version_field,
        Variant[String, Boolean] $repo_src_override = false,
        Variant[String, Boolean] $distro_override = false,
        String $repo_dir,
        String $repo_ext,
        Variant[String, Integer] $repo_owner,
        Variant[String, Integer] $repo_group,
        String $key_id,
        String $key_file_name,
        Variant[String, Boolean] $key_src_override = false,
        String $key_dir,
        String $key_prefix,
        String $ensure = present) {

    # Use the repo helper to install the CUDA repository.
    nvdarepo::repo { 'nvidia-cuda':
        base_url => $base_url,
        version_field => $version_field,
        repo_src_override => $repo_src_override,
        distro_override => $distro_override,
        repo_dir => $repo_dir,
        repo_ext => $repo_ext,
        repo_owner => $repo_owner,
        repo_group => $repo_group,
        key_id => $key_id,
        key_file_name => $key_file_name,
        key_src_override => $key_src_override,
        key_dir => $key_dir,
        key_prefix => $key_prefix,
        ensure => $ensure
    }

}

