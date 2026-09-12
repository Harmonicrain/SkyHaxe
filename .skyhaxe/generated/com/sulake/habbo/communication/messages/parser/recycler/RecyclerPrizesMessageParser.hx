package com.sulake.habbo.communication.messages.parser.recycler
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.recycler._Str_8691;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RecyclerPrizesMessageParser implements IMessageParser 
    {
        var _prizeLevels:Array<ASAny>;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            this._prizeLevels = new Array<ASAny>();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._prizeLevels.push(new _Str_8691(k));
                _local_3++;
            }
            return true;
        }

        public var prizeLevels(get,never):Array<ASAny>;
public function  get_prizeLevels():Array<ASAny>
        {
            return this._prizeLevels;
        }

	public function new() {}
    }

