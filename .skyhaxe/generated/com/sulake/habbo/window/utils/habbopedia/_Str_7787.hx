package com.sulake.habbo.window.utils.habbopedia
;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import flash.text.StyleSheet;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IScrollbarWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.HTMLTextController;
    import com.sulake.core.assets.AssetLoaderStruct;
    import flash.net.URLRequest;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.habbo.utils.HabboWebTools;
    import flash.events.Event;
    import com.sulake.habbo.window.utils.habbopedia.binaryData.*;

     class _Str_7787 implements ILinkEventTracker 
    {
        public static var _Str_18774:Class<Dynamic> = _Str_7787__Str_18774;
        public static var _Str_20822:Class<Dynamic> = _Str_7787__Str_20822;
        public static var _Str_15204:Class<Dynamic> = _Str_7787__Str_15204;
        public static var styleSheet:StyleSheet = _Str_14895();

        var _habboWindowManagerComponent:HabboWindowManagerComponent;
        var _window:IWindowContainer;

        public function new(k:HabboWindowManagerComponent)
        {
            this._habboWindowManagerComponent = k;
            this._habboWindowManagerComponent.context.addLinkEventTracker(this);
            _Str_14895();
        }

        static function _Str_14895():StyleSheet
        {
            var k= new StyleSheet();
            var _local_2= ASCompat.asByteArray(Type.createInstance(_Str_15204, []) );
            var _local_3= _local_2.readUTFBytes(_local_2.length);
            k.parseCSS(_local_3);
            return k;
        }


        
        var visible(get,set):Bool;
function  set_visible(k:Bool):Bool        {
            var _local_2:HTMLTextController = null;
            if (((this._window == null) || this._window.disposed))
            {
                this._window = this.createWindow(_Str_18774, this.windowProcedure);
                _local_2 = Std.downcast(this._window.findChildByName("content") , HTMLTextController);
                _local_2.styleSheet = styleSheet;
                _local_2.textField.mouseWheelEnabled = false;
                _local_2.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this._Str_24991);
                _local_2.addEventListener(WindowMouseEvent.WHEEL, this.onContentWheel);
            }
            return this._window.visible = k;
        }

        function _Str_24991(k:WindowEvent)
        {
            Std.downcast(this._window.findChildByName("scroller") , IScrollbarWindow).scrollV = 0;
        }
function  get_visible():Bool
        {
            return (!(this._window == null)) && this._window.visible;
        }

        function createWindow(k:Class<Dynamic>, _arg_2:ASFunction):IWindowContainer
        {
            var _local_3= ASCompat.asByteArray(Type.createInstance(k, []) );
            var _local_4= new com.sulake.core.utils.xml.XML(_local_3.readUTFBytes(_local_3.length));
            var _local_5= Std.downcast(this._habboWindowManagerComponent.buildFromXML(_local_4) , IWindowContainer);
            _local_5.procedure = _arg_2;
            return _local_5;
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close":
                    this.visible = false;
                    return;
                case "close":
                    this._window.visible = false;
                    return;
            }
        }

        function onContentWheel(k:WindowMouseEvent)
        {
            var _local_2:IScrollbarWindow = null;
            if (((this._window == null) || this._window.disposed))
            {
                return;
            }
            _local_2 = Std.downcast(this._window.findChildByName("scroller") , IScrollbarWindow);
            if (((!(_local_2 == null)) && _local_2.scrollWithWheel(k.delta)))
            {
                k.stopPropagation();
            }
        }

        function _Str_22427(k:String, _arg_2:String)
        {
            this._window.caption = _arg_2;
            Std.downcast(this._window.findChildByName("content") , HTMLTextController).htmlText = k;
            Std.downcast(this._window.findChildByName("content") , ITextWindow).styleSheet = styleSheet;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._habboWindowManagerComponent = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._habboWindowManagerComponent == null;
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "habbopages/";
        }

        public function linkReceived(link:String)
        {
            var _local_2:Array<ASAny> = (cast link.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            _local_2.shift();
            var _local_3= _local_2.join("/");
            this.openPage(_local_3);
        }

        public function openPage(k:String)
        {
            var _local_5:AssetLoaderStruct = null;
            var _local_2= this._habboWindowManagerComponent.getProperty("habbopages.url");
            var _local_3= (_local_2 + k);
            if (this._habboWindowManagerComponent.assets.hasAsset(_local_3))
            {
                Logger.log([("[HabboPagesViewer] reload page: " + _local_3)]);
                this._habboWindowManagerComponent.assets.removeAsset(this._habboWindowManagerComponent.assets.getAssetByName(_local_3));
            }
            var _local_4= new URLRequest((_local_2 + k));
            _local_5 = this._habboWindowManagerComponent.assets.loadAssetFromFile(_local_3, _local_4, "text/plain");
            _local_5.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_22570);
            _local_5.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this._Str_22726);
        }

        function _Str_22726(k:Event=null)
        {
            var _local_2= Std.downcast(k , AssetLoaderEvent);
            var _local_3 = 0;
            if (_local_2 != null)
            {
                _local_3 = _local_2.status;
            }
            HabboWebTools.logEventLog(("habbopages download error " + Std.string(_local_3)));
        }

        function _Str_22570(k:Event=null)
        {
            var _local_5:Array<ASAny> = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= new compat.RegExp("\\n\\r|\\n|\\r", "mg");
            var _local_4= ASCompat.asString(_local_2.assetLoader.content );
            if (_local_4 != null)
            {
                _local_5 = (cast _local_3.split(_local_4));
                _local_6 = _local_5.shift();
                _local_7 = _local_5.join("");
                this.visible = true;
                this._Str_22427(_local_7, _local_6);
                this._window.activate();
            }
        }
    }

