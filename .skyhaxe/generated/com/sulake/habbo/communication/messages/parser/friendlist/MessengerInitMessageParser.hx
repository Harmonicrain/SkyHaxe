package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendCategoryData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MessengerInitMessageParser implements IMessageParser
    {
        var _Str_19675:Int = 0;
        var _Str_20837:Int = 0;
        var _Str_21180:Int = 0;
        var _categories:Array<ASAny>;


        public function flush():Bool
        {
            this._categories = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_19675 = k.readInteger();
            this._Str_20837 = k.readInteger();
            this._Str_21180 = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._categories.push(new FriendCategoryData(k));
                _local_3++;
            }
            return true;
        }

        public var _Str_22808(get,never):Int;
public function  get__Str_22808():Int
        {
            return this._Str_19675;
        }

        public var _Str_26195(get,never):Int;
public function  get__Str_26195():Int
        {
            return this._Str_20837;
        }

        public var _Str_23653(get,never):Int;
public function  get__Str_23653():Int
        {
            return this._Str_21180;
        }

        public var categories(get,never):Array<ASAny>;
public function  get_categories():Array<ASAny>
        {
            return this._categories;
        }

	public function new() {}
    }

