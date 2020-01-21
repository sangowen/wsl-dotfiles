# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import (absolute_import, division, print_function)

# You can import any python module as needed.
import os

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command


# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.acitons, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    # tabnum is 1 for <TAB> and -1 for <S-TAB> by default
    def tab(self, tabnum):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()

class zsh(Command):
    """
    :zsh

    open zsh
    """

    def execute(self):
        import subprocess
        subprocess.Popen(['/home/wayne/bin/ranger_zsh', self.fm.thisdir.path, self.arg(1)])

class vim(Command):
    """
    :vim

    open vim
    """

    def execute(self):
        import subprocess
        selection = self.get_selection_attr('path')
        if not os.path.isdir(selection[0]):
            selection.insert(0, '/home/wayne/bin/ranger_vi')
            selection.insert(1, self.arg(1))
        else:
            selection[0] = '/home/wayne/bin/ranger_vi'
            selection.insert(1, self.arg(1))
        subprocess.Popen(selection)

    def get_selection_attr(self, attr):
        return [getattr(item, attr) for item in
                self.fm.thistab.get_selection()]

class nvim(Command):
    """
    :nvim

    open nvim
    """

    def execute(self):
        import subprocess
        selection = self.get_selection_attr('path')
        if not os.path.isdir(selection[0]):
            selection.insert(0, '/home/wayne/bin/ranger_nvim')
            selection.insert(1, self.arg(1))
        else:
            selection[0] = '/home/wayne/bin/ranger_nvim'
            selection.insert(1, self.arg(1))
        subprocess.Popen(selection)

    def get_selection_attr(self, attr):
        return [getattr(item, attr) for item in
                self.fm.thistab.get_selection()]

class peco_open_popup(Command):
    """
    :peco_open_popup

    open an pop window of last editted files and use peco for filtering/selection
    """

    def execute(self):
        import subprocess

        FNULL = open(os.devnull, 'w')
        p1 = subprocess.Popen(['/usr/bin/urxvt', '-name', 'one_command_shell_big', '-e', '/home/wayne/bin/peco_popup'], stdout=FNULL, stderr=FNULL)
        p1.wait()
        if not os.path.isfile("/tmp/nopecresult"):
            self.fm.set_option_from_string("preview_files", "false")
            self.fm.set_option_from_string("column_ratios", "2,1")

class cd_zsh(Command):
    """
    :cd_zsh

    cd to path copied from zsh
    """

    def execute(self):
        import subprocess

        stdout = subprocess.check_output(['/usr/bin/xclip', '-se', 'c', '-o'])
        if stdout:
            self.fm.cd(stdout)

class shell_cmd(Command):
    """
    :shell_cmd

    run shell command
    """

    def execute(self):
        import subprocess
        subprocess.Popen(str.split(self.rest(1)), stdout=open(os.devnull, 'wb'), stderr=open(os.devnull, 'wb'))


class fasd(Command):
    """
    :fasd

    Jump to directory using fasd
    """
    def execute(self):
        import subprocess
        arg = self.rest(1)
        if arg:
            directory = subprocess.check_output(["fasd", "-d"]+arg.split(), universal_newlines=True).strip()
            self.fm.cd(directory)

class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        import os.path
        if self.quantifier:
            # match only directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -type d -print 2> /dev/null | sed 1d | cut -b3- | /home/wayne/.fzf/bin/fzf +m"
        else:
            # match files and directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -print 2> /dev/null | sed 1d | cut -b3- | /home/wayne/.fzf/bin/fzf +m"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)

class fzf_open(Command):
    """
    :fzf_open

    Open MRU using fzf.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        import os.path
        command="cat ~/.cache/ctrlp/mru/cache.txt | /home/wayne/.fzf/bin/fzf +m"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = [os.path.abspath(stdout.rstrip('\n'))]
            # if os.path.isdir(fzf_file):
            #     self.fm.cd(fzf_file)
            # else:
            #     self.fm.select_file(fzf_file)
            if not os.path.isdir(fzf_file[0]):
                fzf_file.insert(0, '/home/wayne/bin/ranger_vi')
            else:
                fzf_file[0] = '/home/wayne/bin/ranger_vi'
            subprocess.Popen(fzf_file)
