package com.sulake.habbo.friendlist.domain
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendlist.Util;

     class FriendCategory implements IDisposable
    {
        public static inline final PAGE_SIZE= 100;
        public static inline final _Str_15031= 0;
        public static inline final _Str_7666= -1;

        var _id:Int = 0;
        var _name:String;
        var _open:Bool = false;
        var _friends:Array<ASAny>;
        var _received:Bool = false;
        var _disposed:Bool = false;
        var _view:IWindowContainer;
        var _Str_4347:Int = 0;

        public function new(k:Int, _arg_2:String)
        {
            this._friends = [];
            this._id = k;
            this._name = _arg_2;
            this._open = (!(this._id == _Str_7666));
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._view = null;
        }

        public function _Str_11247(k:Friend)
        {
            this._Str_8793(k.id);
            this._friends.push(k);
            ASCompat.ASArray.sortOn(this._friends, ["pocketHabboUser", "name"], [(ASCompat.toInt(ASCompat.ASArray.NUMERIC )| ASCompat.toInt(ASCompat.ASArray.DESCENDING)), ASCompat.ASArray.CASEINSENSITIVE]);
        }

        public function _Str_8217(k:Array<ASAny>)
        {
            var _local_2:Friend = null;
            final _iter_ = this._friends; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.selected)
                {
                    k.push(_local_2);
                }
            }
        }

        public function getFriend(k:Int):Friend
        {
            var _local_2:Friend = null;
            final _iter_ = this._friends; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.id == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function getFriendCount(k:Bool, _arg_2:Bool=false):Int
        {
            var _local_4:Friend = null;
            var _local_3 = 0;
            final _iter_ = this._friends; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                if ((((!k) || _local_4.online) && ((!_arg_2) || _local_4.followingAllowed)))
                {
                    _local_3 = (_local_3 + 1);
                }
            }
            return _local_3;
        }

        public function _Str_8793(k:Int):Friend
        {
            var _local_2= this.getFriend(k);
            if (_local_2 != null)
            {
                Util.remove(this._friends, _local_2);
                return _local_2;
            }
            return null;
        }

        function _Str_19812()
        {
            if (this._Str_4347 >= this._Str_11426())
            {
                this._Str_4347 = Std.int(Math.max(0, (this._Str_11426() - 1)));
            }
        }

        public function _Str_11426():Int
        {
            return Std.int(Math.fceil((this._friends.length / PAGE_SIZE)));
        }

        public function _Str_23845():Int
        {
            this._Str_19812();
            return this._Str_4347 * PAGE_SIZE;
        }

        public function _Str_25646():Int
        {
            this._Str_19812();
            return Std.int(Math.min(((this._Str_4347 + 1) * PAGE_SIZE), this._friends.length));
        }

        public function _Str_22255(k:Bool)
        {
            var _local_2:Friend = null;
            this._open = k;
            if (!k)
            {
                final _iter_ = this._friends; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    _local_2.selected = false;
                }
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var received(get,set):Bool;
public function  get_received():Bool
        {
            return this._received;
        }

        
        public var id(get,set):Int;
public function  get_id():Int
        {
            return this._id;
        }

        
        public var name(get,set):String;
public function  get_name():String
        {
            return this._name;
        }

        public var friends(get,never):Array<ASAny>;
public function  get_friends():Array<ASAny>
        {
            return this._friends;
        }

        
        public var view(get,set):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._view;
        }

        public var open(get,never):Bool;
public function  get_open():Bool
        {
            return this._open;
        }

        
        public var pageIndex(get,set):Int;
public function  get_pageIndex():Int
        {
            return this._Str_4347;
        }
public function  set_id(k:Int):Int        {
            return this._id = k;
        }
public function  set_name(k:String):String        {
            return this._name = k;
        }
public function  set_view(k:IWindowContainer):IWindowContainer        {
            return this._view = k;
        }
public function  set_received(k:Bool):Bool        {
            return this._received = k;
        }
public function  set_pageIndex(k:Int):Int        {
            return this._Str_4347 = k;
        }
    }

