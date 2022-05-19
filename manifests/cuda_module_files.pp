# @summary (Un-) Installs a module file for making specific CUDA versions
#          available on demand.
#
# This is a utility type that can be used by administrators to create module
# files for installed CUDA versions. This allows end users to use the module
# enviroment to switch between different versions of CUDA as necessary.
#
# @param packages The hash from the ordered_install, which is used to filter
#                 CUDA packages and create the module files for them.
# @param ensure Indicates whether the module file should be written or
#               removed. This defaults to 'present'.
# @param module_dir The directory receiving the module file. This parameter
#                   defaults to '/etc/modulefiles'.
# @param install_dir The directory where CUDA is assumed to be installed. If
#                    a specific version is selected, this version is suffixed
#                    to this path, wherefore it should not be terminated with
#                    a directory separator. This parameter defaults to
#                    '/usr/local/cuda'.
# @param system_version The version string used for the default current version
#                       of CUDA. This parameter defaults to 'system'.
#
# @author Christoph Müller
define nvdarepo::cuda_module_files(
        Hash $packages,
        String $ensure = present,
        Array[String] $module_packages = [ 'environment-modules' ],
        String $module_dir = '/etc/modulefiles',
        String $install_dir = '/usr/local/cuda',
        String $system_version = 'system',
        ) {

    # Make sure that environment modules are installed.
    if ($ensure == present) {
        ensure_packages($module_packages)
    }

    # Make sure that the module directory exists.
    file { "${$module_dir}":
        ensure => if ($ensures == present) { directory },
        owner => root,
        group => root,
        mode => '0644',
    }

    file { "${$module_dir}/cuda":
        ensure => if ($ensure == present) { directory } else { absent },
        owner => root,
        group => root,
        mode => '0644',
    }

    # Install module files for all requested versions of CUDA.
    # The regex is a bit shaky ...
    $packages.each | String $package, Hash $attributes | {
        if ($attributes[name] =~ /^cuda(-[0-9]*-[0-9]*)*$/) {
            # Determine the CUDA version as identified by the module file.
            $version = if ($attributes[name] =~ /^cuda-([0-9]+)-([0-9]+)$/) {
                "${1}.${2}"

            } elsif ($attributes[name] =~ /^cuda-([0-9]+)$/) {
                $1
            }

            # Determine the CUDA version as used in the module name.
            $module_version = if ($version) {
                $version
            } else {
                $system_version
            }

            # Determine the CUDA installation path.
            $root_path = if ($version) {
                "${install_dir}-${version}"
            } else {
                $install_dir
            }

            # Create the module file from the EPP template.
            notify { "${$module_dir}/cuda/${module_version}": }
            file { "${$module_dir}/cuda/${module_version}":
                ensure => if ($ensure == present) { file } else { absent },
                owner => root,
                group => root,
                mode => '0644',
                content => epp('nvdarepo/cuda_module_file.epp', {
                    root => $root_path,
                    version => $version
                })
            }
        }
    }
}
