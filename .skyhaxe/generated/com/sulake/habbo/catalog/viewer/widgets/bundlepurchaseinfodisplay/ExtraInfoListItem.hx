package com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay
;
    import com.sulake.core.runtime.IDisposable;
	import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoItemData;
    import com.sulake.habbo.catalog.viewer.widgets.BundlePurchaseExtraInfoCatalogWidget;
    import com.sulake.core.window.IWindowContainer;

     class ExtraInfoListItem implements IDisposable 
    {
        public static inline final ALIGN_TOP= 0;
        public static inline final ALIGN_BOTTOM= 1;
        public static inline final ALIGN_OVERLAY= 2;

        var _id:Int = 0;
        var _data:ExtraInfoItemData;
        var _alignment:Int = 0;
        var _alwaysOnTop:Bool = false;
        var _disposed:Bool = false;
        var _creationSeconds:Float = Math.NaN;
        var _removalSeconds:Float = Math.NaN;
        var _isItemRemoved:Bool = false;

        public function new(k:BundlePurchaseExtraInfoCatalogWidget, _arg_2:Int, _arg_3:ExtraInfoItemData, _arg_4:Int=0, _arg_5:Bool=false)
        {
            this._id = _arg_2;
            this._data = _arg_3;
            this._alignment = _arg_4;
            this._alwaysOnTop = _arg_5;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            this._data = null;
            this._disposed = true;
        }

        
        public var id(get,set):Int;
public function  get_id():Int
        {
            return this._id;
        }
public function  set_id(k:Int):Int        {
            return this._id = k;
        }

        
        public var data(get,set):ExtraInfoItemData;
public function  get_data():ExtraInfoItemData
        {
            return this._data;
        }
public function  set_data(k:ExtraInfoItemData):ExtraInfoItemData        {
            return this._data = k;
        }

        public var alignment(get,never):Int;
public function  get_alignment():Int
        {
            return this._alignment;
        }

        public var _Str_22324(get,never):Bool;
public function  get__Str_22324():Bool
        {
            return this._alwaysOnTop;
        }

        
        public var _Str_13645(get,set):Float;
public function  get__Str_13645():Float
        {
            return this._creationSeconds;
        }
public function  set__Str_13645(k:Float):Float        {
            return this._creationSeconds = k;
        }

        public var _Str_24857(get,never):Bool;
public function  get__Str_24857():Bool
        {
            return this._isItemRemoved;
        }

        
        public var _Str_14104(get,set):Float;
public function  get__Str_14104():Float
        {
            return this._removalSeconds;
        }
public function  set__Str_14104(k:Float):Float        {
            this._removalSeconds = k;
            this._isItemRemoved = true;
return k;
        }

        public function getRenderedWindow():IWindowContainer
        {
            return null;
        }
    }

