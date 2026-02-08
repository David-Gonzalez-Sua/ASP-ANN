# Created by Chat-GPT

import platform
import sys
import subprocess
import pkg_resources


def system_info():
    print("=== SYSTEM INFO ===")
    print("OS:", platform.system(), platform.release())
    print("Machine:", platform.machine())
    print("Processor:", platform.processor())
    print("Python version:", sys.version)
    print("Python executable:", sys.executable)
    print()


def python_packages():
    print("=== INSTALLED PACKAGES ===")
    packages = sorted([(d.project_name, d.version) for d in pkg_resources.working_set])

    for name, version in packages:
        print(f"{name}=={version}")

    print()


def clingo_info():
    print("=== CLINGO INFO ===")
    try:
        result = subprocess.run(["clingo", "--version"], capture_output=True, text=True)
        print(result.stdout)
    except FileNotFoundError:
        print("Clingo not found in PATH")
    print()


def gpu_info():
    print("=== GPU INFO ===")
    try:
        result = subprocess.run(["nvidia-smi"], capture_output=True, text=True)
        print(result.stdout)
    except:
        print("No NVIDIA GPU or nvidia-smi not installed")
    print()


if __name__ == "__main__":
    system_info()
    clingo_info()
    gpu_info()
    python_packages()