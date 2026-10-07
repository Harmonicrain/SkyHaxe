package com.sulake.habbo.avatar.view
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.avatar.AvatarEditorView;
    import com.sulake.habbo.avatar.HabboAvatarEditorManager;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.avatar.ChangeUserNameResultMessageEvent;

     class AvatarEditorNameChangeView 
    {
        static var _Str_5899:UInt = 13232628;
        static var _Str_7150:UInt = 11129827;

        var _window:IFrameWindow;
        var _mainView:AvatarEditorView;
        var _manager:HabboAvatarEditorManager;
        var _suggestionsRenderer:AvatarEditorNameSuggestionListRenderer;
        var _checkedName:String;
        var _pendingName:String;
        var _waitingNameCheck:Bool = false;

        public function new(k:AvatarEditorView, _arg_2:Int, _arg_3:Int)
        {
            this._mainView = k;
            this._manager = this._mainView.editor.manager;
            this._window = cast(this._manager.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(Type.createInstance(HabboAvatarEditorCom.avatar_editor_name_change, []))), IFrameWindow);
            this._window.x = _arg_2;
            var _local_4= this._manager.windowManager.getDesktop(1).width;
            if ((this._window.x + this._window.width) > _local_4)
            {
                this._window.x = (_local_4 - this._window.width);
            }
            this._window.y = _arg_3;
            this._Str_7598();
        }

        function _Str_7598()
        {
            this._window.procedure = this._Str_3545;
            var k= Std.downcast(this._window.findChildByName("select_name_button") , IButtonWindow);
            if (k != null)
            {
                k.disable();
            }
        }

        public function focus()
        {
            this._window.activate();
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
                    k.caption = this._manager.localization.getLocalization("help.tutorial.name.wait_while_checking");
                }
            }
            this._waitingNameCheck = true;
        }

        function _Str_3545(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:IWindow = null;
            var _local_4:ITextFieldWindow = null;
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
                case "check_name_button":
                    this._manager.handler.checkName(this.getName());
                    this._Str_13481();
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

        public var _Str_16320(never,set):String;
public function  set__Str_16320(k:String):String        {
            this._checkedName = k;
            if (this._pendingName == this._checkedName)
            {
                return k;
            }
            this._Str_17607();
return k;
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
            this._manager.localization.registerParameter("help.tutorial.name.available", "name", this._checkedName);
            k.text = this._manager.localization.getLocalization("help.tutorial.name.available");
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
                    this._manager.localization.registerParameter("help.tutorial.name.taken", "name", _arg_2);
                    _local_4.text = this._manager.localization.getLocalization("help.tutorial.name.taken");
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_NAME_NOT_VALID => true):
                    this._manager.localization.registerParameter("help.tutorial.name.invalid", "name", _arg_2);
                    _local_4.text = this._manager.localization.getLocalization("help.tutorial.name.invalid");
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_NAME_REQUIRED => true):
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_NAME_TOO_LONG => true):
                    _local_4.text = this._manager.localization.getLocalization("help.tutorial.name.long");
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_NAME_TOO_SHORT => true):
                    _local_4.text = this._manager.localization.getLocalization("help.tutorial.name.short");
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_NAME_CHANGE_NOT_ALLOWED => true):
                    _local_4.text = this._manager.localization.getLocalization("help.tutorial.name.change_not_allowed");
                    
                case (_ == ChangeUserNameResultMessageEvent.ERROR_MERGE_HOTEL_DOWN => true):
                    _local_4.text = this._manager.localization.getLocalization("help.tutorial.name.merge_hotel_down");
                    

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
            this._suggestionsRenderer = new AvatarEditorNameSuggestionListRenderer(this._manager);
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
            k.text = this._manager.localization.getLocalization("help.tutorial.name.info");
            var _local_2= Std.downcast(this._window.findChildByName("suggestions") , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.visible = false;
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
    }


