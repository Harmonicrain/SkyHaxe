package com.sulake.habbo.ui.widget.furniture.customstackheight
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.handler.FurnitureCustomStackHeightWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.SetCustomStackingHeightComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;

     class CustomStackHeightWidget extends RoomWidgetBase
    {
        static inline final _Str_14570= 10;
        static inline final MAX_HEIGHT= 40;
        static inline final _Str_15538= 20;

        var _window:IWindowContainer;
        var _furniId:Int = 0;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null, _arg_4:IHabboLocalizationManager=null)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            cast(k, FurnitureCustomStackHeightWidgetHandler).widget = this;
        }

        override public function dispose()
        {
            this.destroyWindow();
            super.dispose();
        }

        override public function  get_mainWindow():IWindow
        {
            return this._window;
        }

        function createWindow()
        {
            if (this._window == null)
            {
                this._window = cast(windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(assets.getAssetByName("custom_stack_height_xml").content)), IWindowContainer);
                this._window.procedure = this.windowProcedure;
                this._window.center();
            }
        }

        public function open(k:Int, _arg_2:Float)
        {
            this._furniId = k;
            _arg_2 = Math.min(_arg_2, MAX_HEIGHT);
            if (this._window == null)
            {
                this.createWindow();
            }
            this._window.findChildByName("input_height").caption = Std.string(_arg_2);
            this._Str_18328();
            this._window.visible = true;
        }

        public function hide()
        {
            if (this._window == null)
            {
                return;
            }
            this._window.visible = false;
        }

        function destroyWindow()
        {
            if (this._window != null)
            {
                this._window.procedure = null;
                this._window.dispose();
                this._window = null;
            }
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (_arg_2 == null)
            {
                return;
            }
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "button_floor_level":
                        this._Str_19462 = 0;
                        this._Str_12076();
                        
                    case "button_above_stack":
                        this.handler.container.connection.send(new SetCustomStackingHeightComposer(this._furniId));
                        
                    case "header_button_close":
                        this.destroyWindow();
                        
                    case "slider":
                        this._window.findChildByName("slider_button").x = Std.int(cast(k, WindowMouseEvent).localX);
                        this._Str_12076();
                        
                }
            }
            else
            {
                if (((k.type == WindowMouseEvent.UP) || (k.type == WindowMouseEvent.UP_OUTSIDE)))
                {
                    switch (_arg_2.name)
                    {
                        case "slider_button":
                            this._Str_12076();
                            
                    }
                }
                else
                {
                    if (k.type == WindowMouseEvent.DOUBLE_CLICK)
                    {
                        switch (_arg_2.name)
                        {
                            case "slider_button":
                                this._Str_21486(true);
                                this._Str_12076();
                                
                        }
                    }
                    else
                    {
                        if (k.type == WindowEvent.WINDOW_EVENT_RELOCATED)
                        {
                            switch (_arg_2.name)
                            {
                                case "slider_button":
                                    this._Str_21486();
                                    
                            }
                        }
                        else
                        {
                            if (k.type == WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN)
                            {
                                if (_arg_2.name == "input_height")
                                {
                                    if (cast(k, WindowKeyboardEvent).keyCode == 13)
                                    {
                                        this._Str_18328();
                                        this._Str_12076();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        function _Str_12076()
        {
            var k= Std.int(Std.parseFloat(this._window.findChildByName("input_height").caption) * 100);
            this.handler.container.connection.send(new SetCustomStackingHeightComposer(this._furniId, k));
        }

        function _Str_18328()
        {
            var k= Std.parseFloat(this._window.findChildByName("input_height").caption);
            var _local_2= (k / _Str_14570);
            _local_2 = Math.min(_local_2, 1);
            var _local_3:Float = (this._window.findChildByName("slider").width - _Str_15538);
            this._window.procedure = null;
            this._window.findChildByName("slider_button").x = Std.int(_local_3 * _local_2);
            this._window.procedure = this.windowProcedure;
        }

        function _Str_21486(k:Bool=false)
        {
            var _local_2= (k ? 1 : 100);
            var _local_3:Float = (this._window.findChildByName("slider").width - _Str_15538);
            var _local_4= (this._window.findChildByName("slider_button").x / _local_3);
            var _local_5= ((_local_4 * _Str_14570) * _local_2);
            this._window.findChildByName("input_height").caption = Std.string((Std.int(_local_5) / (_local_2 * 1)));
        }

        var handler(get,never):FurnitureCustomStackHeightWidgetHandler;
function  get_handler():FurnitureCustomStackHeightWidgetHandler
        {
            return Std.downcast(_handler , FurnitureCustomStackHeightWidgetHandler);
        }

        var _Str_19462(never,set):Float;
function  set__Str_19462(k:Float):Float        {
            if (this._window != null)
            {
                this._window.findChildByName("input_height").caption = Std.string(k);
                this._Str_18328();
            }
return k;
        }

        public function _Str_24760(k:Int, _arg_2:Float)
        {
            if (this._furniId == k)
            {
                this._Str_19462 = _arg_2;
            }
        }
    }

