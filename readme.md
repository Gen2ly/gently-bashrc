### Description

A thorough bash configuration file meant to replace the local `~/.bashrc`.  It has support for:

* Basic expected functionality
* Bash history improvements
* Colored command prompt
* Script directory: `~/.local/bin`
* `ls` and `grep` coloring
* `ls` navigational aliases: `lsd`, `lsl`, `lss`, `lsx`: date, long, size, ext.
* `cd` navigational aliases: `..`, `...`, `....`
* `rm` and `cp` file protection
* `treeless`: directory tree view in pager
* `tarlist`: archive content list
* `abacus`: a command line calculator

### Usage

Add `source /usr/share/doc/gently-bashrc/gently.bashrc` to `/etc/bash.bashrc`, then remove the local bashrc (`~/.bashrc`).
