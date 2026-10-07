package com.sulake.habbo.communication.messages.parser.inventory.avatareffect
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AvatarEffectActivatedMessageParser implements IMessageParser
    {
        var _type:Int = 0;
        var _duration:Int = 0;
        var _Str_5145:Bool = false;


        public function flush():Bool
        {
            this._type = 0;
            this._duration = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._type = k.readInteger();
            this._duration = k.readInteger();
            this._Str_5145 = k.readBoolean();
            return true;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var duration(get,never):Int;
public function  get_duration():Int
        {
            return this._duration;
        }

        public var isPermanent(get,never):Bool;
public function  get_isPermanent():Bool
        {
            return this._Str_5145;
        }

	public function new() {}
    }

