package com.sulake.core.assets
;
    import flash.utils.ByteArray;

     class XmlAsset implements ILazyAsset 
    {
        var _disposed:Bool = false;
        var _unknown:ASObject;
        var _content:com.sulake.core.utils.xml.XML;
        var _decl:AssetTypeDeclaration;
        var _url:String;

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
            if (this._content == null)
            {
                this.prepareLazyContent();
            }
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
                this._unknown = null;
                this._decl = null;
                this._url = null;
            }
        }

        public function setUnknownContent(unknown:ASObject)
        {
            this._content = null;
            this._unknown = unknown;
        }

        public function prepareLazyContent()
        {
            var content:com.sulake.core.utils.ByteArray = null;
            if (Std.is(this._unknown , Class))
            {
                content = ASCompat.asByteArray(Type.createInstance(((this._unknown : Class<Dynamic>) ), []) );
                this._content = new com.sulake.core.utils.xml.XML(content.readUTFBytes(content.length));
                return;
            }
            if (ASCompat.isByteArray(this._unknown ))
            {
                content = ASCompat.asByteArray(this._unknown );
                this._content = new com.sulake.core.utils.xml.XML(content.readUTFBytes(content.length));
                return;
            }
            if (Std.is(this._unknown , String))
            {
                this._content = new com.sulake.core.utils.xml.XML(ASCompat.asString(this._unknown ));
                return;
            }
            if (ASCompat.isXML(this._unknown ))
            {
                this._content = ((this._unknown : com.sulake.core.utils.xml.XML) );
                return;
            }
            if (Std.is(this._unknown , XmlAsset))
            {
                this._content = cast(this._unknown, XmlAsset)._content;
                return;
            }
        }

        public function setFromOtherAsset(asset:IAsset)
        {
            if (Std.is(asset , XmlAsset))
            {
                this._content = cast(asset, XmlAsset)._content;
            }
            else
            {
                throw (cast("Provided asset is not of type XmlAsset!", ASError));
            }
        }

        public function setParamsDesc(xml:com.sulake.core.utils.xml.XMLList)
        {
        }

        public function toString():String
        {
            var k= "XmlAsset";
            k = (k + (" _url:" + this._url));
            k = (k + (" _content:" + ASCompat.xmlToString(this._content)));
            k = (k + (" _unknown:" + this._unknown));
            return k;
        }
    }

