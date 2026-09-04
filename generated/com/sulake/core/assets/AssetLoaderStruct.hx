package com.sulake.core.assets
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.assets.loaders.IAssetLoader;

     class AssetLoaderStruct extends EventDispatcherWrapper implements IDisposable 
    {
        var _assetLoader:IAssetLoader;
        var _assetName:String;

        public function new(assetName:String, assetLoader:IAssetLoader)
        {
            super();
            this._assetName = assetName;
            this._assetLoader = assetLoader;
        }

        public var assetName(get,never):String;
function  get_assetName():String
        {
            return this._assetName;
        }

        public var assetLoader(get,never):IAssetLoader;
function  get_assetLoader():IAssetLoader
        {
            return this._assetLoader;
        }

        override public function dispose()
        {
			try
			{
            if (!disposed)
            {
                if (this._assetLoader != null)
                {
                    if (!this._assetLoader.disposed)
                    {
                        this._assetLoader.dispose();
                        this._assetLoader = null;
                    }
                }
                super.dispose();
            }
			}
			catch (error:ASError)
			{
				Habbo.trackLoginStep("Failed to dispose " + this._assetName);
			}
        }
    }

