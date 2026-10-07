package com.sulake.habbo.ui.widget.friendrequest
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     class FriendRequestDialog 
    {
        var _window:IWindowContainer;
        var _widget:FriendRequestWidget;
        var _requestId:Int = 0;
        var _userId:Int = 0;
        var _userName:String;
        var _lockPosition:Bool = false;
        var _drag:Bool = false;
        var _deactivated:Bool = false;

        public function new(k:FriendRequestWidget, _arg_2:Int, _arg_3:Int, _arg_4:String)
        {
            this._widget = k;
            this._requestId = _arg_2;
            this._userId = _arg_3;
            this._userName = _arg_4;
        }

        public function dispose()
        {
            this._widget = null;
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = null;
        }

        function addMouseClickListener(k:IWindow, _arg_2:ASFunction)
        {
            if (k != null)
            {
                k.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
                k.addEventListener(WindowMouseEvent.CLICK, _arg_2);
            }
        }

        function createWindow()
        {
            if ((((!(this._widget != null)) || (!(this._widget.assets != null))) || (!(this._widget.windowManager != null))))
            {
                return;
            }
            var k= Std.downcast(this._widget.assets.getAssetByName("instant_friend_request") , XmlAsset);
            if (k == null)
            {
                return;
            }
            this._window = Std.downcast(this._widget.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) ), 0) , IWindowContainer);
            if (this._window == null)
            {
                return;
            }
            this._window.addEventListener(WindowEvent.WINDOW_EVENT_DEACTIVATED, this._Str_23221);
            var _local_2= Std.downcast(this._window.findChildByName("profile_region") , IRegionWindow);
            if (_local_2 != null)
            {
                _local_2.procedure = this._Str_18339;
                _local_2.toolTipCaption = this._widget.localizations.getLocalization("infostand.profile.link.tooltip", "");
                _local_2.toolTipDelay = 100;
            }
            var _local_3= Std.downcast(this._window.findChildByName("text") , ITextWindow);
            if (_local_3 != null)
            {
                _local_3.text = this._widget.localizations.registerParameter("widget.friendrequest.from", "username", this._userName);
            }
            var _local_4= this._window.findChildByName("accept_button");
            this.addMouseClickListener(_local_4, this.onAccept);
            var _local_5= this._window.findChildByName("decline_button");
            this.addMouseClickListener(_local_5, this._Str_23136);
            var _local_6= this._window.findChildByName("close_button");
            this.addMouseClickListener(_local_6, this.onCloseHandler);
            var _local_7= Std.downcast(this._window.findChildByName("profile_icon") , IIconWindow);
            _local_7.procedure = this._Str_22905;
            this._window.procedure = this._Str_3545;
            this._window.visible = false;
        }

        function _Str_3545(k:WindowEvent, _arg_2:IWindow)
        {
            if (k == null)
            {
                return;
            }
            switch (k.type)
            {
                case WindowMouseEvent.OVER:
                    this._lockPosition = true;
                    return;
                case WindowMouseEvent.OUT:
                    this._lockPosition = false;
                    return;
                case WindowMouseEvent.DOWN:
                    this._drag = true;
                    return;
                case WindowMouseEvent.UP
                   | WindowMouseEvent.UP_OUTSIDE:
                    this._drag = false;
                    return;
            }
        }

        public function _Str_16818(k:IBitmapWrapperWindow, _arg_2:String)
        {
            if ((((!(k != null)) || (!(this._widget != null))) || (!(this._widget.assets != null))))
            {
                return;
            }
            var _local_3= Std.downcast(this._widget.assets.getAssetByName(_arg_2) , BitmapDataAsset);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= ASCompat.dynamicAs(_local_3.content , BitmapData);
            if (_local_4 == null)
            {
                return;
            }
            if (k.bitmap != null)
            {
                k.bitmap.dispose();
            }
            k.bitmap = new BitmapData(k.width, k.height, true, 0);
            k.bitmap.draw(_local_4);
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public function show()
        {
            if (this._window != null)
            {
                this._window.visible = true;
                this._window.activate();
            }
        }

        public var _Str_23989(never,set):Rectangle;
public function  set__Str_23989(k:Rectangle):Rectangle        {
            var _local_5:Point = null;
            if (k == null)
            {
                this._widget._Str_22064(this._requestId);
                return k;
            }
            if ((this._lockPosition || this._drag))
            {
                return k;
            }
            var _local_2= true;
            if (this._window == null)
            {
                this.createWindow();
                _local_2 = false;
            }
            if (this._window == null)
            {
                return k;
            }
            var _local_3= new Point(((k.left + (k.width / 2)) - (this._window.width / 2)), ((k.top - this._window.height) + 10));
            var _local_4= Point.distance(this._window.position, _local_3);
            if ((_local_2 && (_local_4 > 5)))
            {
                _local_5 = Point.interpolate(this._window.position, _local_3, 0.5);
                this._window.x = Std.int(_local_5.x);
                this._window.y = Std.int(_local_5.y);
            }
            else
            {
                this._window.x = Std.int(_local_3.x);
                this._window.y = Std.int(_local_3.y);
            }
            if (!this._window.visible)
            {
                this.show();
            }
            if (this._deactivated)
            {
                this.show();
                this._deactivated = false;
            }
return k;
        }

        function _Str_23221(k:WindowEvent)
        {
            this._deactivated = true;
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            if (this._widget != null)
            {
                this._widget._Str_22064(this._requestId);
            }
        }

        function onAccept(k:WindowMouseEvent)
        {
            if (this._widget != null)
            {
                this._widget._Str_11273(this._requestId);
            }
        }

        function _Str_23136(k:WindowMouseEvent)
        {
            if (this._widget != null)
            {
                this._widget._Str_12175(this._requestId);
            }
        }

        function _Str_18339(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:ITextWindow = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._widget.showProfile(this._userId, "instantFriendRequest_name");
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                _local_3 = Std.downcast(this._window.findChildByName("text") , ITextWindow);
                _local_3.underline = true;
            }
            if (k.type == WindowMouseEvent.OUT)
            {
                _local_3 = Std.downcast(this._window.findChildByName("text") , ITextWindow);
                _local_3.underline = false;
            }
        }

        function _Str_22905(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:IIconWindow = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._widget.showProfile(this._userId, "instantFriendRequest_icon");
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                _local_3 = Std.downcast(this._window.findChildByName("profile_icon") , IIconWindow);
                _local_3.style = 22;
                _local_3.invalidate();
            }
            if (k.type == WindowMouseEvent.OUT)
            {
                _local_3 = Std.downcast(this._window.findChildByName("profile_icon") , IIconWindow);
                _local_3.style = 21;
                _local_3.invalidate();
            }
        }
    }

