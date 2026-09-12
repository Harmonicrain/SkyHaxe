package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.recycler._Str_7232;
    import com.sulake.habbo.catalog.viewer._Str_9030;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.recycler.IRecycler;
    import com.sulake.habbo.catalog.viewer.PageLocalization;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.habbo.catalog.recycler._Str_3718;
    import com.sulake.habbo.room.ImageResult;
    import flash.geom.Point;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.room.object.RoomObjectOperationEnum;

     class RecyclerCatalogWidget extends CatalogWidget implements _Str_7232 
    {
        var _Str_4455:_Str_9030;

        public function new(k:IWindowContainer)
        {
            super(k);
        }

        var recycler(get,never):IRecycler;
function  get_recycler():IRecycler
        {
            return page.viewer.catalog.getRecycler();
        }

        override public function dispose()
        {
            if (this._Str_4455 != null)
            {
                this._Str_4455.dispose();
                this._Str_4455 = null;
            }
            if (this.recycler != null)
            {
                this.recycler.cancel();
            }
            super.dispose();
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            _Str_2819(CatalogWidgetEnum.RECYCLER);
            window.findChildByName("inactive").visible = false;
            window.findChildByName("timeout").visible = false;
            window.findChildByName("normal").visible = false;
            if (this.recycler == null)
            {
                return false;
            }
            this.recycler.init(this);
            return true;
        }

        public function _Str_17679()
        {
            window.findChildByName("inactive").visible = true;
            window.findChildByName("timeout").visible = false;
            window.findChildByName("normal").visible = false;
            this._Str_13293();
            var k= Std.downcast(window.parent , IWindowContainer).findChildByName(PageLocalization.CATALOG_HEADER_DESCRIPTION);
            if (k != null)
            {
                k.caption = "${recycler.info.closed}";
            }
        }

        public function _Str_19627(k:Int)
        {
            var _local_2= Std.string(Std.int((k / 60)));
            var _local_3= Std.string((k % 60));
            page.viewer.catalog.localization.registerParameter("recycler.alert.timeout", "minutes", _local_2);
            page.viewer.catalog.localization.registerParameter("recycler.alert.timeout", "seconds", _local_3);
            window.findChildByName("inactive").visible = false;
            window.findChildByName("timeout").visible = true;
            window.findChildByName("normal").visible = false;
            var _local_4= Std.downcast(window.parent , IWindowContainer).findChildByName(PageLocalization.CATALOG_HEADER_DESCRIPTION);
            if (_local_4 != null)
            {
                _local_4.caption = "${recycler.alert.timeout}";
            }
        }

        public function _Str_20090()
        {
            window.findChildByName("inactive").visible = true;
            window.findChildByName("timeout").visible = false;
            window.findChildByName("normal").visible = false;
            this._Str_13293();
            var k= Std.downcast(window.parent , IWindowContainer).findChildByName(PageLocalization.CATALOG_HEADER_DESCRIPTION);
            if (k != null)
            {
                k.caption = "";
            }
        }

        public function _Str_20131()
        {
            window.findChildByName("inactive").visible = true;
            window.findChildByName("timeout").visible = false;
            window.findChildByName("normal").visible = false;
            this._Str_13293();
            var k= Std.downcast(window.parent , IWindowContainer).findChildByName(PageLocalization.CATALOG_HEADER_DESCRIPTION);
            if (k != null)
            {
                k.caption = "${recycler.info.finished}";
            }
            var _local_2= cast(window.findChildByName("recycle_again_button"), IButtonWindow);
            _local_2.visible = true;
            _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_24819);
        }

        public function _Str_19869()
        {
            window.findChildByName("inactive").visible = false;
            window.findChildByName("timeout").visible = false;
            window.findChildByName("normal").visible = true;
            this._Str_13293();
            window.procedure = this._Str_10415;
            window.parent.procedure = this._Str_10415;
            var k= Std.downcast(window.parent , IWindowContainer).findChildByName(PageLocalization.CATALOG_HEADER_DESCRIPTION);
            if (k != null)
            {
                k.caption = "${recycler.info.ready}";
            }
        }

        function _Str_13293()
        {
            var _local_2 = 0;
            var _local_3:IBitmapWrapperWindow = null;
            var k= _Str_21202("ctlg_recycler_slot_bg");
            if (k == null)
            {
                return;
            }
            _local_2 = 1;
            while (_local_2 <= this.recycler.numberOfSlots)
            {
                _local_3 = Std.downcast(window.findChildByName(("slot_bg_" + Std.string(_local_2))) , IBitmapWrapperWindow);
                if (_local_3 != null)
                {
                    _local_3.bitmap = k.clone();
                    _local_3.procedure = this._Str_21666;
                }
                _local_2++;
            }
            _local_2 = 1;
            while (_local_2 <= this.recycler.numberOfSlots)
            {
                _local_3 = Std.downcast(window.findChildByName(("slot_img_" + Std.string(_local_2))) , IBitmapWrapperWindow);
                if (_local_3 != null)
                {
                    _local_3.bitmap = k.clone();
                    _local_3.procedure = this._Str_21666;
                }
                _local_2++;
            }
        }

        public function _Str_15301()
        {
            var _local_2:IBitmapWrapperWindow = null;
            var _local_3:_Str_3718 = null;
            var _local_4:ImageResult = null;
            var _local_5:BitmapData = null;
            var _local_6:Point = null;
            if (((window == null) || (this.recycler == null)))
            {
                return;
            }
            var k = 0;
            while (k < this.recycler.numberOfSlots)
            {
                _local_2 = Std.downcast(window.findChildByName(("slot_img_" + Std.string(k + 1))) , IBitmapWrapperWindow);
                if (_local_2 == null)
                {
                    return;
                }
                _local_3 = this.recycler._Str_18924(k);
                if (_local_3 == null)
                {
                    _local_2.bitmap = new BitmapData(1, 1, true, 0xFFFFFF);
                }
                else
                {
                    _local_4 = this._Str_6819(_local_3);
                    if (((!(_local_4 == null)) && (!(_local_4.data == null))))
                    {
                        _local_5 = new BitmapData(_local_2.width, _local_2.height, true, 0xFFFFFF);
                        _local_5.fillRect(_local_5.rect, 0xFFFFFF);
                        _local_6 = new Point(((_local_2.width - _local_4.data.width) / 2), ((_local_2.height - _local_4.data.height) / 2));
                        _local_5.copyPixels(_local_4.data, _local_4.data.rect, _local_6, null, null, true);
                        _local_2.bitmap = _local_5;
                        _local_4.data.dispose();
                    }
                }
                k++;
            }
        }

        function _Str_6819(k:_Str_3718):ImageResult
        {
            var _local_2:ImageResult = null;
            if (((k == null) || (page.viewer.roomEngine == null)))
            {
                return null;
            }
            if (k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)
            {
                return page.viewer.roomEngine.getFurnitureIcon(k.typeId, null);
            }
            if (k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
            {
                return page.viewer.roomEngine.getWallItemIcon(k.typeId, null, k.xxxExtra);
            }
            return null;
        }

        function _Str_10415(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3= page.viewer.roomEngine;
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_3.getSelectedObjectData(_local_3.activeRoomId);
            switch (k.type)
            {
                case WindowMouseEvent.OUT:
                    if (this._Str_4455 != null)
                    {
                        this._Str_4455._Str_16533();
                    }
                    return;
                case WindowMouseEvent.MOVE:
                    if (this._Str_4455 != null)
                    {
                        this._Str_4455._Str_10415(k, _arg_2, _local_4);
                    }
                    return;
                case WindowMouseEvent.OVER:
                    if (this._Str_4455 == null)
                    {
                        this._Str_4455 = new _Str_9030();
                        this._Str_4455.mainContainer = window;
                        this._Str_4455.roomEngine = _local_3;
                    }
                    return;
            }
        }

        function _Str_21666(event:WindowEvent, target:IWindow)
        {
            var slotId = 0;
            var roomEngine= page.viewer.roomEngine;
            if (((roomEngine == null) || (this.recycler == null)))
            {
                return;
            }
            var objectData= roomEngine.getSelectedObjectData(roomEngine.activeRoomId);
            if (event.type == WindowMouseEvent.UP)
            {
                if (event.window.name.indexOf("slot_") == 0)
                {
                    slotId = (ASCompat.toInt(event.window.name.charAt((event.window.name.length - 1))) - 1);
                    if (objectData != null)
                    {
                        if (objectData.operation != RoomObjectOperationEnum.OBJECT_PLACE)
                        {
                            page.viewer.catalog.windowManager.alert("${generic.alert.title}", "${catalog.alert.recycler.inventory}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:WindowEvent)
                            {
                                k.dispose();
                            });
                            return;
                        }
                        this.recycler.placeObjectAtSlot(slotId, objectData.id, objectData.category, objectData.typeId, objectData._Str_4766);
                    }
                    else
                    {
                        this.recycler.releaseSlot(slotId);
                    }
                    roomEngine.cancelRoomObjectInsert();
                    if (this._Str_4455 != null)
                    {
                        this._Str_4455._Str_16533();
                    }
                    return;
                }
            }
            if (event.type == WindowMouseEvent.MOVE)
            {
                this._Str_10415(event, target);
            }
        }

        public function _Str_20203(k:Bool)
        {
            if ((disposed || (window == null)))
            {
                return;
            }
            var _local_2= window.findChildByName("recycler_recycle");
            if (_local_2 != null)
            {
                if (k)
                {
                    _local_2.enable();
                    _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_25763);
                }
                else
                {
                    _local_2.disable();
                }
            }
        }

        function _Str_25763(k:WindowMouseEvent)
        {
            if (this.recycler != null)
            {
                this.recycler.executeRecycler();
            }
        }

        function _Str_24819(k:WindowMouseEvent)
        {
            if (this.recycler != null)
            {
                this.recycler.empty();
                this.recycler.init(this);
            }
        }
    }

