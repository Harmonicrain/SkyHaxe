package com.sulake.habbo.communication.messages.parser.preferences
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AccountPreferencesParser implements IMessageParser 
    {
        var _traxVolume:Int = 0;
        var _furniVolume:Int = 0;
        var _uiVolume:Int = 0;
        var _freeFlowChatDisabled:Bool = false;
        var _roomInvitesIgnored:Bool = false;
        var _roomCameraFollowDisabled:Bool = false;
        var _uiFlags:Int = 0;
        var _preferedChatStyle:Int = 0;
        var _chatSizePreference:Int = 0;
        var _wiredMenuButton:Bool = false;
        var _wiredInspectButton:Bool = false;
        var _playTestMode:Bool = false;
        var _wiredWhisperDisabled:Bool = false;
        var _showAllNotifications:Bool = false;
        var _wiredUiStyle:String = "";


        public var traxVolume(get,never):Int;
function  get_traxVolume():Int
        {
            return this._traxVolume;
        }

        public var furniVolume(get,never):Int;
function  get_furniVolume():Int
        {
            return this._furniVolume;
        }

        public var uiVolume(get,never):Int;
function  get_uiVolume():Int
        {
            return this._uiVolume;
        }

        public var freeFlowChatDisabled(get,never):Bool;
function  get_freeFlowChatDisabled():Bool
        {
            return this._freeFlowChatDisabled;
        }

        public var roomInvitesIgnored(get,never):Bool;
function  get_roomInvitesIgnored():Bool
        {
            return this._roomInvitesIgnored;
        }

        public var roomCameraFollowDisabled(get,never):Bool;
function  get_roomCameraFollowDisabled():Bool
        {
            return this._roomCameraFollowDisabled;
        }

        public var uiFlags(get,never):Int;
function  get_uiFlags():Int
        {
            return this._uiFlags;
        }

        public var preferedChatStyle(get,never):Int;
function  get_preferedChatStyle():Int
        {
            return this._preferedChatStyle;
        }

        public var chatSizePreference(get,never):Int;
function  get_chatSizePreference():Int
        {
            return this._chatSizePreference;
        }

        public var wiredMenuButton(get,never):Bool;
function  get_wiredMenuButton():Bool { return _wiredMenuButton; }
        public var wiredInspectButton(get,never):Bool;
function  get_wiredInspectButton():Bool { return _wiredInspectButton; }
        public var playTestMode(get,never):Bool;
function  get_playTestMode():Bool { return _playTestMode; }
        public var wiredWhisperDisabled(get,never):Bool;
function  get_wiredWhisperDisabled():Bool { return _wiredWhisperDisabled; }
        public var showAllNotifications(get,never):Bool;
function  get_showAllNotifications():Bool { return _showAllNotifications; }
        public var wiredUiStyle(get,never):String;
function  get_wiredUiStyle():String { return _wiredUiStyle; }

        public function flush():Bool
        {
            this._freeFlowChatDisabled = false;
            this._roomCameraFollowDisabled = false;
            this._uiFlags = 0;
            this._preferedChatStyle = 0;
            this._chatSizePreference = 0;
            this._wiredMenuButton = false;
            this._wiredInspectButton = false;
            this._playTestMode = false;
            this._wiredWhisperDisabled = false;
            this._showAllNotifications = false;
            this._wiredUiStyle = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._uiVolume = k.readInteger();
            this._furniVolume = k.readInteger();
            this._traxVolume = k.readInteger();
            this._freeFlowChatDisabled = k.readBoolean();
            this._roomInvitesIgnored = k.readBoolean();
            this._roomCameraFollowDisabled = k.readBoolean();
            this._uiFlags = k.readInteger();
            this._preferedChatStyle = k.readInteger();
            if (k.bytesAvailable >= 9)
            {
                this._wiredMenuButton = k.readBoolean();
                this._wiredInspectButton = k.readBoolean();
                this._playTestMode = k.readBoolean();
                k.readInteger();
                this._wiredWhisperDisabled = k.readBoolean();
                this._showAllNotifications = k.bytesAvailable > 0
                    ? k.readBoolean() : false;
                this._wiredUiStyle = k.bytesAvailable > 2 ? k.readString() : "";
            }
            this._chatSizePreference = k.bytesAvailable > 0 ? k.readInteger() : 0;
            return true;
        }

	public function new() {}
    }

