# Introduction #

A summary of some useful tips on how to do some of the things you want to do with Genero Studio.

**DISCLAIMER** None of these are 'official' or 'recommended practices', use at your own risk.

Any editing of configuration files should be done when Studio is not open.  Studio may write what it has in memory back to these files when it is closed, thus overwriting changes you make whilst Studio is open


# Tools->Configurations #

The changes you make in Tools Configurations are saved in %APPDATA%\FourJs\Genero Studio [version](version.md)\generoStudio.conf

If you want the developers in your team to have a standard configuration, have one person create the standard configuration, and then copy the generoStudio.conf between the Genero Studio installations in your environment.

This technique can also be used when upgrading versions of Genero Studio.  You'll note that the version of Genero Studio is included in the directory given above.  Just copy generoStudio.conf from the old version's directory to the newest, however there is one disclaimer... the format of the .conf may change between versions so test and be prepared to have to manually edit the .conf file to reflect the new format.

(On Linux the directory isn't APPDATA but the Linux equivalent)

# Tools->User Preferences #

Like with Tools->Configurations, some of these are saved in a file %APPDATA%\FourJs\Genero Studio [version](version.md)\user.conf.  Using the same techniques as above and with the same disclaimer you can copy this file between installations of Genero Studio

# I don't want .42r in a bin directory #

If you're like me, you are used to having your source (.4gl, .per, .4fd etc) in the same directory as your compiled objects(.42r, .42m, .42f etc) and don't like the fact that Studio places all the compiled objects in a bin directory.

In the project hierarchy there is a property TargetDirectory and this is by default set to  $(WorkspaceDir)/bin.  To have your compiled objects, ensure that the TargetDirectory property is set to $(WorkspaceDir) instead.  See section below on how you can alter templates so that it is like this for all new projects

# Editing Templates #

The files used as the template for any new .4pw, .4gl, .4rp file etc are stored in GSTDIR/bin/src/studio/tpl.  You can modify these files and distribute around the installations of Genero Studio in your work place.

I modify the template.4pw so that the Target Directory property does not include bin on all new projects I create
```
  <Project label="Project_1" targetDirectory="$(WorkspaceDir)">
```

# Adding Templates #

You can add new template files into the GSTDIR/bin/src/studio/tpl directory but then how do you make Studio use them or offer them as a choice to be used.

In %APPDATA%\FourJs\Genero Studio [version](version.md)\user.conf find an instance of a similar template file...

For instance if I want to create an additional templates for .4pw, find the existing .4pw entry template entry that opens template.4pw ...

```
<Creatable action="PMOpenWorkspace" description="Create a project" extension="4pw" file="template.4pw" icon="workspace" isTemplate="true" label="Simple Project (.4pw)" name="PMSimpleProject"/>
```

and copy and paste this line in the same place in user.conf and edit the description, file, label attributes

```
<Creatable action="PMOpenWorkspace" description="Create my project" extension="4pw" file="my_template.4pw" icon="workspace" isTemplate="true" label="My Simple Project (.4pw)" name="PMSimpleProject"/>
```



