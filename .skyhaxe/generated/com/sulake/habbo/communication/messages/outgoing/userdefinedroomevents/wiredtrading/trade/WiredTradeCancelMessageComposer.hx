package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.trade
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class WiredTradeCancelMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny> = [];
        public function getMessageArray():Array<ASAny> { return this._data; }
        public function dispose() { this._data = null; }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._data == null; }
public function new(){}
    }

