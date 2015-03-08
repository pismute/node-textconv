# node-textconv [![Build Status](https://secure.travis-ci.org/pismute/node-textconv.png?branch=master)](http://travis-ci.org/pismute/node-textconv)

A text converter for git.

## Getting Started

Install the module with: `npm install -g node-textconv`

Define your differences in `.gitattributes`:

```
*.xlsx   diff=xlsx
*.XLSX   diff=xlsx
```

Put settings in your configuration:

```
git config --global diff.xlsx.textconv "textconv --xlsx"
git config --global diff.xlsx.cachetextconv true
```

You are ready to compare versions, just run `git diff`.

If you want to use a external difftool, also `node-textconv` help you:

```
git config --global difftool.diffmerge.cmd "difftool diffmerge \$LOCAL \$REMOTE"
```

## Documentation

`node-textconv` is a helper tool to diff binary files. It consists of two helping scripts, **textconv**  and **difftool**. **textconv** is just a converter to convert a binary file to text. git has a way to make any binary file diffable. If you provide text converters, you can diff them. But unfortunately, when we use external difftool like DiffMerge git , git don't help us to diff binary files. git just run only a diff script for external difftool. The diff script have to convert binary file to text and then run external difftool. **difftool** script make binary files diffable in even external difftool.

For details, read [attribute section in progit](http://git-scm.com/book/en/Customizing-Git-Git-Attributes#Binary-Files) and [reference about gitattributes](https://www.kernel.org/pub/software/scm/git/docs/gitattributes.html)

### textconv

Currently, **textconv** supports only xlsx files. Coming soon! other formats.

#### xlsx

This file has three sheets of staff, cast, description. This script easily convert xlsx files to markdown text. Sheet name is converted to head. The body of xlsx sheet is converted to csv format in code block. let see [An example xlsx files](https://github.com/pismute/node-textconv/raw/master/src/test/data/the-attorney.xlsx).

This file has three sheets:

![staff](https://raw.githubusercontent.com/pismute/node-textconv/master/doc/image/staff.png)
![cast](https://raw.githubusercontent.com/pismute/node-textconv/master/doc/image/cast.png)
![description](https://raw.githubusercontent.com/pismute/node-textconv/master/doc/image/description.png)

**textconv** convert it to text:

```
### staff

``` csv

"staff",,,
,"Director","Woo-seok Yang",
,"Writers","Yoon Hyeon-ho","Woo-seok Yang"

``` .

### cast

``` csv

"cast",,
,"Yeong-ae Kim","Choi Soon-ae"
,"Do Won Kwak","Cha Dong-yeong"
,"Dal-su Oh","Park Dong-ho"
,"Kang-ho Song","Song Woo-seok"
,"Young-chang Song","Judge"
,"Si-wan Yim","Jin-woo"

``` .

### description

``` csv

"An ambitious tax attorney decides to represent an old friend in court."

``` .

```

you can test it as you run `textconv --xlsx [xlsx file]`.

First of all, We have to define a difference for xlsx in `.gitattributes`. Git Attribute are saved in Git repository and then will be shared with colleague:

```
*.xlsx   diff=xlsx
*.XLSX   diff=xlsx
```

Each person set up this text converter for xlsx in your configuration:

```
git config --global diff.xlsx.textconv "textconv --xlsx"
```

To cache once converted files, you can boost your work:

```
git config --global diff.xlsx.cachetextconv true
```

To clear cache:

```
git update-ref -d refs/notes/textconv/xlsx
```

Git mangage cache file like a loose object; Therefore, cache file is in git database(`.git` direcotry)

### difftool

When we want to use a external diff tool, git doen't help us to use textconv feature; Therefore, the wrapper script should grasp textconv configuration and use it. This difftool script do this.

If you are on diffmerge, change configuration like this:

```
git config --global diff.tool diffmerge
git config --global difftool.diffmerge.cmd "difftool diffmerge \$LOCAL \$REMOTE"
```

If you run `git difftool 4515ef2 src/test/data/the-attorney.xlsx` after clone this repository, then you can see diffmerge window:

![diffmerge](https://raw.githubusercontent.com/pismute/node-textconv/master/doc/image/difftool-diffmerge.png)

This settings for `git difftool` only. [SourceTree](http://www.sourcetreeapp.com/) require additional configuration:

```
git config --global difftool.sourcetree.cmd "difftool diffmerge \$LOCAL \$REMOTE"
```

## License
Copyright (c) 2014+ Changwoo Park. Licensed under the MIT license.
