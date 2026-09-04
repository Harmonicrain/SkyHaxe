package com.sulake.habbo.communication.messages.parser.advertisement
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class InterstitialMessageParser implements IMessageParser 
    {
        var _canShowInterstitial:Bool = false;


        public var canShowInterstitial(get,never):Bool;
function  get_canShowInterstitial():Bool
        {
            return this._canShowInterstitial;
        }

        public function flush():Bool
        {
            this._canShowInterstitial = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._canShowInterstitial = k.readBoolean();
            return true;
        }

	public function new() {}
    }

