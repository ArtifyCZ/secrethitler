from setuptools import setup
import secretHitler as src

setup(
    name='SecretHitler',
    version=src.__version__,
    description='Python Distribution Utilities',
    author=src.__author__,
    author_email=src.__email__,
    # url='https://www.python.org/sigs/distutils-sig/',
    packages=['secretHitler'],
    install_requires=[
        "requests",
        "gql[requests]"
    ],
    extras_require={
        "dev": [
            "pycodestyle",
            "sphinx",
            "sphinx-rtd-theme",
            "sphinx-rtd-dark-mode"
        ]
    }
)
