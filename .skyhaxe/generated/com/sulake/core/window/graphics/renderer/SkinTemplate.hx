package com.sulake.core.window.graphics.renderer
;
    import com.sulake.core.window.utils.ChildEntityArray;
    import com.sulake.core.assets.IAsset;

     class SkinTemplate extends ChildEntityArray implements ISkinTemplate 
    {
        var _name:String;
        var _asset:IAsset;

        public function new(name:String, asset:IAsset)
        {
            super();
            this._name = name;
            this._asset = asset;
        }

        public var id(get,never):UInt;
public function  get_id():UInt
        {
            return 0;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var asset(get,never):IAsset;
public function  get_asset():IAsset
        {
            return this._asset;
        }

        public function dispose()
        {
            var _local_2:UInt = 0;
            var k:UInt = this.numChildren;
            _local_2 = 0;
            while (_local_2 < k)
            {
                this.removeChildAt(0);
                _local_2++;
            }
            this._asset = null;
            this._name = null;
        }
    }

