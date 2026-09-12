package com.sulake.habbo.communication.messages.incoming.recycler
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _Str_8691 
    {
        var _Str_6714:Int = 0;
        var _Str_19614:Int = 0;
        var _prizes:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._Str_6714 = k.readInteger();
            this._Str_19614 = k.readInteger();
            this._prizes = new Array<ASAny>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._prizes.push(new _Str_7352(k));
                _local_3++;
            }
        }

        public var _Str_16418(get,never):Int;
public function  get__Str_16418():Int
        {
            return this._Str_6714;
        }

        public var _Str_24405(get,never):Int;
public function  get__Str_24405():Int
        {
            return this._Str_19614;
        }

        public var prizes(get,never):Array<ASAny>;
public function  get_prizes():Array<ASAny>
        {
            return this._prizes;
        }
    }

