package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.WiredTransactionSuccessContents;

    /** Exact July parser for S2C 2677 (local 7133). */
     class WiredTransactionSuccessMessageParser implements IMessageParser
    {
        static var _nextInternalId:Int = 1;
        var _contents:WiredTransactionSuccessContents;

        public function flush():Bool
        {
            this._contents = null;
            return true;
        }

        public function parse(data:IMessageDataWrapper):Bool
        {
            this._contents = new WiredTransactionSuccessContents(
                _nextInternalId++, data);
            return true;
        }

        public var contents(get,never):WiredTransactionSuccessContents;
public function  get_contents():WiredTransactionSuccessContents
        {
            return this._contents;
        }

	public function new() {}
    }

