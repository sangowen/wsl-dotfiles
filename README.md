# wsl-dotfiles
![](ide.gif)
## Using i3wm as IDE
First of all, thank all of the developers and the community for making i3wm such a great window manager. i3wm totally changed my workflow and made me much more productive at work. </br>
One thing is that I've tried layout files before but I have never get a chance to apply it to my workflow. Everything during everyday work is dynamic and I open window one at a time, not all of them altogether. I may have to close and reopen windows very often.
It finally came to this setup that arranges ranger, vim and tmux/urxvt/zsh. It's a very hacky solution and I sincerely hope there is better way to achieve this. Please share your thought if you have any ideas.

This involves:
* i3 config: a lot of for_window [...] and regex
* customized ranger python functions
* customized bash script to start ranger, vimserver and tmux
* vim-like marks on those three windows

What it can do:
* ranger, vim, tmux, zsh are native, they are only kind of "grouped" by i3/vimserver/tmux
* reduces left/right gaps when ranger starts
* ranger, vim, and tmux restarts in the same place, no matter what is currently opened and what is the order of opening these windows
  * Ranger is 20% width on the left, vim & tmux is tabbed layout on the right
* ranger goes back to the last visited directory when reopened
* open files from ranger to vim as edit (current buffer) / split / vsplit / tab
* supports opening multiple files from ranger to vim to some extent
* open zsh in tmux under current ranger path (split / vsplit / tab)
* layout is persistent through i3 restart
* etc...
## Requirement
* i3-gaps
* ranger
* vim
  * (optional) ctrlp
* zsh
* urxvt
* tmux
* jq
* (optional) fasd
* (optional) peco
* (optional) fzf
## Keybinding & Behavior 
The keybindings and behaviors can be changed in the corredsponding files listed in each section.

### ranger
Related files: ranger/rc.conf, ranger/command.py, bin/ranger_vi, bin/ranger_zsh
```
ve: edit file in vim with current buffer
vv: open file(s) in vim with vertical split
vs: open file(s) in vim with horizontal split
vt: open file(s) in vim with new tab (and then vsplit if multiple files are selected)

sv: open zsh in current path with vertical split
ss: open zsh in current path with horizontal split
st: open zsh in current path with new tab
sc: open zsh in current path with new tab # similar to tmux prefix+c

space: toggle selection for current file
V: toggle VISUAL mode

z space: fasd to folder; requires fasd
ctrl-p: open popup window listing most recently used files. By selecting the file(s), it/they will be open in vim 
        with new tab (and then vsplit if multiple files are selected)
        requires peco & vim ctrlp plugin
```

### i3wm
Related files: i3/config*
```
mod+m: Mark mode (single char)
mod+': Goto mode (single char)
mod+hjkl: focus left, down, up, right
```

### vim
Related files: bin/ranger_vi, .vimrc

```
Normal mode:
  qq: :qa
  qt: :tabclose
```

### zsh
Related files: .zshrc

```
qq: exit
ctrl-p: open popup window listing most recently used files. By selecting the file(s), it/they will be open in vim 
        with new tab (and then vsplit if multiple files are selected)
        requires peco & vim ctrlp plugin
```

## Ricing
The whole desktop env. looks like:
[https://imgur.com/a/WJSv5Le](https://imgur.com/a/WJSv5Le)
