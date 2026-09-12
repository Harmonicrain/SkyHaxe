package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildBadgeSettings
    {
        var _partId:Int = 0;
        var _colorId:Int = 0;
        var _position:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._partId = k.readInteger();
            this._colorId = k.readInteger();
            this._position = k.readInteger();
        }

        public var partId(get,never):Int;
public function  get_partId():Int
        {
            return this._partId;
        }

        public var colorId(get,never):Int;
public function  get_colorId():Int
        {
            return this._colorId;
        }

        public var position(get,never):Int;
public function  get_position():Int
        {
            return this._position;
        }
    }

