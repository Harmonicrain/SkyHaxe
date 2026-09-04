package com.sulake.habbo.communication.messages.parser.groupforums
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ForumDataMessageParser implements IMessageParser
    {
        var _Str_2381:ExtendedForumData;


        public var _Str_22345(get,never):ExtendedForumData;
function  get__Str_22345():ExtendedForumData
        {
            return this._Str_2381;
        }

        public function flush():Bool
        {
            this._Str_2381 = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_2381 = ExtendedForumData._Str_4933(k);
            return true;
        }

	public function new() {}
    }

