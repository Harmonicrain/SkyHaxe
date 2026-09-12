package com.sulake.habbo.roomevents
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredClickSettingsEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredClickUserResponseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredEnvironmentEvent;
    import com.sulake.habbo.room.IRoomEngineServices;
    import com.sulake.habbo.roomevents.events.WiredAchievementsUpdatedEvent;
    import com.sulake.habbo.roomevents.events.WiredUserClickHandledEvent;

    /**
     * Owns July's room-scoped Wired environment state. Achievement identifiers
     * remain protocol data without exposing Creator Tools authoring.
     */
     class WiredEnvironment implements IDisposable
    {
        public static inline final CLICK_USER_DEFAULT= 0;
        public static inline final CLICK_USER_WALK_BEHIND= 1;
        public static inline final CLICK_USER_PASS_THROUGH= 2;
        public static inline final CLICK_FURNI_DEFAULT= 0;
        public static inline final CLICK_FURNI_PASS_THROUGH= 1;

        static inline final CLICK_SETTINGS_OWNER= "wired_env";
        static inline final CLICK_SETTINGS_NOTIFICATION_ID= "wired_click_settings_toggle";

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _messageEvents:Array<ASAny> = [];
        var _hasClickUserWired:Bool = false;
        var _achievements:Vector<String> = new Vector();
        var _clickUserOption:Int = 0;
        var _clickFurniOption:Int = 0;
        var _ignored:Bool = false;
        var _hideTimeout:UInt = ASCompat.MAX_UINT;
        var _disposed:Bool = false;

        public function new(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this.addMessageEvent(new WiredEnvironmentEvent(this.onEnvironment));
            this.addMessageEvent(new WiredClickUserResponseEvent(this.onClickUserResponse));
            this.addMessageEvent(new WiredClickSettingsEvent(this.onClickSettings));
        }

        function addMessageEvent(event:IMessageEvent)
        {
            this._messageEvents.push(
                this._roomEvents.communication.addHabboConnectionMessageEvent(event));
        }

        function onEnvironment(event:IMessageEvent)
        {
            var parser=
                Std.downcast(event , WiredEnvironmentEvent).getParser();
            this._hasClickUserWired = parser.hasClickUserWired;
            this._achievements = parser.enabledAchievements != null
                ? parser.enabledAchievements.concat()
                : new Vector<String>();
            this._roomEvents.events.dispatchEvent(new WiredAchievementsUpdatedEvent(
                WiredAchievementsUpdatedEvent.WIRED_ACHIEVEMENTS_UPDATED,
                this._achievements));
        }

        function onClickUserResponse(event:IMessageEvent)
        {
            var parser=
                Std.downcast(event , WiredClickUserResponseEvent).getParser();
            this._roomEvents.events.dispatchEvent(new WiredUserClickHandledEvent(
                WiredUserClickHandledEvent.WIRED_USER_CLICK_HANDLED,
                parser.index, parser.openMenu));
        }

        function onClickSettings(event:IMessageEvent)
        {
var ignoredMessage:String  = null, extraData:ASObject  = null;            var parser=
                Std.downcast(event , WiredClickSettingsEvent).getParser();
            var userOption= this.normalizeUserOption(parser.userOption);
            var furniOption= this.normalizeFurniOption(parser.furniOption);
            var changed= userOption != this._clickUserOption
                || furniOption != this._clickFurniOption;

            if (this._ignored && !this._roomEvents.hasWiredMenuWritePermission)
            {
                this._ignored = false;
                changed = true;
                this.removeClickSettingsNotification();
            }
            if (!changed)
            {
                return;
            }

            this._clickUserOption = userOption;
            this._clickFurniOption = furniOption;
            if (!this.hasActiveClickSettings())
            {
                ASCompat.clearTimeout(this._hideTimeout);
                this._hideTimeout = ASCompat.setTimeout(this.hideNotificationIfInactive, 3000);
            }

            if (this._ignored)
            {
ignoredMessage= this._roomEvents.localization.getLocalization(
                    "notification.click_settings_ignored", "Wired click settings are ignored");
                if (this.hasActiveClickSettings())
                {
                    ignoredMessage += " " + this._roomEvents.localization.getLocalization(
                        "notification.click_settings", "Wired click settings changed");
                }
                this._roomEvents.notifications.addItem(ignoredMessage, "wired");
                return;
            }

            this.applyClickSettings(this._clickUserOption, this._clickFurniOption);
            var message= this._roomEvents.localization.getLocalization(
                "notification.click_settings", "Wired click settings changed");
            if (this._roomEvents.hasWiredMenuWritePermission && this.hasActiveClickSettings())
            {
extraData= {};
ASCompat.setDynamicProperty(                extraData, "id", CLICK_SETTINGS_NOTIFICATION_ID);
ASCompat.setDynamicProperty(                extraData, "stay", true);
ASCompat.setDynamicProperty(                extraData, "toggle_callback", this.onToggleClickSettings);
                this._roomEvents.notifications.addItem(message, "wired", null, null, extraData);
            }
            else
            {
                this._roomEvents.notifications.addItem(message, "wired");
            }
        }

        function onToggleClickSettings(ignored:Bool)
        {
            this._ignored = ignored;
            if (ignored)
            {
                this.applyClickSettings(CLICK_USER_DEFAULT, CLICK_FURNI_DEFAULT);
            }
            else
            {
                this.applyClickSettings(this._clickUserOption, this._clickFurniOption);
            }
        }

        function hideNotificationIfInactive()
        {
            if (!this.hasActiveClickSettings())
            {
                this._ignored = false;
                this.removeClickSettingsNotification();
            }
        }

        function removeClickSettingsNotification()
        {
            if (this._roomEvents != null && this._roomEvents.notifications != null)
            {
                this._roomEvents.notifications.removeNotificationById(
                    CLICK_SETTINGS_NOTIFICATION_ID);
            }
        }

        function applyClickSettings(userOption:Int, furniOption:Int)
        {
            if (this._roomEvents.roomEngine != null)
            {
                ASCompat.reinterpretAs(this._roomEvents.roomEngine , IRoomEngineServices).setClickSettings(
                    CLICK_SETTINGS_OWNER,
                    userOption == CLICK_USER_PASS_THROUGH,
                    furniOption == CLICK_FURNI_PASS_THROUGH);
            }
        }

        function normalizeUserOption(value:Int):Int
        {
            return value >= CLICK_USER_DEFAULT && value <= CLICK_USER_PASS_THROUGH
                ? value : CLICK_USER_DEFAULT;
        }

        function normalizeFurniOption(value:Int):Int
        {
            return value >= CLICK_FURNI_DEFAULT && value <= CLICK_FURNI_PASS_THROUGH
                ? value : CLICK_FURNI_DEFAULT;
        }

        function hasActiveClickSettings():Bool
        {
            return this._clickUserOption != CLICK_USER_DEFAULT
                || this._clickFurniOption != CLICK_FURNI_DEFAULT;
        }

        public function leaveRoom()
        {
            this.removeClickSettingsNotification();
            ASCompat.clearTimeout(this._hideTimeout);
            this._hideTimeout = ASCompat.MAX_UINT;
            this._hasClickUserWired = false;
            this._achievements = new Vector<String>();
            this._ignored = false;
            this._clickUserOption = CLICK_USER_DEFAULT;
            this._clickFurniOption = CLICK_FURNI_DEFAULT;
            this.applyClickSettings(CLICK_USER_DEFAULT, CLICK_FURNI_DEFAULT);
            if (this._roomEvents != null)
            {
                this._roomEvents.events.dispatchEvent(new WiredAchievementsUpdatedEvent(
                    WiredAchievementsUpdatedEvent.WIRED_ACHIEVEMENTS_UPDATED,
                    this._achievements));
            }
        }

        public var hasClickUserWired(get,never):Bool;
public function  get_hasClickUserWired():Bool
        {
            return this._hasClickUserWired;
        }

        public var achievements(get,never):Vector<String>;
public function  get_achievements():Vector<String>
        {
            return this._achievements.concat();
        }

        public var clickUserOption(get,never):Int;
public function  get_clickUserOption():Int
        {
            return this._ignored ? CLICK_USER_DEFAULT : this._clickUserOption;
        }

        public var clickFurniOption(get,never):Int;
public function  get_clickFurniOption():Int
        {
            return this._ignored ? CLICK_FURNI_DEFAULT : this._clickFurniOption;
        }

        public function dispose()
        {
var event:IMessageEvent  = null;            if (this._disposed)
            {
                return;
            }
            this.leaveRoom();
            if (this._roomEvents != null && this._roomEvents.communication != null)
            {
                final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
event = _tmp_;
                    this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
                }
            }
            this._messageEvents = null;
            this._roomEvents = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

