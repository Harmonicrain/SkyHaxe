package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildMemberData 
    {
        var _groupId:Int = 0;
        var _groupName:String;
        var _baseRoomId:Int = 0;
        var _badgeCode:String;
        var _totalEntries:Int = 0;
        var _entries:Array<ASAny>;
        var _allowedToManage:Bool = false;
        var _pageSize:Int = 0;
        var _pageIndex:Int = 0;
        var _searchType:Int = 0;
        var _userNameFilter:String;
        var _usersById:ASDictionary<ASAny,ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            var _local_4:MemberData = null;
            this._usersById = new ASDictionary<ASAny,ASAny>();
            this._groupId = k.readInteger();
            this._groupName = k.readString();
            this._baseRoomId = k.readInteger();
            this._badgeCode = k.readString();
            this._totalEntries = k.readInteger();
            this._entries = new Array<ASAny>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new MemberData(k);
                this._entries.push(_local_4);
                this._usersById[_local_4.userId] = _local_4;
                _local_3++;
            }
            this._allowedToManage = k.readBoolean();
            this._pageSize = k.readInteger();
            this._pageIndex = k.readInteger();
            this._searchType = k.readInteger();
            this._userNameFilter = k.readString();
        }

        static function removeFromArray(k:Int, _arg_2:Array<ASAny>)
        {
            var _local_3 = 0;
            var _local_4:MemberData = null;
            while (_local_3 < _arg_2.length)
            {
                _local_4 = _arg_2[_local_3];
                if (_local_4.userId == k)
                {
                    _arg_2.splice(_local_3, 1);
                }
                else
                {
                    _local_3++;
                }
            }
        }


        public var groupId(get,never):Int;
public function  get_groupId():Int
        {
            return this._groupId;
        }

        public var groupName(get,never):String;
public function  get_groupName():String
        {
            return this._groupName;
        }

        public var baseRoomId(get,never):Int;
public function  get_baseRoomId():Int
        {
            return this._baseRoomId;
        }

        public var badgeCode(get,never):String;
public function  get_badgeCode():String
        {
            return this._badgeCode;
        }

        public var totalEntries(get,never):Int;
public function  get_totalEntries():Int
        {
            return this._totalEntries;
        }

        public var pageSize(get,never):Int;
public function  get_pageSize():Int
        {
            return this._pageSize;
        }

        public var pageIndex(get,never):Int;
public function  get_pageIndex():Int
        {
            return this._pageIndex;
        }

        public var searchType(get,never):Int;
public function  get_searchType():Int
        {
            return this._searchType;
        }

        public var entries(get,never):Array<ASAny>;
public function  get_entries():Array<ASAny>
        {
            return this._entries;
        }

        public var allowedToManage(get,never):Bool;
public function  get_allowedToManage():Bool
        {
            return this._allowedToManage;
        }

        public var userNameFilter(get,never):String;
public function  get_userNameFilter():String
        {
            return this._userNameFilter;
        }

        public var totalPages(get,never):Int;
public function  get_totalPages():Int
        {
            return Std.int(Math.max(1, Math.fceil((this._totalEntries / this._pageSize))));
        }

        public function update(k:MemberData)
        {
            var _local_2 = 0;
            var _local_3:MemberData = null;
            this._usersById[k.userId] = k;
            while (_local_2 < this._entries.length)
            {
                _local_3 = this._entries[_local_2];
                if (_local_3.userId == k.userId)
                {
                    this._entries[_local_2] = k;
                    return;
                }
                _local_2++;
            }
            this._entries.push(k);
        }

        public function remove(k:Int)
        {
            removeFromArray(k, this._entries);
            this._usersById.remove(k);
        }

        public function getUser(k:Int):MemberData
        {
            return this._usersById[k];
        }
    }

