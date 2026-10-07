package com.sulake.habbo.help.namechange
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.help.INameChangeUI;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ITextWindow;
    import flash.external.ExternalInterface;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.avatar.ChangeUserNameResultMessageEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class NameChangeView implements IDisposable 
    {
        static inline final FLASHEXTERNALINTERFACE_UPDATENAME= "FlashExternalInterface.updateName";
        static var _Str_5899:UInt = 13232628;
        static var _Str_7150:UInt = 11129827;

        var _controller:INameChangeUI;
        var _window:IFrameWindow;
        var _checkedName:String;
        var _pendingName:String;
        var _mainView:IWindowContainer;
        var _selectionView:IWindowContainer;
        var _confirmationView:IWindowContainer;
        var _currentView:IWindowContainer;
        var _waitingNameCheck:Bool = false;
        var _suggestionsRenderer:NameSuggestionListRenderer;
        var _disposed:Bool = false;

        public function new(k:INameChangeUI)        {
            this._controller = k;
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return NameChangeController.TUI_NAME_VIEW;
        }

        public var _Str_16320(never,set):String;
public function  set__Str_16320(k:String):String        {
            this._checkedName = k;
            if (this._pendingName == this._checkedName)
            {
                this._Str_16586();
                return k;
            }
            this._Str_17607();
return k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this.disposeWindow();
                if (this._suggestionsRenderer != null)
                {
                    this._suggestionsRenderer.dispose();
                    this._suggestionsRenderer = null;
                }
                this._disposed = true;
            }
        }

        function disposeWindow()
        {
            this._mainView = null;
            this._selectionView = null;
            this._confirmationView = null;
            this._currentView = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function showView(k:IWindowContainer)
        {
            this._waitingNameCheck = false;
            if (this._currentView != null)
            {
                this._currentView.visible = false;
            }
            this._currentView = k;
            this._currentView.visible = true;
            if (this._window != null)
            {
                this._window.content.width = this._currentView.width;
                this._window.content.height = this._currentView.height;
            }
        }

        public function _Str_22632()
        {
            if (this._window == null)
            {
                this._window = Std.downcast(this._controller.buildXmlWindow("welcome_name_change") , IFrameWindow);
                if (this._window == null)
                {
                    return;
                }
                this._window.center();
                this._window.procedure = this._Str_3545;
                this._mainView = Std.downcast(this._window.content.getChildAt(0) , IWindowContainer);
            }
            if (this._mainView == null)
            {
                return;
            }
            this._controller.localization.registerParameter("tutorial.name_change.current", "name", this._controller.myName);
            this._window.caption = this._controller.localization.getLocalization("tutorial.name_change.title.main");
            this.showView(this._mainView);
        }

        function _Str_20459()
        {
            if (this._selectionView == null)
            {
                this._selectionView = Std.downcast(this._controller.buildXmlWindow("welcome_name_selection") , IWindowContainer);
                if (this._selectionView == null)
                {
                    return;
                }
                this._window.content.addChild(this._selectionView);
            }
            this._window.caption = this._controller.localization.getLocalization("tutorial.name_change.title.select");
            var k= Std.downcast(this._window.findChildByName("select_name_button") , IButtonWindow);
            if (k != null)
            {
                k.disable();
            }
            this._Str_15733();
            this.showView(this._selectionView);
        }

        function _Str_16586()
        {
            if (this._confirmationView == null)
            {
                this._confirmationView = Std.downcast(this._controller.buildXmlWindow("welcome_name_confirmation") , IWindowContainer);
                if (this._confirmationView == null)
                {
                    return;
                }
                this._window.content.addChild(this._confirmationView);
            }
            this._window.caption = this._controller.localization.getLocalization("tutorial.name_change.title.confirm");
            var k= Std.downcast(this._confirmationView.findChildByName("final_name") , ITextWindow);
            if (k != null)
            {
                k.text = this._checkedName;
            }
            this.showView(this._confirmationView);
            if (ExternalInterface.available)
            {
                ExternalInterface.call(FLASHEXTERNALINTERFACE_UPDATENAME, [this._checkedName]);
            }
        }

        public var view(get,never):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._window;
        }

        public function _Str_15733()
        {
            if (this._window == null)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("info_text") , ITextWindow);
            if (k == null)
            {
                return;
            }
            k.text = this._controller.localization.getLocalization("help.tutorial.name.info");
            var _local_2= Std.downcast(this._window.findChildByName("suggestions") , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.visible = false;
        }

        public function _Str_17607()
        {
            if (this._window == null)
            {
                return;
            }
            this._Str_7477(true);
            var k= Std.downcast(this._window.findChildByName("info_text") , ITextWindow);
            if (k == null)
            {
                return;
            }
            this._controller.localization.registerParameter("help.tutorial.name.available", "name", this._checkedName);
            k.text = this._controller.localization.getLocalization("help.tutorial.name.available");
            var _local_2= Std.downcast(this._window.findChildByName("input") , ITextFieldWindow);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.text = this._checkedName;
            var _local_3= Std.downcast(this._window.findChildByName("suggestions") , IWindowContainer);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.visible = false;
        }

        public function _Str_14489(k:Int, _arg_2:String, _arg_3:Array<ASAny>)
        {
            var _local_8:IWindow = null;
            this._Str_7477(false);
            if (this._currentView != this._selectionView)
            {
                this._Str_20459();
            }
            this._pendingName = null;
            this._checkedName = null;
            if (this._window == null)
            {
                return;
            }
            var _local_4= Std.downcast(this._window.findChildByName("info_text") , ITextWindow);
            if (_local_4 == null)
            {
                return;
            }
            switch (k)
            {
                case (_ == ChangeUserNameResultMessageEvent.ERROR_NAME_IN_USE => true):
                    this._controller.localization.registerParameter("help.tutorial.name.taken", "name", _arg_2);
                    _local_4.text = this._controller.localization.getLocalization("help.tutorial.name.taken");
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_NAME_NOT_VALID => true):
                    this._controller.localization.registerParameter("help.tutorial.name.invalid", "name", _arg_2);
                    _local_4.text = this._controller.localization.getLocalization("help.tutorial.name.invalid");
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_NAME_REQUIRED => true):
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_NAME_TOO_LONG => true):
                    _local_4.text = this._controller.localization.getLocalization("help.tutorial.name.long");
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_NAME_TOO_SHORT => true):
                    _local_4.text = this._controller.localization.getLocalization("help.tutorial.name.short");
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_NAME_CHANGE_NOT_ALLOWED => true):
                    _local_4.text = this._controller.localization.getLocalization("help.tutorial.name.change_not_allowed");
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_MERGE_HOTEL_DOWN => true):
                    _local_4.text = this._controller.localization.getLocalization("help.tutorial.name.merge_hotel_down");
                    

default:
            }
            var _local_5= Std.downcast(this._window.findChildByName("suggestions") , IWindowContainer);
            if (_local_5 == null)
            {
                return;
            }
            if (((k == ChangeUserNameResultMessageEvent.ERROR_MERGE_HOTEL_DOWN) || (k == ChangeUserNameResultMessageEvent.ERROR_NAME_CHANGE_NOT_ALLOWED)))
            {
                _local_5.visible = false;
                return;
            }
            _local_5.visible = true;
            this._suggestionsRenderer = new NameSuggestionListRenderer(this._controller);
            var _local_6= this._suggestionsRenderer.render(_arg_3, _local_5);
            var _local_7 = 0;
            while (_local_7 < _local_5.numChildren)
            {
                _local_8 = _local_5.getChildAt(_local_7);
                _local_8.color = _Str_5899;
                _local_8.addEventListener(WindowMouseEvent.CLICK, this._Str_16049);
                _local_8.addEventListener(WindowMouseEvent.OVER, this._Str_18499);
                _local_8.addEventListener(WindowMouseEvent.OUT, this._Str_18785);
                _local_7++;
            }
        }

        function _Str_16049(k:WindowMouseEvent)
        {
            this._Str_7477(true);
            var _local_2= Std.downcast(k.target , ITextWindow);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.text;
            this._Str_15733();
            var _local_4= Std.downcast(this._window.findChildByName("input") , ITextFieldWindow);
            if (_local_4 == null)
            {
                return;
            }
            _local_4.text = _local_3;
        }

        function _Str_18499(k:WindowMouseEvent)
        {
            var _local_2= Std.downcast(k.target , ITextWindow);
            if (_local_2 != null)
            {
                _local_2.color = _Str_7150;
            }
        }

        function _Str_18785(k:WindowMouseEvent)
        {
            var _local_2= Std.downcast(k.target , ITextWindow);
            if (_local_2 != null)
            {
                _local_2.color = _Str_5899;
            }
        }

        public function _Str_13481()
        {
            var k:IWindow = null;
            if (((this._window != null) && (!this._window.disposed)))
            {
                k = this._window.findChildByName("select_name_button");
                if (k != null)
                {
                    k.disable();
                }
                k = this._window.findChildByName("check_name_button");
                if (k != null)
                {
                    k.disable();
                }
                k = this._window.findChildByName("input");
                if (k != null)
                {
                    k.disable();
                }
                k = this._window.findChildByName("info_text");
                if (k != null)
                {
                    k.caption = this._controller.localization.getLocalization("help.tutorial.name.wait_while_checking");
                }
            }
            this._waitingNameCheck = true;
        }

        public function _Str_7477(k:Bool)
        {
            var _local_2:IWindow = null;
            if (((this._window != null) && (!this._window.disposed)))
            {
                if (k)
                {
                    _local_2 = this._window.findChildByName("select_name_button");
                    if (_local_2 != null)
                    {
                        _local_2.enable();
                    }
                }
                _local_2 = this._window.findChildByName("check_name_button");
                if (_local_2 != null)
                {
                    _local_2.enable();
                }
                _local_2 = this._window.findChildByName("input");
                if (_local_2 != null)
                {
                    _local_2.enable();
                }
            }
            this._waitingNameCheck = false;
        }

        function _Str_3545(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:IWindow = null;
            var _local_4:ITextFieldWindow = null;
            var _local_5:String = null;
            if (!this._waitingNameCheck)
            {
                if (k.type == WindowEvent.WINDOW_EVENT_CHANGE)
                {
                    if (_arg_2.name == "input")
                    {
                        _local_3 = this._window.findChildByName("select_name_button");
                        _local_4 = Std.downcast(_arg_2 , ITextFieldWindow);
                        if (((_local_3 != null) && (_local_4 != null)))
                        {
                            if (_local_4.text.length > 2)
                            {
                                _local_3.enable();
                            }
                            else
                            {
                                _local_3.disable();
                            }
                        }
                    }
                }
            }
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "change_name_button":
                    this._Str_20459();
                    return;
                case "keep_name_button":
                    this._checkedName = this._controller.myName;
                    this._Str_16586();
                    return;
                case "check_name_button":
                    this._controller.checkName(this.getName());
                    this._Str_13481();
                    return;
                case "select_name_button":
                    _local_5 = this.getName();
                    if (_local_5.length < 1)
                    {
                        return;
                    }
                    if (this._checkedName != _local_5)
                    {
                        this._pendingName = _local_5;
                        this._controller.checkName(_local_5);
                        this._Str_13481();
                    }
                    else
                    {
                        this._Str_16586();
                    }
                    return;
                case "cancel_selection_button":
                    this._controller.hideView();
                    return;
                case "confirm_name_button":
                    this._controller.changeName(this._checkedName);
                    return;
                case "cancel_confirmation_button":
                    this._controller.hideView();
                    return;
                case "header_button_close":
                    this._controller.hideView();
                    return;
            }
        }

        function getName():String
        {
            var k:ITextFieldWindow = null;
            if (this._window != null)
            {
                k = Std.downcast(this._window.findChildByName("input") , ITextFieldWindow);
                if (k != null)
                {
                    return k.text;
                }
            }
            return null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

