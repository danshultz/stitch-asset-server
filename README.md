#Introduction

Stitch Asset Server is a project for compiling, bundling and serving up your assets. The goal of this tool is to provide a way to use node for general javascript development and to integrate into the existing node servers. While the tool supports convention over configuration, you are able to easily configure the following:

##Why a different tool?

There are some great toos out there (stitch, connect-assets, hem, etc). The problem with all these tools is that they are not flexible and not easily extendable. This tool is extendable and should be easy to use and easy to extend if you needs are complex.

This tool provides the following:
 
* simple server integration for single js/css file serving
* ability to serve multiple css/js packages based on configuration
* inline code configuration or static config file
* pre-compiling assets for production with md5 digest
* in browser testing support for your application (http://0.0.0.0:9294/test) utilizing mocha/chai
* file watch support and recompiling on file watching

Future support:

* script tag generation for node servers
* ability to publish assets to cdn/server
* configurable "compilers" so you can mix and match templateing engines/css compilers as you please. A base set of compilers (as the current set) will be defined
* auto browser test runner with single file support using web sockets and a file watcher

Current it only supports express ~2.0.0 but will be updated to support express ~3.0.0 as well as Strata

##Quick Start

Coming soon!

##Sample Configuration file

A sample of what the configs and options look like can be [found here](https://github.com/danshultz/stitch-asset-server/blob/master/test/options_test.coffee)

##Usage

###Development Tool

after installing, run ```asset-server```

###Precompiling Assets

When you go to production, you will want to pre-compile your assets. Running ```asset-server precompile``` will pre-compile your assets and create a manifest file of the assets. By default, the assets will be precompiled with an md5 hash in their name based on the contents of the file ({original name}-{md5}.{ext}).

###Asset Server

####Express

add the following to your server startup

```coffee-script
{AssetCompiler} = require('stitch-asset-server')
{Options} = require('stitch-asset-server')
{ExpressAdapter} = require('stitch-asset-server')

app = express.createServer();

asset_options = new Options()
adapter = new ExpressAdapter(app)
compiler = new AssetCompiler(asset_options.build_compiler_package())
compiler.create_routes(adapter)
```


###Thanks/Credits

This was inspired by [Hem](https://github.com/maccman/hem), which was created by Alex MacCaw. Parts of the source for this project was adapted based on his project.

