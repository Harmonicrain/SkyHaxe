package com.sulake.habbo.communication.messages.parser.nux
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.nux.NewUserExperienceGiftOptions;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NewUserExperienceGiftOfferParser implements IMessageParser 
    {
        var _giftOptions:Vector<NewUserExperienceGiftOptions>;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            this._giftOptions = new Vector<NewUserExperienceGiftOptions>();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._giftOptions.push(new NewUserExperienceGiftOptions(k));
                _local_3++;
            }
            return true;
        }

        public var giftOptions(get,never):Vector<NewUserExperienceGiftOptions>;
function  get_giftOptions():Vector<NewUserExperienceGiftOptions>
        {
            return this._giftOptions;
        }

	public function new() {}
    }

