package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.habbo.room.preview.RoomPreviewer;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import flash.display.DisplayObject;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import flash.geom.Point;
    import com.sulake.core.window.IWindow;
    import flash.display.Bitmap;
    import flash.display.BitmapData;

     class RoomPreviewerWidget implements IRoomPreviewerWidget
    {
        public static inline final ROOM_PREVIEWER= "room_previewer";
        static final ROOM_PREVIEWER_SCALE:String = (ROOM_PREVIEWER + ":scale");
        static final ROOM_PREVIEWER_OFFSET_X:String = (ROOM_PREVIEWER + ":offsetx");
        static final ROOM_PREVIEWER_OFFSET_Y:String = (ROOM_PREVIEWER + ":offsety");
        static final ROOM_PREVIEWER_ZOOM:String = (ROOM_PREVIEWER + ":zoom");
        static final PROPERTY_SCALE:PropertyStruct = new PropertyStruct(ROOM_PREVIEWER_SCALE, RoomPreviewer.SCALE_NORMAL, PropertyStruct.INT, false, [RoomPreviewer.SCALE_SMALL, RoomPreviewer.SCALE_NORMAL]);
        static final PROPERTY_OFFSET_X:PropertyStruct = new PropertyStruct(ROOM_PREVIEWER_OFFSET_X, 0, PropertyStruct.INT, false);
        static final PROPERTY_OFFSET_Y:PropertyStruct = new PropertyStruct(ROOM_PREVIEWER_OFFSET_Y, 0, PropertyStruct.INT, false);
        static final PROPERTY_ZOOM:PropertyStruct = new PropertyStruct(ROOM_PREVIEWER_ZOOM, 1, PropertyStruct.INT, false);
        static var _Str_12060:Int = 2;

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _roomCanvas:IDisplayObjectWrapper;
        var _roomPreviewer:RoomPreviewer;
        var _scale:Int = 0;
        var _offsetX:Int = 0;
        var _offsetY:Int = 0;
        var _zoom:Int = 0;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            var _local_3:DisplayObject = null;
            this._scale = ASCompat.toInt(PROPERTY_SCALE.value);
            this._zoom = ASCompat.toInt(PROPERTY_ZOOM.value);
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._roomPreviewer = new RoomPreviewer(_arg_2.roomEngine, _Str_12060++);
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("room_previewer_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._roomCanvas = Std.downcast(this._root.findChildByName("room_canvas") , IDisplayObjectWrapper);
            if (this._roomPreviewer != null)
            {
                this._root.addEventListener(WindowMouseEvent.CLICK, this._Str_24167);
                this._root.addEventListener(WindowEvent.WINDOW_EVENT_RESIZE, this._Str_25015);
                this._roomPreviewer.reset(false);
                _local_3 = this._roomPreviewer.getRoomCanvas(this._roomCanvas.width, this._roomCanvas.height);
                if (_local_3 != null)
                {
                    this._roomCanvas.setDisplayObject(_local_3);
                }
            }
            this._widgetWindow.rootWindow = this._root;
            this._root.width = this._widgetWindow.width;
            this._root.height = this._widgetWindow.height;
            this._roomPreviewer.modifyRoomCanvas(this._root.width, this._root.height);
        }

        
        public var scale(get,set):Int;
public function  get_scale():Int
        {
            return this._scale;
        }
public function  set_scale(scale:Int):Int        {
            this._scale = scale;
            this.refresh();
return scale;
        }

        
        public var offsetX(get,set):Int;
public function  get_offsetX():Int
        {
            return this._offsetX;
        }
public function  set_offsetX(offsetX:Int):Int        {
            this._offsetX = offsetX;
            this.refresh();
return offsetX;
        }

        
        public var offsetY(get,set):Int;
public function  get_offsetY():Int
        {
            return this._offsetY;
        }
public function  set_offsetY(offsetY:Int):Int        {
            this._offsetY = offsetY;
            this.refresh();
return offsetY;
        }

        
        public var zoom(get,set):Int;
public function  get_zoom():Int
        {
            return this._zoom;
        }
public function  set_zoom(zoom:Int):Int        {
            this._zoom = zoom;
            this.refresh();
return zoom;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(PROPERTY_SCALE.withValue(this._scale));
            k.push(PROPERTY_OFFSET_X.withValue(this._offsetX));
            k.push(PROPERTY_OFFSET_Y.withValue(this._offsetY));
            k.push(PROPERTY_ZOOM.withValue(this._zoom));
            return k;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
var property:PropertyStruct  = null;            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
property = _tmp_;
                switch (property.key)
                {
                    case ROOM_PREVIEWER_SCALE:
                        this.scale = ASCompat.toInt(property.value);
                        
                    case ROOM_PREVIEWER_OFFSET_X:
                        this.offsetX = ASCompat.toInt(property.value);
                        
                    case ROOM_PREVIEWER_OFFSET_Y:
                        this.offsetY = ASCompat.toInt(property.value);
                        
                    case ROOM_PREVIEWER_ZOOM:
                        this.zoom = ASCompat.toInt(property.value);
                        
                }
            }
return k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._roomPreviewer != null)
                {
                    this._roomPreviewer.dispose();
                    this._roomPreviewer = null;
                }
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

        function refresh()
        {
            var k:DisplayObject = null;
            if (this._roomPreviewer != null)
            {
                if ((this._scale == RoomPreviewer.SCALE_NORMAL))
                {
                    this._roomPreviewer.zoomIn();
                }
                else
                {
                    this._roomPreviewer.zoomOut();
                }
                this._roomPreviewer.addViewOffset = new Point(this._offsetX, this._offsetY);
                k = this._roomCanvas.getDisplayObject();
                k.scaleX = (k.scaleY = this.zoom);
                k.x = this.offsetX;
                k.y = this.offsetY;
            }
        }

        public function toString():String
        {
            return "RoomPreviewerWidget";
        }

        function onClick(k:WindowMouseEvent)
        {
        }

        function _Str_25015(k:WindowEvent, _arg_2:IWindow=null)
        {
            var _local_3= k.window.width;
            var _local_4= k.window.height;
            this._roomPreviewer.modifyRoomCanvas(_local_3, _local_4);
        }

        function _Str_24167(k:WindowMouseEvent)
        {
            this._roomPreviewer.changeRoomObjectState();
        }

        public var roomPreviewer(get,never):RoomPreviewer;
public function  get_roomPreviewer():RoomPreviewer
        {
            return this._roomPreviewer;
        }

        public function showPreview(k:BitmapData)
        {
            var _local_2= new Bitmap(k);
            _local_2.scaleX = 2;
            _local_2.scaleY = 2;
            this._roomCanvas.setDisplayObject(_local_2);
        }
    }



