# Crystal Heroku Buildpack

You can create an app in Heroku with Crystal's buildpack by running the
following command:

## Usage

#### Create a Heroku app with this buildpack

```
heroku create --buildpack "https://github.com/ucmsky/heroku-buildpack-crystal.git"
```

#### Set the buildpack of an existing Heroku app

```
heroku config:set BUILDPACK_URL="https://github.com/ucmsky/heroku-buildpack-crystal.git"
```

## Configuration

Create a `crystal_buildpack.config` file in your app's root dir. The file's syntax is bash.

If you don't specify a config option, then the default option from the buildpack's [`crystal_buildpack.config`](https://github.com/ucmsky/heroku-buildpack-crystal/blob/master/crystal_buildpack.config) file will be used.


__Here's a full config file with all available options:__

```
# Crystal version
crystal_version=0.10.2

# Always rebuild from scratch on every deploy?
always_rebuild=false

# Export heroku config vars
config_vars_to_export=(DATABASE_URL)

# A command to run right after compiling the app
post_compile="pwd"

# Build command
build_command=("make db_migrate" "make build")
```

#### Specifying config vars to export at compile time

* To set a config var on your heroku node you can exec from the shell:

```
heroku config:set MY_VAR=the_value
```

* Add the config vars you want to be exported in your `crystal_buildpack.config` file:

```
config_vars_to_export=(DATABASE_URL MY_VAR)
```

## Other notes

In order for the buildpack to work properly you should have a `shard.yml`
file, as it is how it will detect that your app is a Crystal app.

To learn more about using custom buildpacks in Heroku, read [their docs](https://devcenter.heroku.com/articles/third-party-buildpacks#using-a-custom-buildpack).

## Older versions of Crystal

If you have and older version of Crystal (`<= 0.9`), that uses the old
`Projectfile` way of handling dependencies, you can use
[version 1.0](https://github.com/zamith/heroku-buildpack-crystal/tree/v1.0.0) of
the buildpack.
