package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueMessageData;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class UserInfoFrameCtrl implements IDisposable implements  ITrackedWindow 
    {
        var _main:ModerationManager;
        var _userId:Int = 0;
        var _frame:IFrameWindow;
        var _disposed:Bool = false;
        var _userInfoCtrl:UserInfoCtrl;
        var _issue:IssueMessageData;

        public function new(k:ModerationManager, _arg_2:Int, _arg_3:IssueMessageData=null)
        {
            this._main = k;
            this._userId = _arg_2;
            this._issue = _arg_3;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function show()
        {
            this._frame = cast(this._main.getXmlWindow("user_info_frame"), IFrameWindow);
            this._frame.caption = "User Info";
            var k= this._frame.findChildByTag("close");
            k.procedure = this.onClose;
            this._userInfoCtrl = new UserInfoCtrl(this._frame, this._main, this._issue, null, true);
            this._userInfoCtrl.load(this._frame.content, this._userId);
            this._frame.visible = true;
        }

        public function getType():Int
        {
            return WindowTracker._Str_17385;
        }

        public function getId():String
        {
            return "" + Std.string(this._userId);
        }

        public function getFrame():IFrameWindow
        {
            return this._frame;
        }

        function onClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.dispose();
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._frame != null)
            {
                this._frame.destroy();
                this._frame = null;
            }
            if (this._userInfoCtrl != null)
            {
                this._userInfoCtrl.dispose();
                this._userInfoCtrl = null;
            }
            this._issue = null;
            this._main = null;
        }
    }

