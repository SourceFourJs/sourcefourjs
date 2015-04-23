# Introduction #
The Genero Toolkit is an attempt to create a general purpose toolkit for Genero on which other Genero applications can be built. For most people this will probably mean taking ideas from the toolkit and reworking it to fit in with their own development environment. Hopefully though it will reduce the amount of "re-inventing the wheel" that is required for anyone starting with Genero development.

# Details #
Currently the wishlist is to provide the following:
  * libGtCore - A core library providing basic functionality like encryption, emailing, standard dialogs, a simple regex engine, etc.
  * libGtNetwork - A networking library to provide functionality like ftp, pop, etc.
  * libGtFormat - Library to allow output to various document formats. XHTML will be the first for the documentation generator.
  * GtDocgen - A documentation generator. The idea is to have the format of the documentation the same as is used by Javadoc and Doxygen so that at a later stage if someone wants to write a plugin for 4gl for either of those programs no changes to the code documentation would be required.
  * GtMisql - A graphical record/list view replacement for the misql program available from IIUG.

Please use the Issue tracker for any other wishlist items you may have.

# FAQ #
  1. Why are you doing this?
    * To hopefully help build an open source community around Genero development.
  1. Shouldn't Four J's provide this functionality?
    * No, not necessarily. I would rather see Four J's provide functionality that cannot be developed in the Genero language. This, IMHO, would include things like a more consistent "class-based" API, an improved canvas, improved socket functionality, HTML support, printing interfaces, etc. The Genero roadmap shows that some of this is currently being developed.
  1. How can I help?
    * Coding, bug fixing, logging wishlists, documentation - whatever takes your fancy. The only thing I would ask is that in order to keep the toolkit consistent you use the same coding standards I'm using. If that's too much like hard work, send me the code and I'll do it for you.
  1. What did you do the development in?
    * Genero Studio running on openSUSE (latest version). I'm normally a vim man but thought I would give Genero Studio a try so that I could provide feedback to Four J's about it.
  1. Are you getting paid to do this development?
    * No.
  1. Are you sure there are no copyright issues with this code?
    * There shouldn't be. Some of the modules I developed for Quanta Systems Limited (now part of the Integral Technology Group) and I do have permission from Integral Technology Group to release those modules under the MIT license. The rest I have developed from scratch (though sometimes using ideas from the work I do during the day).

# Released Versions #
  * 0.1 - Initial release which contains a very basic GtCore library and a basic unittest framework. Released 18 September 2007.

The latest development source code is always available from the subversion repository.

# Roadmap #
Version 0.1 (Released: 18 September 2007)
  * Very basic GtCore library
  * Basic unit test framework in place

Version 0.2
  * Added functionality to the GtCore library
  * Start of documentation generator

Version 0.3
  * To be decided

# License #
The code is released under the MIT license.





