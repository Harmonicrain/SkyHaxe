package com.sulake.habbo.friendlist.domain
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendRequestData;

     class FriendRequest implements IDisposable 
    {
        public static inline final _Str_5035= 1;
        public static inline final _Str_7320= 2;
        public static inline final _Str_7073= 3;
        public static inline final _Str_15312= 4;

        var _requestId:Int = 0;
        var _requesterName:String;
        var _requesterUserId:Int = 0;
        var _state:Int = 1;
        var _disposed:Bool = false;
        var _view:IWindowContainer;

        public function new(k:FriendRequestData)
        {
            this._requestId = k.requestId;
            this._requesterName = k.requesterName;
            this._requesterUserId = k.requesterUserId;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this.view != null)
            {
                this.view.destroy();
                this.view = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var requestId(get,never):Int;
public function  get_requestId():Int
        {
            return this._requestId;
        }

        public var requesterName(get,never):String;
public function  get_requesterName():String
        {
            return this._requesterName;
        }

        public var requesterUserId(get,never):Int;
public function  get_requesterUserId():Int
        {
            return this._requesterUserId;
        }

        
        public var view(get,set):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._view;
        }

        
        public var state(get,set):Int;
public function  get_state():Int
        {
            return this._state;
        }
public function  set_view(k:IWindowContainer):IWindowContainer        {
            return this._view = k;
        }
public function  set_state(k:Int):Int        {
            return this._state = k;
        }
    }

