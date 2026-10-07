package com.sulake.habbo.friendlist
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class AlertView implements IDisposable 
    {
        static var _Str_4602:ASDictionary<ASAny,ASAny> = new ASDictionary();

        var _habboFriendList:HabboFriendList;
        var _Str_3245:IFrameWindow;
        var _Str_4188:String;
        var _title:String;
        var _disposed:Bool = false;

        public function new(k:HabboFriendList, _arg_2:String, _arg_3:String=null)
        {
            this._habboFriendList = k;
            this._Str_4188 = _arg_2;
            this._title = _arg_3;
        }

        public function show()
        {
            var k= cast(_Str_4602[this._Str_4188], IFrameWindow);
            if (k != null)
            {
                k.dispose();
            }
            this._Str_3245 = this._Str_23510();
            if (this._title != null)
            {
                this._Str_3245.caption = this._title;
            }
            this.setupContent(this._Str_3245.content);
            var _local_2= Util._Str_10228(this._habboFriendList.view.mainWindow, this._Str_3245.width, this._Str_3245.height);
            this._Str_3245.x = Std.int(_local_2.x);
            this._Str_3245.y = Std.int(_local_2.y);
            _Str_4602[this._Str_4188] = this._Str_3245;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._Str_3245 != null)
            {
                this._Str_3245.destroy();
                this._Str_3245 = null;
            }
            this._habboFriendList = null;
        }

        @:allow(com.sulake.habbo.friendlist) function setupContent(k:IWindowContainer)
        {
        }

        @:allow(com.sulake.habbo.friendlist) function onClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.dispose();
        }

        function _Str_23510():IFrameWindow
        {
            var k= cast(this._habboFriendList.getXmlWindow(this._Str_4188), IFrameWindow);
            var _local_2= k.findChildByTag("close");
            _local_2.procedure = this.onClose;
            return k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var friendList(get,never):HabboFriendList;
public function  get_friendList():HabboFriendList
        {
            return this._habboFriendList;
        }
    }

