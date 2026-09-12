package org.openvideoads.util
;
    import org.openvideoads.base.Debuggable;
    import flash.display.DisplayObjectContainer;

     class Display extends Debuggable 
    {
        public static inline final NORMAL= "normal";
        public static inline final FULLSCREEN= "fullscreen";
        public static inline final THUMBNAIL= "thumbnail";

        var _displayObjectContainer:DisplayObjectContainer;
        var _displayWidth:Float = 0;
        var _displayHeight:Float = 0;
        var _displayMode:String = "normal";
        var _displaySpecification:DisplaySpecification = null;
        var _Str_16523:Bool = true;
        var _Str_18638:Float = 0;
        var _Str_17522:Float = 0;

        public function new(k:DisplayObjectContainer, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:DisplaySpecification, _arg_6:Bool, _arg_7:Float, _arg_8:Float)
        {
            super();
            this._displayObjectContainer = k;
            this._displayWidth = _arg_2;
            this._displayHeight = _arg_3;
            this._displayMode = _arg_4;
            this._displaySpecification = _arg_5;
            this._Str_16523 = _arg_6;
            this._Str_18638 = _arg_7;
            this._Str_17522 = _arg_8;
        }

        
        public var displayWidth(get,set):Float;
public function  set_displayWidth(k:Float):Float        {
            return this._displayWidth = k;
        }
public function  get_displayWidth():Float
        {
            return this._displayWidth;
        }

        
        public var displayHeight(get,set):Float;
public function  set_displayHeight(k:Float):Float        {
            return this._displayHeight = k;
        }
public function  get_displayHeight():Float
        {
            return this._displayHeight;
        }

        public var _Str_25114(get,never):Float;
public function  get__Str_25114():Float
        {
            return this._displaySpecification.width;
        }

        public var _Str_25629(get,never):Float;
public function  get__Str_25629():Float
        {
            return this._displaySpecification.height;
        }

        
        public var displayMode(get,set):String;
public function  set_displayMode(k:String):String        {
            return this._displayMode = k;
        }
public function  get_displayMode():String
        {
            return this._displayMode;
        }

        public function isNormalMode():Bool
        {
            if (this._displayMode != null)
            {
                return StringUtils._Str_2576(this._displayMode, Display.NORMAL);
            }
            return false;
        }

        public function _Str_22879():Bool
        {
            if (this._displayMode != null)
            {
                return this.isNormalMode() == false;
            }
            return false;
        }

        public var scaleX(get,never):Float;
public function  get_scaleX():Float
        {
            return this.displayWidth / this._Str_25114;
        }

        public var scaleY(get,never):Float;
public function  get_scaleY():Float
        {
            return this.displayHeight / this._Str_25629;
        }

        public var _Str_21708(get,never):Bool;
public function  get__Str_21708():Bool
        {
            return this._Str_16523;
        }

        public var _Str_25295(get,never):Float;
public function  get__Str_25295():Float
        {
            return this._Str_18638;
        }

        public var _Str_22782(get,never):Float;
public function  get__Str_22782():Float
        {
            return this._Str_17522;
        }

        public function getActiveMargin(k:Bool=false):Float
        {
            if (this._Str_21708)
            {
                return this._displaySpecification.marginsSpecification.getWithControlsMargin(this.displayMode, k);
            }
            return this._displaySpecification.marginsSpecification.getWithoutControlsMargin(this.displayMode, k);
        }

        public function getMarginAdjustedHeight(k:Bool=false):Float
        {
            return this.displayHeight - this.getActiveMargin(k);
        }

        
        public var displayObjectContainer(get,set):DisplayObjectContainer;
public function  set_displayObjectContainer(k:DisplayObjectContainer):DisplayObjectContainer        {
            return this._displayObjectContainer = k;
        }
public function  get_displayObjectContainer():DisplayObjectContainer
        {
            return this._displayObjectContainer;
        }

        public function clone():Display
        {
            return new Display(this._displayObjectContainer, Std.int(this._displayWidth), Std.int(this._displayHeight), this._displayMode, this._displaySpecification, this._Str_16523, this._Str_18638, this._Str_17522);
        }

        public function toString():String
        {
            return ((((("(displayWidth: " + Std.string(this._displayWidth)) + ", displayHeight: ") + Std.string(this._displayHeight)) + ", displayMode: ") + this._displayMode) + ")";
        }
    }

