package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CompetitionRoomsData
    {
        var _Str_5696:Int = 0;
        var _Str_4347:Int = 0;
        var _Str_18850:Int = 0;

        public function new(k:IMessageDataWrapper, _arg_2:Int=0, _arg_3:Int=0)
        {
            this._Str_5696 = _arg_2;
            this._Str_4347 = _arg_3;
            if (k != null)
            {
                this._Str_5696 = k.readInteger();
                this._Str_4347 = k.readInteger();
                this._Str_18850 = k.readInteger();
            }
        }

        public var goalId(get,never):Int;
public function  get_goalId():Int
        {
            return this._Str_5696;
        }

        public var pageIndex(get,never):Int;
public function  get_pageIndex():Int
        {
            return this._Str_4347;
        }

        public var _Str_8849(get,never):Int;
public function  get__Str_8849():Int
        {
            return this._Str_18850;
        }
    }

