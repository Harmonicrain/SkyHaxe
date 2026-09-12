package com.sulake.habbo.help
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.window.IWindowContainer;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.habbo.help._enum.WelcomeNotificationAlignment;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;

     class WelcomeScreenController implements IUpdateReceiver 
    {
        var _habboHelp:HabboHelp;
        var _disposed:Bool = false;
        var _window:IWindowContainer;
        var _targetLoc:Point;
        var _targetIconId:String;
        var _alignment:Int = 0;
        var _clickActionId:String;

        public function new(k:HabboHelp)
        {
            this._targetLoc = new Point(72, 10);
            this._habboHelp = k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (this._habboHelp != null)
            {
                this._habboHelp.removeUpdateReceiver(this);
                this._habboHelp = null;
            }
            if (this._window != null)
            {
                this._window.findChildByName("close").removeEventListener(WindowMouseEvent.CLICK, this._Str_20454);
                this._window.findChildByName("click").removeEventListener(WindowMouseEvent.CLICK, this._Str_21239);
                this._window.dispose();
                this._window = null;
            }
            this._disposed = true;
        }

        public function showWelcomeScreen(k:String, _arg_2:String, _arg_3:Int, _arg_4:String)
        {
            if (this._disposed)
            {
                return;
            }
            this._targetIconId = k;
            this._alignment = _arg_3;
            this._clickActionId = _arg_4;
            if (this._window == null)
            {
                this._Str_10233();
            }
            var _local_5= cast(this._window.findChildByName("text"), ITextWindow);
            _local_5.caption = (("${" + _arg_2) + "}");
            _local_5.height = Std.int(_local_5.textHeight + 5);
            this.updatePosition();
            this._Str_25505();
            this._window.visible = true;
            this._window.activate();
        }

        function _Str_10233()
        {
            var k= Std.downcast(this._habboHelp.assets.getAssetByName("welcome_screen_xml") , XmlAsset);
            this._window = Std.downcast(this._habboHelp.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) ), 2) , IWindowContainer);
            var _local_2= Std.downcast(this._window.findChildByName("frame") , IFrameWindow);
            _local_2.header.visible = false;
            _local_2.content.y = (_local_2.content.y - 20);
            var _local_3= Std.downcast(this._window.findChildByName("text") , ITextWindow);
            _local_3.height = Std.int(_local_3.textHeight + 5);
            _local_2.content.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_STRETCH, false);
            _local_2.height = (_local_2.height - 20);
            this._window.findChildByName("close").addEventListener(WindowMouseEvent.CLICK, this._Str_20454);
            this._window.findChildByName("click").addEventListener(WindowMouseEvent.CLICK, this._Str_21239);
        }

        function updatePosition()
        {
            var k= this._habboHelp.toolbar.getIconLocation(this._targetIconId);
            var _local_2= this._window.findChildByName("arrow");
            var _local_3= this._window.findChildByName("arrow_right");
            if (k == null)
            {
                k = new Rectangle(0, 0, this._window.width, this._window.height);
            }
            if (this._alignment == WelcomeNotificationAlignment.LEFT)
            {
                this._targetLoc.x = 72;
                this._window.x = -this._window.width;
                _local_2.y = Std.int((this._window.height - _local_2.height) / 2);
                _local_2.visible = true;
                _local_3.visible = false;
            }
            else
            {
                this._targetLoc.x = (k.x - this._window.width);
                this._window.x = Std.int((k.x + k.width) + this._window.width);
                _local_3.y = Std.int((this._window.height - _local_2.height) / 2);
                _local_3.visible = true;
                _local_2.visible = false;
            }
            if (k != null)
            {
                this._targetLoc.y = ((k.y + (k.height / 2)) - (this._window.height / 2));
            }
            else
            {
                this._targetLoc.y = 0;
            }
            this._window.y = Std.int(this._targetLoc.y);
        }

        function _Str_20454(k:WindowMouseEvent)
        {
            this.closeWindow();
        }

        function _Str_21239(k:WindowMouseEvent)
        {
            if (this._clickActionId != null)
            {
                this._habboHelp.toolbar.toggleWindowVisibility(this._clickActionId);
            }
            this.closeWindow();
        }

        function closeWindow()
        {
            if (this._window == null)
            {
                return;
            }
            this._window.visible = false;
            this.dispose();
        }

        public function update(k:UInt)
        {
            var _local_3:Point = null;
            if (this._window == null)
            {
                this._habboHelp.removeUpdateReceiver(this);
                return;
            }
            var _local_2= Point.distance(this._window.position, this._targetLoc);
            if (_local_2 > 5)
            {
                _local_3 = Point.interpolate(this._window.position, this._targetLoc, 0.5);
                this._window.x = Std.int(_local_3.x);
                this._window.y = Std.int(_local_3.y);
            }
            else
            {
                this._window.x = Std.int(this._targetLoc.x);
                this._window.y = Std.int(this._targetLoc.y);
                this._habboHelp.removeUpdateReceiver(this);
            }
        }

        function _Str_25505()
        {
            this._habboHelp.removeUpdateReceiver(this);
            this._habboHelp.registerUpdateReceiver(this, 10);
        }

        public function onHabboToolbarEvent(k:HabboToolbarEvent)
        {
            var _local_2:Rectangle = null;
            if (this._disposed)
            {
                return;
            }
            switch (k.type)
            {
                case HabboToolbarEvent.HTE_RESIZED:
                    if (this._habboHelp != null)
                    {
                        _local_2 = this._habboHelp.toolbar.getIconLocation(this._targetIconId);
                    }
                    if (_local_2 != null)
                    {
                        this._targetLoc.y = ((_local_2.y + (_local_2.height / 2)) - (this._window.height / 2));
                        this._window.y = Std.int(this._targetLoc.y);
                    }
                    return;
                case HabboToolbarEvent.HTE_TOOLBAR_CLICK
                   | HabboToolbarEvent.HTE_GROUP_ROOM_INFO_CLICK:
                    this.closeWindow();
                    return;
            }
        }
    }

