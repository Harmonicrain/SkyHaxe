package com.sulake.core.window.graphics
;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    import flash.display.Shape;
    import flash.text.TextField;
    import flash.display.Bitmap;
    import flash.text.TextFieldType;
    import flash.display.Shape;
    import flash.geom.Point;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.IBitmapDrawable;
    import com.sulake.core.utils.profiler.tracking.TrackedBitmapData;

     class GraphicContext extends Sprite implements IGraphicContext 
    {
        public static inline final GC_TYPE_UNKNOWN:UInt = 0;
        public static final GC_TYPE_BITMAP:UInt = (1 << 0);
        public static final GC_TYPE_TEXTFIELD:UInt = (1 << 1);
        public static final GC_TYPE_CONTAINER:UInt = (1 << 2);
        public static final GC_TYPE_SHAPE:UInt = (1 << 3);
        public static final GC_TYPE_MORPH_SHAPE:UInt = (1 << 4);
        public static final _Str_22036:UInt = (1 << 6);
        public static final _Str_19868:UInt = (1 << 7);
        public static final GC_TYPE_DESKTOP:UInt = (1 << 8);
        static var _counter:UInt = 0;
        static var _allocated:UInt = 0;

        var _Str_4059:DisplayObjectContainer;
        var _Str_21049:Bool = false;
        var _Str_7873:Bool = false;
        var _disposed:Bool = false;
        var _Str_873:Rectangle;
        var _Str_3303:Shape;

        public function new(k:String, _arg_2:UInt, _arg_3:Rectangle)
        {
            var _local_4:TextField = null;
            super();
            _counter++;
            if (_arg_3 == null)
            {
                _arg_3 = new Rectangle(0, 0, 0, 0);
            }
            this.name = k;
            this.mouseEnabled = false;
            this.doubleClickEnabled = false;
            this.x = _arg_3.x;
            this.y = _arg_3.y;
            this._Str_873 = _arg_3;
            this._Str_21049 = true;
            this._Str_7873 = false;
            switch (_arg_2)
            {
                case GraphicContext.GC_TYPE_BITMAP:
                    this._Str_7873 = true;
                    this.setDisplayObject(new Bitmap());
                    this._Str_20707(Std.int(_arg_3.width), Std.int(_arg_3.height));
                    return;
                case GraphicContext.GC_TYPE_TEXTFIELD:
                    _local_4 = new TextField();
                    _local_4.width = _arg_3.width;
                    _local_4.height = _arg_3.height;
                    _local_4.type = TextFieldType.INPUT;
                    this.setDisplayObject(_local_4);
                    return;
                case GraphicContext.GC_TYPE_SHAPE:
                    this.setDisplayObject(new Shape());
                    return;
                case GraphicContext.GC_TYPE_MORPH_SHAPE:
                    this.setDisplayObject(new Shape());
                    return;
                case GraphicContext.GC_TYPE_CONTAINER:
                    this.setDisplayObject(new Sprite());
                    return;
                case GraphicContext.GC_TYPE_DESKTOP:
                    return;
                case GraphicContext.GC_TYPE_UNKNOWN:
                    return;
                default:
                    throw new ASError((("Unsupported graphic context type: " + Std.string(_arg_2)) + "!"));
            }
        }

        public static var numGraphicContexts(get,never):UInt;
public static function  get_numGraphicContexts():UInt
        {
            return _counter;
        }

        public static var allocatedByteCount(get,never):UInt;
public static function  get_allocatedByteCount():UInt
        {
            return _allocated;
        }


        
public var graphicParent(get,set):DisplayObjectContainer;
public function  set_graphicParent(k:DisplayObjectContainer):DisplayObjectContainer        {
            if (graphicParent != null)
            {
                graphicParent.removeChild(this);
            }
            if (k != null)
            {
                k.addChild(this);
            }
return k;
        }

        public function offSet(k:Point)
        {
            this.x = k.x;
            this.y = k.y;
        }

        override public function  get_filters():Array<flash.filters.BitmapFilter>
        {
            return (cast this.getDisplayObject().filters);
        }

        override public function  set_filters(k:Array<flash.filters.BitmapFilter>):Array<flash.filters.BitmapFilter>        {
            return this.getDisplayObject().filters = (cast k);
        }

        
        public var blend(get,set):Float;
public function  get_blend():Float
        {
            return this.alpha;
        }
public function  set_blend(k:Float):Float        {
            return this.alpha = k;
        }

        
        public var mouse(get,set):Bool;
public function  get_mouse():Bool
        {
            return this.mouseEnabled;
        }
public function  set_mouse(k:Bool):Bool        {
            return this.mouseEnabled = k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (graphicParent != null)
                {
                    graphicParent.removeChild(this);
                    this.graphicParent = null;
                }
                while (this._Str_13711 > 0)
                {
                    this._Str_19139(0);
                }
                if (this._Str_7873)
                {
                    this._Str_24624();
                }
                if (this._Str_4059 != null)
                {
                    while (this._Str_4059.numChildren > 0)
                    {
                        this._Str_4059.removeChildAt(0);
                    }
                }
                this._Str_4059 = null;
                while (numChildren > 0)
                {
                    removeChildAt(0);
                }
                this._Str_3303 = null;
                this._disposed = true;
                _counter--;
            }
        }

        override public function toString():String
        {
            return ('[object GraphicContext name="' + name) + '"]';
        }

        public function getDrawRegion():Rectangle
        {
            return this._Str_873.clone();
        }

        public function _Str_15334(k:Rectangle, _arg_2:Bool, _arg_3:Rectangle):BitmapData
        {
            var _local_4:BitmapData = null;
            if ((this._Str_7873 && _arg_2))
            {
                _local_4 = this._Str_20707(Std.int(k.width), Std.int(k.height));
            }
            x = k.x;
            y = k.y;
            this._Str_873.x = k.x;
            this._Str_873.y = k.y;
            this._Str_873.width = k.width;
            this._Str_873.height = k.height;
            if (_arg_3 != null)
            {
                if (this._Str_3303 == null)
                {
                    this._Str_3303 = new Shape();
                    this._Str_3303.visible = false;
                    super.addChild(this._Str_3303);
                }
                this._Str_3303.graphics.clear();
                this._Str_3303.graphics.beginFill(0xFF);
                this._Str_3303.graphics.drawRect(_arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height);
                this._Str_3303.graphics.endFill();
                this.getDisplayObject().mask = this._Str_3303;
            }
            else
            {
                if (this._Str_3303 != null)
                {
                    super.removeChild(this._Str_3303);
                    this._Str_3303.graphics.clear();
                    this._Str_3303 = null;
                    this.getDisplayObject().mask = null;
                }
            }
            return _local_4;
        }

        public function getDisplayObject():DisplayObject
        {
            return getChildAt(0);
        }

        public function setDisplayObject(k:DisplayObject):DisplayObject
        {
            var _local_2:DisplayObject = null;
            if (numChildren > 0)
            {
                _local_2 = removeChildAt(0);
            }
            addChildAt(k, 0);
            k.mask = this._Str_3303;
            return _local_2;
        }

        public function getAbsoluteMousePosition(k:Point)
        {
            k.x = stage.mouseX;
            k.y = stage.mouseY;
        }

        public function getRelativeMousePosition(k:Point)
        {
            var _local_2= this.getDisplayObject();
            k.x = _local_2.mouseX;
            k.y = _local_2.mouseY;
        }

        public function fetchDrawBuffer():IBitmapDrawable
        {
            var k:Bitmap = null;
            if (this._Str_7873)
            {
                k = Std.downcast(this.getDisplayObject() , Bitmap);
                if (k != null)
                {
                    return k.bitmapData;
                }
            }
            return null;
        }

        function _Str_20707(k:Int, _arg_2:Int):BitmapData
        {
            var _local_3:Bitmap = null;
            var _local_4:BitmapData = null;
            if (this._Str_7873)
            {
                _local_3 = Std.downcast(this.getDisplayObject() , Bitmap);
                if (_local_3 != null)
                {
                    _local_4 = _local_3.bitmapData;
                    if (_local_4 != null)
                    {
                        if (((!(_local_4.width == k)) || (!(_local_4.height == _arg_2))))
                        {
                            _local_3.bitmapData = null;
                            _allocated = (_allocated - ((_local_4.width * _local_4.height) * 4));
                            _local_4.dispose();
                            _local_4 = null;
                        }
                    }
                    if ((((_local_4 == null) && (k > 0)) && (_arg_2 > 0)))
                    {
                        _local_4 = new TrackedBitmapData(this, k, _arg_2, this._Str_21049, 0xFFFFFF);
                        _allocated = (_allocated + ((_local_4.width * _local_4.height) * 4));
                        _local_3.bitmapData = _local_4;
                    }
                    return _local_4;
                }
            }
            return null;
        }

        function _Str_24624()
        {
            var k:Bitmap = null;
            var _local_2:BitmapData = null;
            if (this._Str_7873)
            {
                k = Std.downcast(this.getDisplayObject() , Bitmap);
                if (k != null)
                {
                    _local_2 = k.bitmapData;
                    if (_local_2 != null)
                    {
                        k.bitmapData = null;
                        _allocated = (_allocated - ((_local_2.width * _local_2.height) * 4));
                        _local_2.dispose();
                    }
                }
            }
        }

        public function _Str_23788(k:Rectangle)
        {
            graphics.clear();
            graphics.lineStyle(1, 0xFF00FF00);
            graphics.drawRect(0, 0, width, height);
            if (k != null)
            {
                graphics.lineStyle(1, 0xFF0000FF);
                graphics.drawRect(k.x, k.y, k.width, k.height);
            }
        }

        function _Str_5255():DisplayObjectContainer
        {
            if (this._Str_4059 == null)
            {
                this._Str_4059 = new Sprite();
                this._Str_4059.name = (this.name + " - Child Container");
                this._Str_4059.mouseEnabled = false;
                addChild(this._Str_4059);
            }
            return this._Str_4059;
        }

        function _Str_26244()
        {
            if (this._Str_4059 != null)
            {
                removeChild(this._Str_4059);
                this._Str_4059 = null;
            }
        }

        public var _Str_13711(get,never):Int;
public function  get__Str_13711():Int
        {
            return (this._Str_4059 != null) ? this._Str_4059.numChildren : 0;
        }

        public function _Str_22175(k:IGraphicContext):IGraphicContext
        {
            return ASCompat.reinterpretAs(this._Str_5255().addChild(ASCompat.reinterpretAs(k , DisplayObject)) , IGraphicContext);
        }

        public function _Str_16175(k:IGraphicContext, _arg_2:Int):IGraphicContext
        {
            return ASCompat.reinterpretAs(this._Str_5255().addChildAt(ASCompat.reinterpretAs(k , DisplayObject), _arg_2) , IGraphicContext);
        }

        public function _Str_16021(k:Int):IGraphicContext
        {
            return ASCompat.reinterpretAs(this._Str_5255().getChildAt(k) , IGraphicContext);
        }

        public function _Str_25925(k:String):IGraphicContext
        {
            return ASCompat.reinterpretAs(this._Str_5255().getChildByName(k) , IGraphicContext);
        }

        public function _Str_24886(k:IGraphicContext):Int
        {
            return this._Str_5255().getChildIndex(cast(k, DisplayObject));
        }

        public function _Str_17938(k:IGraphicContext):IGraphicContext
        {
            return ASCompat.reinterpretAs(this._Str_5255().removeChild(cast(k, DisplayObject)) , IGraphicContext);
        }

        public function _Str_19139(k:Int):IGraphicContext
        {
            var _local_2= ASCompat.reinterpretAs(this._Str_5255().getChildAt(k) , IGraphicContext);
            return (_local_2 == null) ? null : this._Str_17938(_local_2);
        }

        public function _Str_19243(child:IGraphicContext, index:Int)
        {
            var current = 0;
            var temp:Array<ASAny> = null;
            var i:UInt = 0;
            var dispObj= ASCompat.reinterpretAs(child , DisplayObject);
            if (dispObj != null)
            {
                try
                {
                    current = this._Str_5255().getChildIndex(dispObj);
                }
                catch(error:ArgumentError)
                {
                    temp = new Array<ASAny>();
                    i = 0;
                    while (i < (_Str_13711 : UInt))
                    {
                        temp.push(_Str_16021(ASCompat.toInt(i)));
                        i++;
                    }
                    throw new ASError("Provided display object is not a child of this!");
                }
                if (index != current)
                {
                    this._Str_5255().setChildIndex(dispObj, index);
                }
            }
            else
            {
                throw new ASError("Provided child must implement IGraphicContext!");
            }
        }

        public function _Str_20742(k:IGraphicContext, _arg_2:IGraphicContext)
        {
            this._Str_5255().swapChildren(ASCompat.reinterpretAs(k , DisplayObject), ASCompat.reinterpretAs(_arg_2 , DisplayObject));
        }

        public function _Str_21032(k:Int, _arg_2:Int)
        {
            this._Str_5255().swapChildrenAt(k, _arg_2);
        }
public function  get_graphicParent():DisplayObjectContainer{return parent; }    }

