#Introduction

Stitch Asset Server is a project for compiling, bundling and serving up your assets. The goal of this tool is to provide a way to use node for general javascript development and to integrate into the existing node servers. While the tool supports convention over configuration, you are able to easily configure the following:

Current Supports:
* included libraries
* use/not use CommonJS

Future Support in Process
* node web server used
* css tools
* js temlate engines 

Current it only supports express ~2.0.0 but will be updated to support express ~3.0.0 as well as Strata

##Why a different tool?

There are some great toos out there (stitch, connect-assets, hem, etc). The problem with all these tools is that they are not flexible and not easily extendable. This tool is extendable and should be easy to use and easy to extend if you needs are complex.

This tool provides the following:
 
* simple server integration for single js/css file serving
* ability to serve multiple css/js packages based on configuration
* inline code configuration or static config file
* pre-compiling assets for production with md5 digest

Future support:
* script tag generation for node servers
* ability to publish assets to cdn/server

##Quick Start

``
npm install -g stitch-asset-server
asset-server
```

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


