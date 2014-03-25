---
layout: post
title: Getting Started with IntelliJ IDEA and GitHub
categories: programming
---

Some of my classmates and peers have more experience on classroom assignments than real-world projects and are unfamiliar with version control. This guide is a quick intro to setting up IntelliJ IDEA with Git, which is the workflow I prefer for Java projects.

You can download IntelliJ IDEA Community Edition for free [here](https://www.jetbrains.com/idea/download/). Of course, you will also need a JDK. Use OpenJDK on Linux, or [Java SE](http://www.oracle.com/technetwork/java/javase/downloads/index.html) for Windows and Mac OSX.

While that's downloading, you should familiarize yourself with Git. IntelliJ IDEA (and most IDEs) provide graphical version control tools, but you should still be familiar with how to use the Git command line. Knowing how to use it will provide a deeper understanding of what Git is doing and how to fix things if they go wrong. GitHub and Code School have a great [interactive tutorial](http://try.github.io/) that you can run in your browser. The official [Git documentation](http://www.git-scm.com/documentation) has videos as well as a reference manual and a free book on more advanced subjects.

Once IntelliJ IDEA is downloaded and installed, launch it. Since you are probably new to IntelliJ IDEA, select "I do not have a previous version of IntelliJ IDEA."

Cloning an existing project on GitHub is easy. On the welcome screen, click "Check out from Version Control" and then click on GitHub. Enter your GitHub credentials. (If you checked the "Save Password" option, IntelliJ IDEA will ask you to set the master password for the password manager.) A Clone Repository window will appear. Enter the clone URL from the GitHub page of the repository you want to clone, and set the directory you want the files to be saved. Click Clone and click Yes when asked to create a project for the sources.

For a basic project that doesn't use any third-party SDKs or frameworks, the Import Project wizard should be straightforward. You may have to specify the location of the JDK on the Project SDK screen. If the JDK is not listed, click the plus symbol and then click JDK. The JDK is usually located in `/usr/lib/jvm/<JDK folder>` on Linux or `C:\Program Files\Java\<JDK folder>` on Windows.

Once the wizard is complete, the project window will appear. (In IntelliJ, each project has its own window.) Click View > Tool Buttons and then click Projects on the left edge to open the project view to navigate your project. When you're ready to commit changes, push upstream or use any other Git command, click the VCS menu at the top of the screen.

Keep in mind that IntelliJ IDEA has no concept of saving files. Everything you type is saved to disk, and you are expected to use version control to save points of progress. Remember to commit changes frequently (commiting for each added feature is a good practice).
