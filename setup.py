from setuptools import setup

import sitebaker

setup(
    name = 'SiteBaker',
    version = sitebaker.__version__,
    description = 'SiteBaker',
    license = 'Apache',
    url = 'http://todo',
    author = 'Jason R Briggs',
    author_email =  'jasonrbriggs@gmail.com',
    platforms = ['any'],
    packages = ['sitebaker', 'sitebaker.plugins' ],
    install_requires = ['Markdown>=2.2.0', 'proton>=0.7.2'],
    tests_require = [ 'mock' ],
    test_suite = 'tests',
    scripts = [ './baker' ]
)
