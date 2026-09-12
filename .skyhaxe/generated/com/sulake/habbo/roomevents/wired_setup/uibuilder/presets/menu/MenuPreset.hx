package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.elements.MenuItem;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.elements.MenuSpacer;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.views.MenuItemView;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.geom.Point;

     class MenuPreset extends WiredUIPreset
    {
        public static final SPACER:MenuSpacer = new MenuSpacer();

        var _container:IWindowContainer;
        var _menuItemTemplate:IRegionWindow;
        var _spacerTemplate:IWindow;
        var _items:Vector<MenuItemView>;
        var _anchor:IWindow;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle, elements:Array<ASAny>, anchor:IWindow)
        {
var element:ASAny  = null, itemView:MenuItemView  = null;            super(roomEvents, presetManager, style);
            this._anchor = anchor;
            this._container = style.createQuickMenu();
            var list= this.menuList;
            var widthPadding= this._container.width - list.width;
            var heightPadding= this._container.height - list.height;
            this._menuItemTemplate = Std.downcast(list.removeListItem(list.getListItemByName("menu_item_template")) , IRegionWindow);
            this._spacerTemplate = list.removeListItem(list.getListItemByName("spacer_template"));
            this._items = new Vector<MenuItemView>();
            var requestedWidth= 0;
            if (checkNullIteratee(elements)) for (_tmp_ in elements)
            {
element = _tmp_;
                if (Std.is(element , MenuItem))
                {
itemView= new MenuItemView(this, ASCompat.dynamicAs(element , MenuItem));
                    this._items.push(itemView);
                    list.addListItem(itemView.window);
                    requestedWidth = Std.int(Math.max(requestedWidth, itemView.requestedMinWidth));
                }
                else if (Std.is(element , MenuSpacer))
                {
                    list.addListItem(this._spacerTemplate.clone());
                }
            }
            this._container.width = requestedWidth + widthPadding + style.menuRightOffset;
            this._container.height = list.height + heightPadding;
            this._container.addEventListener(WindowEvent.WINDOW_EVENT_DEACTIVATED, this.onDeactivate);
        }

        function onDeactivate(event:WindowEvent) { this.requestClose(); }

        public function requestOpen()
        {
            var desktop= this._roomEvents.windowManager.getDesktop(1);
            if (desktop != null) { desktop.addChild(this._container); }
            var point= new Point();
            this._anchor.getGlobalPosition(point);
            this._container.x = Std.int(point.x);
            this._container.y = Std.int(point.y + this._anchor.height);
            this._container.visible = true;
            this._container.activate();
        }

        public function requestClose()
        {
            var desktop= this._roomEvents.windowManager.getDesktop(1);
            if (desktop != null && (this._container.parent : ASAny) == (desktop : ASAny)) { desktop.removeChild(this._container); }
        }

        public function setSelected(index:Int, value:Bool) { this._items[index].selected = value; }
        public function getSelected(index:Int):Bool { return this._items[index].selected; }
        public function setDisabled(index:Int, value:Bool) { this._items[index].disabled = value; }
        public function getDisabled(index:Int):Bool { return this._items[index].disabled; }
        override public function  get_window():IWindow { return this._container; }
        override function  get_childPresets():Array<ASAny> { return []; }
        public var menuItemTemplate(get,never):IRegionWindow;
public function  get_menuItemTemplate():IRegionWindow { return this._menuItemTemplate; }
        var menuList(get,never):IItemListWindow;
function  get_menuList():IItemListWindow { return Std.downcast(this._container.findChildByName("menu_list") , IItemListWindow); }

        override public function dispose()
        {
var item:MenuItemView  = null;            if (disposed) { return; }
            this.requestClose();
            final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) { item = _tmp_;
item.dispose(); }
            this._items = null;
            this._container.dispose();
            this._container = null;
            this._menuItemTemplate.dispose();
            this._menuItemTemplate = null;
            this._spacerTemplate.dispose();
            this._spacerTemplate = null;
            this._anchor = null;
            super.dispose();
        }
    }

