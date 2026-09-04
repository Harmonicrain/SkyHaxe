package com.sulake.habbo.communication.messages.parser.camera
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ThumbnailStatusMessageParser implements IMessageParser 
    {
        var _ok:Bool = true;
        var _renderLimitHit:Bool = false;


        public function isOk():Bool
        {
            return this._ok;
        }

        public function isRenderLimitHit():Bool
        {
            return this._renderLimitHit;
        }

        public function flush():Bool
        {
            this._ok = true;
            this._renderLimitHit = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k.bytesAvailable != 0)
            {
                this._ok = k.readBoolean();
                this._renderLimitHit = k.readBoolean();
            }
            return true;
        }

	public function new() {}
    }

