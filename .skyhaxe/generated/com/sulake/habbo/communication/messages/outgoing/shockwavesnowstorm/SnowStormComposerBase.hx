package com.sulake.habbo.communication.messages.outgoing.shockwavesnowstorm
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SnowStormComposerBase implements IMessageComposer
    {
        var _message:Array<ASAny> = [];
        public function getMessageArray():Array<ASAny> { return this._message; }
        public function dispose() { this._message = null; }

	public function new() {}
    }

