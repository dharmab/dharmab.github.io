---
layout: post
title: Premake is Best Make
categories: programming c++
---

Last week, I started work on a cross-platform C++ project (which I hope to be able to write more about in several weeks). I don't actually know much C++; neither does anyone else on my team. We're using this project to improve our abilities in that area.

One of the first hurdles we had to address was how to build our project across several platforms. We want to deploy a single codebase to Windows, OSX and Linux. Also, we had a number  of developers with different backgrounds and development environments.

The initial approach we attempted was to maintain a Visual Studio 2013 project, an Apple XCode project and a Makefile. We very quickly realized that maintaining three build systems was not feasible and research other solutions. Based on our research, we then explored two solutions: CMake and Premake.

Both CMake and Premake perform the same task: They aren't build systems, but rather generate the configuration files for other build systems. A single CMake or Premake configuration will create consistent project files for half a dozen IDEs across several platforms (or simply a Makefile if you prefer command-line tools).

We first tried CMake since it was more popular. While CMake is indeed powerful, we encountered difficulties.

* CMakeLists.txt configuration files are quite complex. They're writeen in a CMake-specific scripting language, with lots of 

* CMake's official documentation is lackluster. There's a manpage, a short tutorial, and a link to buy a book. That left us with forum posts and StackOverflow, which are often out of date and sometimes misinformed. Most articles on CMake were based on 2.6, while we were on 2.8.

* CMake commands are somewhat complex. A large amount of "clutter" files and directories are generated during a CMake operations, so out-of-source builds are a recommended practice. Combined with the need to pass debug/release flags, a CMake build process looked something like:

    $ mkdir -p build/debug
    $ cd build/debug
    $ cmake ../.. -DCMAKE_BUILD_TYPE="Debug"

Of course, this could have been scripted but it certainly didn't help the case for CMake (two more scripts to maintine across three platforms)

The second system we tried was Premake, and we had a much better experience.

* Declarative-style configuration in Lua, a language I had some experience in and like.

* Comphrehensive documentation including an in-depth tutorial.

* Single-step build generation: `premake4 gmake`, `premake4 vs2010` or `premake4 xcode3` and we're good to go.

We ended up spending a few hours with Premake rather than a few days with CMake, even given some exotic requirements for our builds. If you're looking for a cross-platform build generator, Premake has my seal of approval.
