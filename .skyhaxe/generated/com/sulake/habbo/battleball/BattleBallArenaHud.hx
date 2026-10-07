package com.sulake.habbo.battleball
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    /**
     * The arena HUD: the button strip, the clock, the score bars and the start countdown.
     *
     * Split out of BattleBallArenaWindow, which owned the frame, the HUD and the overlays at
     * once. The window still owns the frame and the panel; this draws into them.
     */
     class BattleBallArenaHud
    {
        /** Columns of kick buttons in the arena HUD, used for both the x and y grid. */
        static inline final KICK_COLUMNS= 7;
        /** The arena keeps its established projection; the television surround lives outside it. */
        static inline final ARENA_WIDTH= 760;
        /** well bottom join (4+3) -> footer rule (2) -> footer face -> bottom rule. */
        static final FOOTER_T:Int = BattleBallArenaWindow.FRAME_T + BattleBallArenaWindow.ARENA_VIEW_H + 9;
        static inline final ARENA_HEIGHT= 560;
        static final FRAME_W:Int = ARENA_WIDTH + BattleBallArenaWindow.WELL_SIDE * 2;
        static inline final HUD_H= 79;
        var _arenaHud:IWindowContainer;
        var _arenaHudActions:ASObject = {};
        var _arenaHudButtonLayer:IWindowContainer;
        var _arenaHudTime:ITextWindow;
        var _arenaRoundDurationMs:Int = 0;
        var _arenaScoreBars:Array<ASAny> = [];
        var _arenaTitle:ITextWindow;
        var _assets:BattleBallAssets;
        var _componentAssets:IAssetLibrary;
        var _chrome:BattleBallChrome;
        var _countdownDigit:Int = -1;
        var _countdownNumeral:DisplayObject;
        var _frame:IWindowContainer;
        var _activatedPowerObjectId:Int = -1;
        var _activatedPowerAt:Int = 0;
        var _arenaHudControlSignature:String = "";
        var _lastArenaState:Int = -1;
        var _panel:Sprite;
        var _services:BattleBallViewServices;
        var _surface:BattleBallWindowSurface;
        var _windowManager:IHabboWindowManager;
        var _errorLabel:TextField;

        public function new(windowManager:IHabboWindowManager, assets:BattleBallAssets,
                                   componentAssets:IAssetLibrary, chrome:BattleBallChrome,
                                   services:BattleBallViewServices)
        {
            this._windowManager = windowManager; this._assets = assets;
            this._componentAssets = componentAssets;
            this._chrome = chrome; this._services = services;
            this._surface = new BattleBallWindowSurface(windowManager, assets, this.registerArenaHudAction);
        }

        /** The window hands over the display objects it owns once they exist. */
        /** The frame's title field is created with the border, so the window hands it over after. */
        public var title(never,set):ITextWindow;
public function  set_title(value:ITextWindow):ITextWindow{ return this._arenaTitle = value; }
        /** Presentation changes are the window's call; the strip is ours. */
        public function setVisible(value:Bool) { if (this._arenaHud != null) this._arenaHud.visible = value; }

        public function attach(_frame:IWindowContainer, _panel:Sprite)
        {
            this._frame = _frame;
            this._panel = _panel;
        }
        public function syncArenaHud(model:BattleBallModel)
        {
var team = 0, scoreBar:IBitmapWrapperWindow  = null, old:IWindow  = null, kickIndex = 0, candidate:ASObject  = null, shortName:String  = null, kickX = 0, kickY = 0;            this.ensureArenaHud();
            if (this._arenaTitle != null && model != null) this._arenaTitle.caption = this._services.arenaName(model.mapId);
            if (this._arenaHud == null) return;
            this._arenaHud.visible = true;

            if (this._arenaHudTime != null)
                this._arenaHudTime.caption = (this._services.text("bb_hud_remaining_time") : ASAny)
                    .replace("%time%", this.formatTime(model.displayedTimeRemainingMs));
            if (model.state != this._lastArenaState)
            {
                this._arenaRoundDurationMs = Std.int(model.state == 2 ? Std.int(Math.max(1, model.displayedTimeRemainingMs) ): 0);
                this._lastArenaState = model.state;
            }
            if (model.state == 2 && model.displayedTimeRemainingMs > this._arenaRoundDurationMs)
                this._arenaRoundDurationMs = model.displayedTimeRemainingMs;
            var elapsed= model.state == 2 && this._arenaRoundDurationMs > 0
                ? Math.max(0, Math.min(1, 1 - model.displayedTimeRemainingMs / this._arenaRoundDurationMs)) : 0;
            var highestScore= 1;
            var team = 0;
            for (_tmp_ in 0...4)
{team= _tmp_;
                if (ASCompat.hasOwnProperty(model.scores, team)) highestScore = Std.int(Math.max(highestScore, ASCompat.toInt(model.scores[Std.string(team)])));
};
            for (_tmp_ in 0...4)
            {
team= _tmp_;
scoreBar= ASCompat.dynamicAs(this._arenaScoreBars[team] , IBitmapWrapperWindow);
                if (scoreBar == null) continue;
                scoreBar.visible = ASCompat.hasOwnProperty(model.scores, team);
                scoreBar.width = Std.int(scoreBar.visible
                    ? Std.int(Math.max(5, Math.fround(159 * elapsed * ASCompat.toInt(model.scores[Std.string(team)]) / highestScore)) ): 5);
            }

            var local:ASObject = model.localPlayer(ASCompat.toInt(this._services.localUserId()));
            var held:ASObject = local == null ? null : this.findHeldPower(model, ASCompat.toInt(local.objectId));
            if (held == null || ASCompat.toInt(held.objectId) != this._activatedPowerObjectId)
            {
                this._activatedPowerObjectId = -1;
                this._activatedPowerAt = 0;
            }
            else if (flash.Lib.getTimer() - this._activatedPowerAt >= 1000)
            {
                // No authoritative removal arrived: the request was rejected or lost, so restore it.
                this._activatedPowerObjectId = -1;
                this._activatedPowerAt = 0;
            }
            var controlSignature= this.arenaHudControlSignature(model, local, held);
            if (controlSignature == this._arenaHudControlSignature) return;
            this._arenaHudControlSignature = controlSignature;

            // Rebuild the controls only when their actual contents change. Recreating them on every
            // 250 ms arena tick could dispose the window between mouse-down and mouse-up, swallowing
            // an otherwise valid click and making every HUD action intermittently unresponsive.
            if (this._arenaHudButtonLayer != null)
            {
                while (this._arenaHudButtonLayer.numChildren > 0)
                {
old= this._arenaHudButtonLayer.removeChildAt(0);
                    if (old != null) old.dispose();
                }
                this._arenaHudActions = {};
                this._surface.bind(this._arenaHudButtonLayer);
            }
            // Laid out from the right so optional owner/power actions cannot disturb the time and score
            // positions on the left.
            var right= this._arenaHud.width;
            right -= 70;
            this.positionArenaHudButton("battleball_hud_leave", this._services.text("bb_hud_leave"),
                right, 0, 70, 25, this.leaveGame);

            right -= 80;
            if (held != null && ASCompat.toInt(held.objectId) != this._activatedPowerObjectId)
            {
                this.drawHeldPower(held, ASCompat.toInt(local.teamId), right);
            }
            else
            {
                // The original bottom bar keeps the power slot visible even while empty. State zero is
                // the barred-circle member and has no action until a collected power replaces it.
                this.arenaBitmap("hh_game_bb_room_bb2_button_pwrup_0", right, 0, 47, 44);
            }
            if (model.ownerUserId == this._services.localUserId() && model.state == 0)
            {
                right -= 76;
                this.positionArenaHudButton("battleball_hud_delete", this._services.text("bb_hud_delete"),
                    right, 0, 70, 25, this.deleteGame);
            }
            // ownerUserId is briefly 0 before the lobby summary arrives. Preserve the old fallback so
            // the owner can still start; the server remains authoritative about permission.
            if (model.state == 0 && (model.ownerUserId <= 0 || model.ownerUserId == this._services.localUserId()))
            {
                right -= 76;
                this.positionArenaHudButton("battleball_hud_start", this._services.text("bb_hud_start"),
                    right, 0, 70, 25, this.startGame);
            }
            // Owner kick controls keep their complete functionality in two compact rows. A game can
            // contain at most nineteen other players, which fits here without covering the arena art.
            if (model.ownerUserId == this._services.localUserId() && model.state == 0)
            {
kickIndex= 0;
                final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
candidate = _tmp_;
                    if (candidate.type != 0 || candidate.userId == this._services.localUserId()) continue;
shortName= this._services.playerDisplayName(candidate);
                    if (shortName == "") shortName = this._services.text("bb_hud_player");
                    if (shortName.length > 6) shortName = shortName.substr(0, 5) + ".";
kickX= 194 + (kickIndex % KICK_COLUMNS) * 73;
kickY= 28 + Std.int(kickIndex / KICK_COLUMNS) * 21;
                    this.positionArenaHudButton("battleball_hud_kick_" + candidate.userId,
                        (this._services.text("bb_hud_kick") : ASAny).replace("%player%", shortName),
                        kickX, kickY, 70, 19, this._services.kickPlayer, candidate.userId);
                    kickIndex++;
                }
            }
        }
        /**
         * The arena redraws on every state update, but its controls should behave like normal Habbo UI.
         * Keep them in a native window layer over the unused black part of the television screen instead
         * of recreating Flash text and shapes over the room artwork several times per second.
         */
        public function ensureArenaHud()
        {
            if (this._arenaHud != null || this._frame == null) return;
            this._arenaHud = Std.downcast(this._windowManager.createWindow("battleball_arena_hud", "",
                WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.NULL, WindowParam.WINDOW_PARAM_NULL,
                new Rectangle(14, FOOTER_T, FRAME_W - 28, HUD_H)) , IWindowContainer);
            if (this._arenaHud == null) return;
            this._frame.addChild(this._arenaHud);
            this.buildOriginalScorePanel();
            this._arenaHudButtonLayer = Std.downcast(this._windowManager.createWindow("battleball_hud_buttons", "",
                WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT,
                WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT,
                new Rectangle(0, 0, this._arenaHud.width, this._arenaHud.height)) , IWindowContainer);
            if (this._arenaHudButtonLayer != null) this._arenaHud.addChild(this._arenaHudButtonLayer);
        }
        /**
         * Arena buttons drawn from the cast's own three-slice b10_button, so the HUD matches the rest of
         * the BattleBall UI rather than wearing the default Habbo button skin.
         */
        function positionArenaHudButton(id:String, caption:String, x:Int, y:Int, width:Int, height:Int,
                                                action:ASFunction, data:ASObject=null)
        {
            if (this._arenaHudButtonLayer == null) return;
            var top= y + Std.int((height - 19) / 2);
            this._surface.button(id, caption, x, top, width, 19, action, data);
        }

        /**
         * Recreates BB Bottombar Class's held-power control: the original 47x44 power artwork is the
         * button, and the original cast clock beside it marks the server's 15-second hold.
         * Harlequin is the only member with team-specific frames, named 6_1 through 6_4.
         */
        function drawHeldPower(held:ASObject, teamId:Int, x:Int)
        {
            if (this._arenaHudButtonLayer == null || held == null) return;
            var objectId= ASCompat.toInt(held.objectId);
            var powerType= Std.int(Math.max(1, Math.min(8, ASCompat.toInt(held.powerType))));
            var member= "hh_game_bb_room_bb2_button_pwrup_" + Std.string(powerType);
            if (powerType == 6) member += "_" + Std.string(Math.max(1, Math.min(4, teamId + 1)));
            var icon= this.arenaBitmap(member, x, 0, 47, 44);

            var powerKey= "bb_powerup_" + Std.string(ASCompat.toInt(held.powerType));
            var powerName:String = this._services.text(powerKey);
            if (powerName == powerKey) powerName = ASCompat.toString(held.powerType);
            var tooltip:String = (this._services.text("bb_hud_use_power") : ASAny).replace("%power%", powerName);

            // A missing converted member should never make activation impossible: leave a compact
            // native button in its place while keeping the same action and localised power name.
            if (icon == null)
            {
                this.positionArenaHudButton("battleball_hud_activate_fallback", tooltip,
                    x, 0, 74, 25, this.activatePower, objectId);
                return;
            }

            var timerData= this._assets.bitmapData(
                "hh_game_bb_room_bb2_timer_pwrup_11");
            if (timerData != null)
                this.arenaBitmap("hh_game_bb_room_bb2_timer_pwrup_11",
                    x + 51, Std.int((44 - timerData.height) / 2), timerData.width, timerData.height);

            // Register this last so it sits above both bitmaps. The entire reserved control—including
            // the gap and clock—is one activation target, not only the opaque pixels of the icon.
            var hotspot= this._surface.hotspot("battleball_hud_activate", x, 0, 80, 44,
                this.activatePower, objectId);
            if (Std.is(hotspot , IInteractiveWindow)) cast(hotspot, IInteractiveWindow).toolTipCaption = tooltip;
        }

        /** Adds an exact-size bitmap from the arena cast to the native HUD window tree. */
        function arenaBitmap(member:String, x:Int, y:Int, width:Int, height:Int):IBitmapWrapperWindow
        {
            if (this._arenaHudButtonLayer == null || this._windowManager == null || this._assets == null)
                return null;
            var data= this._assets.bitmapData(member);
            if (data == null) return null;
            var bitmap= Std.downcast(this._windowManager.createWindow(
                "battleball_arena_bitmap_" + Std.string(this._arenaHudButtonLayer.numChildren), "",
                WindowType.WINDOW_TYPE_BITMAP_WRAPPER, HabboWindowStyle.NULL,
                WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT,
                new Rectangle(x, y, width, height)) , IBitmapWrapperWindow);
            if (bitmap == null) return null;
            bitmap.background = false;
            bitmap.color = 0xFFFFFF;
            bitmap.disposesBitmap = false;
            bitmap.bitmap = data;
            bitmap.width = width;
            bitmap.height = height;
            this._arenaHudButtonLayer.addChild(bitmap);
            return bitmap;
        }
        function registerArenaHudAction(window:IWindow, action:ASFunction, data:ASObject=null)
        {
            if (window == null || action == null) return;
ASCompat.setDynamicProperty(            this._arenaHudActions, window.name, {action:action, data:data});
            window.addEventListener(WindowMouseEvent.CLICK, this.onArenaHudWindowButton);
        }
        function onArenaHudWindowButton(event:WindowEvent)
        {
            var entry:ASObject = event == null || event.window == null
                ? null : ASCompat.getDynamicProperty(this._arenaHudActions, event.window.name);
            if (entry != null) entry.action(entry.data);
        }
        /** Rebuilds the 186x82 bb_scores.window composition from its generated XML and draw plan. */
        /**
         * The in-game score panel, rendered from the cast's own bb_scores window (186x82) instead of the
         * hand-drawn skin that stood in for it. That skin existed because the converter was flattening
         * the chrome; now that it decodes correctly the real frame, drop shadow, tab, score well, four
         * tracks and their end caps all come straight from the layout.
         */
        function buildOriginalScorePanel()
        {
var node:com.sulake.core.utils.xml.XML  = null, id:String  = null, member:String  = null, bitmap:IBitmapWrapperWindow  = null, team = 0;            if (this._componentAssets == null) return;
            var asset= this._componentAssets.getAssetByName("bb_scores_xml");
            if (asset == null || !ASCompat.isXML(asset.content )) return;
            var source= new com.sulake.core.utils.xml.XML(asset.content).copy();
            var scoreWindow= Std.downcast(this._windowManager.buildFromXML(source) , IWindowContainer);
            if (scoreWindow == null) return;
            scoreWindow.x = 0; scoreWindow.y = 0;
            scoreWindow.setParamFlag(WindowParam.WINDOW_PARAM_MOUSE_DRAGGING_TARGET, false);
            this._arenaHud.addChild(scoreWindow);
            var drag= scoreWindow.findChildByName("bb_drag_handle");
            if (drag != null) drag.visible = false;
            var nodes= new com.sulake.core.utils.xml.XML(new com.sulake.core.utils.xml.XML(source.child("window").children().at(0)).child("children").at(0)).children();
            if (checkNullIteratee(nodes)) for (_tmp_ in nodes)
            {
node = _tmp_;
                if (this.xmlVariable(node, "bb_kind") != "p") continue;
id= this.xmlVariable(node, "bb_id");
member= this.xmlVariable(node, "bb_member");
bitmap= Std.downcast(scoreWindow.findChildByName(node.attribute("name").toString()) , IBitmapWrapperWindow);
                if (bitmap == null) continue;
                // The four team bars are the live score indicators, drawn after the chrome so they can
                // be resized; everything else is static window art.
                // bb_scores is authored as a free-standing window. Here it is inset into the arena's own
                // metal footer, so its frame, drop shadow and title tab would be a second border drawn on
                // top of one that is already there. Keep only the score well and its contents.
                if (member.indexOf("bb_mtl_") == 0 || member == "bb_ui_sd" || member == "shadow_pixel"
                    || member == "bb_fl" || member == "bb_fc")
                {
                    bitmap.visible = false;
                    continue;
                }
                this._surface.assignBitmap(bitmap, member, this.xmlVariable(node, "bb_flip") == "1");
                if (id.indexOf("bb_bar_scores") == 0)
                {
team= ASCompat.toInt(id.substr("bb_bar_scores".length)) - 1;
                    if (team >= 0 && team < 4) this._arenaScoreBars[team] = bitmap;
                }
            }
            this._arenaHudTime = Std.downcast(this.windowBySemanticId(scoreWindow, source, "bb_info_remTime") , ITextWindow);
            if (this._arenaHudTime != null)
                this._surface.formatText(this._arenaHudTime, "", 0x000000, false, "center");
        }

        function windowBySemanticId(root:IWindowContainer, source:com.sulake.core.utils.xml.XML, id:String):IWindow
        {
            var node= this.findDescendantBySemanticId(source, id);
            return node == null ? null : root.findChildByName(node.attribute("name").toString());
        }

        function findDescendantBySemanticId(source:com.sulake.core.utils.xml.XML, id:String):com.sulake.core.utils.xml.XML
        {
            var child:com.sulake.core.utils.xml.XML = null;
            var match:com.sulake.core.utils.xml.XML = null;
            final _iter_ = source.children(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
child  = _tmp_;
                if (this.xmlVariable(child, "bb_id") == id) return child;
                match = this.findDescendantBySemanticId(child, id);
                if (match != null) return match;
            }
            return null;
        }

        function xmlVariable(node:com.sulake.core.utils.xml.XML, key:String):String
        {
var variable:com.sulake.core.utils.xml.XML  = null;            final _iter_ = node.child("variables").child("var"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{variable = _tmp_;
                if (variable.attribute("key").toString() == key) return variable.attribute("value").toString();
};
            return "";
        }
        /**
         * The 3/2/1 shown over the board while the round starts.
         *
         * Driven from the arena tick, not from showArena: the server sends no delta while the state
         * stays COUNTDOWN, so a numeral drawn once at open never changed and sat on 3 for the whole
         * three seconds. The numeral is retained and swapped only when the digit actually changes,
         * because adding a fresh one each tick would stack them on the panel.
         *
         * Note bb2_timer_pwrup_* is the cast's powerup timer. Shockwave announced the start with its
         * own bb_cdown.window -- a titled window with a draining bar and an exit button -- which this
         * does not reproduce.
         */
        public function drawStartCountdown(model:BattleBallModel)
        {
            if (model == null || this._panel == null) return;
            if (model.state != 1)
            {
                this.clearStartCountdown();
                return;
            }
            var digit= Std.int(Math.max(1, Math.min(3, Math.fceil(model.displayedTimeRemainingMs / 1000))));
            if (digit == this._countdownDigit && this._countdownNumeral != null
                && (this._countdownNumeral.parent : ASAny) == (this._panel : ASAny)) return;
            this.clearStartCountdown();
            var numeral= this._assets.display("hh_game_bb_room_bb2_timer_pwrup_" + Std.string(digit));
            if (numeral == null) return;
            numeral.scaleX = 2;
            numeral.scaleY = 2;
            numeral.x = Math.fround((ARENA_WIDTH - numeral.width) / 2);
            numeral.y = Math.fround((ARENA_HEIGHT - numeral.height) / 2) - 20;
            this._panel.addChild(numeral);
            this._countdownNumeral = numeral;
            this._countdownDigit = digit;
        }
        public function clearStartCountdown()
        {
            if (this._countdownNumeral != null && this._countdownNumeral.parent != null)
                this._countdownNumeral.parent.removeChild(this._countdownNumeral);
            this._countdownNumeral = null;
            this._countdownDigit = -1;
        }
        function formatTime(value:Int):String { var seconds=Std.int(Math.max(0,Std.int(value/1000))); var minutes=Std.int(seconds/60); seconds%=60; return Std.string(minutes)+":"+(seconds<10?"0":"")+Std.string(seconds); }
        function findHeldPower(model:BattleBallModel, playerObjectId:Int):ASObject { var object:ASObject  = null;final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {object = _tmp_;
if(object.type==1&&object.holderObjectId==playerObjectId)return object;
}; return null; }
        function arenaHudControlSignature(model:BattleBallModel, local:ASObject, held:ASObject):String
        {
var candidate:ASObject  = null;            var parts:Array<ASAny> = [model.state, model.ownerUserId, this._services.localUserId(),
                local == null ? -1 : ASCompat.toInt(local.objectId), local == null ? -1 : ASCompat.toInt(local.teamId),
                held == null ? -1 : ASCompat.toInt(held.objectId), held == null ? -1 : ASCompat.toInt(held.powerType),
                this._activatedPowerObjectId];
            if (model.ownerUserId == this._services.localUserId() && model.state == 0)
            {
                final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
candidate = _tmp_;
                    if (candidate.type == 0 && candidate.userId != this._services.localUserId())
                        ASCompat.ASArray.pushMultiple(parts, candidate.userId, this._services.playerDisplayName(candidate));
                }
            }
            return parts.join("|");
        }
        /** HUD actions. One-line signals, owned here so the arena never calls into the facade. */
        function startGame(data:ASObject=null) { this._services.emit(BattleBallViewEvent.START); }
        function leaveGame(data:ASObject=null) { this._services.emit(BattleBallViewEvent.LEAVE); }
        function activatePower(id:ASObject)
        {
            // Havana removes the stored power as soon as it is used. Suppress the stale held object
            // during the request round trip so the visible control immediately returns to state zero.
            var objectId= ASCompat.toInt(id);
            if (objectId <= 0 || objectId == this._activatedPowerObjectId) return;
            this._activatedPowerObjectId = objectId;
            this._activatedPowerAt = flash.Lib.getTimer();
            this._services.emit(BattleBallViewEvent.ACTIVATE,{powerObjectId:objectId});
        }
        function deleteGame(data:ASObject=null) { this._services.emit(BattleBallViewEvent.DELETE_GAME); }
        function label(value:String, x:Int, y:Int, width:Int, height:Int, size:Int, colour:UInt, bold:Bool=false, background:UInt=0)
        {
            var text= this._chrome.textField(value,x,y,width,height,size,colour,bold);
            if (background != 0) { text.background = true; text.backgroundColor = ASCompat.toInt(background )& 0xFFFFFF; }
            this._panel.addChild(text);
        }
        public function showError(message:String)
        {
            if (this._panel == null) return;
            if (this._errorLabel != null && (this._errorLabel.parent : ASAny) == (this._panel : ASAny))
                this._panel.removeChild(this._errorLabel);
            this._errorLabel = this._chrome.textField(message, 18, 520, 700, 22, 12, 0xFF9C9C, true);
            this._errorLabel.background = true;
            this._errorLabel.backgroundColor = 0x000000;
            this._panel.addChild(this._errorLabel);
        }
    }

