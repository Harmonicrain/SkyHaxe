package com.sulake.habbo.window.widgets
;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.window._enum._Str_3724;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.filters.ColorMatrixFilter;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;

     class AvatarImageWidget implements IAvatarImageWidget implements  IAvatarImageListener
    {
        public static inline final AVATAR_IMAGE= "avatar_image";
        static final FIGURE_KEY:String = (AVATAR_IMAGE + ":figure");
        static final scalePropertyKey:String = (AVATAR_IMAGE + ":scale");
        static final onlyHeadPropertyKey:String = (AVATAR_IMAGE + ":only_head");
        static final croppedPropertyKey:String = (AVATAR_IMAGE + ":cropped");
        static final directionPropertyKey:String = (AVATAR_IMAGE + ":direction");
        static final _Str_3257:Array<ASAny> = ["northeast", "east", "southeast", "south", "southwest", "west", "northwest", "north"];
        static final figureProperty:PropertyStruct = new PropertyStruct(FIGURE_KEY, "hd-180-1.ch-210-66.lg-270-82.sh-290-81", PropertyStruct.STRING);
        static final scaleProperty:PropertyStruct = new PropertyStruct(scalePropertyKey, AvatarScaleType.LARGE, PropertyStruct.STRING, false, [AvatarScaleType.SMALL, AvatarScaleType.LARGE]);
        static final onlyHeadProperty:PropertyStruct = new PropertyStruct(onlyHeadPropertyKey, false, PropertyStruct.BOOLEAN);
        static final croppedProperty:PropertyStruct = new PropertyStruct(croppedPropertyKey, false, PropertyStruct.BOOLEAN);
        static final directionProperty:PropertyStruct = new PropertyStruct(directionPropertyKey, _Str_3257[_Str_3724._Str_4519], PropertyStruct.STRING, false, _Str_3257);

        static inline final rc= 0.333333333333333;
        static inline final _Str_761= 0.333333333333333;
        static inline final bc= 0.333333333333333;

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _bitmap:IBitmapWrapperWindow;
        var _region:IRegionWindow;
        var _figure:String;
        var _scale:String;
        var _onlyHead:Bool = false;
        var _cropped:Bool = false;
        var _direction:Int = 0;
        var _userId:Int = 0;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._figure = ASCompat.toString(figureProperty.value);
            this._scale = ASCompat.toString(scaleProperty.value);
            this._onlyHead = ASCompat.toBool(onlyHeadProperty.value);
            this._cropped = ASCompat.toBool(croppedProperty.value);
            this._direction = _Str_3257.indexOf(ASCompat.toString(directionProperty.value));
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("avatar_image_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
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
            k.push(onlyHeadProperty.withValue(this._onlyHead));
            k.push(croppedProperty.withValue(this._cropped));
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
                        this.scale = ASCompat.toString(_local_2.value);
                        
                    case onlyHeadPropertyKey:
                        this.onlyHead = ASCompat.toBool(_local_2.value);
                        
                    case croppedPropertyKey:
                        this.cropped = ASCompat.toBool(_local_2.value);
                        
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

        
        public var scale(get,set):String;
public function  get_scale():String
        {
            return this._scale;
        }
public function  set_scale(k:String):String        {
            this._scale = k;
            this.refresh();
return k;
        }

        
        public var onlyHead(get,set):Bool;
public function  get_onlyHead():Bool
        {
            return this._onlyHead;
        }
public function  set_onlyHead(k:Bool):Bool        {
            this._onlyHead = k;
            this.refresh();
return k;
        }

        
        public var cropped(get,set):Bool;
public function  get_cropped():Bool
        {
            return this._cropped;
        }
public function  set_cropped(k:Bool):Bool        {
            this._cropped = k;
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

        
        public var userId(get,set):Int;
public function  get_userId():Int
        {
            return this._userId;
        }
public function  set_userId(k:Int):Int        {
            this._userId = k;
            this._region.visible = (this._userId > 0);
return k;
        }

        public function avatarImageReady(k:String)
        {
            if (this._Str_12216(k) == this._figure)
            {
                this.refresh();
            }
        }

        function refresh()
        {
            var _local_3 = Math.NaN;
            var _local_4:IAvatarImage = null;
            var _local_5:String = null;
            this._bitmap.bitmap = null;
            var k = false;
            var _local_2= this._figure;
            if (((_local_2 == null) || (_local_2.length == 0)))
            {
                k = true;
                _local_2 = ASCompat.toString(figureProperty.value);
            }
            if (this._windowManager._Str_1458 != null)
            {
                _local_3 = ((this._scale == AvatarScaleType.LARGE) ? 1 : 0.5);
                _local_4 = this._windowManager._Str_1458.createAvatarImage(_local_2, AvatarScaleType.LARGE, null, this);
                if (_local_4 != null)
                {
                    _local_4.setDirection((this._onlyHead ? AvatarSetType.HEAD : AvatarSetType.FULL), this._direction);
                    if (this._cropped)
                    {
this._bitmap.bitmap = _local_4.getCroppedImage((this._onlyHead ? AvatarSetType.HEAD : AvatarSetType.FULL), _local_3);
                    }
                    else
                    {
                        this._bitmap.bitmap = _local_4.getImage((this._onlyHead ? AvatarSetType.HEAD : AvatarSetType.FULL), true, _local_3);
                    }
                    if (k)
                    {
                        this.convertToGrayscale(this._bitmap);
                    }
                    this._bitmap.disposesBitmap = true;
                    _local_4.dispose();
                }
            }
            if (((this._bitmap.bitmap == null) || (this._bitmap.bitmap.width < 2)))
            {
                _local_5 = (((("placeholder_avatar" + ((this._scale == AvatarScaleType.SMALL) ? "_small" : "")) + (this._onlyHead ? "_head" : "")) + (this._cropped ? "_cropped" : "")) + "_png");
                this._bitmap.bitmap = ASCompat.dynamicAs(this._windowManager.assets.getAssetByName(_local_5).content , BitmapData);
                this._bitmap.disposesBitmap = false;
                this.convertToGrayscale(this._bitmap);
            }
            this._bitmap.invalidate();
            this._widgetWindow.width = this._bitmap.bitmap.width;
            this._widgetWindow.height = this._bitmap.bitmap.height;
        }

        function convertToGrayscale(k:IBitmapWrapperWindow):ASAny
        {
            this._bitmap.bitmap.applyFilter(this._bitmap.bitmap, this._bitmap.bitmap.rect, new Point(), new ColorMatrixFilter([AvatarImageWidget.rc, AvatarImageWidget._Str_761, AvatarImageWidget.bc, 0, 0, AvatarImageWidget.rc, AvatarImageWidget._Str_761, AvatarImageWidget.bc, 0, 0, AvatarImageWidget.rc, AvatarImageWidget._Str_761, AvatarImageWidget.bc, 0, 0, 0, 0, 0, 1, 0]));

return ASCompat.undefinedValue();         }

        function _Str_12216(k:String):String
        {
            return (k == null) ? ASCompat.toString(figureProperty.value) : new compat.RegExp("NaN", "g").replace(k, "");
        }

        function onClick(k:WindowMouseEvent)
        {
            if (this._userId > 0)
            {
                this._windowManager.communication.connection.send(new GetExtendedProfileMessageComposer(this._userId));
            }
        }
    }







