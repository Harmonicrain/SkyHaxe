package com.sulake.habbo.ui.widget.furniture.contextmenu
;
    import com.sulake.habbo.ui.widget.contextmenu.IContextMenuParentWidget;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniActionMessage;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class RandomTeleportContextMenuView extends FurnitureContextInfoView 
    {
        var _objectCategory:Int = 0;

        public function new(k:IContextMenuParentWidget)
        {
            super(k);
        }

        override function updateWindow()
        {
            var k:com.sulake.core.utils.xml.XML = null;
            if ((((!(_widget != null)) || (!(_widget.assets != null))) || (!(_widget.windowManager != null))))
            {
                return;
            }
            if (com.sulake.habbo.ui.widget.contextmenu.ContextInfoView._Str_3452)
            {
                activeView = createMinimizedView();
            }
            else
            {
                if (window == null)
                {
                    k = ((cast(_widget.assets.getAssetByName("random_teleport_menu"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
                    _window = Std.downcast(_widget.windowManager.buildFromXML(k, 0) , IWindowContainer);
                    if (_window == null)
                    {
                        return;
                    }
                    _window.addEventListener(WindowMouseEvent.OVER, onMouseOverOut);
                    _window.addEventListener(WindowMouseEvent.OUT, onMouseOverOut);
                    _window.findChildByName("minimize").addEventListener(WindowMouseEvent.CLICK, _Str_4457);
                    _window.findChildByName("minimize").addEventListener(WindowMouseEvent.OVER, onMinimizeButtonEvent);
                    _window.findChildByName("minimize").addEventListener(WindowMouseEvent.OUT, onMinimizeButtonEvent);
                }
                _window.findChildByName("furni_name").caption = "${furni.random_teleport.name}";
                _window.findChildByName("buttons").procedure = this.buttonEventProc;
                _window.visible = false;
                activeView = _window;
                isMouseOver = false;
            }
        }

        override function buttonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            if (((disposed || (!(_window != null))) || _window.disposed))
            {
                return;
            }
            var _local_3 = false;
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (_arg_2.name == "button")
                {
                    switch (_arg_2.parent.name)
                    {
                        case "use":
                            _widget.messageListener.processWidgetMessage(new RoomWidgetFurniActionMessage(RoomWidgetFurniActionMessage.RWFAM_USE, _Str_2731.getId(), this._objectCategory));
                            
                    }
                }
                _local_3 = true;
            }
            else
            {
                super.buttonEventProc(k, _arg_2);
            }
            if (_local_3)
            {
                _widget.removeView(this, false);
            }
        }

        public var objectCategory(never,set):Int;
public function  set_objectCategory(k:Int):Int        {
            return this._objectCategory = k;
        }
    }




