package com.sulake.habbo.ui.widget.infostand
;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.tracking.HabboTracking;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar.pets.PetTypeEnum;
    import com.sulake.core.window.components.ITextWindow;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import flash.geom.Point;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ICountdownWidget;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniActionMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUserActionMessage;
    import com.sulake.habbo.catalog._enum.CatalogPageName;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.window.widgets._Str_4520;

     class InfoStandPetView 
    {
        static inline final _Str_5169= 162;
        static inline final _Str_16449= 16;
        static inline final _Str_3835= 4;
        static inline final _Str_5037:UInt = 0xDADADA;
        static inline final _Str_4952:UInt = 0x3A3A3A;
        static inline final _Str_18444:UInt = 2085362;
        static inline final _Str_15917:UInt = 39616;
        static inline final _Str_17718:UInt = 10513106;
        static inline final _Str_17091:UInt = 8734654;
        static inline final _Str_18621:UInt = 9094430;
        static inline final _Str_16706:UInt = 0x5E9D00;
        static inline final _Str_18945:UInt = 9094430;
        static inline final _Str_18838:UInt = 0x5E9D00;
        static inline final HAPPINESS= "happiness";
        static inline final EXPERIENCE= "experience";
        static inline final ENERGY= "energy";
        static inline final WELLBEING= "wellbeing";
        static inline final GROWTH= "growth";
        static inline final _Str_8222= 250;
        static inline final _Str_4468= 25;
        static inline final _Str_6207= 5;

        var _catalog:IHabboCatalog;
        var _habboTracking:IHabboTracking;
        var _widget:InfoStandWidget;
        var _window:IItemListWindow;
        var _border:IBorderWindow;
        var _buttonsContainer:IWindowContainer;
        var _infoElements:IItemListWindow;
        var _petCommadTool:PetCommandTool;
        var _petData:Map;
        var _currentPetId:Int = 0;

        public function new(k:InfoStandWidget, _arg_2:String, _arg_3:IHabboCatalog)
        {
            this._widget = k;
            this._catalog = _arg_3;
            this._habboTracking = HabboTracking.getInstance();
            this.createWindow(_arg_2);
            this._petData = new Map();
        }

        public function dispose()
        {
            this._widget = null;
            this._catalog = null;
            this._habboTracking = null;
            this._border = null;
            this._buttonsContainer = null;
            this._infoElements = null;
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = null;
            if (this._petCommadTool != null)
            {
                this._petCommadTool.dispose();
            }
            this._petCommadTool = null;
            if (this._petData != null)
            {
                this._petData.dispose();
                this._petData = null;
            }
        }

        public var window(get,never):IItemListWindow;
public function  get_window():IItemListWindow
        {
            return this._window;
        }

        function updateWindow()
        {
            if ((((this._infoElements == null) || (this._border == null)) || (this._buttonsContainer == null)))
            {
                return;
            }
            this._buttonsContainer.width = this._buttonsContainer.width;
            this._buttonsContainer.visible = (this._buttonsContainer.width > 0);
            this._infoElements.height = Std.int(this._infoElements.scrollableRegion.height);
            this._border.height = (this._infoElements.height + 20);
            this._window.width = Std.int(Math.max(this._border.width, this._buttonsContainer.width));
            this._window.height = Std.int(this._window.scrollableRegion.height);
            if (this._border.width < this._buttonsContainer.width)
            {
                this._border.x = (this._window.width - this._border.width);
                this._buttonsContainer.x = 0;
            }
            else
            {
                this._buttonsContainer.x = (this._window.width - this._buttonsContainer.width);
                this._border.x = 0;
            }
            this._widget._Str_10301();
        }

        public function _Str_4497(k:Int, _arg_2:BitmapData)
        {
            if (this._currentPetId == k)
            {
                this.image = _arg_2;
                this.updateWindow();
                this._Str_24040(_arg_2);
            }
        }

        function _Str_24040(k:BitmapData)
        {
            if (this._petCommadTool != null)
            {
                this._petCommadTool._Str_21945(k);
            }
        }

        public function update(k:InfoStandPetData)
        {
            var _local_2:String = null;
            var _local_3 = Math.NaN;
            var _local_4 = Math.NaN;
            var _local_5 = 0;
            var _local_6 = Math.NaN;
            this.name = k.name;
            this.image = k.image;
            this.ownerName = k.ownerName;
            this._Str_24737 = this._widget.localizations.getLocalization(this._Str_24487(k.type, k.unknownRarityLevel));
            this._Str_23761(k._Str_6943, (!(k.type == PetTypeEnum.MONSTERPLANT)));
            this._Str_25526 = k.age;
            this._Str_25746(k.level, k._Str_4276, (!(k.type == PetTypeEnum.MONSTERPLANT)));
            this._Str_25402(k.level, k.skillTresholds, k.type);
            this._Str_25516(k.rarityLevel, k.type);
            if (k.type == PetTypeEnum.MONSTERPLANT)
            {
                this._Str_14440("default", false);
                this._Str_14440("monsterplant", true);
                _local_2 = TimeFormatUtil._Str_22740(k.remainingTimeToLive);
                this._Str_9597(WELLBEING, k.remainingTimeToLive, k.maximumTimeToLive, _Str_18838, _Str_18945, _local_2);
                this._Str_22309(GROWTH, k.remainingGrowTime);
                this.showButton("petrespect", false);
                if (k.energy > 0)
                {
                    _local_3 = ASCompat.asNumber(k.energy );
                    _local_4 = ASCompat.asNumber(k._Str_3966 );
                    this.showButton("pettreat", ((_local_3 / _local_4) < 0.98));
                }
                else
                {
                    this.showButton("pettreat", false);
                }
                this.showButton("train", false);
                this.showButton("buy_food", false);
                this.showButton("kick", false);
                this.showButton("pick", k._Str_5114);
                this._Str_16559((k.rarityLevel >= 0), k);
            }
            else
            {
                this._Str_14440("default", true);
                this._Str_14440("monsterplant", false);
                this.showButton("petrespect", true);
                this.showButton("pettreat", false);
                this.showButton("train", k._Str_5175);
                this.showButton("pick", k._Str_5175);
                this.showButton("buy_food", true);
                this.showButton("kick", k._Str_5114);
                this._Str_9597(HAPPINESS, k.happyness, k._Str_4448, _Str_15917, _Str_18444);
                this._Str_9597(EXPERIENCE, k.experience, k._Str_4095, _Str_17091, _Str_17718);
                this._Str_9597(ENERGY, k.energy, k._Str_3966, _Str_16706, _Str_18621);
                this._Str_22251();
            }
            this.showButton("move", (k._Str_5175 && (k.type == PetTypeEnum.MONSTERPLANT)));
            this.showButton("rotate", (k._Str_5175 && (k.type == PetTypeEnum.MONSTERPLANT)));
            this.updateWindow();
            this._currentPetId = k.id;
            this._petData.remove(k.id);
            this._petData.add(k.id, k);
            if ((((this._petCommadTool != null) && this._petCommadTool.isVisible()) && k._Str_5175))
            {
                _local_5 = this._Str_16104(k.level, k.skillTresholds);
                _local_6 = (k.experience / k._Str_4095);
                this._petCommadTool._Str_19046(k.id, k.name, k.image, k.type, (k.level - _local_5), _local_6, (this._Str_19542(k.level, k.skillTresholds) - _local_5), k.skillTresholds);
            }
        }

        function _Str_25516(k:Int, _arg_2:Int)
        {
            var _local_3:Array<ASAny> = [PetTypeEnum.MONSTERPLANT, PetTypeEnum.GNOME];
            var _local_4= ((_arg_2 != PetTypeEnum.MONSTERPLANT) ? "default" : "monsterplant");
            var _local_5= this._Str_20171(_local_4);
            var _local_6= Std.downcast(_local_5.getListItemByName("status_rarity_level") , ITextWindow);
            if (_local_6 == null)
            {
                return;
            }
            _local_6.visible = (_local_3.indexOf(_arg_2) > -1);
            this._widget.localizations.registerParameter("infostand.pet.text.raritylevel", "level", this._widget.localizations.getLocalization(("infostand.pet.raritylevel." + Std.string(k))));
            this.updateWindow();
        }

        public function _Str_23859():Int
        {
            return this._currentPetId;
        }

        public function _Str_24853(k:Int, _arg_2:CommandConfiguration)
        {
            if (this._petCommadTool == null)
            {
                return;
            }
            this._petCommadTool._Str_23216(k, _arg_2);
        }

        function _Str_24487(k:Int, _arg_2:Int):String
        {
            return (("pet.breed." + Std.string(k)) + ".") + Std.string(_arg_2);
        }

        function _Str_12421(k:Int, _arg_2:Int, _arg_3:UInt, _arg_4:UInt):BitmapData
        {
            _arg_2 = Std.int(Math.max(_arg_2, 1));
            k = Std.int(Math.max(k, 0));
            if (k > _arg_2)
            {
                k = _arg_2;
            }
            var _local_5= (k / _arg_2);
            var _local_6= 1;
            var _local_7= new BitmapData(_Str_5169, _Str_16449, false);
            _local_7.fillRect(new Rectangle(0, 0, _local_7.width, _local_7.height), _Str_5037);
            var _local_8= new Rectangle(_local_6, _local_6, (_local_7.width - (_local_6 * 2)), (_local_7.height - (_local_6 * 2)));
            _local_7.fillRect(_local_8, _Str_4952);
            var _local_9= new Rectangle(_local_6, (_local_6 + _Str_3835), (_local_7.width - (_local_6 * 2)), ((_local_7.height - (_local_6 * 2)) - _Str_3835));
            _local_9.width = (_local_5 * _local_9.width);
            _local_7.fillRect(_local_9, _arg_3);
            var _local_10= new Rectangle(_local_6, _local_6, (_local_7.width - (_local_6 * 2)), _Str_3835);
            _local_10.width = (_local_5 * _local_10.width);
            _local_7.fillRect(_local_10, _arg_4);
            return _local_7;
        }

        public function _Str_19969()
        {
            var _local_2 = 0;
            var _local_3 = Math.NaN;
            if (this._petCommadTool == null)
            {
                this._petCommadTool = new PetCommandTool(this._widget);
            }
            var k= ASCompat.dynamicAs(this._petData.getValue(this._currentPetId) , InfoStandPetData);
            if (k != null)
            {
                this._petCommadTool.showWindow(true);
                _local_2 = this._Str_16104(k.level, k.skillTresholds);
                _local_3 = (k.experience / k._Str_4095);
                this._petCommadTool._Str_19046(k.id, k.name, k.image, k.type, (k.level - _local_2), _local_3, (this._Str_19542(k.level, k.skillTresholds) - _local_2), k.skillTresholds);
            }
        }

        public function _Str_23384()
        {
            if (((this._petCommadTool != null) && (this._petCommadTool._Str_18025() == this._currentPetId)))
            {
                this._petCommadTool.showWindow(false);
            }
        }

        function createWindow(k:String)
        {
            var _local_5:IWindow = null;
            var _local_6:IBitmapWrapperWindow = null;
            var _local_12:IWindow = null;
            var _local_13:BitmapDataAsset = null;
            var _local_14:BitmapData = null;
            var _local_15:BitmapDataAsset = null;
            var _local_16:BitmapData = null;
            var _local_17:BitmapDataAsset = null;
            var _local_18:BitmapData = null;
            var _local_19:BitmapDataAsset = null;
            var _local_20:BitmapData = null;
            var _local_21:BitmapDataAsset = null;
            var _local_22:BitmapData = null;
            var _local_23:BitmapDataAsset = null;
            var _local_24:BitmapData = null;
            var _local_2= Std.downcast(this._widget.assets.getAssetByName("pet_view") , XmlAsset);
            this._window = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IItemListWindow);
            if (this._window == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            this._border = Std.downcast(this._window.getListItemByName("info_border") , IBorderWindow);
            if (this._border != null)
            {
                this._infoElements = Std.downcast(this._border.findChildByName("infostand_element_list") , IItemListWindow);
            }
            this._window.name = k;
            this._widget.mainContainer.addChild(this._window);
            var _local_3= this._border.findChildByTag("close");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            }
            this._buttonsContainer = Std.downcast(this._window.getListItemByName("button_list") , IWindowContainer);
            if (this._buttonsContainer == null)
            {
                return;
            }
            var _local_4:Array<ASAny> = [];
            this._buttonsContainer.groupChildrenWithTag("CMD_BUTTON", _local_4, -1);
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_5  = _tmp_;
                _local_5.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
            _local_6 = Std.downcast(this._border.findChildByName("petrespect_icon") , IBitmapWrapperWindow);
            if (_local_6 != null)
            {
                _local_13 = Std.downcast(this._widget.assets.getAssetByName("icon_petrespect") , BitmapDataAsset);
                _local_14 = ASCompat.dynamicAs(_local_13.content , BitmapData);
                _local_6.bitmap = _local_14.clone();
            }
            var _local_7= Std.downcast(this._border.findChildByName("status_happiness_icon") , IBitmapWrapperWindow);
            if (_local_7 != null)
            {
                _local_15 = Std.downcast(this._widget.assets.getAssetByName("icon_pet_happiness") , BitmapDataAsset);
                _local_16 = ASCompat.dynamicAs(_local_15.content , BitmapData);
                _local_7.bitmap = _local_16.clone();
            }
            var _local_8= Std.downcast(this._border.findChildByName("status_experience_icon") , IBitmapWrapperWindow);
            if (_local_8 != null)
            {
                _local_17 = Std.downcast(this._widget.assets.getAssetByName("icon_pet_experience") , BitmapDataAsset);
                _local_18 = ASCompat.dynamicAs(_local_17.content , BitmapData);
                _local_8.bitmap = _local_18.clone();
            }
            var _local_9= Std.downcast(this._border.findChildByName("status_energy_icon") , IBitmapWrapperWindow);
            if (_local_9 != null)
            {
                _local_19 = Std.downcast(this._widget.assets.getAssetByName("icon_pet_energy") , BitmapDataAsset);
                _local_20 = ASCompat.dynamicAs(_local_19.content , BitmapData);
                _local_9.bitmap = _local_20.clone();
            }
            var _local_10= Std.downcast(this._border.findChildByName("skill_level_indicator") , IBitmapWrapperWindow);
            if (_local_10 != null)
            {
                _local_21 = Std.downcast(this._widget.assets.getAssetByName("pet_skill_level_0") , BitmapDataAsset);
                _local_22 = ASCompat.dynamicAs(_local_21.content , BitmapData);
                _local_10.bitmap = _local_22.clone();
            }
            var _local_11= Std.downcast(this._border.findChildByName("status_wellbeing_icon") , IBitmapWrapperWindow);
            if (_local_11 != null)
            {
                _local_23 = Std.downcast(this._widget.assets.getAssetByName("icon_pet_wellbeing") , BitmapDataAsset);
                _local_24 = ASCompat.dynamicAs(_local_23.content , BitmapData);
                _local_11.bitmap = _local_24.clone();
            }
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_12  = _tmp_;
                if (_local_12.parent != null)
                {
                    _local_12.parent.width = _local_12.width;
                }
                _local_12.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_17596);
            }
        }

        var name(never,set):String;
function  set_name(k:String):String        {
            if (this._infoElements == null)
            {
                return k;
            }
            var _local_2= Std.downcast(this._infoElements.getListItemByName("name_text") , ITextWindow);
            if (_local_2 == null)
            {
                return k;
            }
            _local_2.text = k;
            _local_2.visible = true;
return k;
        }

        var image(never,set):BitmapData;
function  set_image(k:BitmapData):BitmapData        {
            if (this._infoElements == null)
            {
                return k;
            }
            if (k == null)
            {
                return k;
            }
            var _local_2= Std.downcast(this._infoElements.getListItemByName("image_container") , IWindowContainer);
            if (_local_2 == null)
            {
                return k;
            }
            var _local_3= Std.downcast(_local_2.findChildByName("avatar_image") , IBitmapWrapperWindow);
            if (_local_3 == null)
            {
                return k;
            }
            var _local_4= new BitmapData(_local_3.width, _local_3.height, true, 0);
            var _local_5= new Point(0, 0);
            _local_5.x = Math.fround(((_local_3.width - k.width) / 2));
            _local_5.y = Math.fround(((_local_3.height - k.height) / 2));
            _local_4.copyPixels(k, k.rect, _local_5);
            _local_3.bitmap = _local_4;
            _local_3.invalidate();
            this.updateWindow();
return k;
        }

        function _Str_25746(k:Int, _arg_2:Int, _arg_3:Bool=true)
        {
            if (this._infoElements == null)
            {
                return;
            }
            var _local_4= Std.downcast(this._infoElements.getListItemByName("image_container") , IWindowContainer);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= Std.downcast(_local_4.findChildByName("level_text") , ITextWindow);
            if (_local_5 == null)
            {
                return;
            }
            _local_5.visible = _arg_3;
            this._widget.localizations.registerParameter("pet.level", "level", Std.string(k));
            this._widget.localizations.registerParameter("pet.level", "maxlevel", Std.string(_arg_2));
            this.updateWindow();
        }

        function _Str_25402(k:Int, _arg_2:Array<ASAny>, _arg_3:Int)
        {
            var _local_8 = 0;
            var _local_9:BitmapDataAsset = null;
            var _local_10:BitmapData = null;
            if (this._infoElements == null)
            {
                return;
            }
            var _local_4= Std.downcast(this._infoElements.getListItemByName("image_container") , IWindowContainer);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= _local_4.findChildByName("status_skill_text");
            _local_5.visible = (this._widget.config.getBoolean("pet.enhancements.enabled") && (_arg_3 == 15));
            var _local_6= Std.downcast(_local_4.findChildByName("status_skill_text") , ITextWindow);
            if (_local_6 != null)
            {
                _local_6.caption = (("${infostand.pet.text.skill." + Std.string(_arg_3)) + "}");
            }
            var _local_7= Std.downcast(_local_4.findChildByName("skill_level_indicator") , IBitmapWrapperWindow);
            if (_local_7 != null)
            {
                _local_7.visible = (this._widget.config.getBoolean("pet.enhancements.enabled") && (_arg_3 == 15));
                _local_8 = this._Str_22683(k, _arg_2);
                _local_9 = Std.downcast(this._widget.assets.getAssetByName(("pet_skill_level_" + Std.string(_local_8))) , BitmapDataAsset);
                _local_10 = ASCompat.dynamicAs(_local_9.content , BitmapData);
                _local_7.bitmap = _local_10.clone();
            }
            this.updateWindow();
        }

        var ownerName(never,set):String;
function  set_ownerName(k:String):String        {
            this._widget.localizations.registerParameter("infostand.text.petowner", "name", k);
            this.updateWindow();
return k;
        }

        var _Str_24737(never,set):String;
function  set__Str_24737(k:String):String        {
            if (this._infoElements == null)
            {
                return k;
            }
            var _local_2= Std.downcast(this._infoElements.getListItemByName("breed_text") , ITextWindow);
            if (_local_2 == null)
            {
                return k;
            }
            _local_2.text = k;
            this.updateWindow();
return k;
        }

        var _Str_25526(never,set):Int;
function  set__Str_25526(k:Int):Int        {
            if (this._infoElements == null)
            {
                return k;
            }
            var _local_2= Std.downcast(this._infoElements.getListItemByName("age_text") , ITextWindow);
            if (_local_2 == null)
            {
                return k;
            }
            this._widget.localizations.registerParameter("pet.age", "age", Std.string(k));
            this.updateWindow();
return k;
        }

        function _Str_23761(k:Int, _arg_2:Bool)
        {
            this._widget.localizations.registerParameter("infostand.text.petrespect", "count", Std.string(k));
            if (this._infoElements == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._infoElements.getListItemByName("petrespect_container") , IWindowContainer);
            var _local_4= Std.downcast(_local_3.findChildByName("petrespect_text") , ITextWindow);
            var _local_5= Std.downcast(_local_3.findChildByName("petrespect_icon") , IBitmapWrapperWindow);
            _local_4.visible = _arg_2;
            _local_5.visible = _arg_2;
            _local_5.x = ((_local_4.x + _local_4.width) + 2);
            this.updateWindow();
        }

        function _Str_14440(k:String, _arg_2:Bool)
        {
            var _local_3= this._Str_20171(k);
            if (_local_3 != null)
            {
                _local_3.visible = _arg_2;
            }
        }

        function _Str_20171(k:String):IItemListWindow
        {
            if (this._infoElements == null)
            {
                return null;
            }
            var _local_2= Std.downcast(this._infoElements.getListItemByName("status_container") , IWindowContainer);
            if (_local_2 == null)
            {
                return null;
            }
            return Std.downcast(_local_2.findChildByName(("status_item_list_" + k)) , IItemListWindow);
        }

        function _Str_22309(k:String, _arg_2:Int)
        {
            var _local_3:IWindowContainer = null;
            var _local_4:IWidgetWindow = null;
            var _local_6 = false;
            var _local_7 = false;
            var _local_8:ITextWindow = null;
            var _local_9:IItemListWindow = null;
            if (this._infoElements == null)
            {
                return;
            }
            _local_3 = Std.downcast(this._infoElements.getListItemByName("status_container") , IWindowContainer);
            if (_local_3 == null)
            {
                return;
            }
            _local_4 = Std.downcast(_local_3.findChildByName((k + "_status_widget")) , IWidgetWindow);
            var _local_5= _local_4.widget;
            if (_local_5 == null)
            {
                return;
            }
            switch (k)
            {
                case GROWTH:
                    Std.downcast(_local_5 , ICountdownWidget).seconds = _arg_2;
                    _local_6 = (_arg_2 > 0);
                    _local_7 = (!(_local_4.visible == _local_6));
                    _local_4.visible = _local_6;
                    _local_8 = Std.downcast(_local_3.findChildByName((k + "_status_text")) , ITextWindow);
                    if (_local_8 != null)
                    {
                        _local_8.visible = _local_6;
                    }
                    if (_local_7)
                    {
                        _local_9 = Std.downcast(_local_3.findChildByName("status_item_list_monsterplant") , IItemListWindow);
                        if (_local_9 != null)
                        {
                            _local_9.arrangeListItems();
                        }
                    }
                    return;
            }
        }

        function _Str_9597(k:String, _arg_2:Int, _arg_3:Int, _arg_4:UInt, _arg_5:UInt, _arg_6:String=null)
        {
            var _local_10:BitmapData = null;
            if (this._infoElements == null)
            {
                return;
            }
            var _local_7= Std.downcast(this._infoElements.getListItemByName("status_container") , IWindowContainer);
            if (_local_7 == null)
            {
                return;
            }
            var _local_8= Std.downcast(_local_7.findChildByName((("status_" + k) + "_value_text")) , ITextWindow);
            if (_local_8 != null)
            {
                _local_8.text = ((_arg_6 != null) ? _arg_6 : ((Std.string(_arg_2) + "/") + Std.string(_arg_3)));
            }
            var _local_9= Std.downcast(_local_7.findChildByName((("status_" + k) + "_bitmap")) , IBitmapWrapperWindow);
            if (_local_9 != null)
            {
                _local_10 = this._Str_12421(_arg_2, _arg_3, _arg_4, _arg_5);
                if (_local_10 != null)
                {
                    _local_9.bitmap = _local_10;
                    _local_9.width = _local_10.width;
                    _local_9.height = _local_10.height;
                    _local_9.invalidate();
                }
            }
            this.updateWindow();
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            var _local_2:RoomWidgetMessage = null;
            var _local_3:String = null;
            var _local_5:String = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_4= k.target ;
            switch (_local_4.name)
            {
                case "btn_move":
                    _local_3 = RoomWidgetFurniActionMessage.RWFAM_MOVE;
                    
                case "btn_rotate":
                    _local_3 = RoomWidgetFurniActionMessage.RWFUAM_ROTATE;
                    
                case "btn_pick":
                    _local_3 = RoomWidgetUserActionMessage.RWUAM_PICKUP_PET;
                    if (((this._petCommadTool != null) && (this._petCommadTool._Str_18025() == this._currentPetId)))
                    {
                        this._petCommadTool.showWindow(false);
                    }
                    
                case "btn_kick":
                    _local_3 = RoomWidgetUserActionMessage.RWUAM_PICKUP_PET;
                    if (((this._petCommadTool != null) && (this._petCommadTool._Str_18025() == this._currentPetId)))
                    {
                        this._petCommadTool.showWindow(false);
                    }
                    
                case "btn_train":
                    this._Str_19969();
                    
                case "btn_buy_food":
                    if (this._catalog != null)
                    {
                        this._catalog.openCatalogPage(CatalogPageName.PET_ACCESSORIES);
                        if (((this._habboTracking != null) && (!this._habboTracking.disposed)))
                        {
                            this._habboTracking.trackGoogle("infostandBuyPetFoodButton", "click");
                        }
                    }
                    
                case "btn_petrespect":
                    this._widget.userData.petRespectLeft--;
                    this._Str_22251();
                    _local_3 = RoomWidgetUserActionMessage.RESPECT_PET;
                    
                case "btn_pettreat":
                    _local_3 = RoomWidgetUserActionMessage.RWUAM_TREAT_PET;
                    
            }
            if (_local_3 != null)
            {
                if (((_local_3 == RoomWidgetFurniActionMessage.RWFAM_MOVE) || (_local_3 == RoomWidgetFurniActionMessage.RWFUAM_ROTATE)))
                {
                    _local_6 = this._widget.petData.roomIndex;
                    _local_7 = RoomObjectCategoryEnum.OBJECT_CATEGORY_USER;
                    _local_2 = new RoomWidgetFurniActionMessage(_local_3, _local_6, _local_7, -1, _local_5);
                    this._widget.messageListener.processWidgetMessage(_local_2);
                }
                else
                {
                    _local_8 = this._widget.petData.id;
                    _local_2 = new RoomWidgetUserActionMessage(_local_3, _local_8);
                    this._widget.messageListener.processWidgetMessage(_local_2);
                }
            }
            this.updateWindow();
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this._widget.close();
        }

        function _Str_22251()
        {
            var k= this._widget.userData.petRespectLeft;
            this._widget.localizations.registerParameter("infostand.button.petrespect", "count", Std.string(k));
            this.showButton("petrespect", (k > 0));
        }

        function showButton(k:String, _arg_2:Bool)
        {
            if (this._buttonsContainer == null)
            {
                return;
            }
            var _local_3= this._buttonsContainer.getChildByName(k);
            if (_local_3 != null)
            {
                _local_3.visible = _arg_2;
                this._Str_18168();
            }
        }

        function _Str_17596(k:WindowEvent)
        {
            var _local_2= k.window.parent;
            if (((_local_2 != null) && (_local_2.tags.indexOf("CMD_BUTTON_REGION") > -1)))
            {
                _local_2.width = k.window.width;
            }
        }

        function _Str_18168()
        {
            var _local_5:IWindow = null;
            var k= _Str_8222;
            this._buttonsContainer.width = k;
            var _local_2:Array<ASAny> = [];
            this._buttonsContainer.groupChildrenWithTag("CMD_BUTTON_REGION", _local_2, -1);
            var _local_3= k;
            var _local_4 = 0;
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_5  = _tmp_;
                if (_local_5.visible)
                {
                    if ((_local_3 - _local_5.width) < 0)
                    {
                        _local_3 = k;
                        _local_4 = (_local_4 + (_Str_4468 + _Str_6207));
                    }
                    _local_5.x = (_local_3 - _local_5.width);
                    _local_5.y = _local_4;
                    _local_3 = (_local_5.x - _Str_6207);
                }
            }
            this._buttonsContainer.height = (_local_4 + _Str_4468);
            this.updateWindow();
        }

        function _Str_22683(k:Int, _arg_2:Array<ASAny>):Int
        {
            var _local_4 = 0;
            var _local_3 = 0;
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_4  = ASCompat.toInt(_tmp_);
                if (((_local_4 > 0) && (k >= _local_4)))
                {
                    _local_3++;
                }
            }
            return _local_3;
        }

        function _Str_16104(k:Int, _arg_2:Array<ASAny>):Int
        {
            var _local_4 = 0;
            var _local_3 = 0;
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_4  = ASCompat.toInt(_tmp_);
                if (_local_4 <= k)
                {
                    _local_3 = _local_4;
                }
                else
                {
                    break;
                }
            }
            return _local_3;
        }

        function _Str_19542(k:Int, _arg_2:Array<ASAny>):Int
        {
            var _local_3= this._Str_16104(k, _arg_2);
            var _local_4= _arg_2.indexOf(_local_3);
            var _local_5= _local_3;
            if (_local_4 < (_arg_2.length - 1))
            {
                _local_5 = ASCompat.toInt(_arg_2[(_local_4 + 1)]);
            }
            return _local_5;
        }

        function _Str_16559(k:Bool, _arg_2:InfoStandPetData)
        {
            if (this._infoElements == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._infoElements.getListItemByName("status_container") , IWindowContainer);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= Std.downcast(_local_3.findChildByName("rarity_item_overlay_widget") , IWidgetWindow);
            var _local_5= _local_4.widget;
            if (_local_5 == null)
            {
                return;
            }
            var _local_6= cast(_local_5, _Str_4520);
            _local_6.rarityLevel = _arg_2.rarityLevel;
        }
    }

