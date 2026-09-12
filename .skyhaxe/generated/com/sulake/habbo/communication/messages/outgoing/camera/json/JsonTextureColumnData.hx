package com.sulake.habbo.communication.messages.outgoing.camera.json
;
     class JsonTextureColumnData 
    {
        var _assetNames:Array<ASAny>;

        public function new()
        {
            this._assetNames = new Array<ASAny>();
        }

        public function addAssetName(k:String)
        {
            this._assetNames.push(k);
        }

        public var assetNames(get,never):Array<ASAny>;
public function  get_assetNames():Array<ASAny>
        {
            return this._assetNames;
        }
    }

