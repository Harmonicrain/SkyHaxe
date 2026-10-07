package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;

     class PlaceObjectMessageComposer implements IMessageComposer
    {
        var _objectId:Int = 0;
        var _objectCategory:Int = 0;
        var _wallLocation:String;
        var _x:Int = 0;
        var _y:Int = 0;
        var _dir:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:Int)
        {
            this._objectId = k;
            this._objectCategory = _arg_2;
            this._wallLocation = _arg_3;
            this._x = _arg_4;
            this._y = _arg_5;
            this._dir = _arg_6;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            switch (this._objectCategory)
            {
                case RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE:
                    return [((((((Std.string(this._objectId) + " ") + Std.string(this._x)) + " ") + Std.string(this._y)) + " ") + Std.string(this._dir))];
                case RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM:
                    return [((Std.string(this._objectId) + " ") + this._wallLocation)];
                default:
                    return [];
            }
        }
    }

