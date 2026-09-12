package com.sulake.habbo.room.utils
;
    import com.sulake.core.utils.Map;

     class PublicRoomData
    {
        var _type:String = "";
        var _worlds:Map;

        public function new(k:String)
        {
            this._type = k;
            this._worlds = new Map();
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public function addWorld(k:String, _arg_2:Float, _arg_3:Float):Bool
        {
            if (this._worlds.getValue(k) != null)
            {
                return false;
            }
            this._worlds.add(k, new PublicRoomWorldData(k, _arg_2, _arg_3));
            return true;
        }

        public function hasWorldType(k:String):Bool
        {
            return (this._worlds.getValue(k) != null);
        }

        public function getWorldScale(k:String):Float
        {
            var _local_2= ASCompat.dynamicAs(this._worlds.getValue(k) , PublicRoomWorldData);
            if (_local_2 != null)
            {
                return _local_2.scale;
            }
            return 1;
        }

        public function getWorldHeightScale(k:String):Float
        {
            var _local_2= ASCompat.dynamicAs(this._worlds.getValue(k) , PublicRoomWorldData);
            if (_local_2 != null)
            {
                return _local_2.heightScale;
            }
            return 1;
        }
    }

