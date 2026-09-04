package com.sulake.habbo.communication.messages.parser.newnavigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.TopLevelContext;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NavigatorMetaDataParser implements IMessageParser 
    {
        var _topLevelContexts:Vector<TopLevelContext>;


        public function flush():Bool
        {
            this._topLevelContexts = new Vector<TopLevelContext>(0);
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._topLevelContexts.push(new TopLevelContext(k));
                _local_3++;
            }
            return true;
        }

        public var _Str_23833(get,never):Vector<TopLevelContext>;
function  get__Str_23833():Vector<TopLevelContext>
        {
            return this._topLevelContexts;
        }

	public function new() {}
    }

