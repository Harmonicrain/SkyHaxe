package com.sulake.habbo.window.widgets
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.habbo.window._enum._Str_3724;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.room.utils.Vector3d;

     class FurnitureImageWidget implements _Str_18438 implements  IGetImageListener 
    {
        public static inline final FURNITURE_IMAGE= "furniture_image";
        static final _Str_14664:String = (FURNITURE_IMAGE + ":furnitureType");
        static final scalePropertyKey:String = (FURNITURE_IMAGE + ":scale");
        static final directionPropertyKey:String = (FURNITURE_IMAGE + ":direction");
        static final _Str_3257:Array<ASAny> = ["northeast", "east", "southeast", "south", "southwest", "west", "northwest", "north"];
        static final _Str_7546:Array<ASAny> = [32, 64];
        static final furnitureTypeProperty:PropertyStruct = new PropertyStruct(_Str_14664, "table_plasto_square", PropertyStruct.STRING, false);
        static final scaleProperty:PropertyStruct = new PropertyStruct(scalePropertyKey, 64, PropertyStruct.INT, false, _Str_7546);
        static final directionProperty:PropertyStruct = new PropertyStruct(directionPropertyKey, _Str_3257[_Str_3724._Str_4519], PropertyStruct.STRING, false, _Str_3257);
        static inline final _Str_16516= 0;
        static inline final _Str_20628= 1;

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _bitmap:IBitmapWrapperWindow;
        var _region:IRegionWindow;
        var _furnitureType:String = "table_plasto_square";
        var _scale:Int = 0;
        var _direction:Int = 0;
        var _imageCallbackIds:Map;
        var _extra:String;
        var _itemType:Int = 0;
        var _stuffData:IStuffData = null;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._scale = ASCompat.toInt(scaleProperty.value);
            this._direction = _Str_3257.indexOf(ASCompat.toString(directionProperty.value));
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._imageCallbackIds = new Map();
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("furniture_image_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._bitmap = Std.downcast(this._root.findChildByName("bitmap") , IBitmapWrapperWindow);
            this._region = Std.downcast(this._root.findChildByName("region") , IRegionWindow);
            this._region.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this.refresh();
            this._widgetWindow.rootWindow = this._root;
            this._root.width = this._widgetWindow.width;
            this._root.height = this._widgetWindow.height;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._region != null)
                {
                    this._region.removeEventListener(WindowMouseEvent.CLICK, this.onClick);
                    this._region.dispose();
                    this._region = null;
                }
                this._bitmap = null;
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
            k.push(furnitureTypeProperty.withValue(this._furnitureType));
            k.push(scaleProperty.withValue(this._scale));
            k.push(directionProperty.withValue(_Str_3257[this._direction]));
            return k;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case _Str_14664:
                        this._Str_12916 = ASCompat.toString(_local_2.value);
                        
                    case scalePropertyKey:
                        this.scale = ASCompat.toInt(_local_2.value);
                        
                    case directionPropertyKey:
                        this.direction = _Str_3257.indexOf(ASCompat.toString(_local_2.value));
                        
                }
            }
return k;
        }

        
        public var _Str_12916(get,set):String;
public function  get__Str_12916():String
        {
            return this._furnitureType;
        }
public function  set__Str_12916(k:String):String        {
            this._furnitureType = k;
            this.refresh();
return k;
        }

        
        public var scale(get,set):Int;
public function  get_scale():Int
        {
            return this._scale;
        }
public function  set_scale(k:Int):Int        {
            this._scale = k;
            this.refresh();
return k;
        }

        
        public var direction(get,set):Int;
public function  get_direction():Int
        {
            return this._direction;
        }
public function  set_direction(k:Int):Int        {
            this._direction = k;
            this.refresh();
return k;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            var _local_3:String = this._imageCallbackIds.getValue(k);
            if (_local_3 == this._furnitureType)
            {
                this.refresh();
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function refresh()
        {
            var k:ImageResult = null;
            var _local_2:String = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5:String = null;
            this._bitmap.bitmap = null;
            if (this._windowManager.roomEngine != null)
            {
                _local_2 = "std";
                _local_3 = this._windowManager.roomEngine.getFurnitureTypeId(this._furnitureType);
                if (this._itemType == _Str_16516)
                {
                    k = this._windowManager.roomEngine.getFurnitureImage(_local_3, new Vector3d((this._direction * 45), 0, 0), this._scale, this, 0, this._extra, -1, -1, this._stuffData);
                }
                else
                {
                    k = this._windowManager.roomEngine.getWallItemImage(_local_3, new Vector3d((this._direction * 45), 0, 0), this._scale, this, 0, ((this._stuffData != null) ? this._stuffData.getLegacyString() : ""));
                }
                if (k != null)
                {
                    _local_4 = k.id;
                    this._imageCallbackIds.remove(_local_4);
                    if (_local_4 > 0)
                    {
                        this._imageCallbackIds.add(_local_4, this._furnitureType);
                    }
                    this._bitmap.bitmap = k.data;
                    this._bitmap.disposesBitmap = true;
                }
            }
            if (((this._bitmap.bitmap == null) || (this._bitmap.bitmap.width < 2)))
            {
                _local_5 = (("placeholder_furni" + ((this._scale == 32) ? "_small" : "")) + "_png");
                this._bitmap.bitmap = ASCompat.dynamicAs(this._windowManager.assets.getAssetByName(_local_5).content , BitmapData);
                this._bitmap.disposesBitmap = false;
            }
            this._bitmap.invalidate();
            this._widgetWindow.width = this._bitmap.bitmap.width;
            this._widgetWindow.height = this._bitmap.bitmap.height;
        }

        function onClick(k:WindowMouseEvent)
        {
        }
    }





