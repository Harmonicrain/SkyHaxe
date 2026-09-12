package com.sulake.habbo.ui.widget.furniture.gamehall
;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.display.Sprite;
    import flash.geom.Rectangle;

     class GamehallBoardWindow
    {
        static inline final WINDOW_WIDTH= 292;
        static inline final WINDOW_HEIGHT= 304;
        static inline final CANVAS_X= 5;
        static inline final CANVAS_Y= 5;
        static inline final SCREEN_WIDTH= 270;
        static inline final SCREEN_HEIGHT= 264;

        static inline final BOARD_XML_ASSET= "gamehall_board_xml";
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _root:IWindowContainer;
        var _frame:IWindowContainer;
        var _canvas:IDisplayObjectWrapper;
        var _panel:Sprite;

        public function new(windowManager:IHabboWindowManager, assets:IAssetLibrary)
        {
            this._windowManager = windowManager;
            this._assets = assets;
            this._root = cast(windowManager.createWindow("gamehall_desktop_root", "", WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_NULL, new Rectangle(0, 0, 10, 10)), IWindowContainer);
            this.resizeRoot();
            this._root.addEventListener(WindowEvent.WINDOW_EVENT_PARENT_RESIZED, this.onRootResized);
        }

        public var root(get,never):IWindowContainer;
public function  get_root():IWindowContainer
        {
            return this._root;
        }

        public var frame(get,never):IWindowContainer;
public function  get_frame():IWindowContainer
        {
            return this._frame;
        }

        public var panel(get,never):Sprite;
public function  get_panel():Sprite
        {
            return this._panel;
        }

        public function create(title:String, procedure:ASFunction):Sprite
        {
            GamehallFonts.registerVolter();
            if (this._frame != null)
            {
                this._frame.visible = true;
                this._frame.caption = title;
                this._frame.procedure = procedure;
                this.center();
                this.activate();
                return this._panel;
            }
            var built:IWindow = null;
            try
            {
                built = this.buildFromXmlAsset();
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                built = null;
            }
 }            this._frame = Std.downcast(built , IWindowContainer);
            if (this._frame == null)
            {
                this._frame = cast(this._windowManager.createWindow("gamehall_frame", title, WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, new Rectangle(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)), IWindowContainer);
            }
            this._frame.caption = title;
            this._frame.color = 4296112;
            this._frame.procedure = procedure;
            this._root.addChild(this._frame);
            this._canvas = Std.downcast(this._frame.findChildByName("gamehall_canvas") , IDisplayObjectWrapper);
            if (this._canvas == null)
            {
                this._canvas = cast(this._windowManager.createWindow("gamehall_canvas", "", WindowType.WINDOW_TYPE_DISPLAY_OBJECT_WRAPPER, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, new Rectangle(CANVAS_X, CANVAS_Y, SCREEN_WIDTH, SCREEN_HEIGHT)), IDisplayObjectWrapper);
                this._frame.addChild(this._canvas);
            }
            this._panel = new Sprite();
            this._canvas.setDisplayObject(this._panel);
            this.center();
            this.activate();
            return this._panel;
        }

        public function destroyFrame()
        {
            if (this._frame == null)
            {
                return;
            }
            this._frame.procedure = null;
            this._root.removeChild(this._frame);
            this._frame.dispose();
            this._frame = null;
            this._canvas = null;
            this._panel = null;
        }

        public function setTextVisible(name:String, visible:Bool)
        {
            if (this._frame == null)
            {
                return;
            }
            var window= this._frame.findChildByName(name);
            if (window != null)
            {
                window.visible = visible;
            }
        }

        public function setCaption(name:String, caption:String)
        {
            if (this._frame == null)
            {
                return;
            }
            var window= this._frame.findChildByName(name);
            if (window != null)
            {
                window.caption = caption == null ? "" : caption;
            }
        }

        public function setFrameCaption(caption:String)
        {
            if (this._frame != null)
            {
                this._frame.caption = caption;
            }
        }

        public function activate()
        {
            if (this._root != null)
            {
                this._root.activate();
            }
            if (this._frame != null)
            {
                this._frame.activate();
            }
        }

        public function dispose()
        {
            this.destroyFrame();
            if (this._root != null)
            {
                this._root.removeEventListener(WindowEvent.WINDOW_EVENT_PARENT_RESIZED, this.onRootResized);
                this._root.dispose();
                this._root = null;
            }
            this._windowManager = null;
            this._assets = null;
        }

        function buildFromXmlAsset():IWindow
        {
var asset:IAsset  = null;            var xml:com.sulake.core.utils.xml.XML = null;
            if (this._assets != null)
            {
asset= this._assets.getAssetByName(BOARD_XML_ASSET);
                if (asset != null && asset.content != null)
                {
                    xml = new com.sulake.core.utils.xml.XML(asset.content);
                }
            }
            if (xml == null)
            {
                return null;
            }
            return this._windowManager.buildFromXML(xml);
        }

        function onRootResized(event:WindowEvent)
        {
            if (this._frame != null)
            {
                this.center();
            }
        }

        function resizeRoot()
        {
            if (this._root != null && this._root.desktop != null)
            {
                this._root.width = this._root.desktop.width;
                this._root.height = this._root.desktop.height;
            }
        }

        function center()
        {
            this.resizeRoot();
            if (this._root.width < WINDOW_WIDTH)
            {
                this._root.width = WINDOW_WIDTH;
            }
            if (this._root.height < WINDOW_HEIGHT)
            {
                this._root.height = WINDOW_HEIGHT;
            }
            this._frame.x = Std.int((this._root.width - WINDOW_WIDTH) / 2);
            this._frame.y = Std.int((this._root.height - WINDOW_HEIGHT) / 2);
        }
    }

