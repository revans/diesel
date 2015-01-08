# Diesel

This is a work in progress, so user beware.

Web applications, in general, have a lot of the same functionality. Instead of writing that same
functionality all the time, this gem will write it for you.

Current features that can be generated (with tests) are:

* Registration (name, email, password, accept terms)
* Login/Logout (using Rails' has_secure_password)
* Dashboard (blank)
* Edit User Profile (name, email, password)
* An admin section (checks if the user is an admin, separate admin routes, etc)
* Api base (token authentication, versioning, a custom api testing framework that will test against
  any given URL, the start of api documentation, and more)
* Bower setup (no gems, just using straight bower)
* Angular integration using Bower (installs all angular libraries, includes code for the
  authenticity token handling, base code for the angular app itself, etc.)
* App Server setup (unicorn, puma, thin, nginx, foreman, Procfiles, etc)
* Bootstrap (bootstrap-sass, font-awesome, autoprefixer-rails, flash partial, nav partial, form
  errors partial, etc)
* Some custom frontend SASS mixins, utilities, etc
* Geo-lookup (reverse as well)
* Rails Mail Sandboxing setup


There are some issues where the bundle command doesn't get called when adding gems, but that is
easily fixed by running the bundle command, manually.

There is a Rails Gem generator which isn't fully working yet, but the idea is to create a new
generator base to create another feature generator like the ones above.

I've tried to include at least some minimal tests for the generated code so the developer can use
those to build upon.

I've tried to stick as close to rails as possible, not using things like devise or the bower rails
gem. There are some gems that get added like bootstrap-sass, font-awesome, bcrypt, kaminari (for
pagination), rack-cors, etc.


## Usage

Include the gem in your project's Gemfile:

```
group :development do
  gem 'diesel'
end
```

You'll then have a bunch of new generators which you can see by running the following terminal
command:


```
rails g
```



