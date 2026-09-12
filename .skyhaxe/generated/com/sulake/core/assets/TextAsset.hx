package com.sulake.core.assets
;
    import flash.utils.ByteArray;

     class TextAsset implements IAsset 
    {
        var _disposed:Bool = false;
        var _content:String = "";
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

        public function setUnknownContent(unknown:ASObject)
        {
            var data:com.sulake.core.utils.ByteArray = null;
            if (Std.is(unknown , String))
            {
                this._content = ASCompat.asString(unknown );
                return;
            }
            if (Std.is(unknown , Class))
            {
                data = ASCompat.asByteArray(Type.createInstance(((unknown : Class<Dynamic>) ), []) );
                this._content = data.readUTFBytes(data.length);
                return;
            }
            if (ASCompat.isByteArray(unknown ))
            {
                data = ASCompat.asByteArray(unknown );
                this._content = data.readUTFBytes(data.length);
                return;
            }
            if (Std.is(unknown , TextAsset))
            {
                this._content = cast(unknown, TextAsset)._content;
                return;
            }
            this._content = (unknown ? Std.string(unknown) : "");
        }

        public function setFromOtherAsset(asset:IAsset)
        {
            if (Std.is(asset , TextAsset))
            {
                this._content = cast(asset, TextAsset)._content;
            }
            else
            {
                throw (cast("Provided asset is not of type TextAsset!", ASError));
            }
        }

        public function setParamsDesc(xml:com.sulake.core.utils.xml.XMLList)
        {
        }
    }

