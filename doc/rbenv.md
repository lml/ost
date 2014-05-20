# Local installation

This guide enumerates the steps required for getting the ost project
running locally.  This is a living document and needs to be updated as
and when things change.

The `rbenv` environment versioning tool is used for managing ruby
versions.

> **Note** that while this document uses `rbenv`, it is not required.
> Manual ruby installation or manging versions using `rvm` are
> possible alternate strategies for running the OST application.

## Setup rbenv

Follow the [rbenv installation guide][rbenvinstall] to install rbenv.

### Install rbenv plugins

The following plugins are useful for managing ruby and rails projects
within rbenv.

1. ruby-build: The `rbenv install` command provided by this plugin
   allows us to install ruby versions through rbenv.  Follow the
   [ruby-build installation guide][rbbuildinstall].
2. rbenv-bundler: The `rbenv-bundler` plugin allows bundler commands
   to be executed directly without the bundler exec prefix.  Follow
   the [rbenv-bundler installation guide][rbbundlerinstall].

## Fix outdated packages

The OST project as it stands relies on a few outdated packages that
need to be meddled with before getting a `bundle install` going.

### localtunnel

The localtunnel package has been yanked from the gems repository and
needs manual installation.  The following commands will make the gem
available locally.

```
mkdir vendor/cache
cd !$
wget https://rubygems.org/downloads/localtunnel-0.3.gem
```

## Install major dependencies

Now that the misbehaving packages are out of the way, we can proceed
towards a good `bundle install`.

```
### Install ruby
rbenv install 1.9.3-p194
rbenv rehash
rbenv global 1.9.3-p194

### At this point, it seems like a good idea to relaunch the terminal.
gem install rake:10.1.1
gem install bundler
rbenv rehash
```

## Bundle install

Now we are ready for installing the requirements for the OST project.

```
bundle --without production
rbenv rehash
```

# Running OST

Since we have the bundler plugin for rbenv, we don't need to call `bundle exec`.

The following commands should get us up and running:

```
rake db:migrate
rails server
```

Ensure everything is up and running by launching <http://localhost:3000>.

[rbenvinstall]: https://github.com/sstephenson/rbenv#installation
[rbbuildinstall]: https://github.com/sstephenson/ruby-build#installation
[rbbundlerinstall]: https://github.com/carsomyr/rbenv-bundler#installation
[lock file]: https://github.com/lml/ost/blob/master/Gemfile.lock#L103
