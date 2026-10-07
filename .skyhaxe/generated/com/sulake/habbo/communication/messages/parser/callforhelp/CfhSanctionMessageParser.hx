package com.sulake.habbo.communication.messages.parser.callforhelp
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CfhSanctionTypeData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CfhSanctionMessageParser implements IMessageParser
    {
        var _issueId:Int = -1;
        var _accountId:Int = -1;
        var _sanctionType:CfhSanctionTypeData;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._issueId = k.readInteger();
            this._accountId = k.readInteger();
            this._sanctionType = new CfhSanctionTypeData(k);
            return true;
        }

        public var _Str_2869(get,never):Int;
public function  get__Str_2869():Int
        {
            return this._issueId;
        }

        public var accountId(get,never):Int;
public function  get_accountId():Int
        {
            return this._accountId;
        }

        public var _Str_21198(get,never):CfhSanctionTypeData;
public function  get__Str_21198():CfhSanctionTypeData
        {
            return this._sanctionType;
        }

        public function flush():Bool
        {
            this._issueId = -1;
            this._accountId = -1;
            this._sanctionType = null;
            return true;
        }

	public function new() {}
    }

