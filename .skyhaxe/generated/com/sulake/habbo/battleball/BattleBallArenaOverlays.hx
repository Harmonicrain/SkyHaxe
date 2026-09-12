package com.sulake.habbo.battleball
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * Overlays drawn over the board: hover name tags, the riders' balls and the pickups.
     *
     * Split out of BattleBallArenaWindow, which owned the frame, the HUD and the overlays at
     * once. The window still owns the frame and the panel; this draws into them.
     */
     class BattleBallArenaOverlays
    {
        /**
         * Distance from the top of each pickup bitmap down to the point that rests on the floor, taken
         * from the Director registration point the converter recorded (hh_game_bb_room_inventory.json).
         *
         * These are NOT bottom-aligned sprites: the light bulb is 43 tall but registers at 36, so
         * drawing its bottom edge on the tile floated it 7px. Every pickup differs -- 4px for the
         * spring, 9px for the pins -- which is why they hovered by inconsistent amounts.
         *
         * Only the vertical is taken from the cast. The recorded X is pre-crop and unreliable (tiles
         * record -2 but need 14, see TILE_REGISTRATION_X), so pickups stay centred horizontally.
         */
        /**
         * Pickups are animated in the cast: eight frames each (three for the pins). The bob is drawn
         * into the frames rather than being a positional wobble, so cycling the bitmap is the whole
         * effect. Driven from the frame loop -- drawObjects only runs when the arena is rebuilt, so a
         * pickup drawn once would sit frozen on frame 0.
         */
        static inline final PICKUP_FRAMES= 8;
        /**
         * Red, blue, yellow, green -- the four teams, in the order the protocol numbers them. These are
         * the cast's own values, read off the bb_scrbar_1..4 score bars rather than picked by eye.
         */
        static final TEAM_COLOURS:Array<ASAny> = [0xE05951, 0x51A7E0, 0xD7E051, 0x61E051];
        /**
         * The ball each player rides. Bouncing Bodypart Class draws it from a single greyscale member
         * tinted to the team colour, always with direction 1 and the "wlk" action whichever way the
         * rider faces, so one sprite serves all eight directions. The cast ships frames 0, 1 and 3 --
         * there is no frame 2 -- and Director simply skips a member it cannot resolve.
         */
        static final BALL_FRAMES:Array<ASAny> = [0, 1, 3];
        static inline final PICKUP_FRAME_MS= 120;
        static inline final PICKUP_PINS_FRAMES= 3;
        static final PICKUP_REGISTRATION_Y:ASObject = {
            "lghtbulb": 36, "spring": 49, "flashlght": 19, "cannon": 33, "pinbox": 32,
            "harlequin": 37, "bomb": 41, "drill": 43, "qstnmark": 33, "pins": 11
        };
        var _arena:BattleBallArena;
        var _assets:BattleBallAssets;
        var _componentAssets:IAssetLibrary;
        var _ballFrames:Array<ASAny>;
        var _frame:IWindowContainer;
        var _hoveredPlayerId:Int = -1;
        var _model:BattleBallModel;
        var _nameTags:ASObject = {};
        var _panel:Sprite;
        var _pickupFrames:ASObject = {};
        var _pickups:Array<ASAny> = [];
        var _services:BattleBallViewServices;
        var _windowManager:IHabboWindowManager;
        var _wrapper:IDisplayObjectWrapper;

        public function new(windowManager:IHabboWindowManager, assets:BattleBallAssets,
                                        componentAssets:IAssetLibrary, arena:BattleBallArena,
                                        services:BattleBallViewServices)
        {
            this._windowManager = windowManager; this._assets = assets;
            this._componentAssets = componentAssets;
            this._arena = arena; this._services = services;
        }

        /** The window hands over the display objects it owns once they exist. */
        /** Drop the pickup sprites when the board is cleared. */
        public function clearPickups() { this._pickups = []; }

        public function attach(_frame:IWindowContainer, _panel:Sprite, _wrapper:IDisplayObjectWrapper)
        {
            this._frame = _frame;
            this._panel = _panel;
            this._wrapper = _wrapper;
        }
        public function syncPlayerNameTags(model:BattleBallModel)
        {
var object:ASObject  = null, key:String  = null, tag:IWindowContainer  = null, bounds:Rectangle  = null, location:Point  = null;            if (this._arena == null || this._frame == null || this._wrapper == null) return;
            var seen:ASObject = {};
            final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
object = _tmp_;
                if (object.type != 0) continue;
key= ASCompat.toString(object.objectId);
ASCompat.setDynamicProperty(                seen, key, true);
tag= ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._nameTags, key), IWindowContainer);
                if (tag == null)
                {
                    tag = this.createNativeNameTag(this._services.playerDisplayName(object));
                    if (tag == null) continue;
ASCompat.setDynamicProperty(                    this._nameTags, key, tag);
                    this._frame.addChild(tag);
                }
                this.sizeNativeNameTag(tag, this._services.playerDisplayName(object));
bounds= this._arena.getPlayerBounds(ASCompat.toInt(object.objectId));
location= this._arena.getPlayerScreenLocation(ASCompat.toInt(object.objectId));
                // RoomEngine can briefly have no bounds while an avatar visualization advances frames.
                // Keep the last good position rather than blinking the bubble off for that redraw.
                if (bounds == null || location == null) continue;
                tag.x = Std.int(this._wrapper.x + location.x - tag.width / 2);
                tag.y = Std.int(this._wrapper.y + bounds.top - tag.height + (bounds.height > 50 ? 25 : 0));
                tag.visible = ASCompat.toInt(object.objectId) == this._hoveredPlayerId;
            }
            final _iter_:ASObject = this._nameTags; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
            {
key = _tmp_;
                if (!ASCompat.hasOwnProperty(seen, key)) cast(ASCompat.getDynamicProperty(this._nameTags, key), IWindowContainer).visible = false;
            }
        }
        function applyNameTagHover()
        {
var key:String  = null, tag:IWindowContainer  = null;            final _iter_:ASObject = this._nameTags; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
            {
key = _tmp_;
tag= ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._nameTags, key), IWindowContainer);
                if (tag != null) tag.visible = ASCompat.toInt(key) == this._hoveredPlayerId;
            }
        }
        public function hidePlayerNameTags()
        {
var tag:IWindowContainer  = null;            final _iter_:ASObject = this._nameTags; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {tag = _tmp_;
tag.visible = false;
};
        }
        function createNativeNameTag(name:String):IWindowContainer
        {
            if (this._componentAssets == null) return null;
            var asset= this._componentAssets.getAssetByName("avatar_info_widget");
            if (asset == null || !ASCompat.isXML(asset.content )) return null;
            var xml= new com.sulake.core.utils.xml.XML(asset.content).copy();
            var tag= Std.downcast(this._windowManager.buildFromXML(xml, 0) , IWindowContainer);
            if (tag == null) return null;
            tag.name = "battleball_player_name";
            tag.visible = false;
            tag.findChildByName("change_name_container").visible = false;
            tag.findChildByName("relationship_status").visible = false;
            tag.height = 39;
            this.sizeNativeNameTag(tag, name);
            return tag;
        }
        function sizeNativeNameTag(tag:IWindowContainer, name:String)
        {
            var text= Std.downcast(tag.findChildByName("name") , ITextWindow);
            if (text == null) return;
            if (text.caption != name) text.caption = name;
            if (text.x != 8) text.x = 8;
            // textWidth is clipped by the previous field width in this window implementation, so retain
            // it as a lower bound but also reserve enough width from the untruncated character count.
            var width= Std.int(Math.min(180, Math.max(64, Math.max(Math.fceil(text.textWidth) + 24, name.length * 8 + 24))));
            var border= tag.findChildByName("border");
            // The XML's bubble is fixed-width, not parent-stretched. Resize the actual bubble as well as
            // its outer container or the container clips it into the malformed black rectangle we saw.
            if (border != null)
            {
                if (border.width != width) border.width = width;
                if (border.color != 0xFF5A5551) border.color = 0xFF5A5551;
            }
            if (text.width != width - 16) text.width = width - 16;
            if (tag.width != width) tag.width = width;
            if (tag.color != 0xFF5A5551) tag.color = 0xFF5A5551;
        }
        public function onArenaMouseMove(event:MouseEvent)
        {
var object:ASObject  = null, bounds:Rectangle  = null;            if (this._panel == null || this._arena == null || this._model == null) return;
            var x= this._panel.mouseX;
            var y= this._panel.mouseY;
            var hovered= -1;
            final _iter_:ASObject = this._model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
object = _tmp_;
                if (object.type != 0) continue;
bounds= this._arena.getPlayerBounds(ASCompat.toInt(object.objectId));
                if (bounds == null || !bounds.contains(x, y)) continue;
                // Overlapping avatars: the one drawn lowest is nearest the camera, so it wins.
                if (hovered < 0 || bounds.bottom > this._arena.getPlayerBounds(hovered).bottom)
                    hovered = ASCompat.toInt(object.objectId);
            }
            if (hovered == this._hoveredPlayerId) return;
            this._hoveredPlayerId = hovered;
            this.applyNameTagHover();
        }
        public function onArenaMouseOut(event:MouseEvent)
        {
            if (this._hoveredPlayerId < 0) return;
            this._hoveredPlayerId = -1;
            this.applyNameTagHover();
        }
        /**
         * Board position for a cell. Everything on the board goes through here: tiles, pickups, pins and
         * nametags, so they cannot drift apart from the avatars the engine draws.
         *
         * The engine owns the projection; the only fitted value left is a single per-map anchor that slides
         * that projection onto the painted arena. It is solved once per map from the artwork fit, so the
         * board art and the engine agree by construction rather than by tuning constants against each other.
         */
        /** Places a pickup and registers it for animation. */
        public function addPickup(display:DisplayObject, powerName:String, point:Array<ASAny>)
        {
            var bitmap= Std.downcast(display , Bitmap);
            if (bitmap != null) bitmap.smoothing = false;
            display.x = ASCompat.toNumber(ASCompat.toNumber(point[0]) - display.width / 2);
            display.y = ASCompat.toNumber(ASCompat.toNumber(point[1]) - this.pickupAnchor(powerName, display.height));
            this._panel.addChild(display);
            if (bitmap != null) this._pickups.push({bitmap: bitmap, name: powerName, y: point[1]});
        }
        /** Cached frame bitmaps for one pickup, loaded once and reused for every instance on the board. */
        function pickupFrames(powerName:String):Array<ASAny>
        {
var index = 0, art:Bitmap  = null;            if (ASCompat.getDynamicProperty(this._pickupFrames, powerName)!= null) return ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._pickupFrames, powerName), Array);
            var frames:Array<ASAny> = [];
            var count= powerName == "pins" ? PICKUP_PINS_FRAMES : PICKUP_FRAMES;
            for (_tmp_ in 0...count)
            {
index= _tmp_;
art= Std.downcast(this._assets.display(
                    "hh_game_bb_room_s_bb2_pu_" + powerName + "_a_0_1_1_0_" + Std.string(index)) , Bitmap);
                if (art != null && art.bitmapData != null) frames.push(art.bitmapData);
            }
ASCompat.setDynamicProperty(            this._pickupFrames, powerName, frames);
            return frames;
        }
        public function onPickupFrame(event:Event)
        {
var entry:ASObject  = null, bitmap:Bitmap  = null, frames:Array<ASAny>  = null, next:BitmapData  = null;            if (this._pickups.length == 0) return;
            final _iter_ = this._pickups; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
entry = _tmp_;
bitmap= ASCompat.dynamicAs(entry.bitmap , Bitmap);
                if (bitmap == null || bitmap.parent == null) continue;
frames= this.pickupFrames(ASCompat.toString(entry.name));
                if (frames.length == 0) continue;
next= ASCompat.dynamicAs(frames[Std.int(flash.Lib.getTimer() / PICKUP_FRAME_MS) % frames.length] , BitmapData);
                if (next == null || bitmap.bitmapData == next) continue;
                bitmap.bitmapData = next;
                // Frames can differ in height (the question mark grows on one), so re-anchor each time.
                bitmap.y = ASCompat.toNumber(entry.y) - this.pickupAnchor(ASCompat.toString(entry.name), next.height);
            }
        }
        /** Falls back to the bitmap height for anything the cast has no registration for. */
        function pickupAnchor(powerName:String, height:Float):Int
        {
            return ASCompat.hasOwnProperty(PICKUP_REGISTRATION_Y, powerName)                ? ASCompat.toInt(ASCompat.getDynamicProperty(PICKUP_REGISTRATION_Y, powerName)) : Std.int(height);
        }
        /**
         * Hands the ball art to each rider's avatar. The ball is drawn by the avatar itself (see
         * BouncingBall) so it depth-sorts behind the body, the way the cast's part order has it --
         * a sprite layered over the room canvas could only ever sit in front of the Habbo.
         */
        public function syncPlayerBalls(model:BattleBallModel)
        {
var frame = 0, art:Bitmap  = null, object:ASObject  = null;            if (this._arena == null || model == null || this._assets == null) return;
            if (this._ballFrames == null)
            {
                this._ballFrames = [];
                final _iter_ = BALL_FRAMES; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
frame = ASCompat.toInt(_tmp_);
art= Std.downcast(this._assets.display("hh_game_bb_ui_sh_wlk_bl_001_1_" + Std.string(frame)) , Bitmap);
                    if (art != null && art.bitmapData != null) this._ballFrames.push(art.bitmapData);
                }
                if (this._ballFrames.length == 0) return;
            }
            final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
object = _tmp_;
                if (object.type != 0) continue;
                this._arena.setPlayerBall(ASCompat.toInt(object.objectId), this._ballFrames,
                    ASCompat.toUInt(TEAM_COLOURS[ASCompat.toInt(object.teamId) % TEAM_COLOURS.length]));
            }
        }
    }

