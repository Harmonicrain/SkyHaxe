package com.sulake.habbo.gamecenter
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import flash.display.Loader;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.XmlAsset;
    import flash.system.Security;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.display.LoaderInfo;

     class TeaserView implements IDisposable 
    {
        static inline final GAME_CENTER_TEASER_VIEW_XML= "game_center_teaser_view_xml";

        var _disposed:Bool = false;
        var _gameCenterView:GameCenterView;
        var _teaserDialog:IModalDialog;
        var _teaserWindow:IWindowContainer;
        var _teaserWrapper:IDisplayObjectWrapper;
        var _teaserPlayer:ASObject;
        var _selectedGame:Int = 0;

        public function new(k:GameCenterView)
        {
            this._gameCenterView = k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            this.disable();
            this._gameCenterView = null;
            this._disposed = true;
        }

        public function activate(k:Int)
        {
            this._selectedGame = k;
            if (this._teaserDialog == null)
            {
                this.createWindow();
            }
            this._teaserWindow.invalidate();
            this._teaserWindow.visible = true;
            this.updateLayout();
        }

        public function disable()
        {
            var k:Loader = null;
            if (this._teaserWrapper != null)
            {
                if (this._teaserPlayer)
                {
                    this._teaserPlayer.destroy();
                    this._teaserPlayer = null;
                }
                k = Std.downcast(this._teaserWrapper.getDisplayObject() , Loader);
                if (k != null)
                {
                    k.unloadAndStop();
                }
                this._teaserWrapper = null;
            }
            if (this._teaserDialog != null)
            {
                this._teaserDialog.dispose();
                this._teaserDialog = null;
            }
            this._teaserWindow = null;
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this.disable();
        }

        function createWindow()
        {
            var k= this._gameCenterView.assets.getAssetByName(GAME_CENTER_TEASER_VIEW_XML);
            var _local_2= cast(k, XmlAsset);
            this._teaserDialog = this._gameCenterView.windowManager.buildModalDialogFromXML(new com.sulake.core.utils.xml.XML(_local_2.content));
            this._teaserWindow = Std.downcast(this._teaserDialog.rootWindow , IWindowContainer);
            this._teaserWindow.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            this._teaserWrapper = Std.downcast(this._teaserWindow.findChildByName("teaser_wrapper") , IDisplayObjectWrapper);
            this._Str_23580();
        }

        function _Str_23580()
        {
            Security.allowDomain(["www.youtube.com"]);
            var k= new Loader();
            k.load(new URLRequest((("http://www.youtube.com/v/" + this._Str_20439()) + "?version=3&autoplay=1")));
            k.contentLoaderInfo.addEventListener(Event.INIT, (this._Str_24395 : ASAny));
            k.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, (this._Str_22482 : ASAny));
        }

        function updateLayout()
        {
            this._gameCenterView.registerParameter(this._selectedGame, "gamecenter.teaser_title");
        }

        function _Str_24395(k:Event)
        {
            var _local_3:Loader = null;
            var _local_2= ASCompat.dynamicAs(k.target , LoaderInfo);
            if (_local_2 != null)
            {
                _local_3 = _local_2.loader;
                this._teaserWrapper.setDisplayObject(_local_3);
                _local_3.content.addEventListener("onReady", (this._Str_16623 : ASAny));
            }
        }

        function _Str_20439():String
        {
            return this._gameCenterView.gameManager.getProperty(("gamecenter.teaser." + GameConfigurations.getNameId(this._selectedGame)));
        }

        function _Str_22482(k:IOErrorEvent)
        {
            var _local_2:String = null;
            if (((this._gameCenterView.gameManager != null) && (this._gameCenterView.gameManager.context != null)))
            {
                _local_2 = ((("Failed to load teaser " + this._Str_20439()) + " for game ") + GameConfigurations.getNameId(this._selectedGame));
                this._gameCenterView.gameManager.context.error(_local_2, false, k.errorID);
            }
        }

        function _Str_16623(k:Event)
        {
            this._teaserPlayer = k.target;
            this._teaserPlayer.setSize(this._teaserWrapper.width, this._teaserWrapper.height);
        }
    }

