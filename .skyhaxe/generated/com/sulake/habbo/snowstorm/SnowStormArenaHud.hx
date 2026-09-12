package com.sulake.habbo.snowstorm
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window._enum.PivotPoint;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.utils.IBitmapDataContainer;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.utils.HabboFaceFocuser;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * The r26 health/ammo/make strip hosted by SnowStormArenaWindow.
     *
     * Director replaced RoomBarID with sw_ui.window.  This collaborator instead owns a cropped,
     * generated native layout inside the private arena frame and never references the hotel bar.
     * Health and ammunition are presentation of authoritative state; only one make intention is
     * emitted, and no local state grants a snowball.
     */
     final class SnowStormArenaHud implements IAvatarImageListener
    {
        public static final ACTIVITY_NORMAL:Int = SnowStormProtocol.ACTIVITY_NORMAL;
        public static final ACTIVITY_CREATING:Int = SnowStormProtocol.ACTIVITY_CREATING;
        public static final ACTIVITY_STUNNED:Int = SnowStormProtocol.ACTIVITY_STUNNED;
        public static final ACTIVITY_INVINCIBLE:Int = SnowStormProtocol.ACTIVITY_INVINCIBLE;

        static final MAX_HEALTH:Int = SnowStormProtocol.MAX_HEALTH;
        static final MAX_AMMO:Int = SnowStormProtocol.MAX_AMMO;
        static inline final HEALTH_HEIGHT= 34;
        static inline final HEALTH_TOP= 27;
        static inline final ZERO_FLASH_MS= 2500;
        static inline final ZERO_FLASH_PHASE_MS= 200;
        static inline final MAKE_ACK_TIMEOUT_MS= 1000;
        static inline final ASSET_PREFIX= "hh_game_snowwar_room_";

        var _assets:SnowStormAssets;
        var _avatars:IAvatarRenderManager;
        var _figure:String;
        var _gender:String;
        var _componentAssets:IAssetLibrary;
        var _windowManager:IHabboWindowManager;
        var _makeAction:ASFunction;
        var _root:IWindowContainer;
        var _create:IWindow;
        var _createVisual:IBitmapWrapperWindow;
        var _portrait:IBitmapWrapperWindow;
        var _healthFill:IBitmapWrapperWindow;
        var _ammoWindows:Array<ASAny> = [];
        var _gameplayWindows:Array<ASAny> = [];
        var _health:Int = MAX_HEALTH;
        var _ammo:Int = MAX_AMMO;
        var _activity:Int = ACTIVITY_NORMAL;
        var _spectator:Bool = false;
        var _gameOver:Bool = false;
        var _hover:Bool = false;
        var _mouseDown:Bool = false;
        var _makePending:Bool = false;
        var _makePendingAt:Int = 0;
        var _zeroFlashAt:Int = -1;
        var _lastCreateMember:String = "";
        var _lastAmmoBackgroundMember:String = "";
        var _renderedHealth:Int = -1;
        var _renderedAmmo:Int = -1;
        var _renderedSpectator:Int = -1;
        var _renderedCreateEnabled:Int = -1;
        var _dirty:Bool = true;
        var _disposed:Bool = false;

        public function new(windowManager:IHabboWindowManager,
                                           componentAssets:IAssetLibrary,
                                           assets:SnowStormAssets,
                                           avatars:IAvatarRenderManager,
                                           figure:String,
                                           gender:String,
                                           makeAction:ASFunction)
        {
            this._windowManager = windowManager;
            this._componentAssets = componentAssets;
            this._assets = assets;
            this._avatars = avatars;
            this._figure = figure;
            this._gender = gender;
            this._makeAction = makeAction;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        public var view(get,never):IWindowContainer;
public function  get_view():IWindowContainer { return this._root; }

        public function attach(parent:IWindowContainer, x:Int, y:Int):Bool
        {
var             childIndex = 0, child:IWindow  = null, index = 0, ammo:IWindow  = null;            if (this._disposed || this._root != null || parent == null ||
                this._windowManager == null || this._componentAssets == null) return false;
            var asset= this._componentAssets.getAssetByName("ss_arena_hud_xml");
            if (asset == null || !ASCompat.isXML(asset.content )) return false;
            var source= new com.sulake.core.utils.xml.XML(asset.content);
            this._root = Std.downcast(this._windowManager.buildFromXML(source.copy()) , IWindowContainer);
            if (this._root == null) return false;
            // The source document's bottom bar is 961 px wide; the generated XML intentionally
            // keeps its snow cap and the 288 px portrait/health/ammo/make group. Inside our arena
            // the original blue-grey strip and snow span the footer, with the controls centred.
            var authoredWidth= this._root.width;
            // x is also the horizontal frame inset. Keep the recovered blue strip inside the
            // owning footer's metal edges instead of stretching it over the rounded chrome.
            var contentWidth= Std.int(Math.max(authoredWidth, parent.width - x * 2));
            var controlsOffset= Std.int(Math.max(0, Std.int((contentWidth - authoredWidth) / 2)));
            this._root.width = contentWidth;
            childIndex= 0;while (childIndex < this._root.numChildren)
            {
child= this._root.getChildAt(childIndex);
                if (child.name == "ss_hud_background" || child.name == "ss_hud_snow" ||
                    child.name == "ss_hud_snow_shadow")
                {
                    child.x = 0;
                    child.width = this._root.width;
                }
                else if (child.name == "ss_hud_action_extension")
                {
                    child.x = controlsOffset + authoredWidth;
                    child.width = Std.int(Math.max(0, this._root.width - child.x));
                }
                else child.x += controlsOffset;
childIndex++;
            }
            this._root.x = x;
            this._root.y = y;
            parent.addChild(this._root);
            this.bindStaticArt();
            this.applyDirectorBlend(source);
            this._portrait = Std.downcast(this._root.findChildByName("ss_hud_avatar_head") , IBitmapWrapperWindow);
            this.renderPortrait();
            this._create = this._root.findChildByName("ss_hud_create");
            this._createVisual = Std.downcast(this._root.findChildByName("ss_hud_create_visual") , IBitmapWrapperWindow);
            this._healthFill = Std.downcast(this._root.findChildByName("ss_hud_health_fill") , IBitmapWrapperWindow);
            this._gameplayWindows = [this._create,
                this._root.findChildByName("ss_hud_separator_create"),
                this._root.findChildByName("ss_hud_ammo_background"),
                this._root.findChildByName("ss_hud_separator_health"),
                this._root.findChildByName("ss_hud_health_background"), this._healthFill];
            for (_tmp_ in 1...MAX_AMMO + 1)
            {
index= _tmp_;
ammo= this._root.findChildByName("ss_hud_ammo_" + Std.string(index));
                this._ammoWindows.push(ammo);
                this._gameplayWindows.push(ammo);
            }
            if (this._create != null)
            {
                // Match BattleBallWindowSurface.hotspot(): this transparent region, not its bitmap
                // child, owns input and must accept every pixel in its authored 62x52 bounds.
                this._create.mouseThreshold = 0;
                this._create.addEventListener(WindowMouseEvent.OVER, this.onCreateEvent);
                this._create.addEventListener(WindowMouseEvent.OUT, this.onCreateEvent);
                this._create.addEventListener(WindowMouseEvent.DOWN, this.onCreateEvent);
                this._create.addEventListener(WindowMouseEvent.UP, this.onCreateEvent);
                this._create.addEventListener(WindowMouseEvent.UP_OUTSIDE, this.onCreateEvent);
                this._create.addEventListener(WindowMouseEvent.CLICK, this.onCreateEvent);
            }
            this.render(flash.Lib.getTimer());
            return this._healthFill != null && this._createVisual != null;
        }

        /** Keeps the portrait in step with the figure carried by the authoritative player object. */
        public function setFigure(figure:String)
        {
            if (this._disposed || figure == null || figure == "" || figure == this._figure) return;
            this._figure = figure;
            this.renderPortrait();
        }

        /** Applies only server-confirmed avatar state. */
        public function setState(health:Int, ammo:Int, activity:Int,
                                 spectator:Bool, gameOver:Bool)
        {
            if (this._disposed) return;
            health = Std.int(Math.max(0, Math.min(MAX_HEALTH, health)));
            ammo = Std.int(Math.max(0, Math.min(MAX_AMMO, ammo)));
            activity = Std.int(Math.max(ACTIVITY_NORMAL, Math.min(ACTIVITY_INVINCIBLE, activity)));
            var changed= health != this._health || ammo != this._ammo ||
                activity != this._activity || spectator != this._spectator ||
                gameOver != this._gameOver;
            if (ammo != this._ammo || activity != this._activity)
                this._makePending = false;
            if (ammo == 0 && this._ammo != 0 && health > 0 && !spectator && !gameOver)
                this._zeroFlashAt = flash.Lib.getTimer();
            else if (ammo > 0 || health <= 0 || spectator || gameOver)
                this._zeroFlashAt = -1;
            this._health = health;
            this._ammo = ammo;
            this._activity = activity;
            this._spectator = spectator;
            this._gameOver = gameOver;
            if (changed)
            {
                this._dirty = true;
                this.render(flash.Lib.getTimer());
            }
        }

        /** Called by the owning arena render/update loop; this class owns no timer. */
        public function tick(now:Int=-1)
        {
            if (this._disposed) return;
            if (now < 0) now = flash.Lib.getTimer();
            if (this._makePending && now - this._makePendingAt >= MAKE_ACK_TIMEOUT_MS)
            {
                this._makePending = false;
                this._dirty = true;
            }
            if (this._zeroFlashAt >= 0 && now - this._zeroFlashAt >= ZERO_FLASH_MS)
            {
                this._zeroFlashAt = -1;
                this._dirty = true;
            }
            if (!this._dirty && this._zeroFlashAt < 0) return;
            this.render(now);
        }

        function bindStaticArt()
        {
var index = 0;            this.assign("ss_hud_background", "ui_bcgrnd");
            this.assign("ss_hud_snow_shadow", "ui_snow_sd");
            this.assign("ss_hud_snow", "ui_snow");
            this.assign("ss_hud_separator_create", "ui_separator2");
            this.assign("ss_hud_ammo_background", "ui_snowball_slots");
            this.assign("ss_hud_separator_health", "ui_separator");
            this.assign("ss_hud_health_background", "ui_health_bcgrnd");
            this.assign("ss_hud_health_fill", "ui_healthbar_green");
            for (_tmp_ in 1...MAX_AMMO + 1)
{index= _tmp_;
                this.assign("ss_hud_ammo_" + Std.string(index), "ui_snowball");
};
        }

        /** Preserves Director's authored blend values carried by the generated XML. */
        function applyDirectorBlend(source:com.sulake.core.utils.xml.XML)
        {
var node:com.sulake.core.utils.xml.XML  = null, window:IWindow  = null, variables:com.sulake.core.utils.xml.XMLList  = null, value:com.sulake.core.utils.xml.XML  = null;            var windows= source.child("window");
            if (windows.length() == 0) return;
            var roots= new com.sulake.core.utils.xml.XML(windows.at(0)).children();
            if (roots.length() == 0) return;
            var groups= new com.sulake.core.utils.xml.XML(roots.at(0)).child("children");
            if (groups.length() == 0) return;
            final _iter_ = new com.sulake.core.utils.xml.XML(groups.at(0)).children(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
node = _tmp_;
window= this._root.findChildByName(node.attribute("name").toString());
                if (window == null) continue;
variables= node.child("variables");
                if (variables.length() == 0) continue;
                final _iter_ = new com.sulake.core.utils.xml.XML(variables.at(0)).children(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
value = _tmp_;
                    if (value.attribute("key").toString() != "ss_blend") continue;
                    window.blend = Math.max(0, Math.min(1, ASCompat.toNumber(ASCompat.xmlListToString(value.attribute("value"))) / 100));
                    break;
                }
            }
        }

        function render(now:Int)
        {
var gameplay:IWindow  = null, percent = Math.NaN, height = 0, healthMember:String  = null,                 index = 0;            if (this._root == null) return;
            // Keep the authentic blue-grey bar visible for spectators; only its player controls
            // disappear. Previously hiding the cropped root exposed a mismatched flat grey footer.
            if (!this._root.visible) this._root.visible = true;
            var spectatorValue= this._spectator ? 1 : 0;
            if (spectatorValue != this._renderedSpectator)
            {
                final _iter_ = this._gameplayWindows; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{gameplay = _tmp_;
                    if (gameplay != null) gameplay.visible = !this._spectator;
};
                this._renderedSpectator = spectatorValue;
                this._renderedHealth = -1;
                this._renderedAmmo = -1;
            }
            if (this._spectator)
            {
                this._dirty = false;
                return;
            }

            if (this._health != this._renderedHealth)
            {
percent= this._health / MAX_HEALTH;
height= Std.int(percent * HEALTH_HEIGHT);
                if (this._healthFill != null)
                {
healthMember= percent > 0.7 ? "ui_healthbar_green" :
                        percent > 0.3 ? "ui_healthbar_yellow" : "ui_healthbar_red";
                    this.assignBitmap(this._healthFill, healthMember);
                    this._healthFill.height = height;
                    this._healthFill.y = HEALTH_TOP + HEALTH_HEIGHT - height;
                    this._healthFill.visible = height > 0;
                }
                this._renderedHealth = this._health;
            }
            if (this._ammo != this._renderedAmmo)
            {
                index= 0;while (index < this._ammoWindows.length)
                    {if (this._ammoWindows[index] != null)
                        cast(this._ammoWindows[index], IWindow).visible = index < this._ammo;
index++;
};
                this._renderedAmmo = this._ammo;
            }

            var flashing= this._zeroFlashAt >= 0 && now - this._zeroFlashAt < ZERO_FLASH_MS &&
                Std.int((now - this._zeroFlashAt) / ZERO_FLASH_PHASE_MS) % 2 == 1;
            var ammoBackgroundMember= flashing
                ? "ui_snowball_slots_hilite" : "ui_snowball_slots";
            if (ammoBackgroundMember != this._lastAmmoBackgroundMember)
            {
                this.assign("ss_hud_ammo_background", ammoBackgroundMember);
                this._lastAmmoBackgroundMember = ammoBackgroundMember;
            }
            var enabled= this.canMake();
            var enabledValue= enabled ? 1 : 0;
            if (this._create != null && enabledValue != this._renderedCreateEnabled)
            {
                if (enabled) this._create.enable(); else this._create.disable();
                this._renderedCreateEnabled = enabledValue;
            }
            var member= !enabled ? "ui_makesnowballgreen_off" :
                (this._activity == ACTIVITY_CREATING || this._makePending || this._mouseDown)
                    ? "ui_makesnowballgreen_pressed" :
                (this._hover || flashing) ? "ui_makesnowballgreen_hilite" :
                    "ui_makesnowballgreen";
            if (member != this._lastCreateMember)
            {
                this.assignBitmap(this._createVisual, member);
                this._lastCreateMember = member;
            }
            this._dirty = false;
        }

        function canMake():Bool
        {
            return !this._disposed && !this._spectator && !this._gameOver && this._health > 0 &&
                this._ammo < MAX_AMMO && !this._makePending &&
                (this._activity == ACTIVITY_NORMAL || this._activity == ACTIVITY_INVINCIBLE);
        }

        function onCreateEvent(event:WindowEvent)
        {
var activate = false;            if (this._disposed || event == null) return;
            switch (event.type)
            {
                case WindowMouseEvent.OVER:
                    this._hover = true;
                    
                case WindowMouseEvent.OUT:
                    this._hover = false;
                    this._mouseDown = false;
                    
                case WindowMouseEvent.DOWN:
                    this._mouseDown = this.canMake();
                    
                case WindowMouseEvent.UP:
activate= this._mouseDown && this.canMake();
                    this._mouseDown = false;
                    if (activate) this.activateMake();
                    
                case WindowMouseEvent.UP_OUTSIDE:
                    this._mouseDown = false;
                    
                case WindowMouseEvent.CLICK:
                    // Some AIR window stacks emit CLICK after UP and some omit it entirely. UP is
                    // the authoritative activation edge; this fallback is harmless because the
                    // pending guard is set by activateMake before the callback is dispatched.
                    this.activateMake();
                    
            }
            this.render(flash.Lib.getTimer());
        }

        function activateMake()
        {
            if (!this.canMake()) return;
            this._makePending = true;
            this._makePendingAt = flash.Lib.getTimer();
            this._dirty = true;
            if (this._makeAction != null) this._makeAction();
        }

        function assign(windowName:String, member:String)
        {
            if (this._root == null) return;
            this.assignBitmap(Std.downcast(this._root.findChildByName(windowName) , IBitmapWrapperWindow), member);
        }

        function assignBitmap(window:IBitmapWrapperWindow, member:String)
        {
            if (window == null || this._assets == null) return;
            var data= this._assets.bitmapData(ASSET_PREFIX + member);
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

        /** Restores Shockwave's local portrait slot with the current AIR avatar head. */
        function renderPortrait()
        {
            if (this._portrait == null || this._avatars == null ||
                this._figure == null || this._figure == "") return;
            var avatar= this._avatars.createAvatarImage(
                this._figure, AvatarScaleType.LARGE, this._gender, this);
            if (avatar == null) return;
            if (avatar.isPlaceholder())
            {
                avatar.dispose();
                return;
            }
            var source= HabboFaceFocuser.focusUserFace(
                avatar, AvatarSetType.HEAD, 2, 1);
            avatar.dispose();
            if (source == null) return;
            var target= new BitmapData(this._portrait.width,
                this._portrait.height, true, 0);
            var sourceX= Std.int(Math.max(0, Std.int((source.width - target.width) / 2)));
            var sourceY= Std.int(Math.max(0, Std.int((source.height - target.height) / 2)));
            var sourceWidth= Std.int(Math.min(source.width, target.width));
            var sourceHeight= Std.int(Math.min(source.height, target.height));
            target.copyPixels(source,
                new Rectangle(sourceX, sourceY, sourceWidth, sourceHeight),
                new Point(Std.int((target.width - sourceWidth) / 2),
                    Std.int((target.height - sourceHeight) / 2)), null, null, true);
            source.dispose();
            this._portrait.disposesBitmap = true;
            this._portrait.bitmap = target;
            this._portrait.invalidate();
        }

        public function avatarImageReady(figure:String)
        {
            if (!this._disposed && figure == this._figure) this.renderPortrait();
        }

        public function dispose()
        {
            if (this._disposed) return;
            this._disposed = true;
            if (this._create != null)
            {
                this._create.removeEventListener(WindowMouseEvent.OVER, this.onCreateEvent);
                this._create.removeEventListener(WindowMouseEvent.OUT, this.onCreateEvent);
                this._create.removeEventListener(WindowMouseEvent.DOWN, this.onCreateEvent);
                this._create.removeEventListener(WindowMouseEvent.UP, this.onCreateEvent);
                this._create.removeEventListener(WindowMouseEvent.UP_OUTSIDE, this.onCreateEvent);
                this._create.removeEventListener(WindowMouseEvent.CLICK, this.onCreateEvent);
            }
            if (this._root != null) this._root.dispose();
            this._ammoWindows = [];
            this._gameplayWindows = [];
            this._healthFill = null;
            this._portrait = null;
            this._createVisual = null;
            this._create = null;
            this._root = null;
            this._makeAction = null;
            this._avatars = null;
            this._figure = null;
            this._gender = null;
            this._assets = null;
            this._componentAssets = null;
            this._windowManager = null;
        }
    }

