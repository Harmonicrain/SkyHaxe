package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;

    /** July's room/chest transaction page envelope. */
     class WiredTransactionLogPage
    {
        public static inline final LIST_CHEST= 0;
        public static inline final LIST_ROOM= 1;

        var _listType:Int = 0;
        var _listId:Float = Math.NaN;
        var _totalLogs:Int = 0;
        var _currentPage:Int = 0;
        var _amount:Int = 0;
        var _logs:Vector<WiredTransactionInfo>;

        public function new(data:IMessageDataWrapper)
        {
var i = 0;            this._listType = data.readInteger();
            this._listId = data.readLong();
            this._totalLogs = data.readInteger();
            this._currentPage = data.readInteger();
            this._amount = data.readInteger();
            var count= WiredMessageDataValidator.readCount(
                data, 54, 100, "Wired transaction logs");
            this._logs = new Vector<WiredTransactionInfo>();
            for (_tmp_ in 0...count)
            {
i= _tmp_;
                this._logs.push(new WiredTransactionInfo(data));
            }
        }

        public var listType(get,never):Int;
public function  get_listType():Int { return this._listType; }
        public var listId(get,never):Float;
public function  get_listId():Float { return this._listId; }
        public var totalLogs(get,never):Int;
public function  get_totalLogs():Int { return this._totalLogs; }
        public var currentPage(get,never):Int;
public function  get_currentPage():Int { return this._currentPage; }
        public var amount(get,never):Int;
public function  get_amount():Int { return this._amount; }
        public var logs(get,never):Vector<WiredTransactionInfo>;
public function  get_logs():Vector<WiredTransactionInfo> { return this._logs; }
    }

