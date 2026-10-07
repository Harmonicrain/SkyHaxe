package com.sulake.core.assets
;
    import flash.media.Sound;

     class SoundAsset implements IAsset 
    {
        var _disposed:Bool = false;
        var _content:Sound = null;
        var _decl:AssetTypeDeclaration;
        var _url:String;

        public function new(k:AssetTypeDeclaration, _arg_2:String=null)
        {
            this._decl = k;
            this._url = _arg_2;
        }

        public var url(get,never):String;
public function  get_url():String
        {
            return this._url;
        }

        public var content(get,never):ASObject;
public function  get_content():ASObject
        {
            return (this._content : ASObject) ;
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

        public function setUnknownContent(unknown:ASObject)
        {
            if (Std.is(unknown , Sound))
            {
                if (this._content != null)
                {
                    this._content.close();
                }
                this._content = ASCompat.dynamicAs(unknown , Sound);
                return;
            }
            if (ASCompat.isByteArray(unknown ))
            {
            }
            if (Std.is(unknown , Class))
            {
                if (this._content != null)
                {
                    this._content.close();
                }
                this._content = ASCompat.dynamicAs(Type.createInstance(((unknown : Class<Dynamic>) ), []) , Sound);
                return;
            }
            if (Std.is(unknown , SoundAsset))
            {
                if (this._content != null)
                {
                    this._content.close();
                }
                this._content = cast(unknown, SoundAsset)._content;
                return;
            }
        }

        public function setFromOtherAsset(asset:IAsset)
        {
            if (Std.is(asset , SoundAsset))
            {
                this._content = cast(asset, SoundAsset)._content;
            }
        }

        public function setParamsDesc(xml:com.sulake.core.utils.xml.XMLList)
        {
        }
    }

