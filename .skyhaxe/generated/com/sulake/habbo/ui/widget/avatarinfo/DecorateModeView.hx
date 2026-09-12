package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class DecorateModeView extends AvatarContextInfoButtonView 
    {
        public function new(k:AvatarInfoWidget, _arg_2:Int, _arg_3:String, _arg_4:Int)
        {
            super(k);
            _Str_3403 = false;
            AvatarContextInfoButtonView.setup(this, _arg_2, _arg_3, _arg_4, RoomObjectTypeEnum.HABBO);
        }

        override function updateWindow()
        {
            var k:com.sulake.core.utils.xml.XML = null;
            if ((((!(_widget != null)) || (!(_widget.assets != null))) || (!(_widget.windowManager != null))))
            {
                return;
            }
            if (_window == null)
            {
                k = ((cast(_widget.assets.getAssetByName("own_avatar_decorating"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
                _window = Std.downcast(_widget.windowManager.buildFromXML(k, 0) , IWindowContainer);
                if (_window == null)
                {
                    return;
                }
                _window.addEventListener(WindowMouseEvent.OVER, onMouseOverOut);
                _window.addEventListener(WindowMouseEvent.OUT, onMouseOverOut);
                _buttons = Std.downcast(_window.findChildByName("buttons") , IItemListWindow);
                _buttons.procedure = this._Str_5162;
                this._Str_2771();
            }
            this.activeView = _window;
        }

        override public function show()
        {
            if (_Str_3007 != null)
            {
                _Str_3007.visible = true;
                _Str_3007.activate();
            }
        }

        override public function hide(k:Bool)
        {
            if (_Str_3007 != null)
            {
                _Str_3007.visible = false;
            }
            isMouseOver = false;
        }

        override function  set_activeView(k:IWindowContainer):IWindowContainer        {
            if (k == null)
            {
                return k;
            }
            return _Str_3007 = k;
        }

        public function isVisible():Bool
        {
            return (_Str_3007 != null) && _Str_3007.visible;
        }

        public function _Str_2771()
        {
            showButton("decorate");
        }

        function _Str_5162(k:WindowEvent, _arg_2:IWindow)
        {
            if (disposed)
            {
                return;
            }
            if (((!(window != null)) || window.disposed))
            {
                return;
            }
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (_arg_2.name == "button")
                {
                    switch (_arg_2.parent.name)
                    {
                        case "decorate":
                            this.widget.isUserDecorating = false;
                            
                    }
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    super.buttonEventProc(k, _arg_2);
                    isMouseOver = true;
                }
                else
                {
                    if (k.type == WindowMouseEvent.OUT)
                    {
                        super.buttonEventProc(k, _arg_2);
                        isMouseOver = false;
                    }
                    else
                    {
                        super.buttonEventProc(k, _arg_2);
                    }
                }
            }
        }

        override public function  get_maximumBlend():Float
        {
            return 0.8;
        }

        var widget(get,never):AvatarInfoWidget;
function  get_widget():AvatarInfoWidget
        {
            return Std.downcast(_widget , AvatarInfoWidget);
        }
    }

