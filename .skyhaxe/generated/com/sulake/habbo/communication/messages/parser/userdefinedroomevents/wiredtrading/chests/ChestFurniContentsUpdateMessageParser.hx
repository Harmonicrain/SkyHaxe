package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestStorage;

     class ChestFurniContentsUpdateMessageParser implements IMessageParser
    {
        static inline final MAX_DELTA_ITEMS= 1000;
        var _chestId:Int = 0;
        var _removedIds:Vector<Int>;
        var _addedStorage:Vector<ChestStorage>;

        public function flush():Bool
        {
            this._chestId = 0; this._removedIds = null; this._addedStorage = null; return true;
        }
        public function parse(data:IMessageDataWrapper):Bool
        {
var i = 0;            if (data.bytesAvailable < 12) { return false; }
            this._chestId = data.readInteger();
            var removedCount= data.readInteger();
            if (removedCount < 0 || removedCount > MAX_DELTA_ITEMS
                || data.bytesAvailable < (removedCount * 4 + 4 : UInt))
            {
                return false;
            }
            this._removedIds = new Vector<Int>();
            var i = 0;
            for (_tmp_ in 0...removedCount)
            {
i= _tmp_;
                this._removedIds.push(data.readInteger());
            }
            var addedCount= data.readInteger();
            if (addedCount < 0 || addedCount > MAX_DELTA_ITEMS) { return false; }
            this._addedStorage = new Vector<ChestStorage>();
            try
            {
                for (_tmp_ in 0...addedCount)
                {
i= _tmp_;
                    this._addedStorage.push(new ChestStorage(data));
                }
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                this._addedStorage = null;
                return false;
            }
 }            return data.bytesAvailable == 0;
        }
        public var chestId(get,never):Int;
public function  get_chestId():Int { return this._chestId; }
        public var removedIds(get,never):Vector<Int>;
public function  get_removedIds():Vector<Int> { return this._removedIds; }
        public var addedStorage(get,never):Vector<ChestStorage>;
public function  get_addedStorage():Vector<ChestStorage> { return this._addedStorage; }

	public function new() {}
    }

