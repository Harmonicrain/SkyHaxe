package com.sulake.habbo.snowstorm
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.ui.IRoomUI;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.geom.Rectangle;

    /** SnowStorm-owned root over the room; it never hides or resizes the hotel canvas. */
     final class SnowStormWindowHost
    {
        var _windowManager:IHabboWindowManager;
        var _roomUI:IRoomUI;
        var _root:IWindowContainer;

        public function new(windowManager:IHabboWindowManager, roomUI:IRoomUI)
        { this._windowManager = windowManager; this._roomUI = roomUI; }
        public var root(get,never):IWindowContainer;
public function  get_root():IWindowContainer { return this._root; }
        public var created(get,never):Bool;
public function  get_created():Bool { return this._root != null; }
        public var width(get,never):Int;
public function  get_width():Int { return this._root == null ? 0 : this._root.width; }
        public var height(get,never):Int;
public function  get_height():Int { return this._root == null ? 0 : this._root.height; }

        public function ensureRoot():IWindowContainer
        {
            if (this._root == null && this._windowManager != null)
            {
                this._root = Std.downcast(this._windowManager.createWindow("snowstorm_root", "",
                    WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT,
                    WindowParam.WINDOW_PARAM_NULL, new Rectangle(0, 0, 10, 10)) , IWindowContainer);
                this.resize();
            }
            return this._root;
        }

        public function resize()
        {
            if (this._root == null || this._root.desktop == null) return;
            var bounds:Rectangle = this._roomUI == null ? null : this._roomUI.getRoomViewRect();
            if (bounds == null || bounds.width <= 0 || bounds.height <= 0)
                bounds = new Rectangle(0, 0, this._root.desktop.width, this._root.desktop.height);
            this._root.x = Std.int(bounds.x); this._root.y = Std.int(bounds.y);
            this._root.width = Std.int(bounds.width); this._root.height = Std.int(bounds.height);
        }

        public function adopt(window:IWindow)
        { if (this.ensureRoot() != null && window != null) this._root.addChild(window); }
        public function bringToFront(window:IWindow)
        { if (this._root != null && window != null && this._root.numChildren > 0) this._root.setChildIndex(window, this._root.numChildren - 1); }
        public function bringHostToFront()
        {
            if (this._root == null) return;
            var parent= Std.downcast(this._root.parent , IWindowContainer);
            if (parent != null && parent.numChildren > 0) parent.setChildIndex(this._root, parent.numChildren - 1);
        }
        public function dispose()
        { if (this._root != null) this._root.dispose(); this._root = null; this._windowManager = null; this._roomUI = null; }
    }

