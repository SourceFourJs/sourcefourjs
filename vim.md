<font color='red'>
<b>JANUARY 2010: Genero has shipped with vim files since 2.20 <a href='http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#auto-completion-vim'>http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#auto-completion-vim</a></b>

<b>AUGUST 2010: Genero Studio 2.30 will have a vim editing mode in the Code Editor</b>

</font>


# Introduction #

For those that use vim, some tips on how to configure vim for use with Genero source files

# Details #

**$VIMRUNTIME**

Before configuring vim, determine if the VIMRUNTIME environment variable is set.  If not, find the file filetype.vim, this file will typically exist in the $VIMRUNTIME directory.  You will probably find one copy for each version of vim you have installed.  Treat this directory as $VIMRUNTIME for the purposes of this article.

**$VIMRUNTIME/syntax/[genero|per].vim**

Download genero.vim from ... and place in $VIMRUNTIME/syntax

Download per.vim from ... and place in $VIMRUNTIME/syntax

genero.vim and per.vim contain keywords and other syntax attributes for Genero .4gl and .per files.  I won't explain how these files work but if you look at them you should be able to figure out where to add anything in the future as new keywords are introduced.

**$VIMRUNTIME/indent/genero.vim**

Download genero.vim from ... and place in $VIMRUNTIME/indent

genero.vim contains keywords for Genero .4gl files that automate indenting in vim.


**$VIMRUNTIME/filetype.vim**

In $VIMRUNTIME/filetype.vim search for the existing 4gl setting.  It will probably look like ...
```
" Informix 4GL (source - canonical, include file, I4GL+M4 preproc.)
au BufNewFile,BufRead *.4gl,*.4gh,*.m4gl    setf fgl
```

Change it (after taking a backup first) to something like ...
```
" Informix 4GL (source - canonical, include file, I4GL+M4 preproc.)
au BufNewFile,BufRead *.4gh,*.m4gl  setf fgl
au BufNewFile,BufRead *.4gl setf genero
au BufNewFile,BufRead *.per setf per
au BufNewFile,BufRead *.4ad,*.4tb,*.4tm,*.4st,*.42f setf xml
```

This controls what syntax and indent files is used for files of a particular extension.  So with these changes .4gl files will now use the syntax defined in the file $VIMRUNTIME/syntax/genero.vim, the .per files will use the syntax defined in the file $VIMRUNTIME/syntax/per.vim, and the .4ad, .4tb etc files will use the existing xml.vim synatx file.


**$VIMRUNTIME/colors**

With vim you can also create your own color configuration files in $VIMRUNTIME/colors.  Type `:help colors` in vim for more details




**Possible Problems**

Check that no DOS to UNIX file or vice versa translaction has occured.  This can be checked by doing a diff of filetype.vim with the previous file, or by doing a diff of fgl.vim and genero.vim.  If every line is showing as different then this has occured.

In vim you can get more info through the help mechanism, type
`:help filetype`, `:help syntax`, `:help indent`, and `:help colors`

As new syntax is introduced into Genero, these changes will need to be included in the syntax and indent configuration files.  You can make the changes yourself but also idenfity the maintainer in the .vim file header comments and get them to change their copy for future users.