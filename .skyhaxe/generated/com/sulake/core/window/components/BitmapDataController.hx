package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.utils.IBitmapDataContainer;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.core.window._enum.PivotPoint;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.utils.PropertyStruct;

     class BitmapDataController extends WindowController implements IBitmapDataContainer 
    {
        var _bitmapData:BitmapData;
        var _pivot:UInt = 0;
        var _stretchedX:Bool = false;
        var _stretchedY:Bool = false;
        var _zoomX:Float = Math.NaN;
        var _zoomY:Float = Math.NaN;
        var _greyscale:Bool = false;
        var _etchingColor:UInt = 0;
        var _etchingPoint:Point;
        var _fitSizeToContents:Bool = false;
        var _wrapX:Bool = false;
        var _wrapY:Bool = false;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            this._etchingPoint = new Point(0, -1);
            var _local_12= _arg_5.getWindowFactory().getThemeManager().getPropertyDefaults(_arg_3);
            this._pivot = PivotPoint.pivotFromName(ASCompat.toString(_local_12.get(PropertyKeys.PIVOT_POINT).value));
            this._stretchedX = ASCompat.toBool(_local_12.get(PropertyKeys.STRETCHED_X).value);
            this._stretchedY = ASCompat.toBool(_local_12.get(PropertyKeys.STRETCHED_Y).value);
            this._zoomX = ASCompat.toNumber(_local_12.get(PropertyKeys.ZOOM_X).value);
            this._zoomY = ASCompat.toNumber(_local_12.get(PropertyKeys.ZOOM_Y).value);
            this._wrapX = ASCompat.toBool(_local_12.get(PropertyKeys.WRAP_X).value);
            this._wrapY = ASCompat.toBool(_local_12.get(PropertyKeys.WRAP_Y).value);
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        override public function dispose()
        {
            this._bitmapData = null;
            super.dispose();
        }

        
public var bitmapData(get,set):BitmapData;
public function  get_bitmapData():BitmapData
        {
            return this._bitmapData;
        }

        
        public var pivotPoint(get,set):UInt;
public function  get_pivotPoint():UInt
        {
            return this._pivot;
        }
public function  set_pivotPoint(k:UInt):UInt        {
            return this._pivot = k;
        }

        
        public var stretchedX(get,set):Bool;
public function  get_stretchedX():Bool
        {
            return this._stretchedX;
        }
public function  set_stretchedX(k:Bool):Bool        {
            return this._stretchedX = k;
        }

        
        public var stretchedY(get,set):Bool;
public function  get_stretchedY():Bool
        {
            return this._stretchedY;
        }
public function  set_stretchedY(k:Bool):Bool        {
            return this._stretchedY = k;
        }

        
        public var zoomX(get,set):Float;
public function  get_zoomX():Float
        {
            return this._zoomX;
        }
public function  set_zoomX(k:Float):Float        {
            this._zoomX = k;
            this.fitSize();
return k;
        }

        
        public var zoomY(get,set):Float;
public function  get_zoomY():Float
        {
            return this._zoomY;
        }
public function  set_zoomY(k:Float):Float        {
            this._zoomY = k;
            this.fitSize();
return k;
        }

        
        public var greyscale(get,set):Bool;
public function  get_greyscale():Bool
        {
            return this._greyscale;
        }
public function  set_greyscale(k:Bool):Bool        {
            return this._greyscale = k;
        }

        
        public var etchingColor(get,set):UInt;
public function  get_etchingColor():UInt
        {
            return this._etchingColor;
        }
public function  set_etchingColor(k:UInt):UInt        {
            return this._etchingColor = k;
        }

        
        public var fitSizeToContents(get,set):Bool;
public function  get_fitSizeToContents():Bool
        {
            return this._fitSizeToContents;
        }
public function  set_fitSizeToContents(k:Bool):Bool        {
            this._fitSizeToContents = k;
            this.fitSize();
return k;
        }

        override public function  get_etchingPoint():Point
        {
            return this._etchingPoint;
        }

        override public function  set_etching(k:Array<ASAny>):Array<ASAny>        {
            this.etchingColor = ASCompat.toUInt(k[0]);
            this._etchingPoint = new Point(ASCompat.toNumber(k[1]), ASCompat.toNumber(k[2]));
return k;
        }

        
        public var wrapX(get,set):Bool;
public function  get_wrapX():Bool
        {
            return this._wrapX;
        }
public function  set_wrapX(k:Bool):Bool        {
            return this._wrapX = k;
        }

        
        public var wrapY(get,set):Bool;
public function  get_wrapY():Bool
        {
            return this._wrapY;
        }
public function  set_wrapY(k:Bool):Bool        {
            return this._wrapY = k;
        }

        function fitSize()
        {
            if ((this._fitSizeToContents && (!(this._bitmapData == null))))
            {
                width = Std.int(Math.abs((this._bitmapData.width * this._zoomX)));
                height = Std.int(Math.abs((this._bitmapData.height * this._zoomY)));
            }
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            k.push(createProperty(PropertyKeys.PIVOT_POINT, PivotPoint.PIVOT_NAMES[ASCompat.toInt(this._pivot)]));
            k.push(createProperty(PropertyKeys.STRETCHED_X, this._stretchedX));
            k.push(createProperty(PropertyKeys.STRETCHED_Y, this._stretchedY));
            k.push(createProperty(PropertyKeys.WRAP_X, this._wrapX));
            k.push(createProperty(PropertyKeys.WRAP_Y, this._wrapY));
            k.push(createProperty(PropertyKeys.ZOOM_X, this._zoomX));
            k.push(createProperty(PropertyKeys.ZOOM_Y, this._zoomY));
            k.push(createProperty(PropertyKeys.GREYSCALE, this._greyscale));
            k.push(createProperty(PropertyKeys.ETCHING_COLOR, this._etchingColor));
            k.push(createProperty(PropertyKeys.FIT_SIZE_TO_CONTENTS, this._fitSizeToContents));
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.PIVOT_POINT:
                        this._pivot = PivotPoint.pivotFromName(ASCompat.toString(_local_2.value));
                        
                    case PropertyKeys.STRETCHED_X:
                        this._stretchedX = ASCompat.toBool(_local_2.value);
                        
                    case PropertyKeys.STRETCHED_Y:
                        this._stretchedY = ASCompat.toBool(_local_2.value);
                        
                    case PropertyKeys.ZOOM_X:
                        this._zoomX = ASCompat.toNumber(_local_2.value);
                        
                    case PropertyKeys.ZOOM_Y:
                        this._zoomY = ASCompat.toNumber(_local_2.value);
                        
                    case PropertyKeys.WRAP_X:
                        this._wrapX = ASCompat.toBool(_local_2.value);
                        
                    case PropertyKeys.WRAP_Y:
                        this._wrapY = ASCompat.toBool(_local_2.value);
                        
                    case PropertyKeys.GREYSCALE:
                        this._greyscale = ASCompat.toBool(_local_2.value);
                        
                    case PropertyKeys.ETCHING_COLOR:
                        this._etchingColor = ASCompat.toUInt(_local_2.value);
                        
                    case PropertyKeys.FIT_SIZE_TO_CONTENTS:
                        this.fitSizeToContents = ASCompat.asBoolean(_local_2.value );
                        
                }
            }
            return super.properties = k;
        }
public 
function  set_bitmapData(k:BitmapData):BitmapData{throw "Accessor unavailable on base instance: bitmapData"; return k;
}    }

