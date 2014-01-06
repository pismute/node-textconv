# node-textconv [![Build Status](https://secure.travis-ci.org/pismute/node-textconv.png?branch=master)](http://travis-ci.org/pismute/node-textconv)

a textconv util for git.

## Getting Started

Install the module with: `npm install -g node-textconv`

Put a textconver for xlsx in your configuration:

```
git config --global diff.xlsx.textconv "textconv --xlsx"
```

Define your differences in `.gitattributes`:

```
*.xlsx   diff=xlsx
*.XLSX   diff=xlsx
```

You are ready to compare versions.

## License
Copyright (c) 2014 Changwoo Park. Licensed under the MIT license.
