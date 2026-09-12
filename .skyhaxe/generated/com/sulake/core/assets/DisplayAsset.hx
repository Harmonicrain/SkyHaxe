package com.sulake.core.assets
;
    import flash.display.DisplayObject;

     class DisplayAsset implements IAsset 
    {
        var _url:String;
        var _content:DisplayObject;
        var _disposed:Bool = false;
        var _decl:AssetTypeDeclaration;

        public function new(decl:AssetTypeDeclaration, url:String=null)
        {
            this._decl = decl;
            this._url = url;
        }

        public var url(get,never):String;
public function  get_url():String
        {
            return this._url;
        }

        public var content(get,never):ASObject;
public function  get_content():ASObject
        {
            return this._content;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var declaration(get,never):AssetTypeDeclaration;
public function  get_declaration():AssetTypeDeclaration
        {
            return this._decl;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._content.loaderInfo != null)
                {
                    if (this._content.loaderInfo.loader != null)
                    {
                        this._content.loaderInfo.loader.unload();
                    }
                }
                this._content = null;
                this._decl = null;
                this._disposed = true;
                this._url = null;
            }
        }

        public function setUnknownContent(unknown:ASObject)
        {
            if (Std.is(unknown , DisplayObject))
            {
                this._content = ASCompat.dynamicAs(unknown , DisplayObject);
                if (this._content != null)
                {
                    return;
                }
                throw new ASError("Failed to convert DisplayObject to DisplayAsset!");
            }
            if (Std.is(unknown , DisplayAsset))
            {
                this._content = cast(unknown, DisplayAsset)._content;
                this._decl = cast(unknown, DisplayAsset)._decl;
                if (this._content == null)
                {
                    throw new ASError("Failed to read content from DisplayAsset!");
                }
            }
        }

        public function setFromOtherAsset(asset:IAsset)
        {
            if (Std.is(asset , DisplayAsset))
            {
                this._content = cast(asset, DisplayAsset)._content;
                this._decl = cast(asset, DisplayAsset)._decl;
            }
            else
            {
                throw new ASError("Provided asset should be of type DisplayAsset!");
            }
        }

        public function setParamsDesc(xml:com.sulake.core.utils.xml.XMLList)
        {
        }
    }

