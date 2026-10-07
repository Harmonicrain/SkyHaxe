package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;

     class PickupObjectMessageComposer implements IMessageComposer
    {
        var _objectId:Int = 0;
        var _objectCategory:Int = 0;

        public function new(k:Int, _arg_2:Int)
        {
            this._objectId = k;
            this._objectCategory = _arg_2;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            var k = 0;
            switch (this._objectCategory)
            {
                case RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE:
                    k = 2;
                    
                case RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM:
                    k = 1;
                    
                default:
                    return [];
            }
            return [k, this._objectId];
        }
    }

