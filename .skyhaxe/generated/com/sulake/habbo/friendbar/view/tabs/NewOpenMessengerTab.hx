package com.sulake.habbo.friendbar.view.tabs
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;

     class NewOpenMessengerTab extends Tab 
    {
        static inline final ICON= "icon";
        static inline final HEADER= "header";
        static inline final NEW_OPEN_MESSENGER_TAB_XML= "new_open_messenger_tab_xml";
        static inline final DEFAULT_COLOR:UInt = 8374494;
        static inline final _Str_2841:UInt = 9560569;
        static inline final _Str_20489= 10;
        static final POOL:Array<ASAny> = [];
        static final _Str_4440:Array<ASAny> = [];


        public static function _Str_2363():NewOpenMessengerTab
        {
            var k:NewOpenMessengerTab = null;
            k = ((POOL.length > 0) ? POOL.pop() : Type.createInstance(NewOpenMessengerTab, []));
            k._Str_2638 = false;
            k._window = k._Str_18310();
            return k;
        }


        public function _Str_18310():IWindowContainer
        {
            var k:IWindowContainer = ((_Str_4440.length > 0) ? _Str_4440.pop() : Std.downcast(Tab._Str_3684.buildFromXML(((Tab.ASSETS.getAssetByName(NEW_OPEN_MESSENGER_TAB_XML).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer));
            k.addEventListener(WindowMouseEvent.CLICK, this._Str_3369);
            k.addEventListener(WindowMouseEvent.OVER, onMouseOver);
            k.addEventListener(WindowMouseEvent.OUT, onMouseOut);
            k.height = Tab.HEIGHT;
            return k;
        }

        function _Str_18874(k:IWindowContainer)
        {
            if (((k != null) && (!k.disposed)))
            {
                k.procedure = null;
                k.removeEventListener(WindowMouseEvent.CLICK, onMouseClick);
                k.removeEventListener(WindowMouseEvent.OVER, onMouseOver);
                k.removeEventListener(WindowMouseEvent.OUT, onMouseOut);
                k.width = Tab.WIDTH;
                k.height = Tab.HEIGHT;
                if (_Str_4440.indexOf(k) == -1)
                {
                    _Str_4440.push(k);
                }
            }
        }

        override public function recycle()
        {
            if (!disposed)
            {
                if (!_Str_2638)
                {
                    if (_window != null)
                    {
                        this._Str_18874(_window);
                        _window = null;
                    }
                    _Str_2638 = true;
                    POOL.push(this);
                }
            }
        }

        override function expose()
        {
            super.expose();
            _window.color = (_Str_3341 ? _Str_2841 : DEFAULT_COLOR);
        }

        override function conceal()
        {
            super.conceal();
            _window.color = (_Str_3341 ? _Str_2841 : DEFAULT_COLOR);
        }

        function _Str_3369(k:WindowMouseEvent)
        {
            if (((!disposed) && (!_Str_6044)))
            {
                Tab._Str_2925.toggleMessenger();
            }
        }

	public function new() { super(); }
    }


