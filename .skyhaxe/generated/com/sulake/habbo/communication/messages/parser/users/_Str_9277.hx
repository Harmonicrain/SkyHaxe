package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _Str_9277 implements IMessageParser 
    {
        var _Str_2698:Array<ASAny>;
        var _Str_2306:Int = 0;

        public function new()
        {
            this._Str_2698 = [];
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_2698 = [];
            this._Str_2306 = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_2698.push(k.readString());
                _local_3++;
            }
            return true;
        }

        public var tags(get,never):Array<ASAny>;
public function  get_tags():Array<ASAny>
        {
            return this._Str_2698.slice(0);
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._Str_2306;
        }
    }

