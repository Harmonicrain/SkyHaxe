package com.sulake.habbo.ui.widget.furniture.friendfurni
;
    import com.sulake.habbo.ui.widget.furniture.contextmenu.FurnitureContextInfoView;
    import com.sulake.habbo.ui.widget.contextmenu.IContextMenuParentWidget;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.furniture.contextmenu.FurnitureContextMenuWidget;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.UseFurnitureMessageComposer;
    import com.sulake.core.window.events.WindowEvent;

     class FriendFurniContextMenuView extends FurnitureContextInfoView 
    {
        public function new(k:IContextMenuParentWidget)
        {
            super(k);
        }

        override function updateWindow()
        {
            var k:com.sulake.core.utils.xml.XML = null;
            var _local_2:IWindow = null;
            if ((((_widget == null) || (_widget.assets == null)) || (_widget.windowManager == null)))
            {
                return;
            }
            if (com.sulake.habbo.ui.widget.contextmenu.ContextInfoView._Str_3452)
            {
                activeView = createMinimizedView();
            }
            else
            {
                if (((window == null) || window.disposed))
                {
                    k = ((_widget.assets.getAssetByName("friendfurni_menu").content : com.sulake.core.utils.xml.XML) );
                    _window = Std.downcast(_widget.windowManager.buildFromXML(k, 0) , IWindowContainer);
                    if (window == null)
                    {
                        return;
                    }
                    window.addEventListener(WindowMouseEvent.OVER, onMouseOverOut);
                    window.addEventListener(WindowMouseEvent.OUT, onMouseOverOut);
                    _local_2 = window.findChildByName("minimize");
                    if (_local_2 != null)
                    {
                        _local_2.addEventListener(WindowMouseEvent.CLICK, _Str_4457);
                        _local_2.addEventListener(WindowMouseEvent.OVER, onMinimizeButtonEvent);
                        _local_2.addEventListener(WindowMouseEvent.OUT, onMinimizeButtonEvent);
                    }
                }
                _window.findChildByName("buttons").procedure = this.buttonEventProc;
                _window.visible = false;
                activeView = window;
                isMouseOver = false;
            }
        }

        override function buttonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:FurnitureContextMenuWidget = null;
            if (((disposed || (window == null)) || window.disposed))
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
                            _local_4 = Std.downcast(_widget , FurnitureContextMenuWidget);
                            if (_local_4 != null)
                            {
                                _local_4.handler.container.connection.send(new UseFurnitureMessageComposer(_Str_2731.getId()));
                            }
                            
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
    }

