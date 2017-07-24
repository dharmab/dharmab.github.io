---
layout: post
title: 'Isolated Python'
categories: programming python docker
---

Python is a great language for developing scripts, command-line tools and web APIs. It's easy to write, easy to read and has a huge ecosystem of libaries and tools. However, managing different versions of Python and its many libraries can be a pain. The traditional solution is to isolate each project's dependencies with Virtualenv. We can use a few more tools to create fully isolated Python processes that truly run anywhere.

## Isolated Configuration with direnv

The [twelve-factor guidelines](https://12factor.net) are recommended design patterns which make service code easier to develop and run. The third of the twelve factors is 'Store config in the environment'. In practice, this means reading config from environment variables. This is good because it means that the code doesn't need to have access to a database, document store or even a filesystem to be configured.

The easiest place to put environment variables on \*nix are `~/.bash_profile` and `~/.bashrc`. Depending on your operating system, these files are loaded when you log in or when you launch a new terminal. Developers will often put their variables in one of those files:

```bash
#!/bin/bash

[. . . ]

export API_KEY_ID='01189998819991197253'
export API_KEY='f7bdb9bc2e22d6142ea7a0ab'
```

This works fine, until a developer has two projects which need to use separate API keys, or an administrator/operator wants to separate their full-access administrator keys from limited-access application keys.

We can solve that problem by creating a separate Bash script in each project directory:

```
.
├── project0
│   └── environment.sh
├── project1
│   └── environment.sh
└── project2
    └── environment.sh
```

and then sourcing each script when we want to run each project:

```bash
cd project0
source environment.sh
```

This works fine, too- provided that the developer always remembers to source the environment script when they change projects. But a good developer is a lazy developer, and a utility called [direnv](https://direnv.net/) can automate this setup for us.

```bash
# Install direnv
brew install direnv # If you're on Linux you know what to do :)
# Add bash hook and reload profile
echo 'eval $(direnv hook bash)' >> ~/.bash_profile
source ~/.bash_profile
# Globally ignore direnv files in Git
git config --global core.excludesfile ~/.gitignore
echo '.envrc' >> ~/.gitignore
echo '.direnv' >> ~/.gitignore
```

Now we can create a .envrc in each of our projects:

```bash
#!/bin/bash

export API_KEY_ID='01189998819991197253'
export API_KEY='f7bdb9bc2e22d6142ea7a0ab'
```

Run `direnv allow` to approve the content of the script. Now the API keys will automatically load when we enter the project directory, and unload when we leave it.

If we store credentials in a password manager like [pass](https://www.passwordstore.org) or [Vault](https://www.vaultproject.io), we can reference them in our `.envrc`:

```bash
#!/bin/bash
AZURE_CLIENT_ID=$(pass Azure/ClientId)
AZURE_CLIENT_SECRET=$(pass Azure/SecretKey)
AZURE_TENANT_ID=$(pass Azure/TenantId)
AZURE_SUBSCRIPTION_ID=$(pass Azure/SubscriptionId)
export AZURE_CLIENT_ID AZURE_CLIENT_SECRET AZURE_TENANT_ID AZURE_SUBSCRIPTION_ID
```

Our projects now have isolated configurations with effortless switching! Here's a real example from my machine:

```bash
$ cd ~/git/booster-azure/
direnv: loading .envrc
direnv: export +AZURE_CLIENT_ID +AZURE_CLIENT_SECRET +AZURE_RESOURCE_GROUP +AZURE_SCALE_SET +AZURE_SUBSCRIPTION_ID +AZURE_TENANT_ID +FLASK_APP +FLASK_DEBUG +POSTGRES_PASSWORD +VIRTUAL_ENV ~PATH
[booster-azure]$ cd ~/git/dcos-infrastructure/
direnv: loading .envrc
direnv: export +CONFIG_LOCATION +VIRTUAL_ENV ~PATH
[dcos-infrastructure]$ echo $AZURE_CLIENT_SECRET

[dcos-infrastructure]$
```

## Isolated Dependencies with Virtualenv

[Virtualenv](https://virtualenv.pypa.io/en/stable) will be familiar to most Python developers. It allows us to have different sets and versions of Python libraries installed for different applications, eliminating conflicts caused by mismatched library versions.

Direnv makes it very easy to set up a Virtualenv, using a special `layout` function:

```bash
#!/bin/bash
layout python3

AZURE_CLIENT_ID=$(pass Azure/ClientId)
AZURE_CLIENT_SECRET=$(pass Azure/SecretKey)
[. . .]
```

Now direnv will automatically create the Virtualenv and configure PATH for use just like the other environment variables.  (Use `layout python` for a Python2 Virtualenv.) Create a [requirements.txt file](https://pip.pypa.io/en/stable/user_guide/#requirements-files) with a list of the libraries and versions your project needs, and install it with `pip install -r requirements.txt`. When you leave the project directory, the Virtualenv will be unloaded and the rest of your system won't be cluttered with the project's libraries.

## Isolated Runtime: Docker

This is all well and good for developing Python code. But if our code has to run on a different machine, we have to also set up the configuration and libraries on that machine. Systemd services with `EnviromentFile=` directives and Virtualenvs can solve the problem, and if that works for you, that's great! But you can also run your service inside a Docker container, which is great if all of your collaborators and servers also run Docker.

Setting up and using Docker is best done by reading the [official documentation](https://docs.docker.com/get-started). If you're familiar with containers, [here's an example project which uses Docker to run a small application](https://github.com/dharmab/ksl-bike-sniper). You can use this as an example for your own projects!
