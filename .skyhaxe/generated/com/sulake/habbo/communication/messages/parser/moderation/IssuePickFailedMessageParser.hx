package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class IssuePickFailedMessageParser implements IMessageParser
    {
        var _issues:Array<ASAny>;
        var _retryEnabled:Bool = false;
        var _retryCount:Int = 0;


        public var issues(get,never):Array<ASAny>;
public function  get_issues():Array<ASAny>
        {
            return this._issues;
        }

        public var retryEnabled(get,never):Bool;
public function  get_retryEnabled():Bool
        {
            return this._retryEnabled;
        }

        public var retryCount(get,never):Int;
public function  get_retryCount():Int
        {
            return this._retryCount;
        }

        public function flush():Bool
        {
            this._issues = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6:String = null;
            var _local_7:IssueMessageData = null;
            this._issues = new Array<ASAny>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readInteger();
                _local_6 = k.readString();
                _local_7 = new IssueMessageData(_local_4, 0, 0, 0, 0, 0, 0, 0, null, 0, null, _local_5, _local_6, null, 0, []);
                this._issues.push(_local_7);
                _local_3++;
            }
            this._retryEnabled = k.readBoolean();
            this._retryCount = k.readInteger();
            return true;
        }

	public function new() {}
    }

