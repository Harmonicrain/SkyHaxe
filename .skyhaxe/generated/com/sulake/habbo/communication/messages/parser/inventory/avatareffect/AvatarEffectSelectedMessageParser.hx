package com.sulake.habbo.communication.messages.parser.inventory.avatareffect
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AvatarEffectSelectedMessageParser implements IMessageParser
    {
        var _type:Int = 0;


        public function flush():Bool
        {
            this._type = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._type = k.readInteger();
            return true;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

	public function new() {}
    }

