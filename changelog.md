## 1.1.0 (2015-06-15)

Features:

  - test support (out-of-the-box RSpec, other frameworks with sandboxing)
  - new plugin structure (old structure supported as well)

## 1.0.2 (2015-05-27)

Features:

  - new command line argument --version, -v prints version number

Bugfixes:

  - Fix an issue that complains about plugin being nil while executing

## 1.0.1 (2015-05-06)

Features:

  - support ERB (embedded Ruby) in Hoogfile.yml
  - support multiple plugin directories
  - support for specific plugin/hookin configurations

Bugfixes:

  - fix githoog install by requiring 'pathname'

Notes:

  - minimum Ruby version is 2.0
