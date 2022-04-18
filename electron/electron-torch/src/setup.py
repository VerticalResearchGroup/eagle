from setuptools import setup
from torch.utils.cpp_extension import BuildExtension, CppExtension

setup(
    name='electron_torch',
    ext_modules=[
        CppExtension(
            '_ELECC',
            torch_electron_sources,
            include_dirs=include_dirs,
            extra_compile_args=extra_compile_args,
            library_dirs=library_dirs,
            extra_link_args=extra_link_args + \
                [make_relative_rpath('electron_torch/lib')],
        ),
    ],
    cmdclass={
        'build_ext': Build,  # Build is a derived class of BuildExtension
    }
    # more configs...
)