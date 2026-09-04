package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatCategory;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserFlatCatsMessageParser implements IMessageParser
    {
        var _nodes:Array<ASAny>;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._nodes = new Array<ASAny>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._nodes.push(new FlatCategory(k));
                _local_3++;
            }
            return true;
        }

        public function flush():Bool
        {
            this._nodes = null;
            return true;
        }

        public var nodes(get,never):Array<ASAny>;
function  get_nodes():Array<ASAny>
        {
            return this._nodes;
        }

	public function new() {}
    }

