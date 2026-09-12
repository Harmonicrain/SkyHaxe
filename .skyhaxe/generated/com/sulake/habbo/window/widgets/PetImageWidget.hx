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
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.avatar.pets.PetFigureData;
    import com.sulake.room.utils.Vector3d;

     class PetImageWidget implements _Str_18605 implements  IGetImageListener 
    {
        public static inline final PET_IMAGE= "pet_image";
        static final FIGURE_KEY:String = (PET_IMAGE + ":figure");
        static final scalePropertyKey:String = (PET_IMAGE + ":scale");
        static final directionPropertyKey:String = (PET_IMAGE + ":direction");
        static final _Str_3257:Array<ASAny> = ["northeast", "east", "southeast", "south", "southwest", "west", "northwest", "north"];
        static final _Str_7546:Array<ASAny> = [32, 64];
        static final figureProperty:PropertyStruct = new PropertyStruct(FIGURE_KEY, "1 0 ffffff", PropertyStruct.STRING);
        static final scaleProperty:PropertyStruct = new PropertyStruct(scalePropertyKey, 64, PropertyStruct.INT, false, _Str_7546);
        static final directionProperty:PropertyStruct = new PropertyStruct(directionPropertyKey, _Str_3257[_Str_3724._Str_4519], PropertyStruct.STRING, false, _Str_3257);

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _bitmap:IBitmapWrapperWindow;
        var _region:IRegionWindow;
        var _figure:String;
        var _scale:Int = 0;
        var _direction:Int = 0;
        var _imageCallbackIds:Map;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._figure = ASCompat.toString(figureProperty.value);
            this._scale = ASCompat.toInt(scaleProperty.value);
            this._direction = _Str_3257.indexOf(ASCompat.toString(directionProperty.value));
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._imageCallbackIds = new Map();
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("pet_image_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
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
            k.push(figureProperty.withValue(this._figure));
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
                    case FIGURE_KEY:
                        this.figure = ASCompat.toString(_local_2.value);
                        
                    case scalePropertyKey:
                        this.scale = ASCompat.toInt(_local_2.value);
                        
                    case directionPropertyKey:
                        this.direction = _Str_3257.indexOf(ASCompat.toString(_local_2.value));
                        
                }
            }
return k;
        }

        
        public var figure(get,set):String;
public function  get_figure():String
        {
            return this._figure;
        }
public function  set_figure(k:String):String        {
            this._figure = this._Str_12216(k);
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
            if (this._disposed || this._imageCallbackIds == null)
            {
                return;
            }
            var _local_3:String = this._imageCallbackIds.getValue(k);
            if (_local_3 != null)
            {
                if (this._Str_12216(_local_3) == this._figure)
                {
                    this.refresh();
                }
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function refresh()
        {
            var _local_2:BitmapData = null;
            var _local_3:String = null;
            var _local_4:ImageResult = null;
            var _local_5 = 0;
            var _local_6:String = null;
            if (this._disposed || this._bitmap == null || this._windowManager == null || this._widgetWindow == null)
            {
                return;
            }
            this._bitmap.bitmap = null;
            var k= new PetFigureData(this._figure);
            if (this._windowManager.roomEngine != null)
            {
                _local_3 = "std";
                _local_4 = this._windowManager.roomEngine.getPetImage(k.typeId, k.paletteId, k.color, new Vector3d((this._direction * 45)), this.scale, this, true, 0, k._Str_3542, _local_3);
                if (_local_4 != null)
                {
                    _local_5 = _local_4.id;
                    this._imageCallbackIds.remove(_local_5);
                    if (_local_5 > 0)
                    {
                        this._imageCallbackIds.add(_local_5, this._figure);
                    }
                    this._bitmap.bitmap = _local_4.data;
                    this._bitmap.disposesBitmap = true;
                }
            }
            if (((this._bitmap.bitmap == null) || (this._bitmap.bitmap.width < 2)))
            {
                _local_6 = (("placeholder_pet" + ((this._scale == 32) ? "_small" : "")) + "_png");
                this._bitmap.bitmap = ASCompat.dynamicAs(this._windowManager.assets.getAssetByName(_local_6).content , BitmapData);
                this._bitmap.disposesBitmap = false;
            }
            this._bitmap.invalidate();
            this._widgetWindow.width = this._bitmap.bitmap.width;
            this._widgetWindow.height = this._bitmap.bitmap.height;
        }

        function _Str_12216(k:String):String
        {
            return (k == null) ? ASCompat.toString(figureProperty.value) : new compat.RegExp("NaN", "g").replace(k, "");
        }

        function onClick(k:WindowMouseEvent)
        {
        }
    }




