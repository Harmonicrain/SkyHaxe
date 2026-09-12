package com.sulake.habbo.snowstorm
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.IHabboWindowManager;

    /** Builds one generated r26 layout at a time and binds native controls to it. */
     final class SnowStormLobbyWindow
    {
        var _windowManager:IHabboWindowManager;
        var _componentAssets:IAssetLibrary;
        var _host:SnowStormWindowHost;
        var _surface:SnowStormWindowSurface;
        var _text:ASFunction;
        var _window:IWindowContainer;
        var _source:com.sulake.core.utils.xml.XML;
        var _bindings:ASObject = {};
        var _elements:ASObject = {};
        var _actions:ASObject = {};
        var _focus:ITextFieldWindow;
        var _center:Bool = false;
        var _moved:Bool = false;
        var _positioning:Bool = false;

        public function new(windowManager:IHabboWindowManager,
                                             componentAssets:IAssetLibrary,
                                             assets:SnowStormAssets,
                                             host:SnowStormWindowHost,
                                             text:ASFunction)
        {
            this._windowManager = windowManager; this._componentAssets = componentAssets;
            this._host = host; this._text = text;
            this._surface = new SnowStormWindowSurface(windowManager, assets);
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer { return this._window; }
        public var surface(get,never):SnowStormWindowSurface;
public function  get_surface():SnowStormWindowSurface { return this._surface; }
        public function clearBindings() { this._bindings = {}; }
        public function bindText(id:String, value:String)
        { this.binding(id).text = value; }
        public function bindAction(id:String, action:ASFunction, data:ASObject=null)
        { var value:ASObject=this.binding(id); value.action=action; value.data=data; }
        public function bindInput(id:String, value:String, change:ASFunction)
        { var binding:ASObject=this.binding(id); binding.text=value; binding.change=change; }

        public function renderWindow(name:String, center:Bool=false)
        {
            if (this._componentAssets == null || this._windowManager == null)
                throw new ASError("SnowStorm window dependencies are unavailable");
            var asset= this._componentAssets.getAssetByName(name + "_xml");
            if (asset == null || !ASCompat.isXML(asset.content )) throw new ASError("SnowStorm layout is missing: " + name);
            var oldX= this._window == null ? 0 : this._window.x;
            var oldY= this._window == null ? 0 : this._window.y;
            var keepPosition= this._window != null && this._moved;
            var source= new com.sulake.core.utils.xml.XML(asset.content).copy();
            this.prepareLayout(name, source);
            var candidate= Std.downcast(this._windowManager.buildFromXML(source.copy()) , IWindowContainer);
            if (candidate == null) throw new ASError("SnowStorm layout did not build: " + name);
            // buildFromXML creates a visible window. Keep it hidden until all recovered Director
            // pieces, native button skins and formatted labels have been attached. Otherwise the
            // shared parent graphic context can cache a partially prepared frame; a later hover
            // then invalidates the context and makes the missing lower controls suddenly appear.
            candidate.visible = false;
            if (this._window != null)
            {
                this._window.removeEventListener(WindowEvent.WINDOW_EVENT_RELOCATED, this.onRelocated);
                this._window.dispose();
            }
            this._window = candidate; this._source = source;
            this._center = center; this._elements = {}; this._actions = {}; this._focus = null;
            this._surface.bind(candidate); this.prepareNodes();
            this._host.adopt(candidate); this._host.bringHostToFront();
            this._window.addEventListener(WindowEvent.WINDOW_EVENT_RELOCATED, this.onRelocated);
            if (keepPosition)
            {
                this._positioning = true; this._window.x = oldX; this._window.y = oldY;
                this._positioning = false;
            }
            this.position(); this._window.visible = true; this._window.activate();
            if (this._focus != null) this._focus.focus();
        }

        public function elementById(id:String):ASObject
        {
            var values:Array<ASAny> = ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._elements, id), Array);
            return values == null || values.length == 0 ? null : values[0];
        }

        public function elementByKey(key:String):ASObject
        {
var values:Array<ASAny>  = null, value:ASObject  = null;            final _iter_:ASObject = this._elements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{values = _tmp_;
                if (checkNullIteratee(values)) for (_tmp_ in values)
{value = _tmp_;
                    if (this.variable((value.node : com.sulake.core.utils.xml.XML) , "ss_key") == key) return value;
};
};
            return null;
        }

        public function setElementsVisible(id:String, visible:Bool)
        {
var value:ASObject  = null;            var values:Array<ASAny> = ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._elements, id), Array); if (values == null) return;
            if (checkNullIteratee(values)) for (_tmp_ in values)
            {
value = _tmp_;
                if (value.window != null) value.window.visible = visible;
                if (value.actionWindow != null) value.actionWindow.visible = visible;
            }
        }

        public function addText(value:String, x:Int, y:Int, width:Int, height:Int,
                                colour:UInt=0, bold:Bool=false, align:String="left",
                                underline:Bool=false):ITextWindow
        { return this._surface.textInto(this._window, value, x, y, width, height, colour, bold, align, underline); }

        public function addPiece(member:String, x:Int, y:Int, width:Int, height:Int):IBitmapWrapperWindow
        { return this._surface.pieceInto(this._window, member, x, y, width, height); }

        public function addHotspot(x:Int, y:Int, width:Int, height:Int,
                                   action:ASFunction, data:ASObject=null):IWindow
        {
            var region= this._surface.hotspotInto(this._window, x, y, width, height);
            this.registerAction(region, action, data); return region;
        }

        public function addButton(caption:String, x:Int, y:Int, width:Int, height:Int,
                                  action:ASFunction, data:ASObject=null):IWindowContainer
        {
            var control= this._surface.button(caption, x, y, width, height);
            this.registerAction(control, action, data);
            return control;
        }

        public function hide() { if (this._window != null) this._window.visible = false; }
        public function raise()
        {
            if (this._window == null || !this._window.visible) return;
            this._host.bringHostToFront(); this._host.bringToFront(this._window); this._window.activate();
        }

        public function position()
        {
            this._host.resize(); if (this._window == null || !this._host.created) return;
            this._positioning = true;
            if (this._moved)
            {
                this._window.x = Std.int(Math.max(0, Math.min(this._window.x, this._host.width - 40)));
                this._window.y = Std.int(Math.max(0, Math.min(this._window.y, this._host.height - 29)));
            }
            else if (this._center)
            {
                this._window.x = Std.int(Math.max(0, Std.int((this._host.width - this._window.width) / 2)));
                this._window.y = Std.int(Math.max(0, Std.int((this._host.height - this._window.height) / 2)));
            }
            else { this._window.x = 0; this._window.y = 0; }
            this._positioning = false;
        }

        function prepareNodes()
        {
var node:com.sulake.core.utils.xml.XML  = null, kind:String  = null, id:String  = null, actionWindow:IWindow  = null, visual:IWindow  = null, child:IWindow  = null, backing:IBitmapWrapperWindow  = null, actionIndex = 0, descriptor:ASObject  = null, bindingId:String  = null;            var drag= this._window.findChildByName("ss_drag_handle");
            if (drag != null) drag.mouseThreshold = 0;
            final _iter_ = this.elementNodes(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
node = _tmp_;
kind= this.variable(node, "ss_kind"); if (kind == "") continue;
id= this.variable(node, "ss_id");
actionWindow= this._window.findChildByName(node.attribute("name").toString());
                if (actionWindow == null) throw new ASError("SnowStorm node is missing: " + ASCompat.xmlListToString(node.attribute("name")));
                if (actionWindow.testParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)) actionWindow.mouseThreshold = 0;
visual= actionWindow;
                if ((kind == "p" || kind == "a") && Std.is(actionWindow , IWindowContainer))
                {
child= Std.downcast(actionWindow , IWindowContainer).findChildByName("ss_visual");
                    if (child != null) visual = child;
                }
                if ((kind == "p" || kind == "a") && !Std.is(visual , IBitmapWrapperWindow))
                {
backing= this._surface.pieceInto(this._window, "",
                        ASCompat.toInt(ASCompat.xmlListToString(node.attribute("x"))), ASCompat.toInt(ASCompat.xmlListToString(node.attribute("y"))), ASCompat.toInt(ASCompat.xmlListToString(node.attribute("width"))), ASCompat.toInt(ASCompat.xmlListToString(node.attribute("height"))));
                    if (backing != null)
                    {
actionIndex= this._window.getChildIndex(actionWindow);
                        if (actionIndex >= 0) this._window.setChildIndex(backing, actionIndex);
                        visual = backing;
                    }
                }
descriptor= {x:ASCompat.toInt(ASCompat.xmlListToString(node.attribute("x"))), y:ASCompat.toInt(ASCompat.xmlListToString(node.attribute("y"))), w:ASCompat.toInt(ASCompat.xmlListToString(node.attribute("width"))),
                    h:ASCompat.toInt(ASCompat.xmlListToString(node.attribute("height"))), window:visual, actionWindow:actionWindow, node:node};
                if (ASCompat.getDynamicProperty(this._elements, id)== null) ASCompat.setDynamicProperty(this._elements, id, ([] : Array<Dynamic>));
                ((ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._elements, id), Array) : Array<ASAny>)).push(descriptor);
                this.prepareNode(kind, id, node, actionWindow, visual);
            }
            final _iter_:ASObject = this._bindings; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
{bindingId = _tmp_;
                if (ASCompat.getDynamicProperty(this._elements, bindingId)== null)
                    throw new ASError("SnowStorm binding target is missing: " + bindingId);
};
        }

        function prepareNode(kind:String, id:String, node:com.sulake.core.utils.xml.XML,
                                     actionWindow:IWindow, visual:IWindow)
        {
var colourText:String  = null, colour:UInt  = 0, align:String  = null, input:ITextFieldWindow  = null, change:ASFunction  = null;            var binding:ASObject = ASCompat.getDynamicProperty(this._bindings, id);
            var key= this.variable(node, "ss_key");
            var caption= binding != null && binding.text != null ? ASCompat.toString(binding.text)
                : (key == "" ? "" : ASCompat.toString(this._text(key)));
            var member= this.variable(node, "ss_member");
            var creationControl= id.indexOf("gs_radio_") == 0
                || id == "gs_dropmenu_gamefield" || id == "gs_button_rdy"
                || id == "gs_button_cncl";
            var creationLabel= key == "gs_2teams" || key == "gs_3teams"
                || key == "gs_4teams" || key == "gs_deathmatch";
            if (kind == "p" || kind == "a")
            {
                if (member != "" && member != "shadow.pixel")
                    this._surface.assignBitmap(Std.downcast(visual , IBitmapWrapperWindow), member,
                        this.variable(node, "ss_flipH") == "true");
                if (id.indexOf("bb_kick") == 0) actionWindow.visible = false;
            }
            else if (kind == "t" || kind == "i")
            {
colourText= this.variable(node, "ss_textColor");
colour= ASCompat.toUInt(colourText == "" ? 0 : ASCompat.toUInt(ASCompat.parseInt(colourText)));
align= this.variable(node, "ss_alignment"); if (align == "") align = "left";
                this._surface.formatText(Std.downcast(visual , ITextWindow), caption, colour,
                    this.variable(node, "ss_bold") == "true", align,
                    this.variable(node, "ss_underline") == "true");
                // These four labels are redrawn on the root surface by the creation renderer. That
                // keeps them stable without placing them in an independent context above the open
                // arena menu.
                if (creationLabel) visual.visible = false;
                if (id == "gs_numtickets") { actionWindow.x -= 2; actionWindow.y -= 3; }
                if (kind == "i")
                {
input= Std.downcast(visual , ITextFieldWindow);
                    if (input == null) throw new ASError("SnowStorm input is not native: " + id);
                    input.editable = true; input.selectable = true; input.maxChars = 32;
                    input.text = caption; input.mouseThreshold = 0; this._focus = input;
change= binding == null ? null : ASCompat.asFunction(binding.change );
                    if (change != null) input.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, change);
                }
            }
            else if ((kind == "b" || kind == "d") && !creationControl)
                this._surface.buttonInto(Std.downcast(actionWindow , IWindowContainer), caption);
            if (binding != null && binding.action != null)
            {
                if (!Std.is(actionWindow , IInteractiveWindow))
                    throw new ASError("SnowStorm action target is not interactive: " + id);
                this.registerAction(actionWindow, binding.action, binding.data);
                // Director pagination arrows provide an active and a pressed bitmap. Mirror the
                // BattleBall XML path so the visual depresses while its hit region is held.
                if (kind == "p" && (member.indexOf(".active") == member.length - 7 ||
                    member.indexOf("_active") == member.length - 7))
                    this._surface.bindBitmapPressed(actionWindow,
                        Std.downcast(visual , IBitmapWrapperWindow), member);
            }
        }

        function registerAction(window:IWindow, action:ASFunction, data:ASObject)
        {
            if (window == null || action == null) return;
            window.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
            window.mouseThreshold = 0; ASCompat.setDynamicProperty(this._actions, window.name, {action:action, data:data});
            window.addEventListener(WindowMouseEvent.CLICK, this.onClick);
        }

        function onClick(event:WindowEvent)
        {
            if (event == null || event.window == null) return;
            var entry:ASObject = ASCompat.getDynamicProperty(this._actions, event.window.name);
            if (entry != null) entry.action(entry.data);
        }

        function onRelocated(event:WindowEvent)
        { if (!this._positioning) this._moved = true; }

        function binding(id:String):ASObject
        { if (ASCompat.getDynamicProperty(this._bindings, id)== null) ASCompat.setDynamicProperty(this._bindings, id, {}); return ASCompat.getDynamicProperty(this._bindings, id); }

        function elementNodes():com.sulake.core.utils.xml.XMLList
        {
            if (this._source == null) return com.sulake.core.utils.xml.XMLList.coerce(([] : Array<Dynamic>));
            var windowNodes= this._source.child("window"); if (windowNodes.length() == 0) return com.sulake.core.utils.xml.XMLList.coerce(([] : Array<Dynamic>));
            var roots= new com.sulake.core.utils.xml.XML(windowNodes.at(0)).children(); if (roots.length() == 0) return com.sulake.core.utils.xml.XMLList.coerce(([] : Array<Dynamic>));
            var groups= new com.sulake.core.utils.xml.XML(roots.at(0)).child("children");
            return groups.length() == 0 ? com.sulake.core.utils.xml.XMLList.coerce(([] : Array<Dynamic>)) : new com.sulake.core.utils.xml.XML(groups.at(0)).children();
        }

        function variable(node:com.sulake.core.utils.xml.XML, key:String):String
        {
var value:com.sulake.core.utils.xml.XML  = null;            var groups= node.child("variables"); if (groups.length() == 0) return "";
            final _iter_ = new com.sulake.core.utils.xml.XML(groups.at(0)).children(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{value = _tmp_;
                if (value.attribute("key").toString() == key) return value.attribute("value").toString();
};
            return "";
        }

        function prepareLayout(name:String, source:com.sulake.core.utils.xml.XML)
        {
var textNode:com.sulake.core.utils.xml.XML  = null, textKey:String  = null;            if (source == null) return;
            var windows= source.child("window");
            if (windows.length() == 0) return;
            var containers= new com.sulake.core.utils.xml.XML(windows.at(0)).child("container");
            if (containers.length() == 0) return;
            var root= new com.sulake.core.utils.xml.XML(containers.at(0));
            var groups= root.child("children");
            if (groups.length() == 0) return;

            // Director's 9 px bitmap text fits in the recovered 10 px fields. AIR's Volter
            // renderer needs a 13 px line box; keep the original top edge and expose the full
            // baseline instead of clipping labels such as the duration and team choices.
            final _iter_ = new com.sulake.core.utils.xml.XML(groups.at(0)).children(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
textNode = _tmp_;
                if (this.variable(textNode, "ss_kind") != "t") continue;
                if (ASCompat.toInt(ASCompat.xmlListToString(textNode.attribute("height"))) < 13) this.setNodeHeight(textNode, 13);
textKey= this.variable(textNode, "ss_key");
                if (textKey == "gs_2min" || textKey == "gs_3min" || textKey == "gs_5min")
                {
                    // Preserve each label's original centre while giving AIR's embedded Volter Bold
                    // enough horizontal room for the final 'n'. The Director field was only 30 px.
                    this.setNodeX(textNode, ASCompat.toInt(ASCompat.xmlListToString(textNode.attribute("x"))) - 3);
                    this.setNodeWidth(textNode, ASCompat.toInt(ASCompat.xmlListToString(textNode.attribute("width"))) + 6);
                }
            }

            // Keep the authored 471 px SnowStorm shell and its 40 px list rows. The create form uses
            // the same dimensions, and finished rows need both text lines for their game metadata.
            // Compacting only ss_glist made the window jump in size and discarded that second line.
        }

        function setNodeGeometry(node:com.sulake.core.utils.xml.XML, y:Int, height:Int)
        { this.setNodeY(node, y); this.setNodeHeight(node, height); }

        function setNodeY(node:com.sulake.core.utils.xml.XML, value:Int)
        {
            node.setAttribute("y", Std.string(value)) ;
            this.setNodeVariable(node, "ss_y", Std.string(value));
        }

        function setNodeX(node:com.sulake.core.utils.xml.XML, value:Int)
        {
            node.setAttribute("x", Std.string(value)) ;
            this.setNodeVariable(node, "ss_x", Std.string(value));
        }

        function setNodeWidth(node:com.sulake.core.utils.xml.XML, value:Int)
        {
            node.setAttribute("width", Std.string(value)) ;
            this.setNodeVariable(node, "ss_width", Std.string(value));
        }

        function setNodeHeight(node:com.sulake.core.utils.xml.XML, value:Int)
        {
            node.setAttribute("height", Std.string(value)) ;
            this.setNodeVariable(node, "ss_height", Std.string(value));
        }

        function setNodeVariable(node:com.sulake.core.utils.xml.XML, key:String, value:String)
        {
var variableNode:com.sulake.core.utils.xml.XML  = null;            var groups= node.child("variables"); if (groups.length() == 0) return;
            final _iter_ = new com.sulake.core.utils.xml.XML(groups.at(0)).children(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{variableNode = _tmp_;
                if (variableNode.attribute("key").toString() == key) { variableNode.setAttribute("value", value) ; return; };
}
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.removeEventListener(WindowEvent.WINDOW_EVENT_RELOCATED, this.onRelocated);
                this._window.dispose();
            }
            this._window = null; this._source = null; this._bindings = {}; this._elements = {}; this._actions = {};
            if (this._surface != null) this._surface.dispose(); this._surface = null;
            this._windowManager = null; this._componentAssets = null; this._host = null; this._text = null;
        }
    }

