package com.sulake.habbo.communication.messages.parser.avatar
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.avatar.OutfitData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class WardrobeMessageParser implements IMessageParser
    {
        var _state:Int = 0;
        var _outfits:Array<ASAny>;


        public function flush():Bool
        {
            this._state = 0;
            this._outfits = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:OutfitData = null;
            this._state = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new OutfitData(k);
                this._outfits.push(_local_4);
                _local_3++;
            }
            return true;
        }

        public var outfits(get,never):Array<ASAny>;
public function  get_outfits():Array<ASAny>
        {
            return this._outfits;
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return this._state;
        }

	public function new() {}
    }

