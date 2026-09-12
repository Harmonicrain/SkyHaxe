package com.sulake.core.assets
;
     class AssetTypeDeclaration 
    {
        var _mimeType:String;
        var _assetClass:Class<Dynamic>;
        var _loaderClass:Class<Dynamic>;
        var _fileTypes:Array<ASAny>;

        public function new(mimeType:String, assetClass:Class<Dynamic>, loaderClass:Class<Dynamic>=null,  fileTypes:Array<ASAny> = null)
        {
if (fileTypes == null) fileTypes = [];
            this._mimeType = mimeType;
            this._assetClass = assetClass;
            this._loaderClass = loaderClass;
            if (fileTypes == null)
            {
                this._fileTypes = new Array<ASAny>();
            }
            else
            {
                this._fileTypes = fileTypes;
            }
        }

        public var mimeType(get,never):String;
public function  get_mimeType():String
        {
            return this._mimeType;
        }

        public var assetClass(get,never):Class<Dynamic>;
public function  get_assetClass():Class<Dynamic>
        {
            return this._assetClass;
        }

        public var loaderClass(get,never):Class<Dynamic>;
public function  get_loaderClass():Class<Dynamic>
        {
            return this._loaderClass;
        }

        public var fileTypes(get,never):Array<ASAny>;
public function  get_fileTypes():Array<ASAny>
        {
            return this._fileTypes;
        }
    }

