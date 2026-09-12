package com.sulake.core.window.components
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.MouseCursorType;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.events.WindowEvent;

     class RegionController extends ContainerController implements IRegionWindow 
    {
        static inline final TOOL_TIP_CAPTION= "tool_tip_caption";
        static inline final _Str_20296= "";
        static inline final TOOL_TIP_DELAY= "tool_tip_delay";
        static inline final _Str_20545:UInt = 500;

        var _Str_3681:UInt = 500;
        var _Str_3422:String = "";
        var _Str_4476:Bool = false;
        var _Str_3280:Map;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR));
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        
        public var toolTipCaption(get,set):String;
public function  set_toolTipCaption(k:String):String        {
            this._Str_3422 = ((k == null) ? "" : k);
return k;
        }
public function  get_toolTipCaption():String
        {
            return this._Str_3422;
        }

        
        public var toolTipDelay(get,set):UInt;
public function  set_toolTipDelay(k:UInt):UInt        {
            return this._Str_3681 = k;
        }
public function  get_toolTipDelay():UInt
        {
            return this._Str_3681;
        }

        public function showToolTip(k:IToolTipWindow)
        {
        }

        public function hideToolTip()
        {
        }

        public function setMouseCursorForState(k:UInt, _arg_2:UInt):UInt
        {
            if (this._Str_3280 == null)
            {
                this._Str_3280 = new Map();
            }
            var _local_3:UInt = this._Str_3280.getValue(k);
            if (((_arg_2 == MouseCursorType.DEFAULT) || (_arg_2 == -1)))
            {
                this._Str_3280.remove(k);
            }
            else
            {
                this._Str_3280.setProperty(k, _arg_2);
            }
            return _local_3;
        }

        public function getMouseCursorByState(k:UInt):UInt
        {
            if (testStateFlag(WindowState.DISABLED))
            {
                return MouseCursorType.ARROW;
            }
            if (this._Str_3280 == null)
            {
                return MouseCursorType.DEFAULT;
            }
            return ASCompat.toUInt(this._Str_3280.getValue(k));
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            var _local_3= super.update(k, _arg_2);
            if ((k : ASAny) == (this : ASAny))
            {
                InteractiveController._Str_10773(this, _arg_2);
            }
            return _local_3;
        }

        override public function  get_properties():Array<ASAny>
        {
            return InteractiveController._Str_8987(this, super.properties);
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            InteractiveController._Str_11019(this, k);
            return super.properties = k;
        }

        
        public var _Str_4074(get,set):Bool;
public function  set__Str_4074(k:Bool):Bool        {
            return this._Str_4476 = k;
        }
public function  get__Str_4074():Bool
        {
            return this._Str_4476;
        }
    }

