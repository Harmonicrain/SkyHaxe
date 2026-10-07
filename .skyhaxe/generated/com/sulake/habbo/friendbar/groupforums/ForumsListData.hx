package com.sulake.habbo.friendbar.groupforums
;
    import com.sulake.habbo.communication.messages.parser.groupforums.GetForumsListMessageParser;
    import com.sulake.habbo.communication.messages.parser.groupforums.ForumData;

     class ForumsListData 
    {
        var _listCode:Int = 0;
        var _totalAmount:Int = 0;
        var _startIndex:Int = 0;
        var _forums:Array<ASAny>;

        public function new(k:GetForumsListMessageParser)
        {
            this._listCode = k._Str_5154;
            this._totalAmount = k.totalAmount;
            this._startIndex = k.startIndex;
            this._forums = k.forums;
        }

        public var _Str_5154(get,never):Int;
public function  get__Str_5154():Int
        {
            return this._listCode;
        }

        public var totalAmount(get,never):Int;
public function  get_totalAmount():Int
        {
            return this._totalAmount;
        }

        public var startIndex(get,never):Int;
public function  get_startIndex():Int
        {
            return this._startIndex;
        }

        public var forums(get,never):Array<ASAny>;
public function  get_forums():Array<ASAny>
        {
            return this._forums;
        }

        public var _Str_9052(get,never):Int;
public function  get__Str_9052():Int
        {
            var _local_3:ForumData = null;
            var k = 0;
            var _local_2 = 0;
            while (_local_2 < this._forums.length)
            {
                _local_3 = this._forums[_local_2];
                if (_local_3._Str_18237 > 0)
                {
                    k++;
                }
                _local_2++;
            }
            return k;
        }

        public function _Str_20077(k:Int):ForumData
        {
            var _local_2:ForumData = null;
            final _iter_ = this._forums; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.groupId == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_20834(k:ForumData, _arg_2:Int)
        {
            var _local_3= this._Str_20077(k.groupId);
            if (_local_3 != null)
            {
                _local_3._Str_25309(k);
                _local_3._Str_12786 = _arg_2;
            }
        }
    }

