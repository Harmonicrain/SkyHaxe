package com.sulake.core.assets
;
    import flash.text.Font;
    import com.sulake.core.utils.FontEnum;

     class TypeFaceAsset implements IAsset 
    {
        var _decl:AssetTypeDeclaration;
        var _content:Font;
        var _disposed:Bool = false;

        public function new(k:AssetTypeDeclaration, _arg_2:String=null)
        {
            this._decl = k;
        }

        public var url(get,never):String;
public function  get_url():String
        {
            return null;
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
                this._decl = null;
                this._content = null;
                this._disposed = true;
            }
        }

        public function setUnknownContent(unknown:ASObject)
        {
            try
            {
                if (Std.is(unknown , Class))
                {
                    this._content = FontEnum.registerFont(unknown );
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                throw new ASError(("Failed to register font from resource: " + unknown));
            }
 }        }

        public function setFromOtherAsset(asset:IAsset)
        {
            if (Std.is(asset , TypeFaceAsset))
            {
                this._content = cast(asset, TypeFaceAsset)._content;
            }
            else
            {
                throw new ASError("Provided asset should be of type FontAsset!");
            }
        }

        public function setParamsDesc(xml:com.sulake.core.utils.xml.XMLList)
        {
        }
    }

