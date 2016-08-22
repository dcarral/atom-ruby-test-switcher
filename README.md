# [ruby-test-switcher](https://atom.io/packages/ruby-test-switcher) [![Build status](https://travis-ci.org/dcarral/atom-ruby-test-switcher.svg?branch=master)](https://travis-ci.org/dcarral/atom-ruby-test-switcher) [![Dependencies status](https://david-dm.org/dcarral/atom-ruby-test-switcher.svg)](https://david-dm.org/dcarral/atom-ruby-test-switcher)

__ruby-test-switcher__ is an Atom package to switch between Ruby source code and test files with a single keystroke.

It supports _RSpec_, _minitest_ and _test-unit_, both in _Rails_ and non-_Rails_ projects.

## Usage

By default, available key bindings are:

- Switch in active pane: <kbd>alt</kbd>-<kbd>r</kbd>

  Switch to target file, in the same pane. *

- Switch splitting panes: <kbd>alt</kbd>-<kbd>shift</kbd>-<kbd>r</kbd>

  Switch to target file, in different pane (if needed). Source files are opened to the left, test files to the right. *

\* Notice that if the target file is already opened, both commands simply switch to it.

## Configuration settings

The following configuration settings are exposed:

- Create test file if none is found (default: `false`).

  If enabled, a new text editor is opened when switching to inexistent test files. If disabled, no text editors are opened.

## Installation

From the command line:

```
$ apm install ruby-test-switcher
```

From Atom's GUI:

    Settings/Preferences ➔ Install ➔ `ruby-test-switcher`

---
Inspired by the awesome [Sublime Text 2 Ruby Tests](https://github.com/maltize/sublime-text-2-ruby-tests).
