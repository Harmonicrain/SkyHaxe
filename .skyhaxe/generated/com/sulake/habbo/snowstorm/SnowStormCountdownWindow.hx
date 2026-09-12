package com.sulake.habbo.snowstorm
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.IHabboWindowManager;

    /** Runtime binding for the converted r26 sw_cdown.window layout. */
     final class SnowStormCountdownWindow
    {
        static inline final BAR_WIDTH= 159;
        static inline final DEFAULT_DURATION_MS= 3000;

        var _windowManager:IHabboWindowManager;
        var _componentAssets:IAssetLibrary;
        var _surface:SnowStormWindowSurface;
        var _text:ASFunction;
        var _leaveAction:ASFunction;
        var _root:IWindowContainer;
        var _parent:IWindowContainer;
        var _bar:IBitmapWrapperWindow;
        var _leave:IWindow;
        var _price:ITextWindow;
        var _durationMs:Int = DEFAULT_DURATION_MS;
        var _member:String = "";
        var _lastWidth:Int = -1;
        var _lastSpectator:Bool = false;
        var _lastTicketCost:Int = -1;
        var _disposed:Bool = false;

        public function new(windowManager:IHabboWindowManager,
                                                  componentAssets:IAssetLibrary,
                                                  assets:SnowStormAssets,
                                                  text:ASFunction,
                                                  leaveAction:ASFunction)
        {
            this._windowManager = windowManager;
            this._componentAssets = componentAssets;
            this._surface = new SnowStormWindowSurface(windowManager, assets);
            this._text = text;
            this._leaveAction = leaveAction;
        }

        public function attach(parent:IWindowContainer, x:Int, y:Int):Bool
        {
            if (this._disposed || this._root != null || parent == null ||
                this._windowManager == null || this._componentAssets == null) return false;
            var asset= this._componentAssets.getAssetByName("ss_cdown_xml");
            if (asset == null || !ASCompat.isXML(asset.content )) return false;
            var source= new com.sulake.core.utils.xml.XML(asset.content).copy();
            this._root = Std.downcast(this._windowManager.buildFromXML(source.copy()) , IWindowContainer);
            if (this._root == null) return false;
            this._root.visible = false;
            this._root.x = x;
            this._root.y = y;
            this._parent = parent;
            parent.addChild(this._root);
            this._surface.bind(this._root);
            this.bindLayout(source);
            return this._bar != null && this._leave != null && this._price != null;
        }

        public function update(model:SnowStormModel, ticketCost:Int, force:Bool=false)
        {
            if (this._disposed || this._root == null) return;
            if (model == null || model.state != SnowStormProtocol.STATE_COUNTDOWN)
            {
                this.hide();
                return;
            }
            if (!this._root.visible)
            {
                this._durationMs = Std.int(Math.max(DEFAULT_DURATION_MS, model.timeRemainingMs));
                this._member = "";
                this._lastWidth = -1;
                this._lastTicketCost = -1;
                this._lastSpectator = !model.spectator;
                this._root.visible = true;
                if (this._parent != null)
                    this._parent.setChildIndex(this._root, this._parent.numChildren - 1);
            }

            var remaining= Std.int(Math.max(0, model.displayedTimeRemainingMs));
            var ratio= this._durationMs <= 0 ? 0
                : Math.max(0, Math.min(1, remaining / this._durationMs));
            var width= Std.int(BAR_WIDTH * ratio);
            var member= width < 39 ? "sw_scrbar_1"
                : (width < 80 ? "sw_scrbar_3" : "sw_scrbar_4");
            if (member != this._member)
            {
                this._surface.assignBitmap(this._bar, member);
                this._member = member;
            }
            if (force || width != this._lastWidth)
            {
                this._bar.width = width;
                this._bar.visible = width > 0;
                this._lastWidth = width;
            }
            if (force || model.spectator != this._lastSpectator)
            {
                this._leave.visible = !model.spectator;
                this._lastSpectator = model.spectator;
            }
            if (force || ticketCost != this._lastTicketCost)
            {
                this._price.caption = this.priceCaption(ticketCost);
                this._price.visible = ticketCost > 0;
                this._lastTicketCost = ticketCost;
            }
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return this._root != null && this._root.visible;
        }

        public function hide()
        {
            if (this._root != null && this._root.visible) this._root.visible = false;
            this._member = "";
            this._lastWidth = -1;
        }

        function bindLayout(source:com.sulake.core.utils.xml.XML)
        {
var node:com.sulake.core.utils.xml.XML  = null, kind:String  = null, window:IWindow  = null, id:String  = null, key:String  = null, member:String  = null, field:ITextWindow  = null, colourText:String  = null, colour:UInt  = 0, align:String  = null, caption:String  = null;            final _iter_ = this.elementNodes(source); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
node = _tmp_;
kind= this.variable(node, "ss_kind");
                if (kind == "") continue;
window= this._root.findChildByName(node.attribute("name").toString());
                if (window == null) throw new ASError("SnowStorm countdown node is missing: " + ASCompat.xmlListToString(node.attribute("name")));
id= this.variable(node, "ss_id");
key= this.variable(node, "ss_key");
member= this.variable(node, "ss_member");
                if (kind == "p" || kind == "a")
                {
                    if (member != "" && member != "shadow.pixel")
                        this._surface.assignBitmap(Std.downcast(window , IBitmapWrapperWindow), member,
                            this.variable(node, "ss_flipH") == "true");
                    if (id == "gs_bar_cntDwn") this._bar = Std.downcast(window , IBitmapWrapperWindow);
                }
                else if (kind == "t")
                {
field= Std.downcast(window , ITextWindow);
colourText= this.variable(node, "ss_textColor");
colour= ASCompat.toUInt(colourText == "" ? 0 : ASCompat.toUInt(ASCompat.parseInt(colourText)));
align= this.variable(node, "ss_alignment");
                    if (align == "") align = "left";
caption= key == "" ? "" : this.caption(key);
                    this._surface.formatText(field, caption, colour,
                        this.variable(node, "ss_bold") == "true", align,
                        this.variable(node, "ss_underline") == "true");
                    if (key == "sw_gameprice")
                    {
                        this._price = field;
                        if (this._price.height < 13) this._price.height = 13;
                    }
                }
                else if (kind == "b" && id == "gs_button_leavegame")
                {
                    this._leave = window;
                    this._leave.mouseThreshold = 0;
                    this._surface.buttonInto(Std.downcast(window , IWindowContainer), this.caption(key));
                    this._leave.addEventListener(WindowMouseEvent.CLICK, this.onLeave);
                }
            }
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

        function caption(key:String):String
        {
            if (key == "") return "";
            return this._text == null ? key : ASCompat.toString(this._text(key));
        }

        function priceCaption(ticketCost:Int):String
        {
            ticketCost = Std.int(Math.max(0, ticketCost));
            var key= ticketCost == 1 ? "sw_gameprice_singular" : "sw_gameprice";
            return this.caption(key).split("%cost%").join(Std.string(ticketCost));
        }

        function onLeave(event:WindowMouseEvent)
        {
            if (this._leaveAction != null) this._leaveAction();
        }

        public function dispose()
        {
            if (this._disposed) return;
            this._disposed = true;
            if (this._leave != null)
                this._leave.removeEventListener(WindowMouseEvent.CLICK, this.onLeave);
            if (this._root != null) this._root.dispose();
            if (this._surface != null) this._surface.dispose();
            this._root = null; this._parent = null; this._bar = null;
            this._leave = null; this._price = null; this._surface = null;
            this._windowManager = null; this._componentAssets = null;
            this._text = null; this._leaveAction = null;
        }
    }

