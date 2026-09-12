package com.sulake.habbo.navigator.transitional
;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.habbo.navigator.roomsettings.RoomSettingsCtrl;
    import com.sulake.habbo.navigator.inroom.RoomInfoViewCtrl;
    import com.sulake.habbo.navigator.roomsettings.RoomCreateViewCtrl;
    import com.sulake.habbo.navigator.GuestRoomPasswordInput;
    import com.sulake.habbo.navigator.GuestRoomDoorbell;
    import com.sulake.habbo.navigator.mainview.OfficialRoomEntryManager;
    import com.sulake.habbo.navigator.inroom.RoomEventViewCtrl;
    import com.sulake.habbo.navigator.inroom.RoomEventInfoCtrl;
    import com.sulake.habbo.navigator.roomsettings.RoomFilterCtrl;
    import com.sulake.habbo.navigator.roomsettings.EnforceCategoryCtrl;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.navigator.domain.NavigatorData;
    import com.sulake.habbo.navigator.mainview.ITransitionalMainViewCtrl;
    import com.sulake.habbo.navigator.domain.Tabs;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.habbo.tracking.IHabboTracking;
    import flash.events.IEventDispatcher;
    import flash.geom.Point;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.core.runtime.IID;
    import com.sulake.core.runtime.IUnknown;

     class LegacyNavigator implements IHabboTransitionalNavigator 
    {
        var _newNavigator:HabboNewNavigator;
        var _oldNavigator:HabboNavigator;
        var _fakeMainViewCtrl:FakeMainViewCtrl;
        var _roomInfoViewCtrl:RoomInfoViewCtrl;
        var _roomCreateViewCtrl:RoomCreateViewCtrl;
        var _passwordInput:GuestRoomPasswordInput;
        var _doorbell:GuestRoomDoorbell;
        var _officialRoomEntryManager:OfficialRoomEntryManager;
        var _roomEventViewCtrl:RoomEventViewCtrl;
        var _roomEventInfoCtrl:RoomEventInfoCtrl;
        var _roomFilterCtrl:RoomFilterCtrl;
        var _enforceCategoryCtrl:EnforceCategoryCtrl;

        public function new(k:HabboNewNavigator, _arg_2:HabboNavigator)
        {
            this._newNavigator = k;
            this._oldNavigator = _arg_2;
            this._fakeMainViewCtrl = new FakeMainViewCtrl(this._newNavigator, this._oldNavigator);
            this._roomInfoViewCtrl = new RoomInfoViewCtrl(this);
            this._roomCreateViewCtrl = new RoomCreateViewCtrl(this);
            this._passwordInput = new GuestRoomPasswordInput(this);
            this._doorbell = new GuestRoomDoorbell(this);
            this._officialRoomEntryManager = new OfficialRoomEntryManager(this);
            this._roomEventViewCtrl = new RoomEventViewCtrl(this);
            this._roomEventInfoCtrl = new RoomEventInfoCtrl(this);
            this._roomFilterCtrl = new RoomFilterCtrl(this);
            this._enforceCategoryCtrl = new EnforceCategoryCtrl(this);
        }

        public var _Str_22899(never,set):HabboNavigator;
public function  set__Str_22899(k:HabboNavigator):HabboNavigator        {
            return this._oldNavigator = k;
        }

        public var assets(get,never):IAssetLibrary;
public function  get_assets():IAssetLibrary
        {
            return this._oldNavigator.assets;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._newNavigator.windowManager;
        }

        public var data(get,never):NavigatorData;
public function  get_data():NavigatorData
        {
            return this._oldNavigator.data;
        }

        public var mainViewCtrl(get,never):ITransitionalMainViewCtrl;
public function  get_mainViewCtrl():ITransitionalMainViewCtrl
        {
            return this._fakeMainViewCtrl;
        }

        public var tabs(get,never):Tabs;
public function  get_tabs():Tabs
        {
            return this._oldNavigator.tabs;
        }

        public var roomInfoViewCtrl(get,never):RoomInfoViewCtrl;
public function  get_roomInfoViewCtrl():RoomInfoViewCtrl
        {
            return this._roomInfoViewCtrl;
        }

        public var roomCreateViewCtrl(get,never):RoomCreateViewCtrl;
public function  get_roomCreateViewCtrl():RoomCreateViewCtrl
        {
            return this._roomCreateViewCtrl;
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._oldNavigator.communication;
        }

        public var roomSettingsCtrl(get,never):RoomSettingsCtrl;
public function  get_roomSettingsCtrl():RoomSettingsCtrl
        {
            var k= this._oldNavigator.roomSettingsCtrl;
            k.navigator = this;
            return k;
        }

        public var sessionData(get,never):ISessionDataManager;
public function  get_sessionData():ISessionDataManager
        {
            return this._oldNavigator.sessionData;
        }

        public var passwordInput(get,never):GuestRoomPasswordInput;
public function  get_passwordInput():GuestRoomPasswordInput
        {
            return this._oldNavigator.passwordInput;
        }

        public var doorbell(get,never):GuestRoomDoorbell;
public function  get_doorbell():GuestRoomDoorbell
        {
            return this._doorbell;
        }

        public var roomEventViewCtrl(get,never):RoomEventViewCtrl;
public function  get_roomEventViewCtrl():RoomEventViewCtrl
        {
            return this._roomEventViewCtrl;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._oldNavigator.localization;
        }

        public var officialRoomEntryManager(get,never):OfficialRoomEntryManager;
public function  get_officialRoomEntryManager():OfficialRoomEntryManager
        {
            return this._oldNavigator.officialRoomEntryManager;
        }

        public var toolbar(get,never):IHabboToolbar;
public function  get_toolbar():IHabboToolbar
        {
            return this._oldNavigator.toolbar;
        }

        public var habboHelp(get,never):IHabboHelp;
public function  get_habboHelp():IHabboHelp
        {
            return this._oldNavigator.habboHelp;
        }

        public var roomEventInfoCtrl(get,never):RoomEventInfoCtrl;
public function  get_roomEventInfoCtrl():RoomEventInfoCtrl
        {
            return this._roomEventInfoCtrl;
        }

        public var roomFilterCtrl(get,never):RoomFilterCtrl;
public function  get_roomFilterCtrl():RoomFilterCtrl
        {
            return this._roomFilterCtrl;
        }

        public var roomSessionManager(get,never):IRoomSessionManager;
public function  get_roomSessionManager():IRoomSessionManager
        {
            return this._oldNavigator.roomSessionManager;
        }

        public var enforceCategoryCtrl(get,never):EnforceCategoryCtrl;
public function  get_enforceCategoryCtrl():EnforceCategoryCtrl
        {
            return this._enforceCategoryCtrl;
        }

        public function send(k:IMessageComposer, _arg_2:Bool=false)
        {
            return this._oldNavigator.send(k, _arg_2);
        }

        public function getXmlWindow(k:String, _arg_2:UInt=1):IWindow
        {
            return this._oldNavigator.getXmlWindow(k, _arg_2);
        }

        public function getText(k:String):String
        {
            return this._oldNavigator.getText(k);
        }

        public function registerParameter(k:String, _arg_2:String, _arg_3:String):String
        {
            return this._oldNavigator.registerParameter(k, _arg_2, _arg_3);
        }

        public function getButton(k:String, _arg_2:String, _arg_3:ASFunction, _arg_4:Int=0, _arg_5:Int=0, _arg_6:Int=0):IBitmapWrapperWindow
        {
            return this._oldNavigator.getButton(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        }

        public function refreshButton(k:IWindowContainer, _arg_2:String, _arg_3:Bool, _arg_4:ASFunction, _arg_5:Int, _arg_6:String=null)
        {
            return this._oldNavigator.refreshButton(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        }

        public function getButtonImage(k:String, _arg_2:String="_png"):BitmapData
        {
            return this._oldNavigator.getButtonImage(k, _arg_2);
        }

        public function openCatalogClubPage(k:String)
        {
            return this._oldNavigator.openCatalogClubPage(k);
        }

        public function openCatalogRoomAdsPage()
        {
            return this._oldNavigator.openCatalogRoomAdsPage();
        }

        public function showFavouriteRooms()
        {
            return this._newNavigator.performSearch("favorites");
        }

        public function showHistoryRooms()
        {
            return this._newNavigator.performSearch("history");
        }

        public function showFrequentRooms()
        {
            return this._newNavigator.performSearch("history_freq");
        }

        public var tracking(get,never):IHabboTracking;
public function  get_tracking():IHabboTracking
        {
            return this._oldNavigator.tracking;
        }

        public function goToMainView()
        {
            this._roomCreateViewCtrl.hide();
        }

        public function _Str_24971(k:String, _arg_2:String=null):ASAny
        {
            this._oldNavigator.enterRoomWebRequest(k, true, _arg_2);

return ASCompat.undefinedValue();         }

        public function goToRoom(k:Int, _arg_2:Bool, _arg_3:String="", _arg_4:Int=-1)
        {
            this._oldNavigator.goToRoom(k, false, _arg_3, _arg_4);
        }

        public function isPerkAllowed(k:String):Bool
        {
            return this._oldNavigator.isPerkAllowed(k);
        }

        public function trackGoogle(k:String, _arg_2:String, _arg_3:Int=-1)
        {
            return this._oldNavigator.trackGoogle(k, _arg_2, _arg_3);
        }

        public function getBoolean(k:String):Bool
        {
            return this._oldNavigator.getBoolean(k);
        }

        public function getInteger(k:String, _arg_2:Int):Int
        {
            return this._oldNavigator.getInteger(k, _arg_2);
        }

        public var events(get,never):IEventDispatcher;
public function  get_events():IEventDispatcher
        {
            return this._newNavigator.events;
        }

        public function goToHomeRoom():Bool
        {
            this._newNavigator.goToHomeRoom();
            return true;
        }

        public function performTagSearch(k:String)
        {
            return this._newNavigator.performTagSearch(k);
        }

        public function performTextSearch(k:String)
        {
            return this._newNavigator.performTextSearch(k);
        }

        public function performGuildBaseSearch()
        {
            return this._newNavigator.performSearch("groups");
        }

        public function performCompetitionRoomsSearch(k:Int, _arg_2:Int)
        {
            return this._newNavigator.performSearch("competition");
        }

        public function showOwnRooms()
        {
            return this._newNavigator.performSearch("myworld_view");
        }

        public function goToPrivateRoom(k:Int)
        {
            this._newNavigator.goToRoom(k);
        }

        public function hasRoomRightsButIsNotOwner(k:Int):Bool
        {
            return this._oldNavigator.hasRoomRightsButIsNotOwner(k);
        }

        public function removeRoomRights(k:Int)
        {
            return this._oldNavigator.removeRoomRights(k);
        }

        public function goToRoomNetwork(k:Int, _arg_2:Bool)
        {
            return this.goToRoomNetwork(k, _arg_2);
        }

        public function startRoomCreation()
        {
            return this._newNavigator.createRoom();
        }

        public function openNavigator(k:Point=null)
        {
            if (this._newNavigator.sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
            {
                this._newNavigator.open();
                return;
            }
            this._oldNavigator.openNavigator(k);
        }

        public function closeNavigator()
        {
            if (this._newNavigator.sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
            {
                this._newNavigator.close();
                return;
            }
            this._oldNavigator.closeNavigator();
        }

        public var homeRoomId(get,never):Int;
public function  get_homeRoomId():Int
        {
            return this._oldNavigator.homeRoomId;
        }

        public var enteredGuestRoomData(get,never):GuestRoomData;
public function  get_enteredGuestRoomData():GuestRoomData
        {
            return this._oldNavigator.enteredGuestRoomData;
        }

        public function showToolbarHover(k:Point)
        {
        }

        public function hideToolbarHover(k:Bool)
        {
        }

        public function toggleRoomInfoVisibility()
        {
            if (this._roomInfoViewCtrl != null)
            {
                this._roomInfoViewCtrl.toggle();
            }
        }

        public function canRateRoom():Bool
        {
            return this._oldNavigator.canRateRoom();
        }

        public function queueInterface(k:IID, _arg_2:ASFunction=null):IUnknown
        {
            return this._newNavigator.queueInterface(k, _arg_2);
        }

        public function release(k:IID):UInt
        {
            return this._newNavigator.release(k);
        }

        public function dispose()
        {
            this._roomInfoViewCtrl.dispose();
            this._roomCreateViewCtrl.dispose();
            this._passwordInput.dispose();
            this._doorbell.dispose();
            this._officialRoomEntryManager.dispose();
            this._roomEventViewCtrl.dispose();
            this._roomEventInfoCtrl.dispose();
            this._roomFilterCtrl.dispose();
            this._enforceCategoryCtrl = null;
            this._oldNavigator = null;
            this._newNavigator = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._oldNavigator == null;
        }

        public function openCatalogRoomAdsExtendPage(k:String, _arg_2:String, _arg_3:Date, _arg_4:Int)
        {
            return this._oldNavigator.openCatalogRoomAdsExtendPage(k, _arg_2, _arg_3, _arg_4);
        }

        public function getProperty(k:String, _arg_2:ASDictionary<ASAny,ASAny>=null):String
        {
            return this._oldNavigator.getProperty(k, _arg_2);
        }

        public var isDoorModeOverriddenInCurrentRoom(get,never):Bool;
public function  get_isDoorModeOverriddenInCurrentRoom():Bool
        {
            return this._oldNavigator.isDoorModeOverriddenInCurrentRoom;
        }

        public function trackNavigationDataPoint(k:String, _arg_2:String, _arg_3:String="", _arg_4:Int=0)
        {
            return this._oldNavigator.trackNavigationDataPoint(k, _arg_2, _arg_3, _arg_4);
        }

        public function _Str_12281(k:Int):Bool
        {
            return this._oldNavigator._Str_12281(k);
        }

        public function _Str_8458(k:Int):Bool
        {
            return this._oldNavigator._Str_8458(k);
        }

        public var _Str_8075(get,never):Array<ASAny>;
public function  get__Str_8075():Array<ASAny>
        {
            return this._oldNavigator.data._Str_8075;
        }

        public var _Str_26424(get,never):RoomSettingsCtrl;
public function  get__Str_26424():RoomSettingsCtrl
        {
            return this._oldNavigator.roomSettingsCtrl;
        }
    }

