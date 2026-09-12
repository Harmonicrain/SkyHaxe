package com.sulake.habbo.catalog.viewer
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.room.object.RoomObjectOperationEnum;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.room.ISelectedRoomObjectData;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import flash.display.Sprite;
    import flash.display.Bitmap;

     class _Str_9030 implements IGetImageListener 
    {
        static inline final CATALOGOVERLAYSPRITE= "CatalogOverlaySprite";

        var _roomEngine:IRoomEngine;
        var _mainContainer:IWindowContainer;
        var _state:Bool = false;


        public var roomEngine(never,set):IRoomEngine;
public function  set_roomEngine(k:IRoomEngine):IRoomEngine        {
            return this._roomEngine = k;
        }

        public var mainContainer(never,set):IWindowContainer;
public function  set_mainContainer(k:IWindowContainer):IWindowContainer        {
            return this._mainContainer = k;
        }

        public var state(get,never):Bool;
public function  get_state():Bool
        {
            return this._state;
        }

        public function dispose()
        {
            this._Str_20422();
            this._mainContainer = null;
            this._roomEngine = null;
            this._state = false;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
        }

        public function imageFailed(k:Int)
        {
        }

        public function _Str_10415(k:WindowEvent, _arg_2:IWindow, _arg_3:ISelectedRoomObjectData)
        {
            var _local_4:WindowMouseEvent = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:ImageResult = null;
            if (this._roomEngine == null)
            {
                return;
            }
            _local_4 = Std.downcast(k , WindowMouseEvent);
            switch (k.type)
            {
                case WindowMouseEvent.MOVE:
                    if (((_arg_3 == null) || (!(_arg_3.operation == RoomObjectOperationEnum.OBJECT_PLACE))))
                    {
                        return;
                    }
                    _local_5 = Std.int(_local_4.stageX);
                    _local_6 = Std.int(_local_4.stageY);
                    if (this._Str_15245() == null)
                    {
                        _local_7 = this._Str_6819(_arg_3);
                        if (_local_7 == null)
                        {
                            return;
                        }
                        this._Str_25523(_local_7.data);
                    }
                    this._state = true;
                    this._Str_25277(_local_5, _local_6);
                    return;
                case WindowMouseEvent.OUT:
                    if (this._state)
                    {
                        if (((((_local_4.localX >= 0) && (_local_4.localX < k.target.width)) && (_local_4.localY >= 0)) && (_local_4.localY < k.target.height)))
                        {
                            return;
                        }
                        this._Str_16533();
                    }
                    return;
            }
        }

        public function _Str_16533()
        {
            if (this._state)
            {
                this._Str_20422();
                this._state = false;
            }
        }

        function _Str_6819(k:ISelectedRoomObjectData):ImageResult
        {
            var _local_2:ImageResult = null;
            if (((k == null) || (this._roomEngine == null)))
            {
                return null;
            }
            if (k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)
            {
                return this._roomEngine.getFurnitureIcon(k.typeId, this);
            }
            if (k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
            {
                return this._roomEngine.getWallItemIcon(k.typeId, this, k._Str_4766);
            }
            return null;
        }

        function _Str_25523(k:BitmapData)
        {
            if (((((k == null) || (this._mainContainer == null)) || (this._mainContainer.desktop == null)) || (!(this._Str_15245() == null))))
            {
                return;
            }
            var _local_2= Std.downcast(this._mainContainer.desktop.getDisplayObject() , Sprite);
            var _local_3= new Sprite();
            _local_3.name = CATALOGOVERLAYSPRITE;
            _local_3.mouseEnabled = false;
            _local_3.visible = true;
            var _local_4= new Bitmap(k);
            _local_3.addChild(_local_4);
            _local_2.addChild(_local_3);
        }

        function _Str_15245():Sprite
        {
            if (((this._mainContainer == null) || (this._mainContainer.desktop == null)))
            {
                return null;
            }
            var k= Std.downcast(this._mainContainer.desktop.getDisplayObject() , Sprite);
            var _local_2= Std.downcast(k.getChildByName(CATALOGOVERLAYSPRITE) , Sprite);
            return _local_2;
        }

        function _Str_25277(k:Int, _arg_2:Int)
        {
            var _local_3= this._Str_15245();
            if (_local_3 == null)
            {
                return;
            }
            _local_3.x = (k - Math.fround((_local_3.width / 2)));
            _local_3.y = (_arg_2 - Math.fround((_local_3.height / 2)));
        }

        function _Str_20422()
        {
            if ((((this._mainContainer == null) || (this._mainContainer.desktop == null)) || (this._Str_15245() == null)))
            {
                return;
            }
            var k= Std.downcast(this._mainContainer.desktop.getDisplayObject() , Sprite);
            var _local_2= Std.downcast(k.getChildByName(CATALOGOVERLAYSPRITE) , Sprite);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(_local_2.removeChildAt(0) , Bitmap);
            if (((!(_local_3 == null)) && (!(_local_3.bitmapData == null))))
            {
                _local_3.bitmapData.dispose();
            }
            k.removeChild(k.getChildByName(CATALOGOVERLAYSPRITE));
        }
public function new(){}
    }

