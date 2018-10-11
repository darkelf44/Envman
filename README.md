# Environment Manager for Windows

This project helps you manage the process environment of your command line.

We all know, that on windows your environment can get really messy. Many of the software you install will create new environment variables, and add itself to your path, without asking for permission.This is a batch script, that helps you with keeping your environment, and especially your `PATH` clean, by simplifying the creation and usage of environment scripts.

It lets you create simple scripts that modify your path without opening a text editor, and you can load it in just as easily. It can also create aliases to your scripts, and list them if you need it. All in all, its not much different than just sticking your scripts in a folder, and adding that to your path, but it saves a few seconds on opening a text editor whenever you need to add a new file.

## Getting Started

### Installation

Copy the `envman.cmd` and any other script files, plus the empty `env` folder you want to install into a directory, where you want your installation to be, and add that directory to your path. You can either use the windows settings, or the `setx` command to accomplish that. That's it you are done, you can start getting rid of useless junk, and conflicting items in your path by creating enviroments using the `envman.cmd` script!

### Usage

If you've done everything correctly, issuing the `envman` command in a fresh console should result in the help being displayed. This help should tell you everything you need to know, but lets explain it anyway.

These commands load a list of environments. The last one is only available if you chose to install the `load.cmd` script too:

```
envman load <list of environments>
envman l <list of environments>
load <list of environments>
```

These command clear the environment, by invoking the `env/clear.cmd` script. How it does that is up to you to define:

```
envman clear
envman c
```

These commands lists the names of the available environments:

```
envman list
envman t
```

These commands create a new environment script in the `env` folder that adds new paths to the `PATH` variable:

```
envman install <name> <paths>
envman i <name> <paths>
```

These command create an alias to an existing script. If the original script is deleted, the alias will also fail:

```
envman alias <name> <original>
envman a <name> <original>
```

These commands delete an environment script:

```
envman delete <name>
envman d <name>
```

## Contributing

No need to do so. This is only a small tool for my own convenience.

## Authors

- darkelf44

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

