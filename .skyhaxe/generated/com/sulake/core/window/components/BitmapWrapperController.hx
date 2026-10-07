package com.sulake.core.window.components
;
    import com.sulake.core.window.utils.IBitmapDataContainer;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.graphics.WindowRedrawFlag;
    import com.sulake.core.window.utils.PropertyStruct;

     class BitmapWrapperController extends BitmapDataController implements IBitmapWrapperWindow implements  IBitmapDataContainer 
    {
        var _handleDisposing:Bool = false;
        var _bitmapAssetName:String;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            this._handleDisposing = ASCompat.toBool(_arg_5.getWindowFactory().getThemeManager().getPropertyDefaults(_arg_3).get(PropertyKeys.HANDLE_BITMAP_DISPOSING));
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        
        public var bitmap(get,set):BitmapData;
public function  get_bitmap():BitmapData
        {
            return _bitmapData;
        }
public function  set_bitmap(k:BitmapData):BitmapData        {
            if (((this._handleDisposing && (_bitmapData != null)) && (!(k == _bitmapData))))
            {
                _bitmapData.dispose();
            }
            _bitmapData = k;
            fitSize();
            _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
return k;
        }

        public override function  set_bitmapData(k:BitmapData):BitmapData        {
            return this.bitmap = k;
        }

        
        public var bitmapAssetName(get,set):String;
public function  get_bitmapAssetName():String
        {
            return this._bitmapAssetName;
        }
public function  set_bitmapAssetName(bitmapAssetName:String):String        {
            return this._bitmapAssetName = bitmapAssetName;
        }

        
        public var disposesBitmap(get,set):Bool;
public function  get_disposesBitmap():Bool
        {
            return this._handleDisposing;
        }
public function  set_disposesBitmap(k:Bool):Bool        {
            return this._handleDisposing = k;
        }

        override public function clone():IWindow
        {
            var controller= Std.downcast(super.clone() , BitmapWrapperController);
            controller._bitmapData = ((this._handleDisposing && (_bitmapData != null)) ? _bitmapData.clone() : _bitmapData);
            controller._handleDisposing = this._handleDisposing;
            controller._bitmapAssetName = this._bitmapAssetName;
            return controller;
        }

        override public function dispose()
        {
            if (_bitmapData != null)
            {
                if (this._handleDisposing)
                {
                    _bitmapData.dispose();
                }
                _bitmapData = null;
            }
            super.dispose();
        }

        override public function  get_properties():Array<ASAny>
        {
            var properties= super.properties;
            properties.unshift(createProperty(PropertyKeys.HANDLE_BITMAP_DISPOSING, this._handleDisposing));
            properties.unshift(createProperty(PropertyKeys.BITMAP_ASSET_NAME, this._bitmapAssetName));
            return properties;
        }

        override public function  set_properties(properties:Array<ASAny>):Array<ASAny>        {
var property:PropertyStruct  = null;            if (checkNullIteratee(properties)) for (_tmp_ in properties)
            {
property = _tmp_;
                switch (property.key)
                {
                    case PropertyKeys.HANDLE_BITMAP_DISPOSING:
                        this._handleDisposing = ASCompat.asBoolean(property.value );
                        
                    case PropertyKeys.BITMAP_ASSET_NAME:
                        this._bitmapAssetName = ASCompat.asString(property.value );
                        
                }
            }
            return super.properties = properties;
        }
    }

