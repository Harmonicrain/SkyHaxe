package com.sulake.habbo.room.utils
;
    import com.sulake.room.object.IRoomObjectController;

     class RoomObjectBadgeImageAssetListener 
    {
        var _object:IRoomObjectController;
        var _groupBadge:Bool = false;

        public function new(object:IRoomObjectController, groupBadge:Bool)
        {
            this._object = object;
            this._groupBadge = groupBadge;
        }

        public var object(get,never):IRoomObjectController;
public function  get_object():IRoomObjectController
        {
            return this._object;
        }

        public var _Str_14095(get,never):Bool;
public function  get__Str_14095():Bool
        {
            return this._groupBadge;
        }
    }

