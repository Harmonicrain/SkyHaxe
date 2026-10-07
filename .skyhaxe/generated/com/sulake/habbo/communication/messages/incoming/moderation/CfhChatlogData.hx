package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CfhChatlogData
    {
        var _callId:Int = 0;
        var _Str_20226:Int = 0;
        var _Str_2797:Int = 0;
        var _Str_10679:Int = 0;
        var _Str_8977:ChatRecordData;

        public function new(k:IMessageDataWrapper)
        {
            this._callId = k.readInteger();
            this._Str_20226 = k.readInteger();
            this._Str_2797 = k.readInteger();
            this._Str_10679 = k.readInteger();
            this._Str_8977 = new ChatRecordData(k);
        }

        public var callId(get,never):Int;
public function  get_callId():Int
        {
            return this._callId;
        }

        public var _Str_23592(get,never):Int;
public function  get__Str_23592():Int
        {
            return this._Str_20226;
        }

        public var reportedUserId(get,never):Int;
public function  get_reportedUserId():Int
        {
            return this._Str_2797;
        }

        public var _Str_20325(get,never):Int;
public function  get__Str_20325():Int
        {
            return this._Str_10679;
        }

        public var _Str_17106(get,never):ChatRecordData;
public function  get__Str_17106():ChatRecordData
        {
            return this._Str_8977;
        }
    }

