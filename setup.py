import os
import pathlib
import platform
import subprocess
import sys
from setuptools import setup
from setuptools import Extension
from setuptools.command.build_ext import build_ext

MODULE_NAME = 'LingmoUIPy'


class CMakeExtension(Extension):
    """
    自定义了 Extension 类，忽略原来的 sources、libraries 等参数，交给 CMake 来处理这些事情
    """

    def __init__(self, name: str, sourcedir: str = ""):
        super().__init__(name, sources=[])
        self.sourcedir = os.fspath(pathlib.Path(sourcedir).resolve())


class BuildExt(build_ext):
    """
    自定义了 build_ext 类，对 CMakeExtension 的实例，调用 CMake 和 Make 命令来编译它们
    """

    def build_extension(self, ext: CMakeExtension) -> None:
        cwd = pathlib.Path().absolute()

        build_temp = f"{pathlib.Path(self.build_temp)}/{ext.name}"
        os.makedirs(build_temp, exist_ok=True)

        # Must be in this form due to bug in .resolve() only fixed in Python 3.10+
        ext_fullpath = pathlib.Path.cwd() / self.get_ext_fullpath(ext.name)
        extdir = ext_fullpath.parent.resolve() / MODULE_NAME

        debug = int(os.environ.get("DEBUG", 0)
                    ) if self.debug is None else self.debug
        config = "Debug" if debug else "Release"

        cmake_args = [
            "-S", str(cwd),
            "-B", str(build_temp),
            "-DBUILD_PYTHON=ON",
            "-DCMAKE_CXX_FLAGS_INIT:STRING=",
            "-DCMAKE_GENERATOR:STRING=Ninja",
            "-DCMAKE_BUILD_TYPE:STRING=" + config,
            "-DCMAKE_INSTALL_PREFIX:PATH=" + str(extdir),
        ]
        
        # 如果是Windows，强制使用CL.exe 作为C_compiler
        if platform.system() == "Windows":
            cmake_args += [
                "-DCMAKE_C_COMPILER=cl.exe",
                "-DCMAKE_CXX_COMPILER=cl.exe",
            ]

        build_args = [
            "--config", config,
            "--", "-j8"
        ]

        env = os.environ.copy()  # 获取当前环境变量副本
        subprocess.run(["cmake"] + cmake_args, check=True, env=env)
        if not self.dry_run:
            subprocess.run(["cmake", "--build", str(build_temp)
                            ] + build_args, check=True, env=env)
            subprocess.run(
                ["cmake", "--install", str(build_temp)], check=True, env=env)


lingmoui = CMakeExtension("LingmoUI")

setup(name="LingmoUIPy",
      version="3.0",
      description="This is LingmoUI for Python",
      ext_modules=[lingmoui],  # mymath 现在是 CMakeExtension 类的实例了
      packages=['LingmoUIPy'],
      cmdclass={"build_ext": BuildExt},  # 使用自定义的 build_ext 类
      install_requires=[
          "pyside6>=6.7.3",
      ],
      )
