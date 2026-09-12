package com.sulake.habbo.battleball
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.ui.IRoomUI;
    import com.sulake.habbo.window.IHabboWindowManager;

    import flash.geom.Rectangle;

    /**
     * The container both BattleBall windows live in.
     *
     * The arena and the lobby are siblings, not parent and child: whichever opens first creates the
     * root, and both need it for sizing, positioning and z-order. Holding it in either window would
     * force the other to reach across -- the lobby would need an arena reference merely to raise the
     * final standings above it -- so it lives here and neither window knows about the other.
     *
     * The host deliberately does NOT touch arena or lobby internals. It sizes the root, reports its
     * bounds, and orders children. Each window re-lays itself out against bounds() after a change.
     */
     class BattleBallWindowHost
    {
        var _windowManager:IHabboWindowManager;
        var _roomUI:IRoomUI;
        var _root:IWindowContainer;

        public function new(windowManager:IHabboWindowManager, roomUI:IRoomUI)
        {
            this._windowManager = windowManager;
            this._roomUI = roomUI;
        }

        /** The shared root, created on first use. Null once disposed. */
        public var root(get,never):IWindowContainer;
public function  get_root():IWindowContainer
        {
            return this._root;
        }

        public var created(get,never):Bool;
public function  get_created():Bool
        {
            return this._root != null;
        }

        /**
         * Create the root if it does not exist yet, and size it to the room view.
         *
         * Both entry points used to carry their own copy of this, which is how the root ended up
         * owned by neither window.
         */
        public function ensureRoot():IWindowContainer
        {
            if (this._root == null && this._windowManager != null)
            {
                this._root = cast(this._windowManager.createWindow("battleball_root", "",
                    WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT,
                    WindowParam.WINDOW_PARAM_NULL, new Rectangle(0, 0, 10, 10)), IWindowContainer);
                this.resize();
            }
            return this._root;
        }

        /**
         * Size the root to the room view, falling back to the desktop.
         *
         * Sizes the root and nothing else. Children re-read bounds() and lay themselves out.
         */
        public function resize()
        {
            if (this._root == null || this._root.desktop == null) return;
            var rect:Rectangle = this._roomUI == null ? null : this._roomUI.getRoomViewRect();
            if (rect == null || rect.width <= 0 || rect.height <= 0)
                rect = new Rectangle(0, 0, this._root.desktop.width, this._root.desktop.height);
            this._root.x = Std.int(rect.x);
            this._root.y = Std.int(rect.y);
            this._root.width = Std.int(rect.width);
            this._root.height = Std.int(rect.height);
        }

        /** Current root bounds, in root-local coordinates. */
        public function bounds():Rectangle
        {
            if (this._root == null) return new Rectangle(0, 0, 0, 0);
            return new Rectangle(0, 0, this._root.width, this._root.height);
        }

        public var width(get,never):Int;
public function  get_width():Int
        {
            return this._root == null ? 0 : this._root.width;
        }

        public var height(get,never):Int;
public function  get_height():Int
        {
            return this._root == null ? 0 : this._root.height;
        }

        public function adopt(window:IWindow)
        {
            if (this._root == null || window == null) return;
            this._root.addChild(window);
        }

        /** Raise one of the host's own children above its siblings. */
        public function bringToFront(window:IWindow)
        {
            if (this._root == null || window == null || this._root.numChildren == 0) return;
            this._root.setChildIndex(window, this._root.numChildren - 1);
        }

        /** Raise the whole host above the other windows sharing its parent. */
        public function bringHostToFront()
        {
            if (this._root == null) return;
            var parent= Std.downcast(this._root.parent , IWindowContainer);
            if (parent == null || parent.numChildren == 0) return;
            parent.setChildIndex(this._root, parent.numChildren - 1);
        }

        public function dispose()
        {
            if (this._root != null) { this._root.dispose(); this._root = null; }
            this._windowManager = null;
            this._roomUI = null;
        }
    }

