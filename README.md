#Introduction

Stitch Asset Server is a project for compiling, bundling and serving up your assets. The goal of this tool is to be able to use node as a javascript development tool and to provide a simple way to package up your assets and serve them from node. Additionally, this tool is designed to be a utility that is simple to use yet flexable enough to handle the most complex cases of asset packaging with ease.

While the tool supports convention over configuration, you are able to easily configure the following:

* included libraries
* use/not use CommonJS
* js temlate engines
* css tools
* node web server used

Supports both Strata and Express node web servers out of the box but can easily be exteded to use other servers

##Quick Start

``
npm install -g stitch-asset-server
asset-server create my_asset_server
cd my_asset_server
asset-server run
```

##Usage

###Development Tool

after installing, run ```asset-server run```

###Precompiling Assets

When you go to production, you will want to pre-compile your assets. Running ```asset-server precompile``` will pre-compile your assets and create a manifest file of the assets. By default, the assets will be precompiled with an md5 hash in their name based on the contents of the file ({original name}-{md5}.{ext}).

###Asset Server

####Express

add the following to your server startup
```javascript
var app = require('express').createServer();

var AssetServer = require('stitch-asset-server').AssetServer;
var assetServer = new AssetServer()
assetServer.include(app)
```

####Strata Server

add the following to your server startup
```javascript
var Builder = require('strata').Builder;
var app = new Builder();

var AssetServer = require('stitch-asset-server').AssetServer;
var assetServer = new AssetServer()
assetServer.include(app)
```


