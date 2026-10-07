package com.sulake.habbo.navigator.view.search
;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import flash.ui.Keyboard;

     class SearchView 
    {
        static var _Str_17352:Array<ASAny> = [FilterModeEnum._Str_17193, FilterModeEnum._Str_17720, FilterModeEnum._Str_19005, FilterModeEnum._Str_17241, FilterModeEnum._Str_3783];
        static var _Str_18694:Array<ASAny> = [0, 2, 1, 3, 4, 0];
        static inline final _Str_15977:UInt = 0x9F9F9F;
        static inline final _Str_16807:UInt = 0;

        var _navigator:HabboNewNavigator;
        var _container:IWindowContainer;
        var _inputField:ITextFieldWindow;
        var _filterSelector:IDropMenuWindow;
        var _inputFieldPlaceholderText:String;

        public function new(k:HabboNewNavigator)
        {
            this._navigator = k;
            this._inputFieldPlaceholderText = this._navigator.localization.getLocalizationWithParams("navigator.filter.input.placeholder", "filter rooms by...");
        }

        public var container(never,set):IWindowContainer;
public function  set_container(k:IWindowContainer):IWindowContainer        {
            this._container = k;
            this._filterSelector = cast(this._container.findChildByName("filter_type_drop_menu"), IDropMenuWindow);
            this._inputField = cast(this._container.findChildByName("search_input"), ITextFieldWindow);
            this._inputField.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this._Str_15516);
            this._inputField.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this._Str_14673);
            this._inputField.addEventListener(WindowEvent.WINDOW_EVENT_FOCUSED, this._Str_22495);
            var _local_2= this._container.findChildByName("clear_search_button");
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onClearSearch);
            }
            this.clear();
return k;
        }

        function onClearSearch(k:WindowMouseEvent=null)
        {
            this._inputField.focus();
            this._inputField.caption = "";
            var _local_2= Std.downcast(this._container.findChildByName("search.clear.icon") , IStaticBitmapWrapperWindow);
            _local_2.assetUri = "common_small_pen";
        }

        public function clear()
        {
            this._Str_19423();
            this._filterSelector.selection = FilterModeEnum.DEFAULT;
            this._container.findChildByName("refreshButtonContainer").visible = false;
        }

        public function _Str_22850(k:String, _arg_2:String="")
        {
            var _local_4:IStaticBitmapWrapperWindow = null;
            var _local_3= FilterModeEnum._Str_25167(k);
            if (_local_3 != 0)
            {
                this._filterSelector.selection = ASCompat.toInt(_Str_18694[_local_3]);
                this._inputField.caption = k.substr(ASCompat.toInt(FilterModeEnum._Str_7872[_local_3].length), ASCompat.toInt(k.length - ASCompat.toNumber(FilterModeEnum._Str_7872[_local_3].length)));
            }
            else
            {
                this._inputField.caption = k;
                this._filterSelector.selection = FilterModeEnum.DEFAULT;
            }
            if (((!(_arg_2 == "")) && (!(_arg_2 == this._inputFieldPlaceholderText))))
            {
                this._inputField.caption = _arg_2;
                this._Str_13466(true);
            }
            else
            {
                if (this._inputField.caption == "")
                {
                    this._Str_19423();
                }
                else
                {
                    this._Str_13466(false);
                }
            }
            if (((!(this._inputField.caption.length == 0)) && (!(this._inputField.caption == this._inputFieldPlaceholderText))))
            {
                this._container.findChildByName("refreshButtonContainer").visible = true;
                _local_4 = Std.downcast(this._container.findChildByName("search.clear.icon") , IStaticBitmapWrapperWindow);
                _local_4.assetUri = "icons_close";
            }
            else
            {
                this._container.findChildByName("refreshButtonContainer").visible = false;
                _local_4 = Std.downcast(this._container.findChildByName("search.clear.icon") , IStaticBitmapWrapperWindow);
                _local_4.assetUri = "common_small_pen";
            }
        }

        function _Str_15516(k:WindowKeyboardEvent)
        {
            if (k.keyCode == Keyboard.ENTER)
            {
                this._navigator.performSearch(this._navigator._Str_3440.searchCodeOriginal, this._Str_24862());
            }
        }

        function _Str_24862():String
        {
            return FilterModeEnum._Str_7872[ASCompat.toInt(_Str_17352[this._filterSelector.selection])] + this._inputField.caption;
        }

        function _Str_19423()
        {
            this._Str_13466(true);
            this._inputField.caption = this._inputFieldPlaceholderText;
        }

        function _Str_22495(k:WindowEvent)
        {
            this._Str_13466(false);
            if (this._inputField.caption == this._inputFieldPlaceholderText)
            {
                this._inputField.caption = "";
            }
        }

        function _Str_13466(k:Bool)
        {
            this._inputField.textColor = (k ? _Str_15977 : _Str_16807);
            this._inputField.italic = k;
        }

        function _Str_14673(k:WindowEvent)
        {
        }

        public var _Str_25291(get,never):String;
public function  get__Str_25291():String
        {
            if (this._inputField != null)
            {
                return this._inputField.caption;
            }
            return this._inputFieldPlaceholderText;
        }
    }



