package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.trade
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class WiredTradeItemsMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny> = [];
        public function new(remove:Bool, itemIds:Vector<Int>)
        {
var itemId = 0;            this._data.push(remove);
            this._data.push(itemIds.length);
            if (checkNullIteratee(itemIds)) for (_tmp_ in itemIds) { itemId = _tmp_;
this._data.push(itemId); }
        }
        public function getMessageArray():Array<ASAny> { return this._data; }
        public function dispose() { this._data = null; }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._data == null; }
    }

