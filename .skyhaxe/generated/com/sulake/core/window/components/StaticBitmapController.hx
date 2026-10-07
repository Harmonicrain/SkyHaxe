package com.sulake.core.window.components
;
    import com.sulake.core.window.utils.IBitmapDataContainer;
    import com.sulake.core.assets.IAssetReceiver;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.graphics.WindowRedrawFlag;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;

     class StaticBitmapController extends BitmapDataController implements IStaticBitmapWrapperWindow implements  IBitmapDataContainer implements  IAssetReceiver 
    {
        var _Str_6902:String;
        var _Str_5983:Bool = false;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        override public function dispose()
        {
            if (!_disposed)
            {
                if (this._Str_5983)
                {
                    _bitmapData.dispose();
                }
                super.dispose();
            }
        }

        
        public var assetUri(get,set):String;
public function  get_assetUri():String
        {
            return this._Str_6902;
        }
public function  set_assetUri(k:String):String        {
            if (this._Str_6902 == k)
            {
                return k;
            }
            this._Str_6902 = k;
            if (((k == null) || (k.length <= 0)))
            {
                if (this._Str_5983)
                {
                    _bitmapData.dispose();
                }
                _bitmapData = null;
                this._Str_5983 = false;
                _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
            }
            else
            {
                _context.getResourceManager().retrieveAsset(this._Str_6902, this);
            }
return k;
        }

        public function receiveAsset(k:IAsset, _arg_2:String)
        {
            var _local_5:Rectangle = null;
            if ((_disposed || (!_context.getResourceManager().isSameAsset(this._Str_6902, _arg_2))))
            {
                return;
            }
            var _local_3= Std.downcast(k , BitmapDataAsset);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4:BitmapData = null;
            try
            {
                _local_4 = ASCompat.dynamicAs(_local_3.content , BitmapData);
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                return;
            }
 }            if (_local_4 == null)
            {
                return;
            }
            if (_bitmapData != _local_4)
            {
                if (this._Str_5983)
                {
                    _bitmapData.dispose();
                }
                this._Str_5983 = false;
                _local_5 = _local_3.rectangle;
                if (((_local_4.width == _local_5.width) && (_local_4.height == _local_5.height)))
                {
                    _bitmapData = _local_4;
                }
                else
                {
                    _bitmapData = new BitmapData(Std.int(_local_5.width), Std.int(_local_5.height));
                    _bitmapData.copyPixels(_local_4, _local_5, new Point(0, 0));
                    this._Str_5983 = true;
                }
                _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
            }
            fitSize();
        }

        override public function clone():IWindow
        {
            var k= Std.downcast(super.clone() , StaticBitmapController);
            if (this._Str_5983)
            {
                k._bitmapData = _bitmapData.clone();
            }
            else
            {
                k._bitmapData = _bitmapData;
            }
            k._Str_6902 = this._Str_6902;
            k._Str_5983 = this._Str_5983;
            return k;
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            k.unshift(createProperty(PropertyKeys.ASSET_URI, this._Str_6902));
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.ASSET_URI:
                        this.assetUri = ASCompat.asString(_local_2.value );
                        
                }
            }
            return super.properties = k;
        }
    }

