# ruby-test-switcher

[![Build Status](https://travis-ci.org/dcarral/atom-ruby-test-switcher.svg?branch=master)](https://travis-ci.org/dcarral/atom-ruby-test-switcher)

__ruby-test-switcher__ is an Atom package which allows you to switch between Ruby source code and test files with a single keystroke:

- Linux: <kbd>ctrl</kbd>-<kbd>shift</kbd>-<kbd>.</kbd>
- OS X:  <kbd>cmd</kbd>-<kbd>ctrl</kbd>-<kbd>.</kbd>

It supports RSpec, minitest and test-unit, both for Rails and non-Rails projects.

Inspired by the awesome [Sublime Text 2 Ruby Tests](https://github.com/maltize/sublime-text-2-ruby-tests) plugin.

## Installation

```
$ apm install ruby-test-switcher
```
Or Settings/Preferences ➔ Install ➔ search for `ruby-test-switcher`

Atom Package: https://atom.io/packages/ruby-test-switcher

## FAQ

### Can't I switch between source code and test files with other packages?

Not at the moment, since:

- [ruby-test](https://atom.io/packages/ruby-test) doesn't have this feature.
- [ruby-quick-test](https://github.com/philnash/ruby-quick-test) doesn't have this feature.
- [Rails RSpec](https://github.com/wangyuhere/atom-rails-rspec) is Rails-dependent (support for non-Rails projects requested in September 2014 [[#3]](https://github.com/wangyuhere/atom-rails-rspec/issues/3))
- [Rails Open Rspec](https://atom.io/packages/rails-open-rspec) is Rails-dependent.

__ruby-test-switcher__ will be supported as a standalone package, thus allowing you to use it along your favorite test runner ;)

Besides that, the idea is to integrate this feature within some of the test runners above. So, ideally you won't need an extra package to switch between code and test files.

## Contributing

- [Pull requests](https://github.com/dcarral/atom-ruby-test-switcher/pulls) (bonus point for topic branches)
- [Issues](https://github.com/dcarral/atom-ruby-test-switcher/issues)
