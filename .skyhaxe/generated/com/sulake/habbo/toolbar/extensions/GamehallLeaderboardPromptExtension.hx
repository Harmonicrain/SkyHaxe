package com.sulake.habbo.toolbar.extensions
;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.CloseConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.RoomReadyMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.games.RequestLeaderboardMessageComposer;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.habbo.toolbar.ToolbarDisplayExtensionIds;

     class GamehallLeaderboardPromptExtension implements IDisposable
    {
        static final GAMEHALL_MODELS:ASObject = {
            "hallA": "TICTACTOE",
            "hallB": "BATTLESHIPS",
            "hallC": "CHESS",
            "hallD": "POKER"
        };

        var _toolbar:HabboToolbar;
        var _window:IWindowContainer;
        var _button:IButtonWindow;
        var _buttonLabel:ITextWindow;
        var _roomReadyEvent:IMessageEvent;
        var _closeConnectionEvent:IMessageEvent;
        var _lastRequestTime:Int = 0;
        var _currentGameType:String = "ALL";

        public function new(toolbar:HabboToolbar)
        {
            this._toolbar = toolbar;
            if (this._toolbar.connection != null)
            {
                this._roomReadyEvent = new RoomReadyMessageEvent(this.onRoomReady);
                this._closeConnectionEvent = new CloseConnectionMessageEvent(this.onCloseConnection);
                this._toolbar.connection.addMessageEvent(this._roomReadyEvent);
                this._toolbar.connection.addMessageEvent(this._closeConnectionEvent);
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._toolbar == null;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this.hide();
            if (this._toolbar.connection != null)
            {
                if (this._roomReadyEvent != null)
                {
                    this._toolbar.connection.removeMessageEvent(this._roomReadyEvent);
                    this._roomReadyEvent = null;
                }
                if (this._closeConnectionEvent != null)
                {
                    this._toolbar.connection.removeMessageEvent(this._closeConnectionEvent);
                    this._closeConnectionEvent = null;
                }
            }
            this.destroyWindow();
            this._toolbar = null;
        }

        function onRoomReady(event:IMessageEvent)
        {
            var roomReady= Std.downcast(event , RoomReadyMessageEvent);
            if (roomReady == null || roomReady.getParser() == null)
            {
                this.hide();
                return;
            }
            var parser= roomReady.getParser();
            var gameType= ASCompat.asString(ASCompat.getDynamicProperty(GAMEHALL_MODELS, parser.roomType));
            if (gameType != null)
            {
                this._currentGameType = gameType;
                this.show();
            }
            else
            {
                this._currentGameType = "ALL";
                this.hide();
            }
        }

        function onCloseConnection(event:IMessageEvent)
        {
            this.hide();
        }

        function show()
        {
            if (this._toolbar == null || this._toolbar.extensionView == null)
            {
                return;
            }
            if (this._window == null)
            {
                this.createWindow();
            }
            if (this._window == null)
            {
                return;
            }
            if (!this._toolbar.extensionView.hasExtension(ToolbarDisplayExtensionIds.GAMEHALL_LEADERBOARD_PROMPT))
            {
                this._toolbar.extensionView.attachExtension(
                    ToolbarDisplayExtensionIds.GAMEHALL_LEADERBOARD_PROMPT,
                    this._window,
                    ExtensionFixedSlotsEnum._Str_8642);
            }
        }

        function hide()
        {
            if (this._toolbar != null && this._toolbar.extensionView != null)
            {
                this._toolbar.extensionView.detachExtension(ToolbarDisplayExtensionIds.GAMEHALL_LEADERBOARD_PROMPT);
            }
        }

        function createWindow()
        {
            var asset= Std.downcast(this._toolbar.assets.getAssetByName("gamehall_leaderboard_prompt_xml") , XmlAsset);
            if (asset == null)
            {
                return;
            }
            this._window = Std.downcast(this._toolbar.windowManager.buildFromXML((asset.content : com.sulake.core.utils.xml.XML) , 1) , IWindowContainer);
            if (this._window == null)
            {
                return;
            }
            this._window.procedure = this.onWindowEvent;

            var message= Std.downcast(this._window.findChildByName("prompt_message") , ITextWindow);
            if (message != null)
            {
                message.text = this._toolbar.localization.getLocalization(
                    "gamehall.leaderboard.prompt.message",
                    "This games room has a high score leaderboard!");
            }

            this._button = Std.downcast(this._window.findChildByName("view_high_scores_button") , IButtonWindow);
            var buttonText= this._toolbar.localization.getLocalization(
                "gamehall.leaderboard.prompt.button",
                "View high scores");
            if (this._button != null)
            {
                this._button.caption = "";
                this._button.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
            this._buttonLabel = Std.downcast(this._window.findChildByName("view_high_scores_label") , ITextWindow);
            if (this._buttonLabel != null)
            {
                this._buttonLabel.text = buttonText;
                this._buttonLabel.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
        }

        function destroyWindow()
        {
            if (this._buttonLabel != null)
            {
                this._buttonLabel.removeEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                this._buttonLabel = null;
            }
            if (this._button != null)
            {
                this._button.removeEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                this._button = null;
            }
            if (this._window != null)
            {
                this._window.procedure = null;
                this._window.dispose();
                this._window = null;
            }
        }

        function onWindowEvent(event:WindowEvent, window:IWindow)
        {
            if (event.type != WindowMouseEvent.CLICK || window == null)
            {
                return;
            }
            if (window.name == "view_high_scores_button" || window.name == "view_high_scores_label")
            {
                this.sendLeaderboardRequest();
            }
        }

        function onButtonClicked(event:WindowMouseEvent)
        {
            this.sendLeaderboardRequest();
        }

        function sendLeaderboardRequest()
        {
var now = 0;            if (this._toolbar != null && this._toolbar.connection != null)
            {
now= flash.Lib.getTimer();
                if (now - this._lastRequestTime < 250)
                {
                    return;
                }
                this._lastRequestTime = now;
                this._toolbar.connection.send(new RequestLeaderboardMessageComposer());
            }
        }
    }

