package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.habbo.ui.widget.events._Str_3858;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class BreedPetView extends AvatarContextInfoButtonView 
    {
        static inline final MODE_NORMAL= 0;

        var _mode:Int = 0;
        var _useProductItem:_Str_3858;
        var _canBreed:Bool = false;

        public function new(k:AvatarInfoWidget)
        {
            super(k);
            _Str_3403 = false;
        }

        public static function setup(k:BreedPetView, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:_Str_3858, _arg_7:Bool)
        {
            k._useProductItem = _arg_6;
            k._canBreed = _arg_7;
            AvatarContextInfoButtonView.setup(k, _arg_2, _arg_3, _arg_4, _arg_5, false);
        }


        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._useProductItem.id;
        }

        public var _Str_3710(get,never):Int;
public function  get__Str_3710():Int
        {
            return this._useProductItem._Str_3710;
        }

        override public function dispose()
        {
            if (window != null)
            {
                window.removeEventListener(WindowMouseEvent.OVER, onMouseOverOut);
                window.removeEventListener(WindowMouseEvent.OUT, onMouseOverOut);
            }
            if (this._useProductItem != null)
            {
                this._useProductItem.dispose();
            }
            this._useProductItem = null;
            super.dispose();
        }

        function _Str_18845()
        {
            var k= this.widget.handler.roomSession.roomId;
            this._mode = MODE_NORMAL;
        }

        override function updateWindow()
        {
            var k:com.sulake.core.utils.xml.XML = null;
            if ((((!(_widget != null)) || (!(_widget.assets != null))) || (!(_widget.windowManager != null))))
            {
                return;
            }
            this._Str_18845();
            if (com.sulake.habbo.ui.widget.contextmenu.ContextInfoView._Str_3452)
            {
                activeView = createMinimizedView();
            }
            else
            {
                if (window == null)
                {
                    k = ((cast(_widget.assets.getAssetByName("breed_pet_menu"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
                    _window = Std.downcast(_widget.windowManager.buildFromXML(k, 0) , IWindowContainer);
                    if (window == null)
                    {
                        return;
                    }
                    _window.addEventListener(WindowMouseEvent.OVER, onMouseOverOut);
                    _window.addEventListener(WindowMouseEvent.OUT, onMouseOverOut);
                    _window.findChildByName("minimize").addEventListener(WindowMouseEvent.CLICK, _Str_4457);
                    _window.findChildByName("minimize").addEventListener(WindowMouseEvent.OVER, onMinimizeButtonEvent);
                    _window.findChildByName("minimize").addEventListener(WindowMouseEvent.OUT, onMinimizeButtonEvent);
                }
                _buttons = Std.downcast(window.findChildByName("buttons") , IItemListWindow);
                _buttons.procedure = this.buttonEventProc;
                _window.findChildByName("name").caption = _userName;
                _window.visible = false;
                activeView = _window;
                this._Str_2771();
            }
        }

        public function _Str_2771()
        {
            if (((!(_window != null)) || (!(_buttons != null))))
            {
                return;
            }
            _buttons.autoArrangeItems = false;
            var k= _buttons.numListItems;
            var _local_2 = 0;
            while (_local_2 < k)
            {
                _buttons.getListItemAt(_local_2).visible = false;
                _local_2++;
            }
            switch (this._mode)
            {
                case MODE_NORMAL:
                    if (this._canBreed)
                    {
                        showButton("breed");
                    }
                    
            }
            _buttons.autoArrangeItems = true;
            _buttons.visible = true;
        }

        override function buttonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:RoomWidgetMessage = null;
            if (disposed)
            {
                return;
            }
            if (((!(_window != null)) || _window.disposed))
            {
                return;
            }
            var _local_3 = false;
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (_arg_2.name == "button")
                {
                    _local_3 = true;
                    switch (_arg_2.parent.name)
                    {
                        case "breed":
                            this.widget._Str_16495(this._useProductItem._Str_3710, this._useProductItem._Str_5563, false);
                            
                    }
                }
                if (_local_4 != null)
                {
                    _widget.messageListener.processWidgetMessage(_local_4);
                }
            }
            else
            {
                super.buttonEventProc(k, _arg_2);
            }
            if (_local_3)
            {
                this.widget._Str_11447();
            }
        }

        function _Str_6337(k:Int)
        {
            this._mode = k;
            this._Str_2771();
        }

        var widget(get,never):AvatarInfoWidget;
function  get_widget():AvatarInfoWidget
        {
            return Std.downcast(_widget , AvatarInfoWidget);
        }
    }




