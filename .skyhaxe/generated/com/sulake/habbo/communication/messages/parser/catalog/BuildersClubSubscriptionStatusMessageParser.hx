package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BuildersClubSubscriptionStatusMessageParser implements IMessageParser
    {
        var _secondsRemaining:Int = 0;
        var _furniLimit:Int = 0;
        var _maxFurniLimit:Int = 0;
        var _secondsRemainingWithGrace:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._secondsRemaining = k.readInteger();
            this._furniLimit = k.readInteger();
            this._maxFurniLimit = k.readInteger();
            if (k.bytesAvailable != 0)
            {
                this._secondsRemainingWithGrace = k.readInteger();
            }
            else
            {
                this._secondsRemainingWithGrace = this._secondsRemaining;
            }
            return true;
        }

        public var secondsRemaining(get,never):Int;
public function  get_secondsRemaining():Int
        {
            return this._secondsRemaining;
        }

        public var furniLimit(get,never):Int;
public function  get_furniLimit():Int
        {
            return this._furniLimit;
        }

        public var maxFurniLimit(get,never):Int;
public function  get_maxFurniLimit():Int
        {
            return this._maxFurniLimit;
        }

        public var secondsRemainingWithGrace(get,never):Int;
public function  get_secondsRemainingWithGrace():Int
        {
            return this._secondsRemainingWithGrace;
        }

	public function new() {}
    }

