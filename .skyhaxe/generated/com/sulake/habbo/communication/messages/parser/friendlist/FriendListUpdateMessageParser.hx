package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendCategoryData;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FriendListUpdateMessageParser implements IMessageParser
    {
        var _cats:Array<ASAny>;
        var _removedFriendIds:Array<ASAny>;
        var _addedFriends:Array<ASAny>;
        var _updatedFriends:Array<ASAny>;


        public function flush():Bool
        {
            this._cats = new Array<ASAny>();
            this._removedFriendIds = new Array<ASAny>();
            this._addedFriends = new Array<ASAny>();
            this._updatedFriends = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._cats.push(new FriendCategoryData(k));
                _local_3++;
            }
            var _local_4= k.readInteger();
            _local_3 = 0;
            while (_local_3 < _local_4)
            {
                _local_5 = k.readInteger();
                if (_local_5 == -1)
                {
                    _local_6 = k.readInteger();
                    this._removedFriendIds.push(_local_6);
                }
                else
                {
                    if (_local_5 == 0)
                    {
                        this._updatedFriends.push(new FriendParser(k));
                    }
                    else
                    {
                        if (_local_5 == 1)
                        {
                            this._addedFriends.push(new FriendParser(k));
                        }
                    }
                }
                _local_3++;
            }
            return true;
        }

        public var cats(get,never):Array<ASAny>;
public function  get_cats():Array<ASAny>
        {
            return this._cats;
        }

        public var removedFriendIds(get,never):Array<ASAny>;
public function  get_removedFriendIds():Array<ASAny>
        {
            return this._removedFriendIds;
        }

        public var addedFriends(get,never):Array<ASAny>;
public function  get_addedFriends():Array<ASAny>
        {
            return this._addedFriends;
        }

        public var updatedFriends(get,never):Array<ASAny>;
public function  get_updatedFriends():Array<ASAny>
        {
            return this._updatedFriends;
        }

	public function new() {}
    }

