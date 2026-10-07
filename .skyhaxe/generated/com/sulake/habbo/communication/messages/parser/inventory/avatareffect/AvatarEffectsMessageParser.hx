package com.sulake.habbo.communication.messages.parser.inventory.avatareffect
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.avatareffect.AvatarEffect;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AvatarEffectsMessageParser implements IMessageParser
    {
        var _effects:Array<ASAny>;


        public function flush():Bool
        {
            this._effects = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:AvatarEffect = null;
            this._effects = new Array<ASAny>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new AvatarEffect();
                _local_4.type = k.readInteger();
                _local_4.subType = k.readInteger();
                _local_4.duration = k.readInteger();
                _local_4.amount = k.readInteger();
                _local_4.secondsRemaining = k.readInteger();
                _local_4.isPermanent = k.readBoolean();
                this._effects.push(_local_4);
                _local_3++;
            }
            return true;
        }

        public var effects(get,never):Array<ASAny>;
public function  get_effects():Array<ASAny>
        {
            return this._effects;
        }

	public function new() {}
    }

