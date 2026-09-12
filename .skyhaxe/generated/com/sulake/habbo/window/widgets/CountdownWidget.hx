package com.sulake.habbo.window.widgets
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;

     class CountdownWidget implements ICountdownWidget implements  IUpdateReceiver 
    {
        public static inline final COUNTDOWN= "countdown";
        static final runningPropertyKey:String = (COUNTDOWN + ":running");
        static final digitsPropertyKey:String = (COUNTDOWN + ":digits");
        static final secondsPropertyKey:String = (COUNTDOWN + ":seconds");
        static final colorStylePropertyKey:String = (COUNTDOWN + ":color_style");
        static final runningProperty:PropertyStruct = new PropertyStruct(runningPropertyKey, false, PropertyStruct.BOOLEAN);
        static final digitsProperty:PropertyStruct = new PropertyStruct(digitsPropertyKey, 3, PropertyStruct.UINT);
        static final secondsProperty:PropertyStruct = new PropertyStruct(secondsPropertyKey, 0, PropertyStruct.INT);
        static final colorStyleProperty:PropertyStruct = new PropertyStruct(colorStylePropertyKey, 0, PropertyStruct.INT);
        static inline final COUNTDOWN_CLOCK_UNIT_= "countdown_clock_unit_";
        static final _Str_16025:Array<ASAny> = ["weeks", "days", "hours", "minutes", "seconds"];
        static final _Str_9932:Array<ASAny> = [604800, 86400, 3600, 60, 1];
        static final _Str_16425:Array<ASAny> = [100, 7, 24, 60, 60];
        static final _Str_14826:Array<ASAny> = [0, 0xFFFFFF];
        static final _Str_17827:Array<ASAny> = [3003121663, 0];

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IItemListWindow;
        var _digitWindow:IWindowContainer;
        var _separatorWindow:ITextWindow;
        var _running:Bool = false;
        var _startSeconds:Int = 0;
        var _startTime:Int = 0;
        var _colorStyle:Int = 0;
        var _displayedTime:Int = -1;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._running = ASCompat.toBool(runningProperty.value);
            this._startSeconds = ASCompat.toInt(secondsProperty.value);
            this._startTime = flash.Lib.getTimer();
            this._colorStyle = ASCompat.toInt(colorStyleProperty.value);
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("clock_base_xml").content : com.sulake.core.utils.xml.XML) )) , IItemListWindow);
            this._digitWindow = Std.downcast(this._root.getListItemByName("counter") , IWindowContainer);
            this._separatorWindow = Std.downcast(this._root.getListItemByName("separator") , ITextWindow);
            this.digits = ASCompat.toUInt(digitsProperty.value);
            this._windowManager.registerUpdateReceiver(this, 10);
            this._widgetWindow.setParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN);
            this._widgetWindow.rootWindow = this._root;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._root != null)
                {
                    this._root.dispose();
                    this._root = null;
                }
                if (this._digitWindow != null)
                {
                    this._digitWindow.dispose();
                    this._digitWindow = null;
                }
                if (this._separatorWindow != null)
                {
                    this._separatorWindow.dispose();
                    this._separatorWindow = null;
                }
                if (this._widgetWindow != null)
                {
                    this._widgetWindow.rootWindow = null;
                    this._widgetWindow = null;
                }
                this._windowManager.removeUpdateReceiver(this);
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

        public function update(k:UInt)
        {
            this.refreshDisplay();
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(runningProperty.withValue(this._running));
            k.push(digitsProperty.withValue(this.digits));
            k.push(secondsProperty.withValue(this.seconds));
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
                    case runningPropertyKey:
                        this.running = ASCompat.toBool(_local_2.value);
                        
                    case digitsPropertyKey:
                        this.digits = ASCompat.toUInt(_local_2.value);
                        
                    case secondsPropertyKey:
                        this.seconds = ASCompat.toInt(_local_2.value);
                        
                    case colorStylePropertyKey:
                        this.colorStyle = ASCompat.toInt(_local_2.value);
                        
                }
            }
return k;
        }

        
        public var colorStyle(get,set):Int;
public function  get_colorStyle():Int
        {
            return this._colorStyle;
        }
public function  set_colorStyle(k:Int):Int        {
            var _local_4:IWindowContainer = null;
            var _local_5:ITextWindow = null;
            var _local_6:UInt = 0;
            var _local_7:UInt = 0;
            this._colorStyle = k;
            var _local_2= this._root.numListItems;
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = Std.downcast(this._root.getListItemAt(_local_3) , IWindowContainer);
                if (_local_4 != null)
                {
                    _local_5 = Std.downcast(_local_4.getChildByName("unit") , ITextWindow);
                    if (_local_5 != null)
                    {
                        _local_6 = _local_5.textColor;
                        _local_7 = _local_5.etchingColor;
                        if (((this._colorStyle >= 0) && (this._colorStyle < _Str_14826.length)))
                        {
                            _local_6 = ASCompat.toUInt(_Str_14826[this._colorStyle]);
                            _local_7 = ASCompat.toUInt(_Str_17827[this._colorStyle]);
                        }
                        _local_5.textColor = _local_6;
                        _local_5.etchingColor = _local_7;
                    }
                }
                _local_3++;
            }
return k;
        }

        
        public var running(get,set):Bool;
public function  get_running():Bool
        {
            return this._running;
        }
public function  set_running(k:Bool):Bool        {
            if ((this._running && (!k)))
            {
                this._startSeconds = this.seconds;
            }
            if (((!this._running) && k))
            {
                this._startTime = flash.Lib.getTimer();
            }
            return this._running = k;
        }

        
        public var digits(get,set):UInt;
public function  get_digits():UInt
        {
            return Std.int((this._root.numListItems + 1) / 2);
        }
public function  set_digits(k:UInt):UInt        {
            var _local_2 = 0;
            k = Std.int(Math.max(2, Math.min(4, k)));
            if (k != this.digits)
            {
                this._root.removeListItems();
                _local_2 = 0;
                while ((_local_2 : UInt) < k)
                {
                    if (_local_2 != 0)
                    {
                        this._root.addListItem(this._separatorWindow.clone());
                    }
                    this._root.addListItem(this._digitWindow.clone());
                    _local_2++;
                }
                this.refreshDisplay(true);
            }
return k;
        }

        
        public var seconds(get,set):Int;
public function  get_seconds():Int
        {
            return Std.int(this._running ? Std.int(Math.max(0, (this._startSeconds - ((flash.Lib.getTimer() - this._startTime) / 1000))) ): this._startSeconds);
        }
public function  set_seconds(k:Int):Int        {
            this._startSeconds = k;
            this._startTime = flash.Lib.getTimer();
            this.refreshDisplay();
return k;
        }

        function refreshDisplay(k:Bool=false)
        {
            var _local_4 = 0;
            var _local_6 = 0;
            var _local_7:IWindowContainer = null;
            var _local_8 = 0;
            var _local_2= this.seconds;
            if (((_local_2 == this._displayedTime) && (!k)))
            {
                return;
            }
            var _local_3= ASCompat.toInt(this.digits);
            _local_4 = 0;
            while (_local_4 < (_Str_9932.length - _local_3))
            {
                if (_local_2 >= _Str_9932[_local_4])
                {
                    break;
                }
                _local_4++;
            }
            var _local_5 = 0;
            while (_local_5 < _local_3)
            {
                _local_6 = (_local_4 + _local_5);
                _local_7 = Std.downcast(this._root.getListItemAt((_local_5 * 2)) , IWindowContainer);
                _local_8 = ASCompat.toInt((_local_2 / ASCompat.toNumber(_Str_9932[_local_6])) % ASCompat.toNumber(_Str_16425[_local_6]));
                _local_7.getChildByName("value").caption = (((_local_8 < 10) ? "0" : "") + Std.string(_local_8));
                _local_7.getChildByName("unit").caption = ((("${" + COUNTDOWN_CLOCK_UNIT_) + _Str_16025[_local_6]) + "}");
                _local_5++;
            }
            this._displayedTime = _local_2;
        }
    }

