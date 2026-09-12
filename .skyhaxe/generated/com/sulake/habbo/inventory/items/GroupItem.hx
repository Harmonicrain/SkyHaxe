package com.sulake.habbo.inventory.items
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.inventory.furni.FurniModel;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.IStuffData;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.habbo.sound.events.SongInfoReceivedEvent;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ILimitedItemGridOverlayWidget;
    import com.sulake.habbo.window.widgets.IChestItemGridOverlayWidget;
    import com.sulake.habbo.window.widgets.ChestItemGridOverlayWidget;
    import com.sulake.habbo.window.widgets._Str_3083;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.sound.ISongInfo;

     class GroupItem implements IGetImageListener 
    {
        static inline final INVENTORY_THUMB_XML= "inventory_thumb_xml";
        static inline final _Str_4072= 0xCCCCCC;
        static inline final _Str_4169= 10275685;

        static inline final _Str_18094:Float = 1;
        static inline final _Str_18535= 0.2;

        var _items:Map;
        var _window:IWindowContainer;
        var _model:FurniModel;
        var _type:Int = 0;
        var _roomEngine:IRoomEngine;
        var _Str_1352:Bool = false;
        var _Str_1007:Bool = false;
        var _category:Int = 0;
        var _stuffData:IStuffData;
        var _extra:Float = Math.NaN;
        var _Str_7053:Int = 0;
        var _Str_3155:BitmapData;
        var _Str_3412:Int = 0;
        var _Str_10374:Bool = false;
        var _Str_14011:Bool = false;
        var _Str_19058:Bool = false;
        var _icon:BitmapData;
        var _Str_2779:IWindow;
        var _Str_8275:Bool = false;
        var _Str_8894:Bool = false;
        var _alignment:String = "center";
        var _isInitialized:Bool = false;
        var _name:String = "";
        var _description:String = "";
        var _Str_14420:Int = -1;
        var _Str_4881:Int = -1;

        public function new(k:FurniModel, _arg_2:Int, _arg_3:Int, _arg_4:IRoomEngine, _arg_5:Bool, _arg_6:IStuffData, _arg_7:Float, _arg_8:BitmapData, _arg_9:Bool, _arg_10:String)
        {
            this._model = k;
            this._type = _arg_2;
            this._roomEngine = _arg_4;
            this._Str_14011 = _arg_5;
            this._items = new Map();
            this._category = _arg_3;
            this._stuffData = _arg_6;
            this._extra = _arg_7;
            this._alignment = _arg_10;
            this._icon = _arg_8;
            this._Str_19058 = _arg_9;
            switch (this._category)
            {
                case FurniCategory.WALL_PAPER:
                    this._name = this._model.controller.localization.getLocalization("inventory.furni.item.wallpaper.name");
                    this._description = this._model.controller.localization.getLocalization("inventory.furni.item.wallpaper.desc");
                    
                case FurniCategory.FLOOR:
                    this._name = this._model.controller.localization.getLocalization("inventory.furni.item.floor.name");
                    this._description = this._model.controller.localization.getLocalization("inventory.furni.item.floor.desc");
                    
                case FurniCategory.LANDSCAPE:
                    this._name = this._model.controller.localization.getLocalization("inventory.furni.item.landscape.name");
                    this._description = this._model.controller.localization.getLocalization("inventory.furni.item.landscape.desc");
                    
            }
            this._model.soundManager.events.addEventListener(SongInfoReceivedEvent.SIR_TRAX_SONG_INFO_RECEIVED, this.onSongInfoReceivedEvent);
        }

        public var _Str_23694(get,never):Bool;
public function  get__Str_23694():Bool
        {
            return this._isInitialized && this._Str_10374;
        }

        public var _Str_26366(get,never):Bool;
public function  get__Str_26366():Bool
        {
            return this._Str_7053 == -1;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            if (!this._isInitialized)
            {
                this._Str_22349();
            }
            if (this._window == null)
            {
                return null;
            }
            if (this._window.disposed)
            {
                return null;
            }
            return this._window;
        }

        
        public var _Str_6879(get,set):Bool;
public function  get__Str_6879():Bool
        {
            return this._Str_1352;
        }
public function  set__Str_6879(k:Bool):Bool        {
            return this._Str_1352 = k;
        }

        
        public var Selected(get,set):Bool;
public function  get_Selected():Bool
        {
            return this._Str_1007;
        }
public function  set_Selected(k:Bool):Bool        {
            if (this._Str_1007 != k)
            {
                this._Str_1007 = k;
                this._Str_8706();
            }
return k;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        
        public var icon(get,set):BitmapData;
public function  get_icon():BitmapData
        {
            return this._Str_3155;
        }
public function  set_icon(k:BitmapData):BitmapData        {
            return this._Str_3155 = k;
        }

        
        public var _Str_15216(get,set):Int;
public function  get__Str_15216():Int
        {
            return this._Str_7053;
        }
public function  set__Str_15216(k:Int):Int        {
            return this._Str_7053 = k;
        }

        
        public var previewCallbackId(get,set):Int;
public function  get_previewCallbackId():Int
        {
            return this._Str_3412;
        }
public function  set_previewCallbackId(k:Int):Int        {
            return this._Str_3412 = k;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }

        public var stuffData(get,never):IStuffData;
public function  get_stuffData():IStuffData
        {
            return this._stuffData;
        }

        public var extra(get,never):Float;
public function  get_extra():Float
        {
            return this._extra;
        }

        public var _Str_14978(never,set):Bool;
public function  set__Str_14978(k:Bool):Bool        {
            if (this._Str_14011 != k)
            {
                this._Str_14011 = k;
                this._Str_12824();
            }
return k;
        }

        
        public var _Str_6126(get,set):Bool;
public function  get__Str_6126():Bool
        {
            return this._Str_8275;
        }
public function  set__Str_6126(k:Bool):Bool        {
            if (this._Str_8275 != k)
            {
                this._Str_8275 = k;
                this._Str_13259();
            }
return k;
        }

        public var alignment(get,never):String;
public function  get_alignment():String
        {
            return this._alignment;
        }

        public var isWallItem(get,never):Bool;
public function  get_isWallItem():Bool
        {
            var k= this._Str_5087(0);
            return (k != null) ? k.isWallItem : false;
        }

        public var flatId(get,never):Int;
public function  get_flatId():Int
        {
            var k= this._Str_5087(0);
            return (k != null) ? k.flatId : -1;
        }

        public var isGroupable(get,never):Bool;
public function  get_isGroupable():Bool
        {
            var k= this._Str_5087(0);
            return (k != null) ? k.groupable : true;
        }

        public var _Str_3459(get,never):Bool;
public function  get__Str_3459():Bool
        {
            var k= this._Str_5087(0);
            return (k != null) ? k.rentable : false;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._description;
        }

        public function dispose()
        {
            if (this._model.soundManager != null)
            {
                if (this._model.soundManager.events != null)
                {
                    this._model.soundManager.events.removeEventListener(SongInfoReceivedEvent.SIR_TRAX_SONG_INFO_RECEIVED, this.onSongInfoReceivedEvent);
                }
            }
            this._model = null;
            this._Str_2779 = null;
            this._roomEngine = null;
            if (this._items != null)
            {
                this._items.dispose();
                this._items = null;
            }
            this._stuffData = null;
            if (this._window != null)
            {
                this._window.dispose();
            }
        }

        public function _Str_24322()
        {
            if (this._window != null)
            {
                this._window.procedure = null;
            }
        }

        public function _Str_20973(k:Bool=true)
        {
            var _local_2:ImageResult = null;
            if (this._Str_3155 != null)
            {
                return;
            }
            if (this._Str_10374)
            {
                return;
            }
            if (this.isWallItem)
            {
                _local_2 = this._roomEngine.getWallItemIcon(this._type, this, this._stuffData.getLegacyString());
            }
            else
            {
                _local_2 = this._roomEngine.getFurnitureIcon(this._type, this, Std.string(this._extra), this._stuffData);
            }
            if (_local_2.id > 0)
            {
                if (k)
                {
                    this._Str_22544(_local_2.data);
                }
                this._Str_7053 = _local_2.id;
            }
            else
            {
                this._Str_19507(_local_2.data);
                this._Str_7053 = -1;
            }
            this._Str_10374 = true;
        }

        public function push(k:FurnitureItem, _arg_2:Bool=false)
        {
            var _local_3:FurnitureItem = this._items.getValue(k.id);
            if (_local_3 == null)
            {
                this._items.add(k.id, k);
            }
            else
            {
                _local_3.locked = false;
            }
            this._Str_7686();
            this._Str_8706();
            if (((this._name == null) || (this._name.length == 0)))
            {
                this._name = this._Str_20913();
            }
            if (((this._description == null) || (this._description.length == 0)))
            {
                this._description = this._Str_21119();
            }
            if (_arg_2 != this._Str_8275)
            {
                this._Str_8275 = _arg_2;
                this._Str_13259();
            }
        }

        public function unshift(k:FurnitureItem)
        {
            var _local_2:FurnitureItem = this._items.getValue(k.id);
            if (_local_2 == null)
            {
                this._items.unshift(k.id, k);
            }
            else
            {
                _local_2.locked = false;
            }
            this._Str_10703();
        }

        public function pop():FurnitureItem
        {
            var k:FurnitureItem = null;
            if (this._items.length > 0)
            {
                k = ASCompat.dynamicAs(this._items.getWithIndex(ASCompat.toInt(this._items.length - 1)) , FurnitureItem);
                this._items.remove(k.id);
            }
            this._Str_10703();
            return k;
        }

        public function _Str_3205():FurnitureItem
        {
            var k:FurnitureItem = null;
            if (this._items.length > 0)
            {
                k = ASCompat.dynamicAs(this._items.getWithIndex(ASCompat.toInt(this._items.length - 1)) , FurnitureItem);
                this._Str_10703();
            }
            return k;
        }

        public function _Str_5087(k:Int):FurnitureItem
        {
            return this._items.getWithIndex(k);
        }

        public function _Str_25861(k:Int):Vector<IFurnitureItem>
        {
            var _local_6:FurnitureItem = null;
            var _local_2= new Vector<IFurnitureItem>();
            var _local_3:IFurnitureItem = this._Str_21356();
            if (_local_3 == null)
            {
                return _local_2;
            }
            var _local_4 = 0;
            var _local_5 = 0;
            while ((_local_5 : UInt) < this._items.length)
            {
                if (_local_4 >= k)
                {
                    break;
                }
                _local_6 = this._items.getWithIndex(_local_5);
                if ((((!_local_6.locked) && _local_6.tradeable) && (_local_6.type == _local_3.type)))
                {
                    _local_4++;
                    _local_2.push(_local_6);
                }
                _local_5++;
            }
            return _local_2;
        }

        public function _Str_21356():FurnitureItem
        {
            var _local_2:FurnitureItem = null;
            var _local_3:FurnitureItem = null;
            if (((this._Str_4881 >= 0) && ((this._Str_4881 : UInt) < this._items.length)))
            {
                _local_2 = this._items.getWithIndex(this._Str_4881);
                if (((!_local_2.locked) && _local_2.tradeable))
                {
                    return _local_2;
                }
            }
            var k = 0;
            while ((k : UInt) < this._items.length)
            {
                _local_3 = this._items.getWithIndex(k);
                if (((!_local_3.locked) && _local_3.tradeable))
                {
                    return _local_3;
                }
                k++;
            }
            return null;
        }

        public function _Str_25739():FurnitureItem
        {
            var _local_2:FurnitureItem = null;
            var k = 0;
            while ((k : UInt) < this._items.length)
            {
                _local_2 = this._items.getWithIndex(k);
                if (((!_local_2.locked) && _local_2.recyclable))
                {
                    this._Str_15750(_local_2.id);
                    return _local_2;
                }
                k++;
            }
            return null;
        }

        public function _Str_25918():FurnitureItem
        {
            var _local_2:FurnitureItem = null;
            var k = 0;
            while ((k : UInt) < this._items.length)
            {
                _local_2 = this._items.getWithIndex(k);
                if (((!_local_2.locked) && _local_2.sellable))
                {
                    return _local_2;
                }
                k++;
            }
            return null;
        }

        public function _Str_24519():Array<ASAny>
        {
            var _local_2:FurnitureItem = null;
            var k:Array<ASAny> = [];
            final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                k.push(_local_2.id);
            }
            return k;
        }

        public function _Str_25304():Array<ASAny>
        {
            var _local_2:FurnitureItem = null;
            var k:Array<ASAny> = [];
            final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                if (!_local_2.rentable)
                {
                    k.push(_local_2.id);
                }
            }
            return k;
        }

        public function _Str_15750(k:Int):Bool
        {
            var _local_3:FurnitureItem = null;
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._items.length)
            {
                _local_3 = this._items.getWithIndex(_local_2);
                if (_local_3.id == k)
                {
                    _local_3.locked = true;
                    this._Str_7686();
                    return true;
                }
                _local_2++;
            }
            return false;
        }

        public function _Str_25603(k:Array<ASAny>)
        {
            var _local_3 = false;
            var _local_4:FurnitureItem = null;
            var _local_5 = false;
            var _local_2= ASCompat.toInt(this._items.length - 1);
            while (_local_2 >= 0)
            {
                _local_4 = this._items.getWithIndex(_local_2);
                _local_5 = (k.indexOf(_local_4.ref) >= 0);
                if (_local_4.locked != _local_5)
                {
                    _local_4.locked = _local_5;
                    _local_3 = true;
                }
                _local_2--;
            }
            if (_local_3)
            {
                this._Str_7686();
            }
        }

        public function _Str_10184(k:Int):Bool
        {
            var _local_3:FurnitureItem = null;
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._items.length)
            {
                _local_3 = this._items.getWithIndex(_local_2);
                if (_local_3.id == k)
                {
                    _local_3.locked = false;
                    this._Str_7686();
                    this._Str_12824();
                    return true;
                }
                _local_2++;
            }
            return false;
        }

        public function _Str_12838()
        {
            var k = false;
            var _local_3:FurnitureItem = null;
            var _local_2= ASCompat.toInt(this._items.length - 1);
            while (_local_2 >= 0)
            {
                _local_3 = this._items.getWithIndex(_local_2);
                if (_local_3.locked)
                {
                    _local_3.locked = false;
                    k = true;
                }
                _local_2--;
            }
            if (k)
            {
                this._Str_7686();
            }
        }

        public function getTotalCount():Int
        {
            var k = 0;
            var _local_2 = 0;
            var _local_3:FurnitureItem = null;
            if (this.category == FurniCategory.POST_IT)
            {
                k = 0;
                _local_2 = 0;
                while ((_local_2 : UInt) < this._items.length)
                {
                    _local_3 = ASCompat.dynamicAs(this._items.getWithIndex(_local_2) , FurnitureItem);
                    k = (k + ASCompat.toInt(_local_3.stuffData.getLegacyString()));
                    _local_2++;
                }
                return k;
            }
            return ASCompat.toInt(this._items.length);
        }

        public function _Str_22135():Int
        {
            var _local_3:FurnitureItem = null;
            var k = 0;
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._items.length)
            {
                _local_3 = ASCompat.dynamicAs(this._items.getWithIndex(_local_2) , FurnitureItem);
                if ((_local_3.recyclable && (!_local_3.locked)))
                {
                    k++;
                }
                _local_2++;
            }
            return k;
        }

        public function _Str_24914():Int
        {
            var _local_3:FurnitureItem = null;
            var k = 0;
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._items.length)
            {
                _local_3 = ASCompat.dynamicAs(this._items.getWithIndex(_local_2) , FurnitureItem);
                if ((_local_3.tradeable && (!_local_3.locked)))
                {
                    k++;
                }
                _local_2++;
            }
            return k;
        }

        public function remove(k:Int):FurnitureItem
        {
            var _local_2:FurnitureItem = this._items.getValue(k);
            if (_local_2 != null)
            {
                this._items.remove(k);
                this._Str_10703();
                return _local_2;
            }
            return null;
        }

        public function getItem(k:Int):FurnitureItem
        {
            var _local_2:FurnitureItem = this._items.getValue(k);
            return _local_2;
        }

        public function _Str_23685(k:Int, _arg_2:FurnitureItem)
        {
            this._items.add(k, _arg_2);
            this._Str_10703();
        }

        public function getMinimumItemsToShowCounter():Int
        {
            return 2;
        }

        public function getUnlockedCount():Int
        {
            var k:FurnitureItem = null;
            if (this.category == FurniCategory.POST_IT)
            {
                return this.getTotalCount();
            }
            var _local_2 = 0;
            var _local_3 = 0;
            while ((_local_3 : UInt) < this._items.length)
            {
                k = this._items.getWithIndex(_local_3);
                if (!k.locked)
                {
                    _local_2++;
                }
                _local_3++;
            }
            return _local_2;
        }

        public function _Str_10703()
        {
            if (this._window == null)
            {
                return;
            }
            if (this._window.disposed)
            {
                return;
            }
            this._Str_11831();
            this._Str_13259();
            this._Str_7686();
            this._Str_12824();
            this._Str_8706();
            this._Str_25122();
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (this._window == null)
            {
                return;
            }
            if (this._window.disposed)
            {
                return;
            }
            if (this._Str_7053 != k)
            {
                return;
            }
            this._Str_3155 = _arg_2;
            this._Str_11831();
        }

        public function imageFailed(k:Int)
        {
        }

        function _Str_19507(k:BitmapData)
        {
            this._Str_3155 = k;
            this._Str_10374 = true;
            this._Str_7053 = -1;
            this._Str_11831();
        }

        function _Str_22544(k:BitmapData)
        {
            this._Str_3155 = k;
            this._Str_10374 = true;
            this._Str_11831();
        }

        function _Str_25122()
        {
            if (((this._window == null) || this._window.disposed))
            {
                return;
            }
            var k= this._Str_5087(0);
            var _local_2= Std.downcast(this._window.findChildByName("rent_state") , IStaticBitmapWrapperWindow);
            if (((!(k != null)) || (!this._Str_3459)))
            {
                _local_2.visible = false;
                return;
            }
            _local_2.visible = ((k.secondsToExpiration >= 0) && k.hasRentPeriodStarted);
            var _local_3= this._model.controller.getInteger("purchase.rent.warning_duration_seconds", 172800);
            _local_2.assetUri = ((k.secondsToExpiration < _local_3) ? "inventory_thumb_rent_ending" : "inventory_thumb_rent_started");
        }

        function _Str_7686()
        {
            var _local_5:ITextWindow = null;
            if (this._window == null)
            {
                return;
            }
            var k= this.getUnlockedCount();
            var _local_2:ASAny = (k >= this.getMinimumItemsToShowCounter());
            var _local_3= this._window.findChildByName("number_container");
            _local_3.visible = _local_2;
            if (_local_2)
            {
                _local_5 = Std.downcast(this._window.findChildByName("number") , ITextWindow);
                _local_5.text = Std.string(k);
            }
            var _local_4= Std.downcast(this._window.findChildByName("bitmap") , IBitmapWrapperWindow);
            if (k <= 0)
            {
                _local_4.blend = GroupItem._Str_18535;
            }
            else
            {
                _local_4.blend = GroupItem._Str_18094;
            }
        }

        function _Str_13259()
        {
            if (this._window == null)
            {
                return;
            }
            if (this._Str_2779 == null)
            {
                this._Str_2779 = this._window.findChildByTag("BG_COLOR");
            }
            this._Str_2779.color = (this._Str_8275 ? _Str_4169 : _Str_4072);
        }

        function _Str_8706()
        {
            if (this._window == null)
            {
                return;
            }
            this._window.findChildByName("outline").visible = this.Selected;
        }

        function _Str_12824()
        {
            if (this._window == null)
            {
                return;
            }
            var k= this._window.findChildByName("recyclable_container");
            if (k != null)
            {
                k.visible = (this._Str_14011 && (this._Str_22135() > 0));
            }
        }

        function _Str_11831()
        {
            var k:IWidgetWindow = null;
            var _local_2:ILimitedItemGridOverlayWidget = null;
            var _local_4:IWidgetWindow = null;
            var _local_5:_Str_3083 = null;
            var chestContainer:IWidgetWindow = null;
            var chestOverlay:IChestItemGridOverlayWidget = null;
            var chestBackground:IStaticBitmapWrapperWindow = null;
            var chestColor:String = null;
            if (this._window == null)
            {
                return;
            }
            if (this.stuffData.uniqueSerialNumber > 0)
            {
                k = cast(this._window.findChildByName("unique_item_overlay_container"), IWidgetWindow);
                _local_2 = cast(k.widget, ILimitedItemGridOverlayWidget);
                k.visible = true;
                _local_2.serialNumber = this.stuffData.uniqueSerialNumber;
                _local_2.animated = true;
                this._window.findChildByName("unique_item_background_bitmap").visible = true;
            }
            else
            {
                if (this.stuffData.rarityLevel >= 0)
                {
                    _local_4 = cast(this._window.findChildByName("rarity_item_overlay_container"), IWidgetWindow);
                    _local_5 = cast(_local_4.widget, _Str_3083);
                    _local_5.rarityLevel = this.stuffData.rarityLevel;
                    _local_4.visible = true;
                }
                else
                {
                    if (((this._category == FurniCategory.FURNI_CHEST) ||
                         (this._category == FurniCategory.COINS_CHEST)))
                    {
                        chestContainer = cast(
                            this._window.findChildByName("chest_overlay_container"), IWidgetWindow);
                        chestOverlay =
                            cast(chestContainer.widget, IChestItemGridOverlayWidget);
                        chestOverlay.contentsCount = this.stuffData.contentsCount;
                        chestContainer.visible = true;
                        chestColor =
                            this._category == FurniCategory.COINS_CHEST ?
                            ChestItemGridOverlayWidget.COLOR_GOLD :
                            ChestItemGridOverlayWidget.COLOR_BROWN;
                        chestOverlay.color = chestColor;
                        chestBackground = cast(
                            this._window.findChildByName("chest_background_bitmap"), IStaticBitmapWrapperWindow);
                        chestBackground.assetUri =
                            "chest_overlay_" + chestColor + "_background";
                        chestBackground.visible = true;
                    }
                }
            }
            var _local_3= Std.downcast(this._window.findChildByName("bitmap") , IBitmapWrapperWindow);
            if (_local_3 != null)
            {
                _local_3.bitmap = this._Str_3155;
            }
        }

        function _Str_13002(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = false;
            switch (k.type)
            {
                case WindowMouseEvent.UP:
                    this._Str_8894 = false;
                    this._model.cancelFurniInMover();
                    return;
                case WindowMouseEvent.DOWN:
                    this._model._Str_19669();
                    this.Selected = true;
                    this._Str_8894 = true;
                    this._model._Str_2944();
                    this._model._Str_21498 = this;
                    return;
                case WindowMouseEvent.OUT:
                    if (((!this._Str_8894) || this._model._Str_7553))
                    {
                        return;
                    }
                    _local_3 = this._model._Str_5337(true);
                    if (_local_3)
                    {
                        this._Str_8894 = false;
                    }
                    return;
                case WindowMouseEvent.CLICK:
                    this._Str_8894 = false;
                    return;
                case WindowMouseEvent.DOUBLE_CLICK:
                    this._model._Str_25520();
                    this._Str_8894 = false;
                    return;
            }
        }

        function _Str_22349()
        {
            this.createWindow();
            if (this._icon != null)
            {
                this._Str_19507(this._icon);
            }
            else
            {
                if (!this._Str_19058)
                {
                    this._Str_20973();
                }
            }
            this._window.procedure = this._Str_13002;
            this._window.name = ((this._roomEngine.getFurnitureType(this.type) + ".") + Std.string(this.category));
            if (((this.stuffData != null) && (!(this.stuffData.getLegacyString() == ""))))
            {
                this._window.name = (this._window.name + (".s" + this.stuffData));
            }
            if (!Math.isNaN(this.extra))
            {
                this._window.name = (this._window.name + (".e" + Std.string(this.extra)));
            }
            this._Str_13259();
            this._Str_7686();
            this._Str_11831();
            this._Str_12824();
            this._Str_8706();
            this._isInitialized = true;
        }

        function createWindow()
        {
            this._window = this._model.createItemWindow(INVENTORY_THUMB_XML);
        }

        function _Str_20913():String
        {
            var k:FurnitureItem = null;
            var _local_2:String = null;
            var _local_3:ISongInfo = null;
            k = this._Str_3205();
            if (k == null)
            {
                return "";
            }
            switch (this._category)
            {
                case FurniCategory.POSTER:
                    _local_2 = (("poster_" + k.stuffData.getLegacyString()) + "_name");
                    
                case FurniCategory.TRAX_SONG:
                    _local_3 = this._model.soundManager.musicController.getSongInfo(Std.int(k.extra));
                    if (_local_3 != null)
                    {
                        return _local_3.name;
                    }
                    this.getSongInfo(k);
                    return "";
                default:
                    if (this.isWallItem)
                    {
                        _local_2 = ("wallItem.name." + Std.string(k.type));
                    }
                    else
                    {
                        _local_2 = ("roomItem.name." + Std.string(k.type));
                    }
            }
            return this._model.controller.localization.getLocalization(_local_2);
        }

        function _Str_21119():String
        {
            var k:FurnitureItem = null;
            var _local_2:String = null;
            var _local_3:ISongInfo = null;
            k = this._Str_3205();
            if (k == null)
            {
                return "";
            }
            switch (this._category)
            {
                case FurniCategory.POSTER:
                    _local_2 = (("poster_" + k.stuffData.getLegacyString()) + "_desc");
                    
                case FurniCategory.TRAX_SONG:
                    _local_3 = this._model.soundManager.musicController.getSongInfo(Std.int(k.extra));
                    if (_local_3 != null)
                    {
                        return _local_3.creator;
                    }
                    this.getSongInfo(k);
                    return "";
                default:
                    if (this.isWallItem)
                    {
                        _local_2 = ("wallItem.desc." + Std.string(k.type));
                    }
                    else
                    {
                        _local_2 = ("roomItem.desc." + Std.string(k.type));
                    }
            }
            return this._model.controller.localization.getLocalization(_local_2);
        }

        function getSongInfo(k:FurnitureItem)
        {
            var _local_2 = 0;
            var _local_3:ISongInfo = null;
            if (k == null)
            {
                return;
            }
            this._Str_14420 = -1;
            if (k != null)
            {
                if (k.category == FurniCategory.TRAX_SONG)
                {
                    _local_2 = Std.int(k.extra);
                    _local_3 = this._model.soundManager.musicController.getSongInfo(_local_2);
                    if (_local_3 == null)
                    {
                        this._model.soundManager.musicController.requestSongInfoWithoutSamples(_local_2);
                        this._Str_14420 = _local_2;
                    }
                }
            }
        }

        function onSongInfoReceivedEvent(k:SongInfoReceivedEvent)
        {
            if (k.id == this._Str_14420)
            {
                this._Str_14420 = -1;
                this._name = this._Str_20913();
                this._description = this._Str_21119();
                if (this._model._Str_3968() == this)
                {
                    this._model._Str_2944();
                }
            }
        }

        
        public var _Str_4405(get,set):Int;
public function  get__Str_4405():Int
        {
            return this._Str_4881;
        }
public function  set__Str_4405(k:Int):Int        {
            if ((k : UInt) >= this._items.length)
            {
                k = 0;
            }
            return this._Str_4881 = k;
        }
    }

