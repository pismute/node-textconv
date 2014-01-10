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

### difftool wrapper

When we want to use a external diff tool, git doen't help us to use textconv feature; Therefore, our wrapper script should grasp textconv configuration and use it. This difftool wrapper supports diffmerge only.

If you are on diffmerge, change configation like this:

```
git config --global diff.tool=diffmerge
git config --global difftool.diffmerge.cmd "difftool diffmerge \$LOCAL \$REMOTE"
```

This configuration for `git difftool` only. SourceTree require additional configation:

```
git config --global difftool.sourcetree.cmd "difftool diffmerge \$LOCAL \$REMOTE"
```

## License
Copyright (c) 2014+ Changwoo Park. Licensed under the MIT license.
