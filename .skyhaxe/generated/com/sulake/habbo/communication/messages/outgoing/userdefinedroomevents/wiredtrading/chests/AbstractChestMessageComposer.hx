package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class AbstractChestMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;
        public function new(values:Array<ASAny>) { this._array = values; }
        public function getMessageArray():Array<ASAny> { return this._array; }
        public function dispose() { this._array = null; }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._array == null; }
    }

