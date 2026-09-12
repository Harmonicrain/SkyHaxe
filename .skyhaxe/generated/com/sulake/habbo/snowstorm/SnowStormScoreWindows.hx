package com.sulake.habbo.snowstorm
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window._enum.PivotPoint;
    import com.sulake.core.window.utils.IBitmapDataContainer;
    import com.sulake.habbo.window.IHabboWindowManager;

    /** Runtime values for the converted r26 sw_timeleft, personal_stats and team_stats windows. */
     final class SnowStormScoreWindows
    {
        static inline final ROOM_ASSET_PREFIX= "hh_game_snowwar_room_";

        var _windowManager:IHabboWindowManager;
        var _componentAssets:IAssetLibrary;
        var _assets:SnowStormAssets;
        var _surface:SnowStormWindowSurface;
        var _text:ASFunction;
        var _parent:IWindowContainer;
        var _time:IWindowContainer;
        var _personal:IWindowContainer;
        var _teams:IWindowContainer;
        var _timeFront:ITextWindow;
        var _timeShadow:ITextWindow;
        var _personalFront:ITextWindow;
        var _personalShadow:ITextWindow;
        var _teamFront:Array<ASAny> = [];
        var _teamShadow:Array<ASAny> = [];
        var _teamBackground:Array<ASAny> = [];
        var _canvasX:Int = 0;
        var _canvasY:Int = 0;
        var _canvasWidth:Int = 0;
        var _lastPlaying:Bool = false;
        var _lastSpectator:Bool = false;
        var _lastTeamCount:Int = -1;
        var _lastTime:String = "";
        var _lastPersonal:String = "";
        var _lastTeamScores:Array<ASAny> = [ASCompat.MIN_INT, ASCompat.MIN_INT,
            ASCompat.MIN_INT, ASCompat.MIN_INT];
        var _disposed:Bool = false;

        public function new(windowManager:IHabboWindowManager,
                                               componentAssets:IAssetLibrary,
                                               assets:SnowStormAssets,
                                               text:ASFunction)
        {
            this._windowManager = windowManager;
            this._componentAssets = componentAssets;
            this._assets = assets;
            this._surface = new SnowStormWindowSurface(windowManager, assets);
            this._text = text;
        }

        public function attach(parent:IWindowContainer, canvasX:Int, canvasY:Int,
                               canvasWidth:Int):Bool
        {
            if (this._disposed || this._time != null || parent == null) return false;
            this._parent = parent;
            this._canvasX = canvasX;
            this._canvasY = canvasY;
            this._canvasWidth = canvasWidth;
            this._time = this.build("ss_timeleft_xml");
            this._personal = this.build("ss_personal_stats_xml");
            this._teams = this.build("ss_team_stats_xml");
            if (this._time == null || this._personal == null || this._teams == null) return false;
            this.bindTime();
            this.bindPersonal();
            this.bindTeams();
            this.hide();
            return this._timeFront != null && this._personalFront != null &&
                this._teamFront.length == 4;
        }

        public function update(model:SnowStormModel, expanded:Bool=true)
        {
var index = 0, visible = false, score = 0;            if (this._disposed || model == null || this._time == null) return;
            var playing= expanded && model.state == SnowStormProtocol.STATE_RUNNING;
            var visibilityChanged= playing != this._lastPlaying;
            var layoutChanged= visibilityChanged || model.spectator != this._lastSpectator;
            var teamsChanged= visibilityChanged || model.teamCount != this._lastTeamCount;
            if (visibilityChanged) this._time.visible = playing;
            // The green r26 self-score badge is useful in free-for-all only. In team games the
            // colour stack must contain exactly the configured teams (red/blue[/yellow/purple]).
            if (visibilityChanged || teamsChanged || model.spectator != this._lastSpectator)
            {
                this._personal.visible = playing && !model.spectator && model.teamCount == 1;
                this._teams.visible = playing && model.teamCount > 1;
            }
            this._lastPlaying = playing;
            if (!playing)
            {
                this._lastSpectator = model.spectator;
                this._lastTeamCount = model.teamCount;
                return;
            }

            if (layoutChanged)
            {
                if (model.spectator)
                {
                    this._time.x = this._canvasX + 26;
                    this._time.y = this._canvasY + 36;
                    this._teams.x = this._canvasX + this._canvasWidth - 84;
                    this._teams.y = this._canvasY + 40;
                }
                else
                {
                    this._time.x = this._canvasX + 10;
                    this._time.y = this._canvasY + 15;
                    this._personal.x = this._canvasX + this._canvasWidth - 54;
                    this._personal.y = this._canvasY + 10;
                    this._teams.x = this._canvasX + this._canvasWidth - 54;
                    this._teams.y = this._canvasY + 70;
                }
            }

            var time= this.formatTime(model.displayedTimeRemainingMs);
            if (time != this._lastTime)
            {
                this.setPair(this._timeFront, this._timeShadow, time);
                this._lastTime = time;
            }
            var local:ASObject = model.localPlayer();
            var personal= local == null ? "0" : Std.string(ASCompat.toInt(local.score));
            if (personal != this._lastPersonal)
            {
                this.setPair(this._personalFront, this._personalShadow, personal);
                this._lastPersonal = personal;
            }
            for (_tmp_ in 0...4)
            {
index= _tmp_;
visible= index < model.teamCount && model.teamCount > 1;
                if (teamsChanged)
                {
                    cast(this._teamBackground[index], IWindow).visible = visible;
                    cast(this._teamFront[index], IWindow).visible = visible;
                    cast(this._teamShadow[index], IWindow).visible = visible;
                }
score= model.teamScores != null &&
                    ASCompat.hasOwnProperty(model.teamScores, Std.string(index))                    ? ASCompat.toInt(ASCompat.getDynamicProperty(model.teamScores, Std.string(index))) : 0;
                if (score != ASCompat.toInt(this._lastTeamScores[index]))
                {
                    this.setPair(ASCompat.dynamicAs(this._teamFront[index] , ITextWindow),
                        ASCompat.dynamicAs(this._teamShadow[index] , ITextWindow), Std.string(score));
                    this._lastTeamScores[index] = score;
                }
            }
            if (visibilityChanged || layoutChanged || teamsChanged)
            {
                this.raise(this._time);
                this.raise(this._personal);
                this.raise(this._teams);
            }
            this._lastSpectator = model.spectator;
            this._lastTeamCount = model.teamCount;
        }

        public function hide()
        {
            if (this._time != null && this._time.visible) this._time.visible = false;
            if (this._personal != null && this._personal.visible) this._personal.visible = false;
            if (this._teams != null && this._teams.visible) this._teams.visible = false;
            this._lastPlaying = false;
        }

        function build(assetName:String):IWindowContainer
        {
            if (this._windowManager == null || this._componentAssets == null || this._parent == null)
                return null;
            var asset= this._componentAssets.getAssetByName(assetName);
            if (asset == null || !ASCompat.isXML(asset.content )) return null;
            var source= new com.sulake.core.utils.xml.XML(asset.content).copy();
            var root= Std.downcast(this._windowManager.buildFromXML(source) , IWindowContainer);
            if (root == null) return null;
            this._parent.addChild(root);
            this.bindArt(root, source);
            return root;
        }

        function bindArt(root:IWindowContainer, source:com.sulake.core.utils.xml.XML)
        {
var node:com.sulake.core.utils.xml.XML  = null, member:String  = null, window:IWindow  = null, blend:String  = null, field:ITextWindow  = null, colour:UInt  = 0, key:String  = null;            final _iter_ = this.elementNodes(source); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
node = _tmp_;
member= this.variable(node, "ss_member");
window= root.findChildByName(node.attribute("name").toString());
                if (window == null) continue;
blend= this.variable(node, "ss_blend");
                if (blend != "") window.blend = Math.max(0, Math.min(1, ASCompat.toNumber(blend) / 100));
                if (member != "" && Std.is(window , IBitmapWrapperWindow))
                    this.assignRoomBitmap(Std.downcast(window , IBitmapWrapperWindow), member);
                if (Std.is(window , ITextWindow))
                {
field= Std.downcast(window , ITextWindow);
colour= ASCompat.toUInt(this.variable(node, "ss_textColor"));
key= this.variable(node, "ss_key");
                    this._surface.formatText(field, key == "" ? "" : this.caption(key), colour,
                        this.variable(node, "ss_bold") == "true",
                        this.variable(node, "ss_alignment"));
                }
            }
        }

        function bindTime()
        {
            this._timeFront = Std.downcast(this._time.findChildByName("ss_score_snowwar_timeleft") , ITextWindow);
            this._timeShadow = Std.downcast(this._time.findChildByName("ss_score_snowwar_sd_timeleft") , ITextWindow);
        }

        function bindPersonal()
        {
            this._personalFront = Std.downcast(this._personal.findChildByName("ss_score_snowwar_score_self") , ITextWindow);
            this._personalShadow = Std.downcast(this._personal.findChildByName("ss_score_snowwar_score_sd_self") , ITextWindow);
        }

        function bindTeams()
        {
var index = 0;            for (_tmp_ in 1...5)
            {
index= _tmp_;
                this._teamBackground.push(this._teams.findChildByName(
                    "ss_score_snowwar_scorebg_team" + Std.string(index)));
                this._teamFront.push(this._teams.findChildByName(
                    "ss_score_snowwar_score_team" + Std.string(index)));
                this._teamShadow.push(this._teams.findChildByName(
                    "ss_score_snowwar_score_sd_team" + Std.string(index)));
            }
        }

        function assignRoomBitmap(window:IBitmapWrapperWindow, member:String)
        {
            if (window == null || this._assets == null) return;
            // Converted symbols are <library>_<member with every dot replaced>. Only the shared
            // habbo_simple shell pieces carry dotted Director names (window.top.left,
            // shadow.pixel), so a plain concatenation silently resolved to null and left the
            // timer plaque with nothing but its text.
            var data= this._assets.bitmapData(
                ROOM_ASSET_PREFIX + member.split(".").join("_"));
            if (data == null) return;
            var width= window.width;
            var height= window.height;
            var container= ASCompat.reinterpretAs(window , IBitmapDataContainer);
            if (container != null)
            {
                container.stretchedX = true;
                container.stretchedY = true;
                container.pivotPoint = PivotPoint.TOP_LEFT;
            }
            window.disposesBitmap = false;
            window.bitmap = data;
            window.width = width;
            window.height = height;
            window.color = 0xFFFFFF;
            window.invalidate();
        }

        function setPair(front:ITextWindow, shadow:ITextWindow, value:String)
        {
            if (front != null) front.caption = value;
            if (shadow != null) shadow.caption = value;
        }

        function raise(window:IWindow)
        {
            if (window != null && window.visible && this._parent != null)
                this._parent.setChildIndex(window, this._parent.numChildren - 1);
        }

        function formatTime(milliseconds:Int):String
        {
            var seconds= Std.int(Math.max(0, Std.int(Math.fceil(milliseconds / 1000))));
            var minutes= Std.int(seconds / 60);
            var remainder= seconds % 60;
            return Std.string(minutes) + ":" + (remainder < 10 ? "0" : "") + Std.string(remainder);
        }

        function caption(key:String):String
        {
            if (this._text == null) return key;
            var value= ASCompat.toString(this._text(key));
            return value == null || value == "" ? key : value;
        }

        function elementNodes(source:com.sulake.core.utils.xml.XML):com.sulake.core.utils.xml.XMLList
        {
            var windows= source.child("window");
            if (windows.length() == 0) return com.sulake.core.utils.xml.XMLList.coerce(([] : Array<Dynamic>));
            var roots= new com.sulake.core.utils.xml.XML(windows.at(0)).children();
            if (roots.length() == 0) return com.sulake.core.utils.xml.XMLList.coerce(([] : Array<Dynamic>));
            var groups= new com.sulake.core.utils.xml.XML(roots.at(0)).child("children");
            return groups.length() == 0 ? com.sulake.core.utils.xml.XMLList.coerce(([] : Array<Dynamic>)) : new com.sulake.core.utils.xml.XML(groups.at(0)).children();
        }

        function variable(node:com.sulake.core.utils.xml.XML, key:String):String
        {
var value:com.sulake.core.utils.xml.XML  = null;            var groups= node.child("variables");
            if (groups.length() == 0) return "";
            final _iter_ = new com.sulake.core.utils.xml.XML(groups.at(0)).children(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{value = _tmp_;
                if (value.attribute("key").toString() == key) return value.attribute("value").toString();
};
            return "";
        }

        public function dispose()
        {
            if (this._disposed) return;
            this._disposed = true;
            if (this._time != null) this._time.dispose();
            if (this._personal != null) this._personal.dispose();
            if (this._teams != null) this._teams.dispose();
            if (this._surface != null) this._surface.dispose();
            this._teamFront = [];
            this._teamShadow = [];
            this._teamBackground = [];
            this._time = null;
            this._personal = null;
            this._teams = null;
            this._parent = null;
            this._surface = null;
            this._assets = null;
            this._componentAssets = null;
            this._windowManager = null;
            this._text = null;
        }
    }

