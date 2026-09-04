package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredValidationErrorParameter;

     class WiredValidationErrorParser implements IMessageParser
    {
        static inline final MAX_PARAMETERS= 128;

        var _localizationKey:String;
        var _parameters:Array<ASAny>;


        public function flush():Bool
        {
            this._localizationKey = null;
            this._parameters = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            try
            {
                WiredMessageDataValidator.requireBytes(k, 6, "Wired validation error");
                this._localizationKey = k.readString();
                this._parameters = [];
                var count= WiredMessageDataValidator.readCount(k, 4,
                    MAX_PARAMETERS, "Wired validation error parameters");
                for (index in 0...count)
                {
                    this._parameters.push(new WiredValidationErrorParameter(k));
                }
                return k.bytesAvailable == 0;
            }
            catch (error:ASError)
            {
                this.flush();
                return false;
            }
            return false;
        }

        public var localizationKey(get,never):String;
function  get_localizationKey():String
        {
            return this._localizationKey;
        }

        public var parameters(get,never):Array<ASAny>;
function  get_parameters():Array<ASAny>
        {
            return this._parameters;
        }

	public function new() {}
    }

