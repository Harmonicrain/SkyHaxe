package com.sulake.habbo.window.widgets
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.components.ITextWindow;

     class RunningNumberWidget implements IRunningNumberWidget implements  IUpdateReceiver 
    {
        public static inline final RUNNING_NUMBER= "running_number";
        static final numberPropertyKey:String = (RUNNING_NUMBER + ":number");
        static final digitsPropertyKey:String = (RUNNING_NUMBER + ":digits");
        static final colorStylePropertyKey:String = (RUNNING_NUMBER + ":color_style");
        static final updateFrequencyPropertyKey:String = (RUNNING_NUMBER + ":update_frequency");
        static final numberProperty:PropertyStruct = new PropertyStruct(numberPropertyKey, 0, PropertyStruct.INT);
        static final digitsProperty:PropertyStruct = new PropertyStruct(digitsPropertyKey, 8, PropertyStruct.UINT);
        static final colorStyleProperty:PropertyStruct = new PropertyStruct(colorStylePropertyKey, 0, PropertyStruct.INT);
        static final updateFrequencyProperty:PropertyStruct = new PropertyStruct(updateFrequencyPropertyKey, 50, PropertyStruct.INT);

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _colorStyle:Int = 0;
        var _digits:UInt = 0;
        var _updateFrequency:Int = 0;
        var _newNumber:Int = 0;
        var _displayedNumber:Float = 0;
        var _millisSinceLastUpdate:UInt = 0;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._colorStyle = ASCompat.toInt(colorStyleProperty.value);
            this._digits = ASCompat.toUInt(digitsProperty.value);
            this._updateFrequency = ASCompat.toInt(updateFrequencyProperty.value);
            this._newNumber = ASCompat.toInt(numberProperty.value);
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("running_number_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._windowManager.registerUpdateReceiver(this, this._updateFrequency);
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

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(numberProperty.withValue(this.colorStyle));
            k.push(colorStyleProperty.withValue(this.colorStyle));
            k.push(digitsProperty.withValue(this.digits));
            k.push(updateFrequencyProperty.withValue(this.updateFrequency));
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
                    case numberPropertyKey:
                        this.number = ASCompat.toInt(_local_2.value);
                        
                    case digitsPropertyKey:
                        this.digits = ASCompat.toUInt(_local_2.value);
                        
                    case colorStylePropertyKey:
                        this.colorStyle = ASCompat.toInt(_local_2.value);
                        
                    case updateFrequencyPropertyKey:
                        this.updateFrequency = ASCompat.toInt(_local_2.value);
                        
                }
            }
return k;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }

        public function update(k:UInt)
        {
            if (this._displayedNumber < this.number)
            {
                this._millisSinceLastUpdate = (this._millisSinceLastUpdate + k);
                if (this._millisSinceLastUpdate > (this._updateFrequency : UInt))
                {
                    this._displayedNumber = Math.min(this._newNumber, (this._displayedNumber + (this._millisSinceLastUpdate / this._updateFrequency)));
                    this._millisSinceLastUpdate = (this._millisSinceLastUpdate - this._updateFrequency);
                }
                this.displayedNumber = Std.int(this._displayedNumber);
            }
        }

        var displayedNumber(never,set):UInt;
function  set_displayedNumber(k:UInt):UInt        {
            var _local_2= Std.string(k);
            while ((_local_2.length : UInt) < this._digits)
            {
                _local_2 = ("0" + _local_2);
            }
            var _local_3= cast(this._root.findChildByName("number_field"), ITextWindow);
            _local_3.text = _local_2;
            _local_3.invalidate();
return k;
        }

        
        public var digits(get,set):UInt;
public function  get_digits():UInt
        {
            return this._digits;
        }
public function  set_digits(k:UInt):UInt        {
            return this._digits = k;
        }

        
        public var colorStyle(get,set):Int;
public function  get_colorStyle():Int
        {
            return this._colorStyle;
        }
public function  set_colorStyle(k:Int):Int        {
            return this._colorStyle = k;
        }

        
        public var updateFrequency(get,set):Int;
public function  get_updateFrequency():Int
        {
            return this._updateFrequency;
        }
public function  set_updateFrequency(k:Int):Int        {
            return this._updateFrequency = k;
        }

        
        public var number(get,set):Int;
public function  get_number():Int
        {
            return this._newNumber;
        }
public function  set_number(k:Int):Int        {
            return this._newNumber = k;
        }

        public var setNumberImmediately(never,set):Int;
public function  set_setNumberImmediately(k:Int):Int        {
            this._displayedNumber = k;
            this._newNumber = k;
            this.displayedNumber = Std.int(this._displayedNumber);
return k;
        }
    }

