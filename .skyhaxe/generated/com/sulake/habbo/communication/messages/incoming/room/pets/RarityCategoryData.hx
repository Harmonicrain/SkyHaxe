package com.sulake.habbo.communication.messages.incoming.room.pets
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RarityCategoryData 
    {
        var _chance:Int = 0;
        var _breeds:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._chance = k.readInteger();
            this._breeds = [];
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._breeds.push(k.readInteger());
                _local_3++;
            }
        }

        public function dispose()
        {
            this._chance = -1;
            this._breeds = [];
        }

        public var _Str_12554(get,never):Int;
public function  get__Str_12554():Int
        {
            return this._chance;
        }

        public var breeds(get,never):Array<ASAny>;
public function  get_breeds():Array<ASAny>
        {
            return this._breeds;
        }
    }

