# Getting Started
All that you need to get started with the examples is [Git](http://git-scm.com/) and [Ruby](http://www.ruby-lang.org/en/) (1.8.7 or later) with [Bundler](http://gembundler.com/) for dependency management. 

Below you find the basic instructions for an easy installation on Mac, Linux and Windows. 

## on Mac

### Git
The easiest way is to use [Git OSX installer](http://code.google.com/p/git-osx-installer/)

#### Installing Git with Homebrew
Git can be also be installed using [Homebrew](http://mxcl.github.com/homebrew/) package manager.

To install Homebrew open a terminal and paste the following command:

    /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"

Once you have installed Homebrew you can install Git with the following command: 

    brew install git

#### Git GUIs
* [SourceTree](http://www.sourcetreeapp.com/) 
* [GitHub for Mac](http://mac.github.com/)


### Ruby
Ruby 1.8.7 is preinstalled on Mac OS X 10.6 and later (Snow Leopard and Lion). You just need to:

1. Update RubyGems: `sudo gem update -system`
2. Install bundler: `sudo gem install bundler`

#### RVM
If you want to install the latest version of Ruby or if you want to manage multiple versions, the best option is to install [RVM](https://rvm.beginrescueend.com/) (Ruby Version Manager).

Open the terminal and run the following commands:


    bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
    rvm install 1.9.2
    rvm use 1.9.2 --default


This will install the latest version 1.9.2 and making it as the default Ruby interpreter

For more information you can check [this page](http://www.ruby-lang.org/en/downloads/).
 
## on Linux

### Git
On Debian Linux (like Ubuntu) you can install Git using the apt package manager. Open a terminal and paste the following code: 

    sudo apt-get install git-core


### Ruby
On Debian Linux (like Ubuntu) you can use the apt package manager to install Ruby. You need to install Ruby with development tools (-dev): 

    sudo apt-get install ruby1.9.1-dev

Note that this will install the latest version 1.9.2 and not 1.9.1

## on Windows
###Git
Installing Git is pretty easy. Just download and install the package called [msysGit](http://code.google.com/p/msysgit/downloads/list).

###Ruby
1. Install Ruby **1.8.7** using [RubyInstaller](http://rubyinstaller.org/). If you are planning to use Ruby on Rails, you should consider the [RailsInstaller](http://railsinstaller.org/)
2. Install [Ruby Development Kit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) needed for some gems
3. Install bundler: `gem install bundler`

*Tip*: To make sure the correct Ruby version is used in command line, open command prompt using the “Start command prompt with Ruby” from the Ruby 1.8.7 subfolder in Start-menu

# Using the examples
All the examples are contained in a single Git repository that is hosted on GitHub. Here you can find the instructions how to 
clone the repository and launch the examples. 

## Configuring GitHub

The first step is to configure your Git with your GitHub account. If you haven't done it yet, create an account at [GitHub](http://www.github.com)

Once you have created the account you can follow these guides for configuring your Git: [Mac](http://help.github.com/mac-set-up-git/), [Linux](http://help.github.com/linux-set-up-git/) and [Windows](http://help.github.com/win-set-up-git/)

## Cloning the repository

You can download the examples by simply cloning [this GitHub repository](https://github.com/aaltowebapps/MobileWebAppsExamples). Open a terminal and run the following code: 

     git clone git@github.com:aaltowebapps/MobileWebAppsExamples.git

This will create a directory called `MobileWebAppsExamples` which contains all the examples in separate subdirectories. If you want you can rename it to something else. 

If in the future you need to fetch the changes from the server, you can run the following commands in a terminal:
	
	cd MobileWebAppsExamples
	git pull
	
## Updating the gems

In the directory `MobileWebAppsExamples` there is a file called `Gemfile` that contains all the additional modules (called gems) that
are required to run the examples. 

The first thing is to install [Bundler](http://gembundler.com/) that is tool for managing application's dependencies for Ruby.
You can install it by running the following commands in a terminal: 

    gem install bundler

Once you have install Bundler you can install the additional gems by running the following commands: 

	cd MobileWebAppsExamples
	bundle install
		
## Launching the examples 
Each subdirectory contains a seprate example. Most of examples are based on [Sinatra](http://www.sinatrarb.com/) and you can launch the server with the following command: 
    
    ruby server.rb
    
## Deploying on Heroku
[Heroku](http://www.heroku.com) provides a free and convenient way for hosting applications in the cloud. 
After you sign up for free on their website you can follow [these instructions](http://devcenter.heroku.com/articles/quickstart) for getting started with Heroku 
on different platforms. 
Once you have logged in with you account, you can start to deploy applications by pushing Git repositories. 
Below there is an example how to deploy the sinatraHelloWorld example.

### Copy the files to deploy
First we copy all the files of the application that we need to deploy into a separate directory.
We start in the parent directory where the examples are located and enter the following commands: 

    mkdir deploy
    cd deploy
    cp ../MobileWebAppsExamples/sinatraHelloWorld/* .
  
### Configure the application 
Heroku requires two files for configuring and starting the application: Gemfile and config.ru
We can copy the Gemfile from the examples directory:

    cp ../MobileWebAppsExamples/Gemfile
  
We can create the file config.ru in this way: 

    touch config.ru
    echo "require './server'" >> config.ru 
    echo "run Sinatra::Application" >> config.ru

### Create the Git repository
We create the Git repository and commit all the files

    git init
    git add .
    git commit -am "First commit"

### Create a new Heroku instance
We create a new Heroku instance with the following command: 

    heroku create

The result is:

    Creating quiet-day-9893... done, stack is bamboo-mri-1.9.2
    http://quiet-day-9893.heroku.com/ | git@heroku.com:quiet-day-9893.git
    Git remote heroku added

Heroku has create a new server instance at: [http://quiet-day-9893.heroku.com/](http://quiet-day-9893.heroku.com/)

Heroku has also created a new Git repository (git@heroku.com:quiet-day-9893.git) on their servers and automatically configured is as 
a remote for our local Git repository. We can check that with following command: 

    git remote -v

The result below shows that we have a new remote called heroku:  
    heroku	git@heroku.com:quiet-day-9893.git (fetch)
    heroku	git@heroku.com:quiet-day-9893.git (push)

### Deploy the application 
We can deploy the application by simply pushing the master to heroku:

    git push heroku master
  
The result is the following: 

    Counting objects: 5, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (4/4), done.
    Writing objects: 100% (5/5), 540 bytes, done.
    Total 5 (delta 0), reused 0 (delta 0)

    -----> Heroku receiving push
    -----> Ruby/Sinatra app detected
    -----> Gemfile detected, running Bundler version 1.0.7
           Unresolved dependencies detected; Installing...
           Using --without development:test

     !     Gemfile.lock will soon be required
     !     Check Gemfile.lock into git with `git add Gemfile.lock`
     !     See http://devcenter.heroku.com/articles/bundler

           Fetching source index for http://rubygems.org/
           Installing addressable (2.2.7) 
           Installing coffee-script-source (1.2.0) 
           Installing multi_json (1.1.0) 
           Installing execjs (1.3.0) 
           Installing coffee-script (2.2.0) 
           Installing daemons (1.1.8) 
           Installing eventmachine (0.12.10) with native extensions 
           Installing em-websocket (0.3.6) 
           Installing ffi (1.0.11) with native extensions 
           Installing thor (0.14.6) 
           Installing guard (1.0.1) 
           Installing guard-coffeescript (0.5.5) 
           Installing haml (3.1.4) 
           Installing guard-haml (0.3.2) 
           Installing sass (3.1.15) 
           Installing guard-sass (0.5.4) 
           Installing manifesto (0.7.0) 
           Installing ruby-hmac (0.4.0) 
           Installing signature (0.1.2) 
           Installing pusher (0.9.2) 
           Installing rack (1.4.1) 
           Installing rack-protection (1.2.0) 
           Installing tilt (1.3.3) 
           Installing sinatra (1.3.2) 
           Installing thin (1.3.1) with native extensions 
           Using bundler (1.0.7) 
           Your bundle is complete! It was installed into ./.bundle/gems/
    -----> Compiled slug size is 3.1MB
    -----> Launching... done, v4
           http://quiet-day-9893.heroku.com deployed to Heroku

    To git@heroku.com:quiet-day-9893.git
     * [new branch]      master -> master
 
Now the application is deployed at: [http://quiet-day-9893.heroku.com/](http://quiet-day-9893.heroku.com/)
