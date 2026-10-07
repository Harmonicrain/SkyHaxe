package com.sulake.habbo.communication.messages.parser.camera
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class InitCameraMessageParser implements IMessageParser 
    {
        var _creditPrice:Int = 0;
        var _ducketPrice:Int = 0;
        var _publishDucketPrice:Int = 0;


        public function getCreditPrice():Int
        {
            return this._creditPrice;
        }

        public function getDucketPrice():Int
        {
            return this._ducketPrice;
        }

        public function getPublishDucketPrice():Int
        {
            return this._publishDucketPrice;
        }

        public function flush():Bool
        {
            this._creditPrice = 0;
            this._ducketPrice = 0;
            this._publishDucketPrice = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._creditPrice = k.readInteger();
            this._ducketPrice = k.readInteger();
            if (k.bytesAvailable > 0)
            {
                this._publishDucketPrice = k.readInteger();
            }
            return true;
        }

	public function new() {}
    }

