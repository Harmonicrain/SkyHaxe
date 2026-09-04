package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class IssueInfoMessageParser implements IMessageParser
    {
        var _issueData:IssueMessageData;


        public var _Str_22192(get,never):IssueMessageData;
function  get__Str_22192():IssueMessageData
        {
            return this._issueData;
        }

        public function flush():Bool
        {
            if (this._issueData != null)
            {
            }
            this._issueData = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3= k.readInteger();
            var _local_4= k.readInteger();
            var _local_5= k.readInteger();
            var _local_6:Float = k.readInteger();
            var _local_7= k.readInteger();
            var _local_8= k.readInteger();
            var _local_9= k.readInteger();
            var _local_10= k.readString();
            var _local_11= k.readInteger();
            var _local_12= k.readString();
            var _local_13= k.readInteger();
            var _local_14= k.readString();
            var _local_15= k.readString();
            var _local_16= k.readInteger();
            var _local_17= k.readInteger();
            var _local_18:Array<ASAny> = [];
            var _local_19 = 0;
            while (_local_19 < _local_17)
            {
                _local_18.push(new PatternMatchData(k));
                _local_19++;
            }
            this._issueData = new IssueMessageData(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9, _local_10, _local_11, _local_12, _local_13, _local_14, _local_15, _local_16, _local_18);
            return true;
        }
public function new(){}
    }

