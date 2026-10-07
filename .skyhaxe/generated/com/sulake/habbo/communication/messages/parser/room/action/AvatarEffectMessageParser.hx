package com.sulake.habbo.communication.messages.parser.room.action
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AvatarEffectMessageParser implements IMessageParser 
    {
        var _userId:Int = 0;
        var _effectId:Int = 0;
        var _delayMilliSeconds:Int = 0;


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var effectId(get,never):Int;
public function  get_effectId():Int
        {
            return this._effectId;
        }

        public var delayMilliSeconds(get,never):Int;
public function  get_delayMilliSeconds():Int
        {
            return this._delayMilliSeconds;
        }

        public function flush():Bool
        {
            this._userId = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._userId = k.readInteger();
            this._effectId = k.readInteger();
            this._delayMilliSeconds = k.readInteger();
            return true;
        }

	public function new() {}
    }

