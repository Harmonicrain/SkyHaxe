package com.sulake.core.assets
;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

     class UnknownAsset implements IAsset 
    {
        var _disposed:Bool = false;
        var _content:ASObject = null;
        var _decl:AssetTypeDeclaration;
        var _url:String;

        public function new(k:AssetTypeDeclaration, url:String=null)
        {
            this._decl = k;
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
                this._disposed = true;
                this._content = null;
                this._decl = null;
                this._url = null;
            }
        }

        public function setUnknownContent(content:ASObject)
        {
            this._content = content;
        }

        public function setFromOtherAsset(asset:IAsset)
        {
            this._content = ((asset.content : ASObject) );
        }

        public function setParamsDesc(xml:com.sulake.core.utils.xml.XMLList)
        {
        }

        public function toString():String
        {
            return (getQualifiedClassName(this) + ": ") + this._content;
        }
    }

