package com.sulake.habbo.avatar.wardrobe
;
    import com.sulake.habbo.avatar.common.ISideContentView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;

     class WardrobeView implements ISideContentView 
    {
        var _window:IWindowContainer;
        var _model:WardrobeModel;
        var _slotList:IItemListWindow;
        var _vipSlotList:IItemListWindow;
        var _slotWindowTemplate:IWindow;

        public function new(k:WardrobeModel)
        {
            this._model = k;
            var _local_2= Std.downcast(this._model.controller.manager.assets.getAssetByName("avatareditor_wardrobe_base") , XmlAsset);
            this._window = Std.downcast(this._model.controller.manager.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._slotList = Std.downcast(this._window.findChildByName("hc_slots") , IItemListWindow);
            this._vipSlotList = Std.downcast(this._window.findChildByName("vip_slots") , IItemListWindow);
            this._slotWindowTemplate = this._window.findChildByName("slot_template");
            if (this._slotWindowTemplate != null)
            {
                this._window.removeChild(this._slotWindowTemplate);
            }
            this._window.visible = false;
        }

        public var _Str_23743(get,never):IWindow;
public function  get__Str_23743():IWindow
        {
            return this._slotWindowTemplate;
        }

        public function dispose()
        {
            this._model = null;
            this._slotList = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public function update()
        {
            var _local_2:WardrobeSlot = null;
            if (this._slotList != null)
            {
                this._slotList.removeListItems();
            }
            if (this._vipSlotList != null)
            {
                this._vipSlotList.removeListItems();
            }
            var k= this._model._Str_22986;
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                _local_2 = k[_local_3];
                if (_local_3 < 5)
                {
                    if (this._slotList != null)
                    {
                        this._slotList.addListItem(_local_2.view);
                        _local_2.view.visible = true;
                    }
                }
                else
                {
                    if (this._vipSlotList != null)
                    {
                        this._vipSlotList.addListItem(_local_2.view);
                        _local_2.view.visible = true;
                    }
                }
                _local_3++;
            }
        }

        public function getWindowContainer():IWindowContainer
        {
            return this._window;
        }
    }


