package com.sulake.habbo.campaign
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.campaign.calendar.CalendarView;
    import com.sulake.habbo.communication.messages.parser.campaign.CampaignCalendarData;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.habbo.communication.messages.incoming.campaign.CampaignCalendarDataMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.campaign.CampaignCalendarDoorOpenedMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.campaign.OpenCampaignCalendarDoorAsStaffComposer;
    import com.sulake.habbo.communication.messages.outgoing.campaign.OpenCampaignCalendarDoorComposer;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.room.IGetImageListener;

     class HabboCampaigns extends Component implements ILinkEventTracker 
    {
        var _communicationManager:IHabboCommunicationManager;
        var _localizationManager:IHabboLocalizationManager;
        var _sessionDataManager:ISessionDataManager;
        var _windowManager:IHabboWindowManager;
        var _catalog:IHabboCatalog;
        var _roomEngine:IRoomEngine;
        var _calendarView:CalendarView;
        var _calendarData:CampaignCalendarData;
        var _dayAttempted:Int = -1;
        var _useFakeData:Bool = false;

        public function new(k:IContext, _arg_2:UInt, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }, true), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localizationManager = k;
            }), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine)
            {
                _roomEngine = k;
            })]));
        }

        override function initComponent()
        {
            this._communicationManager.addHabboConnectionMessageEvent(new CampaignCalendarDataMessageEvent(this._Str_25846));
            this._communicationManager.addHabboConnectionMessageEvent(new CampaignCalendarDoorOpenedMessageEvent(this._Str_24922));
            context.addLinkEventTracker(this);
        }

        function _Str_25846(k:CampaignCalendarDataMessageEvent)
        {
            var _local_2= k.getParser();
            this._calendarData = _local_2.getCampaignCalenderData();
        }

        function _Str_24922(k:CampaignCalendarDoorOpenedMessageEvent)
        {
            var _local_2= k.getParser();
            if (_local_2._Str_22341)
            {
                this._Str_16700(_local_2.productName, _local_2.customImage, _local_2._Str_8979);
            }
        }

        public function OpenCampaignCalendarDoor1(k:Int)
        {
            this._dayAttempted = k;
            this._communicationManager.connection.send(new OpenCampaignCalendarDoorAsStaffComposer(this._calendarData._Str_11123, k));
        }

        public function OpenCampaignCalendarDoor2(k:Int)
        {
            this._dayAttempted = k;
            this._communicationManager.connection.send(new OpenCampaignCalendarDoorComposer(this._calendarData._Str_11123, k));
        }

        function _Str_16700(k:String, _arg_2:String, _arg_3:String)
        {
            var _local_4= this._sessionDataManager.getProductData(k);
            if (_local_4 != null)
            {
                this._calendarData._Str_10724.push(this._dayAttempted);
                this._dayAttempted = -1;
                if ((ASCompat.stringAsBool(_arg_2) && (!(_arg_2 == ""))))
                {
                    this._calendarView._Str_22076(_local_4, (this._Str_25051() + _arg_2));
                }
                else
                {
                    if ((ASCompat.stringAsBool(_arg_3) && (!(_arg_3 == ""))))
                    {
                        this._calendarView._Str_22076(_local_4);
                        this._Str_6402(this._calendarView, _arg_3);
                    }
                }
            }
        }

        function _Str_6402(k:IGetImageListener, _arg_2:String):ImageResult
        {
            var _local_3:ImageResult = null;
            var _local_4:IFurnitureData = null;
            _local_4 = this._sessionDataManager.getFloorItemDataByName(_arg_2);
            if (_local_4 != null)
            {
                _local_3 = this._roomEngine.getFurnitureIcon(_local_4.id, k);
            }
            else
            {
                _local_4 = this._sessionDataManager.getWallItemDataByName(_arg_2);
                if (_local_4 != null)
                {
                    _local_3 = this._roomEngine.getWallItemIcon(_local_4.id, k);
                }
            }
            if (((_local_3 != null) && (_local_3.data != null)))
            {
                k.imageReady(_local_3.id, _local_3.data);
            }
            return _local_3;
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "openView/";
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            if (_local_2[1] == "calendar")
            {
                this._Str_21422();
            }
        }

        function _Str_21422()
        {
            if (((!(this._calendarView != null)) && (this._calendarData != null)))
            {
                this._calendarView = new CalendarView(this, this._windowManager);
            }
        }

        public function _Str_24884()
        {
            if (this._calendarView != null)
            {
                this._calendarView.dispose();
                this._calendarView = null;
            }
        }

        function _Str_25051():String
        {
            return getProperty("image.library.url");
        }

        public var _Str_6223(get,never):CampaignCalendarData;
public function  get__Str_6223():CampaignCalendarData
        {
            return this._calendarData;
        }

        public var isAnyRoomController(get,never):Bool;
public function  get_isAnyRoomController():Bool
        {
            return this._sessionDataManager.isAnyRoomController;
        }

        public var localizationManager(get,never):IHabboLocalizationManager;
public function  get_localizationManager():IHabboLocalizationManager
        {
            return this._localizationManager;
        }
    }

