package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;

     class IlluminaInputWidget implements IIlluminaInputWidget
    {
        public static inline final ILLUMINA_INPUT= "illumina_input";
        static final buttonCaptionPropertyKey:String = (ILLUMINA_INPUT + ":button_caption");
        static final emptyMessagePropertyKey:String = (ILLUMINA_INPUT + ":empty_message");
        static final multilinePropertyKey:String = (ILLUMINA_INPUT + ":multiline");
        static final maxCharsPropertyKey:String = (ILLUMINA_INPUT + ":max_chars");
        static final _Str_15732:PropertyStruct = new PropertyStruct(buttonCaptionPropertyKey, "${widgets.chatinput.say}", PropertyStruct.STRING);
        static final _Str_15686:PropertyStruct = new PropertyStruct(emptyMessagePropertyKey, "", PropertyStruct.STRING);
        static final _Str_13245:PropertyStruct = new PropertyStruct(multilinePropertyKey, false, PropertyStruct.BOOLEAN);
        static final _Str_14030:PropertyStruct = new PropertyStruct(maxCharsPropertyKey, 0, PropertyStruct.INT);
        static inline final _Str_15913= 28;

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _submitButton:IButtonWindow;
        var _inputField:ITextFieldWindow;
        var _emptyMessageLabel:ILabelWindow;
        var _submitHandler:IIlluminaInputHandler;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("illumina_input_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._root.width = this._widgetWindow.width;
            this._submitButton = Std.downcast(this._root.findChildByName("submit") , IButtonWindow);
            this._inputField = Std.downcast(this._root.findChildByName("input") , ITextFieldWindow);
            this._emptyMessageLabel = Std.downcast(this._root.findChildByName("empty_message") , ILabelWindow);
            this.buttonCaption = ASCompat.toString(_Str_15732.value);
            this.emptyMessage = ASCompat.toString(_Str_15686.value);
            this.multiline = ASCompat.toBool(_Str_13245.value);
            this.maxChars = ASCompat.toInt(_Str_14030.value);
            this.refresh();
            this._root.procedure = this._Str_16893;
            this._widgetWindow.rootWindow = this._root;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._inputField != null)
                {
                    this._inputField = null;
                }
                this._submitButton = null;
                this._emptyMessageLabel = null;
                if (this._root != null)
                {
                    this._root.dispose();
                    this._root = null;
                }
                if (this._widgetWindow != null)
                {
                    this._widgetWindow.rootWindow = null;
                    this._widgetWindow = null;
                }
                this._windowManager = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(_Str_15732.withValue(this.buttonCaption));
            k.push(_Str_15686.withValue(this.emptyMessage));
            k.push(_Str_13245.withValue(this.multiline));
            k.push(_Str_14030.withValue(this.maxChars));
            return k;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (this._disposed)
            {
                return k;
            }
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case buttonCaptionPropertyKey:
                        this.buttonCaption = ASCompat.toString(_local_2.value);
                        
                    case emptyMessagePropertyKey:
                        this.emptyMessage = ASCompat.toString(_local_2.value);
                        
                    case multilinePropertyKey:
                        this.multiline = ASCompat.toBool(_local_2.value);
                        
                    case maxCharsPropertyKey:
                        this.maxChars = ASCompat.toInt(_local_2.value);
                        
                }
            }
return k;
        }

        
        public var buttonCaption(get,set):String;
public function  get_buttonCaption():String
        {
            return this._submitButton.caption;
        }
public function  set_buttonCaption(k:String):String        {
            this._submitButton.caption = k;
            this._submitButton.visible = ((!(k == null)) && (k.length > 0));
            this.refresh();
return k;
        }

        
        public var emptyMessage(get,set):String;
public function  get_emptyMessage():String
        {
            return this._emptyMessageLabel.caption;
        }
public function  set_emptyMessage(k:String):String        {
            return this._emptyMessageLabel.caption = k;
        }

        
        public var multiline(get,set):Bool;
public function  get_multiline():Bool
        {
            return this._inputField.multiline;
        }
public function  set_multiline(k:Bool):Bool        {
            this._inputField.multiline = k;
            this._root.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_STRETCH, k);
            this._root.height = (k ? this._widgetWindow.height : _Str_15913);
return k;
        }

        
        public var maxChars(get,set):Int;
public function  get_maxChars():Int
        {
            return this._inputField.maxChars;
        }
public function  set_maxChars(k:Int):Int        {
            return this._inputField.maxChars = k;
        }

        
        public var message(get,set):String;
public function  get_message():String
        {
            return this._inputField.caption;
        }
public function  set_message(k:String):String        {
            this._inputField.caption = k;
            this.refresh();
return k;
        }

        
        public var submitHandler(get,set):IIlluminaInputHandler;
public function  get_submitHandler():IIlluminaInputHandler
        {
            return this._submitHandler;
        }
public function  set_submitHandler(k:IIlluminaInputHandler):IIlluminaInputHandler        {
            return this._submitHandler = k;
        }

        function _Str_16893(k:WindowEvent, _arg_2:IWindow)
        {
            switch (k.type)
            {
                case WindowEvent.WINDOW_EVENT_CHANGE:
                    if ((_arg_2 : ASAny) == (this._inputField : ASAny))
                    {
                        this.refresh();
                    }
                    return;
                case WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN:
                    if (((((_arg_2 : ASAny) == (this._inputField : ASAny)) && (cast(k, WindowKeyboardEvent).charCode == 13)) && this._submitButton.visible))
                    {
                        this._Str_19598();
                    }
                    return;
                case WindowMouseEvent.CLICK:
                    if ((_arg_2 : ASAny) == (this._submitButton : ASAny))
                    {
                        this._Str_19598();
                    }
                    return;
            }
        }

        function _Str_19598()
        {
            if (this._submitHandler != null)
            {
                this._submitHandler.onInput(this._widgetWindow, this.message);
            }
        }

        function refresh()
        {
            this._emptyMessageLabel.visible = (this._inputField.length == 0);
            this._inputField.width = ((this._submitButton.visible ? this._submitButton.x : this._root.width) - (this._inputField.x * 2));
        }
    }

