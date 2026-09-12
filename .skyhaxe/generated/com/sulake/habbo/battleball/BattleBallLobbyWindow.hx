package com.sulake.habbo.battleball
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
    import com.sulake.habbo.utils.HabboWebTools;

    /** Shared native WindowManager shell for BattleBall lobby screens and the independent ticket dialog. */
     class BattleBallLobbyWindow
    {
        static inline final LOBBY_TITLE_HEIGHT= 29;
        public static inline final TEAM_ROW_HEIGHT= 16;
        public static inline final TEAM_LINK_HEIGHT= 16;
        static inline final TEAM_CAPACITY_MAX= 6;

        var _anchoredX:Int = 0;
        var _anchoredY:Int = 0;
        var _arenaPresent:ASFunction;
        var _bindings:ASObject = {};
        var _centerLobby:Bool = false;
        var _componentAssets:IAssetLibrary;
        var _elements:ASObject = {};
        var _focusInput:ITextFieldWindow;
        var _hideArena:ASFunction;
        var _hideNameTags:ASFunction;
        var _host:BattleBallWindowHost;
        var _inputChanged:ASFunction;
        var _layoutName:String = "";
        var _lobby:IWindowContainer;
        var _lobbyActions:ASObject = {};
        var _lobbyMoved:Bool = false;
        var _positioning:Bool = false;
        var _surface:BattleBallWindowSurface;
        var _text:ASFunction;
        var _windowManager:IHabboWindowManager;
        var _xmlSource:com.sulake.core.utils.xml.XML;

        public function new(windowManager:IHabboWindowManager, assets:BattleBallAssets,
                                              componentAssets:IAssetLibrary, host:BattleBallWindowHost,
                                              text:ASFunction, hideArena:ASFunction, hideNameTags:ASFunction,
                                              arenaPresent:ASFunction, inputChanged:ASFunction)
        {
            this._windowManager = windowManager;
            this._componentAssets = componentAssets;
            this._host = host;
            this._text = text;
            this._hideArena = hideArena;
            this._hideNameTags = hideNameTags;
            this._arenaPresent = arenaPresent;
            this._inputChanged = inputChanged;
            this._surface = new BattleBallWindowSurface(windowManager, assets, this.registerAction);
        }

        public var panel(get,never):IWindowContainer;
public function  get_panel():IWindowContainer { return this._lobby; }
        public var chrome(get,never):BattleBallWindowSurface;
public function  get_chrome():BattleBallWindowSurface { return this._surface; }
        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer { return this._lobby; }
        public var bindings(get,never):ASObject;
public function  get_bindings():ASObject { return this._bindings; }
        public function clearBindings() { this._bindings = {}; }
        public var centerNext(never,set):Bool;
public function  set_centerNext(value:Bool):Bool{ return this._centerLobby = value; }
        public var moved(never,set):Bool;
public function  set_moved(value:Bool):Bool{ return this._lobbyMoved = value; }

        /** Build one complete native XML window and bind its runtime Director bitmaps. */
        public function renderXmlWindow(assetName:String, overArena:Bool=false):Bool
        {
            if (this._componentAssets == null || this._windowManager == null)
                throw new ASError("BattleBall XML window dependencies are unavailable: " + assetName);
            var asset= this._componentAssets.getAssetByName(assetName);
            if (asset == null || !ASCompat.isXML(asset.content ))
                throw new ASError("BattleBall XML asset is missing: " + assetName);

            var oldX= this._lobby == null ? 0 : this._lobby.x;
            var oldY= this._lobby == null ? 0 : this._lobby.y;
            var keepPosition= this._lobby != null && (this._lobbyMoved || !this._centerLobby);
            var oldLobby= this._lobby;
            var oldSource= this._xmlSource;
            var oldElements:ASObject = this._elements;
            var oldActions:ASObject = this._lobbyActions;
            var oldFocus= this._focusInput;
            var candidateSource= new com.sulake.core.utils.xml.XML(asset.content).copy();
            var candidate= Std.downcast(this._windowManager.buildFromXML(candidateSource) , IWindowContainer);
            if (candidate == null)
                throw new ASError("BattleBall XML asset did not build a container: " + assetName);

            // Prepare a hidden candidate first. A malformed asset or missing binding must not dispose
            // the known-good screen or leave a half-initialised window attached to the desktop.
            candidate.visible = false;
            this._lobby = candidate;
            this._xmlSource = candidateSource;
            this._lobbyActions = {};
            this._elements = {};
            this._focusInput = null;
            this._surface.bind(candidate);
            try
            {
                this.prepareXmlNodes();
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                candidate.dispose();
                this._lobby = oldLobby;
                this._xmlSource = oldSource;
                this._elements = oldElements;
                this._lobbyActions = oldActions;
                this._focusInput = oldFocus;
                this._surface.bind(oldLobby);
                throw error;
            }
 }
            if (oldLobby != null)
            {
                oldLobby.removeEventListener(WindowEvent.WINDOW_EVENT_RELOCATED, this.onLobbyRelocated);
                oldLobby.dispose();
            }
            if (!overArena) this._hideArena();
            this._host.ensureRoot();
            this._host.adopt(candidate);
            // Native WindowManager hit-testing follows the desktop child order. The old Flash canvas
            // received stage events even when this shared host sat behind the room UI; native controls
            // correctly do not. Raise the host whenever a lobby/dialog is shown so the visible
            // BattleBall window is also the first input target.
            this._host.bringHostToFront();
            this._lobby.addEventListener(WindowEvent.WINDOW_EVENT_RELOCATED, this.onLobbyRelocated);

            if (overArena && this._host.created && ASCompat.toBool(this._arenaPresent()))
                this._host.bringToFront(this._lobby);
            this._hideNameTags();
            if (keepPosition)
            {
                this._lobbyMoved = true;
                this._positioning = true;
                this._lobby.x = oldX;
                this._lobby.y = oldY;
                this._positioning = false;
                this._anchoredX = oldX;
                this._anchoredY = oldY;
            }
            else
            {
                this._anchoredX = this._lobby.x;
                this._anchoredY = this._lobby.y;
            }
            this.position();
            this._lobby.visible = true;
            this._lobby.activate();
            if (this._focusInput != null) this._focusInput.focus();
            return true;
        }

        function prepareXmlNodes()
        {
var node:com.sulake.core.utils.xml.XML  = null, kind:String  = null, id:String  = null, window:IWindow  = null, visual:IWindow  = null, child:IWindow  = null, descriptor:ASObject  = null, bindingId:String  = null;            var dragHandle= this._lobby.findChildByName("bb_drag_handle");
            if (dragHandle != null) dragHandle.mouseThreshold = 0;
            final _iter_ = this.xmlElementNodes(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
node = _tmp_;
kind= this.xmlVariable(node, "bb_kind");
                if (kind == "") continue;
id= this.xmlVariable(node, "bb_id");
window= this._lobby.findChildByName(node.attribute("name").toString());
                if (window == null) throw new ASError("BattleBall XML node is missing: " + ASCompat.xmlListToString(node.attribute("name")));
                // Director hit areas are rectangles, not alpha masks. The generator emits native
                // buttons, links and regions with threshold zero; retain that property after build.
                if (window.testParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR))
                    window.mouseThreshold = 0;
visual= window;
                if ((kind == "p" || kind == "a") && Std.is(window , IWindowContainer))
                {
child= Std.downcast(window , IWindowContainer).findChildByName("bb_visual");
                    if (child != null) visual = child;
                }
descriptor= {
                    x:ASCompat.toInt(this.xmlVariable(node, "bb_x") == "" ? node.attribute("x") : this.xmlVariable(node, "bb_x")),
                    y:ASCompat.toInt(ASCompat.xmlListToString(node.attribute("y"))), w:ASCompat.toInt(ASCompat.xmlListToString(node.attribute("width"))), h:ASCompat.toInt(ASCompat.xmlListToString(node.attribute("height"))), window:visual,
                    actionWindow:window, node:node
                };
                if (ASCompat.getDynamicProperty(this._elements, id)== null) ASCompat.setDynamicProperty(this._elements, id, ([] : Array<Dynamic>));
                ((ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._elements, id), Array) : Array<ASAny>)).push(descriptor);
                this.prepareXmlNode(kind, id, node, window, visual);
            }
            final _iter_:ASObject = this._bindings; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
{bindingId = _tmp_;
                if (ASCompat.getDynamicProperty(this._elements, bindingId)== null)
                    throw new ASError("BattleBall XML binding target is missing: " + bindingId);
};
        }

        function prepareXmlNode(kind:String, id:String, node:com.sulake.core.utils.xml.XML, window:IWindow,
                                        visual:IWindow)
        {
var input:ITextFieldWindow  = null, changeHandler:ASFunction  = null;            var binding:ASObject = ASCompat.getDynamicProperty(this._bindings, id);
            var key= this.xmlVariable(node, "bb_key");
            var caption= binding != null && binding.text != null
                ? ASCompat.toString(binding.text) : (key == "" ? "" : ASCompat.toString(this._text(key)));
            var member= this.xmlVariable(node, "bb_member");
            var colourText:String = null;
            var colour:UInt = 0;
            var align:String = null;
            var bold = false;

            if (kind == "p" || kind == "a")
            {
                if (member != "" && member != "shadow_pixel")
                    this._surface.assignBitmap(Std.downcast(visual , IBitmapWrapperWindow), member,
                        kind == "p" && this.xmlVariable(node, "bb_flip") == "1");
                // shadow_pixel is the Director convention for an invisible rectangular hit area.
                // Leaving its bitmap empty makes it visually transparent; hiding the native window
                // would also remove it from WindowManager hit-testing (including Start Game).
                if (id.indexOf("bb_kick") == 0) window.visible = false;
            }
            else if (kind == "t" || kind == "i")
            {
                colourText = this.xmlVariable(node, "text_color");
                colour = ASCompat.toUInt(colourText == "" ? 0x000000 : ASCompat.toUInt(ASCompat.parseInt(colourText, 16)));
                align = this.xmlVariable(node, "alignment");
                if (align == "") align = "left";
                bold = this.xmlVariable(node, "bold") == "true";
                this._surface.formatText(Std.downcast(window , ITextWindow), caption, colour, bold, align,
                    kind == "t" && this.xmlVariable(node, "underline") == "true");
                // Flash/native text fields have a small internal gutter and baseline difference from
                // Director fields. Keep the original port's measured correction for the compact
                // three-digit ticket counter so it sits beside the ticket icon rather than below it.
                if (id == "bb_amount_tickets" || id == "bb_ticketAmount_text")
                {
                    window.x -= 2;
                    window.y -= 3;
                }
                if (kind == "i")
                {
input= Std.downcast(window , ITextFieldWindow);
                    if (input == null) throw new ASError("BattleBall input did not build as ITextFieldWindow: " + id);
                    input.editable = true;
                    input.selectable = true;
                    input.maxChars = 32;
                    input.text = caption;
                    input.mouseThreshold = 0;
                    this._focusInput = input;
changeHandler= binding != null && binding.change != null
                        ? ASCompat.asFunction(binding.change ) : this._inputChanged;
                    if (changeHandler != null)
                        input.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, changeHandler);
                }
            }
            else if (kind == "b")
            {
                this._surface.buttonInto(Std.downcast(window , IWindowContainer), caption);
            }
            if (binding != null && binding.action != null)
            {
                // A control that cannot receive input is a dead button, not a dead client. The
                // generator now emits an interactive node for every bound id, so this should be
                // unreachable -- but it used to throw here and take the whole client down when one
                // cast element (bb_tab_teams) was missing its cursor property.
                if (!Std.is(window , IInteractiveWindow))
                {
                    HabboWebTools.airDebug("[BattleBall UI] action target is not interactive: "
                        + id + " in " + this._layoutName + " -- regenerate tools/gen_bb_layouts.py");
                    return;
                }
                this.registerAction(window, binding.action, binding.data);
                if (kind == "p" && member.indexOf("_active") == member.length - 7)
                    this._surface.bindBitmapPressed(window, Std.downcast(visual , IBitmapWrapperWindow), member);
            }
        }

        public function xmlWindow(id:String):IWindow
        {
            var matches:Array<ASAny> = ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._elements, id), Array);
            return matches == null || matches.length == 0 ? null : ASCompat.dynamicAs(matches[0].window , IWindow);
        }

        /** Shows or hides every native node generated for one Director id, including its hit area. */
        public function setElementsVisible(id:String, visible:Bool)
        {
var descriptor:ASObject  = null;            var matches:Array<ASAny> = ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._elements, id), Array);
            if (matches == null) return;
            if (checkNullIteratee(matches)) for (_tmp_ in matches)
            {
descriptor = _tmp_;
                if (descriptor.window != null) descriptor.window.visible = visible;
                if (descriptor.actionWindow != null) descriptor.actionWindow.visible = visible;
            }
        }

        /** Static labels often share a broad id; their cast member remains a stable selector. */
        public function setMemberVisible(member:String, visible:Bool)
        {
var matches:Array<ASAny>  = null, descriptor:ASObject  = null;            final _iter_:ASObject = this._elements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
matches = _tmp_;
                if (checkNullIteratee(matches)) for (_tmp_ in matches)
                {
descriptor = _tmp_;
                    if (this.xmlVariable((descriptor.node : com.sulake.core.utils.xml.XML) , "bb_member") != member) continue;
                    if (descriptor.window != null) descriptor.window.visible = visible;
                    if (descriptor.actionWindow != null) descriptor.actionWindow.visible = visible;
                }
            }
        }

        public function hide() { if (this._lobby != null) this._lobby.visible = false; }

        /** Keeps an already-visible independent dialog above a sibling window rebuilt by a redraw. */
        public function raise()
        {
            if (this._lobby == null || !this._lobby.visible) return;
            this._host.bringHostToFront();
            this._host.bringToFront(this._lobby);
            this._lobby.activate();
        }

        public function position()
        {
            this._host.resize();
            if (this._lobby == null || !this._host.created) return;
            this._positioning = true;
            if (this._lobbyMoved)
            {
                this._lobby.x = Std.int(Math.max(0, Math.min(this._lobby.x, this._host.width - 40)));
                this._lobby.y = Std.int(Math.max(0, Math.min(this._lobby.y,
                    this._host.height - LOBBY_TITLE_HEIGHT)));
            }
            else if (this._centerLobby)
            {
                this._lobby.x = Std.int(Math.max(0, Std.int((this._host.width - this._lobby.width) / 2)));
                this._lobby.y = Std.int(Math.max(0, Std.int((this._host.height - this._lobby.height) / 2)));
            }
            else
            {
                this._lobby.x = 0;
                this._lobby.y = 0;
            }
            this._positioning = false;
            this._anchoredX = this._lobby.x;
            this._anchoredY = this._lobby.y;
        }

        function onLobbyRelocated(event:WindowEvent)
        {
            if (this._positioning || this._lobby == null) return;
            this._lobbyMoved = true;
            this._anchoredX = this._lobby.x;
            this._anchoredY = this._lobby.y;
        }

        function registerAction(window:IWindow, action:ASFunction, data:ASObject=null)
        {
            if (window == null || action == null) return;
            window.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
            window.mouseThreshold = 0;
ASCompat.setDynamicProperty(            this._lobbyActions, window.name, {action:action, data:data});
            window.removeEventListener(WindowMouseEvent.CLICK, this.onNativeClick);
            window.addEventListener(WindowMouseEvent.CLICK, this.onNativeClick);
        }

        function onNativeClick(event:WindowEvent)
        {
            if (event == null || event.window == null) return;
            var entry:ASObject = ASCompat.getDynamicProperty(this._lobbyActions, event.window.name);
            if (entry != null)
            {
                entry.action(entry.data);
            }
        }

        public function teamRowCapacity(teams:Int):Int
        {
            var area:ASObject = this.xmlLayoutElement("bb_ginfo" + Std.string(teams) + "t_xml", "bb_area_team1");
            if (area == null) return TEAM_CAPACITY_MAX;
            var rows= Std.int((ASCompat.toInt(area.h) - TEAM_LINK_HEIGHT) / TEAM_ROW_HEIGHT);
            return Std.int(Math.max(1, Math.min(TEAM_CAPACITY_MAX, rows)));
        }

        function xmlLayoutElement(assetName:String, id:String):ASObject
        {
            if (this._componentAssets == null) return null;
            var asset= this._componentAssets.getAssetByName(assetName);
            if (asset == null || !ASCompat.isXML(asset.content )) return null;
            var source= new com.sulake.core.utils.xml.XML(asset.content);
            var node= this.findDescendantBySemanticId(source, id);
            if (node == null) return null;
            return {x:ASCompat.toInt(this.xmlVariable(node, "bb_x") == "" ? node.attribute("x") : this.xmlVariable(node, "bb_x")),
                    y:ASCompat.toInt(ASCompat.xmlListToString(node.attribute("y"))), w:ASCompat.toInt(ASCompat.xmlListToString(node.attribute("width"))), h:ASCompat.toInt(ASCompat.xmlListToString(node.attribute("height")))};
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

        public function dispose()
        {
            this.releaseWindow();
            if (this._surface != null) { this._surface.dispose(); this._surface = null; }
            this._windowManager = null;
            this._componentAssets = null;
            this._host = null;
        }

        function releaseWindow()
        {
            if (this._lobby != null)
            {
                this._lobby.removeEventListener(WindowEvent.WINDOW_EVENT_RELOCATED, this.onLobbyRelocated);
                this._lobby.dispose();
            }
            this._lobby = null;
            this._focusInput = null;
            this._elements = {};
            this._lobbyActions = {};
            this._xmlSource = null;
        }

        public function renderWindow(name:String, overArena:Bool=false)
        {
            this._layoutName = name;
            this._centerLobby = overArena;
            this.renderXmlWindow(name + "_xml", overArena);
        }

        function xmlElementNodes():com.sulake.core.utils.xml.XMLList
        {
            if (this._xmlSource == null) return com.sulake.core.utils.xml.XMLList.coerce(([] : Array<Dynamic>));
            var windowNodes= this._xmlSource.child("window");
            if (windowNodes.length() == 0) return com.sulake.core.utils.xml.XMLList.coerce(([] : Array<Dynamic>));
            var roots= new com.sulake.core.utils.xml.XML(windowNodes.at(0)).children();
            if (roots.length() == 0) return com.sulake.core.utils.xml.XMLList.coerce(([] : Array<Dynamic>));
            var groups= new com.sulake.core.utils.xml.XML(roots.at(0)).child("children");
            return groups.length() == 0 ? com.sulake.core.utils.xml.XMLList.coerce(([] : Array<Dynamic>)) : new com.sulake.core.utils.xml.XML(groups.at(0)).children();
        }

        function xmlVariable(node:com.sulake.core.utils.xml.XML, key:String):String
        {
var variable:com.sulake.core.utils.xml.XML  = null;            var groups= node.child("variables");
            if (groups.length() == 0) return "";
            final _iter_ = new com.sulake.core.utils.xml.XML(groups.at(0)).children(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{variable = _tmp_;
                if (variable.attribute("key").toString() == key) return variable.attribute("value").toString();
};
            return "";
        }

        public function bindText(id:String, value:String)
        {
            if (ASCompat.getDynamicProperty(this._bindings, id)== null) ASCompat.setDynamicProperty(this._bindings, id, {});
ASCompat.getDynamicProperty(            this._bindings, id).text = value;
        }

        public function bindAction(id:String, action:ASFunction, data:ASObject=null)
        {
            if (ASCompat.getDynamicProperty(this._bindings, id)== null) ASCompat.setDynamicProperty(this._bindings, id, {});
ASCompat.getDynamicProperty(            this._bindings, id).action = action;
ASCompat.getDynamicProperty(            this._bindings, id).data = data;
        }

        public function bindInput(id:String, value:String, change:ASFunction)
        {
            if (ASCompat.getDynamicProperty(this._bindings, id)== null) ASCompat.setDynamicProperty(this._bindings, id, {});
ASCompat.getDynamicProperty(            this._bindings, id).text = value;
ASCompat.getDynamicProperty(            this._bindings, id).change = change;
        }

        public function elementById(id:String):ASObject
        {
            var matches:Array<ASAny> = ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._elements, id), Array);
            if (matches == null || matches.length == 0) return null;
            return matches[0];
        }
    }

