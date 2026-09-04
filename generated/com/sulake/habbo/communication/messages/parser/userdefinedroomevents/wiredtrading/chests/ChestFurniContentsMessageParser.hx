package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestStorage;

     class ChestFurniContentsMessageParser implements IMessageParser
    {
        static inline final MAX_ITEMS_PER_FRAGMENT= 1000;
        var _chestId:Int = 0;
        var _totalFragments:Int = 0;
        var _fragmentNo:Int = 0;
        var _storageChunk:Vector<ChestStorage>;

        public function flush():Bool
        {
            this._chestId = 0; this._totalFragments = 0; this._fragmentNo = 0;
            this._storageChunk = null; return true;
        }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable < 16) { return false; }
            this._chestId = data.readInteger();
            this._totalFragments = data.readInteger();
            this._fragmentNo = data.readInteger();
            var count= data.readInteger();
            if (this._totalFragments < 1 || this._totalFragments > 10000
                || this._fragmentNo < 0 || this._fragmentNo >= this._totalFragments
                || count < 0 || count > MAX_ITEMS_PER_FRAGMENT)
            {
                return false;
            }
            this._storageChunk = new Vector<ChestStorage>();
            var i:Int;
            try
            {
                for (i in 0...count)
                {
                    this._storageChunk.push(new ChestStorage(data));
                }
            }
            catch (error:ASError)
            {
                this._storageChunk = null;
                return false;
            }
            return data.bytesAvailable == 0;
        }
        public var chestId(get,never):Int;
function  get_chestId():Int { return this._chestId; }
        public var totalFragments(get,never):Int;
function  get_totalFragments():Int { return this._totalFragments; }
        public var fragmentNo(get,never):Int;
function  get_fragmentNo():Int { return this._fragmentNo; }
        public var storageChunk(get,never):Vector<ChestStorage>;
function  get_storageChunk():Vector<ChestStorage> { return this._storageChunk; }

	public function new() {}
    }

