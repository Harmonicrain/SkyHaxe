package com.sulake.habbo.campaign.calendar
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.campaign.HabboCampaigns;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.Stage;
    import flash.events.Event;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.session.product.IProductData;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication.messages.parser.campaign.CampaignCalendarData;

     class CalendarView implements IGetImageListener 
    {
        static inline final MARGIN= 75;

        var _controller:HabboCampaigns;
        var _modal:IModalDialog;
        var _selectedIndex:Int = -1;
        var _itemsOnScreen:Int = 0;

        public function new(k:HabboCampaigns, _arg_2:IHabboWindowManager)
        {
            var _local_7:IWindowContainer = null;
            this._controller = k;
            this._modal = _arg_2.buildModalDialogFromXML(new com.sulake.core.utils.xml.XML(this._controller.assets.getAssetByName("campaign_calendar_xml").content));
            if ((((!(this._modal != null)) || (!(this._modal.rootWindow != null))) || (!(this.itemList != null))))
            {
                return;
            }
            var _local_3= Std.downcast(this.itemList.getListItemAt(0) , IWindowContainer);
            this.itemList.removeListItems();
            this.itemList.disableAutodrag = true;
            var _local_4= this._Str_6223._Str_8399;
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_7 = CalendarItem._Str_15147(_local_3, this._Str_6223, _local_5);
                _local_7.procedure = this.onInput;
                this.itemList.addListItem(_local_7);
                _local_5++;
            }
            this.itemList.scrollStepH = (_local_3.width / this.itemList.maxScrollH);
            var _local_6= this._controller.context.displayObjectContainer.stage;
            _local_6.addEventListener(Event.RESIZE, (this.onResize : ASAny));
            this.window.procedure = this.onInput;
            this.onResize(null);
            this._Str_10170(this._controller._Str_6223._Str_5472);
        }

        public function dispose()
        {
            var k:Stage = null;
            if (this._modal != null)
            {
                k = this._controller.context.displayObjectContainer.stage;
                k.removeEventListener(Event.RESIZE, (this.onResize : ASAny));
                this._modal.dispose();
                this._modal = null;
            }
        }

        public function _Str_22076(k:IProductData, _arg_2:String=null)
        {
            this._Str_5311("${campaign.calendar.heading.product.received}", k.name);
            this._Str_13922(_arg_2);
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            this._Str_13922(_arg_2);
        }

        function _Str_13922(k:ASObject)
        {
            var _local_2= Std.downcast(this.itemList.getListItemAt(this._selectedIndex) , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            CalendarItem._Str_13922(_local_2, k);
        }

        public function imageFailed(k:Int)
        {
        }

        public function hide()
        {
            this._controller._Str_24884();
        }

        function onResize(k:Event)
        {
            var _local_2= this._controller.context.displayObjectContainer.stage;
            this._itemsOnScreen = Std.int(Math.ffloor(((_local_2.stageWidth - (MARGIN * 2)) / (this._Str_13395 + this._Str_18214))));
            this._modal.rootWindow.width = Std.int(this._Str_18893(this._itemsOnScreen));
            var _local_3= this.window.findChildByName("btn_forward");
            if (_local_3 != null)
            {
                _local_3.x = ((this._Str_8780 - this.window.findChildByName("btn_back").x) - _local_3.width);
            }
            _local_3 = this.window.findChildByName("calendar_scrollbar");
            if (_local_3 != null)
            {
                _local_3.width = this._Str_8780;
            }
            this.window.center();
            if (this._selectedIndex > -1)
            {
                this._Str_10170(this._selectedIndex);
            }
        }

        function onInput(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            if (k.type != WindowMouseEvent.DOWN)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "btn_present":
                    _local_3 = this.itemList.getListItemIndex(k.target.parent);
                    if (_local_3 < 0)
                    {
                        return;
                    }
                    if (_local_3 != this._selectedIndex)
                    {
                        this._Str_10170(_local_3);
                    }
                    else
                    {
                        this._controller.OpenCampaignCalendarDoor1(this._selectedIndex);
                    }
                    return;
                case "btn_back":
                    this._Str_10170((this._selectedIndex - 1));
                    return;
                case "btn_forward":
                    this._Str_10170((this._selectedIndex + 1));
                    return;
                case "btn_force_open":
                    this._controller.OpenCampaignCalendarDoor2(this._selectedIndex);
                    return;
                case "header_button_close":
                    this.hide();
                    return;
            }
        }

        function _Str_10170(k:Int)
        {
            var _local_3:IButtonWindow = null;
            var _local_5:IWindowContainer = null;
            var _local_6:String = null;
            var _local_7:String = null;
            if (((k < 0) || (k >= this._Str_6223._Str_8399)))
            {
                return;
            }
            this._selectedIndex = k;
            this.itemList.scrollH = this._Str_24961(this._selectedIndex);
            var _local_2 = 0;
            while (_local_2 < this._Str_6223._Str_8399)
            {
                _local_5 = Std.downcast(this.itemList.getListItemAt(_local_2) , IWindowContainer);
                CalendarItem._Str_3820(_local_5, this._Str_6223, _local_2, k);
                _local_2++;
            }
            CalendarSpinnerUtil._Str_25753(this, this._selectedIndex);
            if (this._controller.isAnyRoomController)
            {
                _local_3 = Std.downcast(this.window.findChildByName("btn_force_open") , IButtonWindow);
                _local_3.visible = true;
            }
            var _local_4= CalendarItem._Str_9903(this._Str_6223, k);
            if (this._selectedIndex < 0)
            {
                this._Str_5311(null, null);
                if (_local_3 != null)
                {
                    _local_3.disable();
                }
            }
            else
            {
                switch (_local_4)
                {
                    case CalendarItem._Str_8424:
                        _local_6 = "${campaign.calendar.info.available.desktop}";
                        
                    case CalendarItem._Str_10321:
                        _local_6 = "${campaign.calendar.info.expired}";
                        
                    case CalendarItem._Str_10951:
                        _local_6 = "${campaign.calendar.info.future}";
                        
                    case CalendarItem._Str_5399:
                        _local_6 = "${campaign.calendar.info.unlocked}";
                        
                }
                _local_7 = ASCompat.thisOrDefault(this._controller.localizationManager.getLocalization("campaign.calendar.heading.day") , "");
                _local_7 = ASCompat.stringReplace(_local_7, "%number%", (this._selectedIndex + 1));
                this._Str_5311(_local_7, _local_6);
                if (_local_3 != null)
                {
                    if (_local_4 != CalendarItem._Str_5399)
                    {
                        _local_3.enable();
                    }
                    else
                    {
                        _local_3.disable();
                    }
                }
            }
        }

        function _Str_5311(k:String, _arg_2:String)
        {
            Std.downcast(this.window.findChildByName("info_heading") , ITextWindow).text = (if (ASCompat.stringAsBool(k)) k; else "");
            Std.downcast(this.window.findChildByName("info_body") , ITextWindow).text = (if (ASCompat.stringAsBool(_arg_2)) _arg_2; else "");
        }

        function _Str_26047(k:Int)
        {
        }

        public var window(get,never):IFrameWindow;
public function  get_window():IFrameWindow
        {
            return (this._modal != null) ? Std.downcast(this._modal.rootWindow , IFrameWindow) : null;
        }

        function _Str_26368(k:Int):Int
        {
            return Std.int(Math.ffloor((((this.itemList.scrollH * this.itemList.maxScrollH) + k) / ((this.itemList.maxScrollH + this._Str_8780) / this.itemList.numListItems))));
        }

        function _Str_24961(k:Int):Float
        {
            return (this._Str_18893(k) - ((this._Str_8780 - this._Str_13395) * 0.5)) / this.itemList.maxScrollH;
        }

        public function _Str_18893(k:Int):Float
        {
            return (k * this._Str_13395) + (Math.max(0, (k - 1)) * this._Str_18214);
        }

        public var itemList(get,never):IItemListWindow;
public function  get_itemList():IItemListWindow
        {
            return (this.window != null) ? Std.downcast(this.window.findChildByName("calendar_itemlist") , IItemListWindow) : null;
        }

        public var _Str_13395(get,never):Int;
public function  get__Str_13395():Int
        {
            return ((this.itemList != null) && (this.itemList.numListItems > 0)) ? this.itemList.getListItemAt(0).width : 0;
        }

        public var _Str_18214(get,never):Int;
public function  get__Str_18214():Int
        {
            return (this.itemList != null) ? this.itemList.spacing : 0;
        }

        public var _Str_8780(get,never):Int;
public function  get__Str_8780():Int
        {
            return ((this.window != null) && (this.window.content != null)) ? this.window.content.width : 0;
        }

        var _Str_6223(get,never):CampaignCalendarData;
function  get__Str_6223():CampaignCalendarData
        {
            return this._controller._Str_6223;
        }
    }

