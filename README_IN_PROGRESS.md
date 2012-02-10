# Items current in development

##Usage

###Precompiling Assets

When you go to production, you will want to pre-compile your assets. Running ```asset-server precompile``` will pre-compile your assets and create a manifest file of the assets. By default, the assets will be precompiled with an md5 hash in their name based on the contents of the file ({original name}-{md5}.{ext}).

###Asset Server

####Strata Server

add the following to your server startup
```javascript
var Builder = require('strata').Builder;
var app = new Builder();

var AssetServer = require('stitch-asset-server').AssetServer;
var assetServer = new AssetServer()
assetServer.include(app)
```


