package com.sulake.habbo.window.widgets
;
    import flash.utils.Timer;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import flash.events.TimerEvent;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.habbo.utils.FriendlyTime;

     class UpdatingTimestampWidget implements _Str_5483 
    {
        public static inline final UPDATING_TIMESTAMP= "updating_timestamp";
        static final _Str_10472:Timer = new Timer(60000);

        var _disposed:Bool = false;
        var _Str_2326:IWidgetWindow;
        var _habboWindowManagerComponent:HabboWindowManagerComponent;
        var _root:ILabelWindow;
        var _timeStamp:Float = Math.NaN;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._Str_2326 = k;
            this._habboWindowManagerComponent = _arg_2;
            this._root = Std.downcast(this._habboWindowManagerComponent.create("", WindowType.WINDOW_TYPE_LABEL, 100, WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT, new Rectangle()) , ILabelWindow);
            this._root.textColor = 0x555555;
            this._Str_2326.rootWindow = this._root;
            _Str_10472.addEventListener(TimerEvent.TIMER, (this._Str_12760 : ASAny));
            this.reset();
        }

        public function reset()
        {
            this._timeStamp = Date.now().getTime();
            this._Str_12760();
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            return [];
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
return k;
        }

        public var align(never,set):String;
public function  set_align(k:String):String        {
            return this._root.defaultTextFormat.align = k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                _Str_10472.removeEventListener(TimerEvent.TIMER, (this._Str_12760 : ASAny));
                if (this._root != null)
                {
                    this._root.dispose();
                    this._root = null;
                }
                if (this._Str_2326 != null)
                {
                    this._Str_2326.rootWindow = null;
                    this._Str_2326 = null;
                }
                this._habboWindowManagerComponent = null;
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

        
        public var timeStamp(get,set):Float;
public function  get_timeStamp():Float
        {
            return this._timeStamp;
        }
public function  set_timeStamp(k:Float):Float        {
            this._timeStamp = k;
            this._Str_12760();
return k;
        }

        function _Str_12760(k:TimerEvent=null)
        {
            if ((((this._disposed || (!(this._root != null))) || (!(this._habboWindowManagerComponent != null))) || (!(this._habboWindowManagerComponent.localization != null))))
            {
                return;
            }
            this._root.caption = FriendlyTime.format(this._habboWindowManagerComponent.localization, ((Date.now().getTime() - this._timeStamp) / 1000), ".ago", 1);
        }

	static final ___init = {

        {
            _Str_10472.start();
        }

	null;
	};
    }

