# @summary Installs NVIDIA package repositories.
#
# Installs all known NVIDIA repositories, which is at the moment only the CUDA
# repository which provides CUDA tools and appropriate drivers. This extra class
# is currently only there for future extensibility.
#
# @author Christoph Müller
class nvdarepo {
    include nvdarepo::cuda
}