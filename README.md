Git.framework - Mac OS X GIT Repository Framework
===================================================
An implementation of Git in Objective-C & Foundation framework for embedding in Mac OS X and potentially iPhone OS Applications.

Supported Features
-------------------
The currently supported features of the project are

  * Reading objects, both loose and packed
  * Resolving refs from `.git/refs`
  * Reading branches, both local and remote
  * Enumeration of commits in breadth and depth first orders

Planned Features
-----------------
Features which will be implemented at some point (in no particular order)

  * Rev-list Support\*\*
  * Pulling changes from a remote repository via either ssh:// or git://
  * Pushing changes to a remote repository via ssh://
  * Mutable objects to enable writing new objects to the repository
  * Manipulation of the Index/Stage
  * ... and much much more\*

Additionally features from [CocoaGit][cocoagit] which are not yet supported will be evaluated and migrated into this project.

\*maybe, as and when things are thought of, suggested, or otherwise materialize, terms and conditions may apply, see binary for details

\*\* Currently supported through `GITGraph` but not yet plumbed into `GITRepo` in anyway

Adding the Framework to your Mac OS X Application
--------------------------------------------------
The first step to this is compiling a *Release* build of Git.framework, this can either be done in Xcode or via `rake` on the command line as

    $ rake build:release

the built product will be in the `builds/Release/` directory.

### Installing in your project
  * In the Finder, copy `Git.framework` to your project directory (eg MyProject/Frameworks)
  * Add the `Frameworks/Git.framework` to your *Linked Frameworks* group in Xcode
  * Open *Get Info* on your Application Target, select the *Build* tab
  * Change the *Configuration* to `All Configurations`
  * Enter `Runpath Search Paths` into the *Filter* field
  * Add `@executable_path/../Frameworks` to the *Runpath Search Paths*
  * Add a `New Copy Files Build Phase` to your Application Target
  * Select `Frameworks` from the *Destination* dropdown
  * Drag `Git.framework` from *Linked Frameworks* to your new *Copy Files* build phase

You might want to rename the *Copy Files* build phase to *Copy Frameworks*

Running the Test Suite
-----------------------
The test suite requires [MacRuby 0.5][macruby] and [Bacon][bacon] and can be run either through Xcode or `rake` in the Terminal. So far tests have been run using MacRuby r3090 and Bacon v0.9.

Bacon can be installed either using Rubygems or alternatively with [rip][rip]

Code Formatting and Style
--------------------------
I've tried to keep the code formatting and style unified within the project and with the current body of code this should be reasonably easy to follow. To aid in keeping the tabs/spaces under control there is a pre-commit hook which can be installed via

    $ rake check_tabs:install_hook

if you don't have a pre-commit hook already then this one will be installed, if you do then the script contents will be printed and you will need to merge them manually. This will cause a commit were there are tabs in the files being committed to fail. If you want to check the staged files or `Source/` contents for tabs you can use either of the following

    $ rake check_tabs:source
    $ rake check_tabs:staged

and any offending lines will be printed.

The hook can be configured to ignore specific file MIME types and extensions, this is done as follows

    $ git config pre-commit.ignored.mime 'image/ application/xml application/octet-stream'
    $ git config pre-commit.ignored.extensions 'graffle pbxproj'

BridgeSupport
--------------
The addition of any C level constants which need to be exposed to a bridged language such as [MacRuby][macruby] or PyObjC will require the regeneration of the BridgeSupport files. The headers containing the constants or functions to be exposed will need to be marked as public in the `Git` target and then the `bridgesupport:generate` rake task will need to be run.

Documentation of Code
----------------------
All headers need to be documented using the style currently in use. Documentation is generated using the [Doyxgen][doxygen] tool and is then post-processed by the `Documentation/doxyclean` project into the final format.

Licence
========
Released under the terms of the MIT licence, details of which are below

    Copyright (c) 2009 Geoff Garside

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.


[cocoagit]: http://github.com/geoffgarside/cocoagit
[macruby]: http://macruby.org/
[bacon]: http://rubyforge.org/projects/test-spec
[doxygen]: http://www.stack.nl/~dimitri/doxygen/
[rip]: http://hellorip.com/
