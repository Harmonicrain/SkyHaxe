package com.sulake.habbo.inventory.recycler
;
    import com.sulake.habbo.inventory.IInventoryModel;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.inventory.items.IFurnitureItem;
    import com.sulake.core.window.IWindowContainer;

     class RecyclerModel implements IInventoryModel 
    {
        public static inline final _Str_599:UInt = 0;
        public static inline final STATE_ACTIVE:UInt = 1;

        var _habboInventory:HabboInventory;
        var _assetLibrary:IAssetLibrary;
        var _roomEngine:IRoomEngine;
        var _communicationManager:IHabboCommunicationManager;
        var _localizationManager:IHabboLocalizationManager;
        var _disposed:Bool = false;
        var _running:Bool = false;
        var _state:UInt = 0;
        var _itemList:Map;

        public function new(k:HabboInventory, _arg_2:IHabboWindowManager, _arg_3:IHabboCommunicationManager, _arg_4:IAssetLibrary, _arg_5:IRoomEngine, _arg_6:IHabboLocalizationManager)
        {
            this._habboInventory = k;
            this._communicationManager = _arg_3;
            this._assetLibrary = _arg_4;
            this._roomEngine = _arg_5;
            this._localizationManager = _arg_6;
        }

        public var running(get,never):Bool;
public function  get_running():Bool
        {
            return this._state == STATE_ACTIVE;
        }

        
        public var state(get,set):UInt;
public function  get_state():UInt
        {
            return this._state;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
public function  set_state(k:UInt):UInt        {
            return this._state = k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._habboInventory = null;
                this._communicationManager = null;
                this._assetLibrary = null;
                this._roomEngine = null;
                this._localizationManager = null;
                this._disposed = true;
            }
            this._Str_20195();
        }

        public function _Str_22646()
        {
            if (((this._habboInventory == null) || (this._habboInventory.furniModel == null)))
            {
                return;
            }
            this._state = STATE_ACTIVE;
            this._itemList = new Map();
            this._habboInventory.furniModel._Str_14978(true);
        }

        public function _Str_20195()
        {
            var _local_2 = 0;
            if ((((this._itemList == null) || (this._habboInventory == null)) || (this._habboInventory.furniModel == null)))
            {
                return;
            }
            this._state = _Str_599;
            this._habboInventory.furniModel._Str_14978(false);
            var k = 0;
            while ((k : UInt) < this._itemList.length)
            {
                _local_2 = ASCompat.toInt(this._itemList.getKey(k));
                this._habboInventory.furniModel._Str_10184(_local_2);
                k++;
            }
            this._itemList = null;
        }

        public function _Str_22697():Int
        {
            if ((((this._itemList == null) || (this._habboInventory == null)) || (this._habboInventory.furniModel == null)))
            {
                return 0;
            }
            var k= this._habboInventory.furniModel._Str_15313();
            if (k == null)
            {
                return 0;
            }
            if (this._itemList.getValue(k.id) == null)
            {
                this._itemList.add(k.id, k);
            }
            return k.id;
        }

        public function _Str_23825(k:Int):Bool
        {
            if (this._itemList == null)
            {
                return true;
            }
            var _local_2:IFurnitureItem = this._itemList.getValue(k);
            if (_local_2 == null)
            {
                return false;
            }
            var _local_3= this._habboInventory.furniModel;
            if (_local_3 == null)
            {
                return false;
            }
            _local_3._Str_10184(k);
            this._itemList.remove(k);
            return true;
        }

        public function _Str_23744():Array<ASAny>
        {
            var k= new Array<ASAny>();
            if (this._itemList == null)
            {
                return [];
            }
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._itemList.length)
            {
                k.push(this._itemList.getKey(_local_2));
                _local_2++;
            }
            return k;
        }

        public function onInventoryClose()
        {
        }

        public function onInventoryOpen()
        {
        }

        public function initCategory(k:String)
        {
        }

        public function onCategorySwitch(k:String)
        {
        }

        public function getWindowContainer():IWindowContainer
        {
            return null;
        }

        public function updateView()
        {
        }

        public function onSubcategorySwitch(k:String)
        {
            Logger.log(["NOT SUPPORTED: MARKETPLACE SELECT BY ID"]);
        }
    }

