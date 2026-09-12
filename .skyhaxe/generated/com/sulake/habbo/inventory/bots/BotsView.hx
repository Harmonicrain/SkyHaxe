package com.sulake.habbo.inventory.bots
;
    import com.sulake.habbo.inventory.IInventoryView;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.parser.inventory.bots.BotData;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IButtonWindow;

     class BotsView implements IInventoryView implements  IAvatarImageListener 
    {
        static inline final _Str_12512= 0;
        static inline final _Str_4299= 1;
        static inline final _Str_5391= 2;
        static inline final _Str_4660= 3;

        var _windowManager:IHabboWindowManager;
        var _assetLibrary:IAssetLibrary;
        var _view:IWindowContainer;
        var _model:BotsModel;
        var _disposed:Bool = false;
        var _grid:IItemGridWindow;
        var _roomEngine:IRoomEngine;
        var _avatarRenderer:IAvatarRenderManager;
        var _gridItems:Map;
        var _selectedGridItem:BotGridItem;
        var _currentState:Int = 0;
        var _previewImageDownloadId:Int = 0;
        var _isInitialized:Bool = false;

        public function new(k:BotsModel, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IRoomEngine, _arg_5:IAvatarRenderManager)
        {
            this._model = k;
            this._assetLibrary = _arg_3;
            this._windowManager = _arg_2;
            this._roomEngine = _arg_4;
            this._avatarRenderer = _arg_5;
            this._gridItems = new Map();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var isVisible(get,never):Bool;
public function  get_isVisible():Bool
        {
            return ((this._view != null) && (!(this._view.parent == null))) && this._view.visible;
        }

        public function dispose()
        {
            this._windowManager = null;
            this._avatarRenderer = null;
            this._roomEngine = null;
            this._assetLibrary = null;
            this._model = null;
            this._view = null;
            this._disposed = true;
        }

        public function update()
        {
            if (!this._isInitialized)
            {
                return;
            }
            this._Str_7044();
            this.updatePreview(this._selectedGridItem);
            this.updateContainerVisibility();
        }

        public function removeItem(k:Int)
        {
            if (!this._isInitialized)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(this._gridItems.remove(k) , BotGridItem);
            if (_local_2 == null)
            {
                return;
            }
            this._grid.removeGridItem(_local_2.window);
            if (this._selectedGridItem == _local_2)
            {
                this._selectedGridItem = null;
                this._Str_9010();
            }
        }

        public function addItem(k:BotData)
        {
            if (!this._isInitialized)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            if (this._gridItems.getValue(k.id) != null)
            {
                return;
            }
            var _local_2= new BotGridItem(this, k, this._windowManager, this._assetLibrary, this._model.isUnseen(k.id));
            if (_local_2 != null)
            {
                this._grid.addGridItem(_local_2.window);
                this._gridItems.add(k.id, _local_2);
                if (this._selectedGridItem == null)
                {
                    this._Str_9010();
                }
            }
        }

        public function _Str_7009(k:Int, _arg_2:Bool=false)
        {
            this._model._Str_7009(k, _arg_2);
        }

        public function getWindowContainer():IWindowContainer
        {
            if (!this._isInitialized)
            {
                this.init();
            }
            if (this._view == null)
            {
                return null;
            }
            if (this._view.disposed)
            {
                return null;
            }
            return this._view;
        }

        public function _Str_7828(k:BotGridItem)
        {
            if (!this._isInitialized)
            {
                return;
            }
            if (this._selectedGridItem != null)
            {
                this._selectedGridItem.setSelected(false);
            }
            this._selectedGridItem = k;
            if (this._selectedGridItem != null)
            {
                this._selectedGridItem.setSelected(true);
            }
            this.updatePreview(k);
        }

        public function _Str_3820()
        {
            var _local_2 = 0;
            if (!this._isInitialized)
            {
                return;
            }
            var k= this._model.items;
            if (!this._model._Str_18819())
            {
                _local_2 = BotsView._Str_4299;
            }
            else
            {
                if (((!(k != null)) || (k.length == 0)))
                {
                    _local_2 = BotsView._Str_5391;
                }
                else
                {
                    _local_2 = BotsView._Str_4660;
                }
            }
            if (this._currentState == _local_2)
            {
                return;
            }
            this._currentState = _local_2;
            this.updateContainerVisibility();
            if (this._currentState == BotsView._Str_4660)
            {
                this._Str_7044();
                this.updatePreview();
            }
        }

        public function _Str_20649(k:BotData):BitmapData
        {
            var _local_2= 3;
            return this._Str_9836(k, _local_2, false, AvatarScaleType.LARGE);
        }

        public function _Str_9836(k:BotData, _arg_2:Int, _arg_3:Bool, _arg_4:String):BitmapData
        {
            var _local_6:BitmapData = null;
            var _local_5= this._avatarRenderer.createAvatarImage(k.figure, _arg_4, k.gender, this);
            _local_5.setDirection(AvatarSetType.FULL, _arg_2);
            if (_arg_3)
            {
_local_6 = _local_5.getCroppedImage(AvatarSetType.FULL);
            }
            else
            {
_local_6 = _local_5.getCroppedImage(AvatarSetType.HEAD);
            }
            _local_5.dispose();
            return _local_6;
        }

        public function avatarImageReady(k:String)
        {
            var _local_2:BotGridItem = null;
            if (this.disposed)
            {
                return;
            }
            final _iter_ = this._gridItems; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                if (_local_2.data.figure == k)
                {
                    _local_2.setImage(this._Str_20649(_local_2.data));
                }
            }
        }

        function _Str_9010()
        {
            if (((this._gridItems == null) || (this._gridItems.length == 0)))
            {
                this.updatePreview();
                return;
            }
            this._Str_7828(this._gridItems.getWithIndex(0));
        }

        public function _Str_16613(k:Int)
        {
            this._Str_7828(this._gridItems.getValue(k));
        }

        function _Str_7044()
        {
            var _local_3 = 0;
            var _local_4:BotGridItem = null;
            if (this._view == null)
            {
                return;
            }
            var k= this._gridItems.getKeys();
            var _local_2= ((this._model.items != null) ? this._model.items.getKeys() : new Array<ASAny>());
            this._grid.lock();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = ASCompat.toInt(_tmp_);
                if (_local_2.indexOf(_local_3) == -1)
                {
                    this.removeItem(_local_3);
                }
            }
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = ASCompat.toInt(_tmp_);
                if (k.indexOf(_local_3) == -1)
                {
                    this.addItem(this._model.items.getValue(_local_3));
                }
                _local_4 = this._gridItems.getValue(_local_3);
                _local_4.setUnseen(this._model.isUnseen(_local_3));
            }
            this._grid.unlock();
        }

        function _Str_9841(k:WindowMouseEvent)
        {
            if (this._selectedGridItem == null)
            {
                return;
            }
            var _local_2= this._selectedGridItem.data;
            if (_local_2 == null)
            {
                return;
            }
            this._Str_7009(_local_2.id);
        }

        function _Str_3545(k:WindowEvent, _arg_2:IWindow)
        {
        }

        function updateContainerVisibility()
        {
            if (this._model.controller._Str_9777 != InventoryCategory.BOTS)
            {
                return;
            }
            var k= this._model.controller.view._Str_10034;
            var _local_2= this._model.controller.view._Str_11062;
            var _local_3= this._view.findChildByName("grid");
            var _local_4= this._view.findChildByName("preview_container");
            switch (this._currentState)
            {
                case BotsView._Str_4299:
                    if (k != null)
                    {
                        k.visible = true;
                    }
                    if (_local_2 != null)
                    {
                        _local_2.visible = false;
                    }
                    _local_3.visible = false;
                    _local_4.visible = false;
                    return;
                case BotsView._Str_5391:
                    if (k != null)
                    {
                        k.visible = false;
                    }
                    if (_local_2 != null)
                    {
                        _local_2.visible = true;
                    }
                    _local_3.visible = false;
                    _local_4.visible = false;
                    return;
                case BotsView._Str_4660:
                    if (k != null)
                    {
                        k.visible = false;
                    }
                    if (_local_2 != null)
                    {
                        _local_2.visible = false;
                    }
                    _local_3.visible = true;
                    _local_4.visible = true;
                    return;
            }
        }

        function updatePreview(k:BotGridItem=null)
        {
            var _local_2:BitmapData = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5 = false;
            var _local_12:BotData = null;
            var _local_13:BitmapData = null;
            if (this._view == null)
            {
                return;
            }
            this._previewImageDownloadId = -1;
            if (((k == null) || (k.data == null)))
            {
                _local_2 = new BitmapData(1, 1);
                _local_3 = "";
                _local_4 = "";
                _local_5 = false;
            }
            else
            {
                _local_12 = k.data;
                _local_3 = _local_12.name;
                _local_4 = _local_12.motto;
                _local_2 = this._Str_9836(_local_12, 4, true, AvatarScaleType.LARGE);
                _local_5 = true;
            }
            var _local_6= Std.downcast(this._view.findChildByName("preview_image") , IBitmapWrapperWindow);
            if (_local_6 != null)
            {
                _local_13 = new BitmapData(_local_6.width, _local_6.height);
                _local_13.fillRect(_local_13.rect, 0);
                _local_13.copyPixels(_local_2, _local_2.rect, new Point(((_local_13.width / 2) - (_local_2.width / 2)), ((_local_13.height / 2) - (_local_2.height / 2))));
                _local_6.bitmap = _local_13;
            }
            _local_2.dispose();
            var _local_7= Std.downcast(this._view.findChildByName("bot_name") , ITextWindow);
            if (_local_7 != null)
            {
                _local_7.caption = _local_3;
            }
            _local_7 = Std.downcast(this._view.findChildByName("bot_description") , ITextWindow);
            if (_local_7 != null)
            {
                _local_7.caption = _local_4;
            }
            var _local_8 = false;
            var _local_9 = false;
            if (this._model.roomSession != null)
            {
                _local_8 = this._model.roomSession.areBotsAllowed;
                _local_9 = this._model.roomSession.isRoomOwner;
            }
            var _local_10= "";
            if (!_local_9)
            {
                if (_local_8)
                {
                    _local_10 = "${inventory.bots.allowed}";
                }
                else
                {
                    _local_10 = "${inventory.bots.forbidden}";
                }
            }
            _local_7 = Std.downcast(this._view.findChildByName("preview_info") , ITextWindow);
            if (_local_7 != null)
            {
                _local_7.caption = _local_10;
            }
            var _local_11= Std.downcast(this._view.findChildByName("place_button") , IButtonWindow);
            if (_local_11 != null)
            {
                if ((_local_5 && (_local_9 || _local_8)))
                {
                    _local_11.enable();
                }
                else
                {
                    _local_11.disable();
                }
            }
        }

        function _Str_22778()
        {
        }

        function init()
        {
            var k:IButtonWindow = null;
            this._view = this._model.controller.view._Str_9043(InventoryCategory.BOTS);
            this._view.visible = false;
            this._view.procedure = this._Str_3545;
            this._Str_22778();
            this._grid = Std.downcast(this._view.findChildByName("grid") , IItemGridWindow);
            k = Std.downcast(this._view.findChildByName("place_button") , IButtonWindow);
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, this._Str_9841);
            }
            var _local_2= Std.downcast(this._view.findChildByName("preview_image") , IBitmapWrapperWindow);
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.DOWN, this._Str_9841);
            }
            this.updatePreview();
            this._Str_3820();
            this._Str_9010();
            this._isInitialized = true;
        }
    }

