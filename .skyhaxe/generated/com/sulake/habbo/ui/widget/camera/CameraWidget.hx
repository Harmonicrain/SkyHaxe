package com.sulake.habbo.ui.widget.camera
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.ui.RoomUI;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.handler.CameraWidgetHandler;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.utils.ErrorReportStorage;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import com.sulake.habbo.sound.HabboSoundTypesEnum;
    import flash.geom.Rectangle;
    import com.sulake.habbo.communication.messages.incoming.camera.CameraPublishStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.camera.CompetitionStatusMessageEvent;

     class CameraWidget extends RoomWidgetBase
    {
        var _component:RoomUI;
        var _viewFinder:CameraViewFinder;
        var _photoLab:CameraPhotoLab;
        public var url:String;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboConfigurationManager, _arg_5:IHabboLocalizationManager, _arg_6:RoomUI)
        {
            super(k, _arg_2, _arg_3, _arg_5);
            this._component = _arg_6;
            this.handler.widget = this;
            this._viewFinder = new CameraViewFinder(this);
            if (this.roomEngine != null)
            {
                this.roomEngine.events.addEventListener(RoomEngineEvent.DISPOSED, this.onRoomDisposed);
                this.roomEngine.events.addEventListener(RoomEngineEvent.ROOM_ZOOMED, this.onRoomZoomed);
            }
            this.handler.sendInitCameraMessage();
            var _local_7= this.handler.roomDesktop.questEngine;
            if (_local_7 != null)
            {
                _local_7.ensureAchievementsInitialized();
            }
        }

        public var photoLab(get,never):CameraPhotoLab;
public function  get_photoLab():CameraPhotoLab
        {
            return this._photoLab;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._component.catalog;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            if (this._viewFinder != null)
            {
                this._viewFinder.dispose();
                this._viewFinder = null;
            }
            if (this._photoLab != null)
            {
                this._photoLab.dispose();
                this._photoLab = null;
            }
            super.dispose();
        }

        public var container(get,never):IRoomWidgetHandlerContainer;
public function  get_container():IRoomWidgetHandlerContainer
        {
            return (this.handler != null) ? this.handler.container : null;
        }

        public var handler(get,never):CameraWidgetHandler;
public function  get_handler():CameraWidgetHandler
        {
            return Std.downcast(_handler , CameraWidgetHandler);
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return (this.container != null) ? this.container.roomEngine : null;
        }

        public function startTakingPhoto(k:String)
        {
            if (((this.roomEngine != null) && (!(this.roomEngine.getRoomCanvasScale() == 1))))
            {
                windowManager.alert(_localizations.getLocalization("camera.zoom.missing.header"), _localizations.getLocalization("camera.zoom.missing.body"), 0, null);
                return;
            }
            if (this.component.getProperty("camera.effects.enabled") == "true")
            {
                CameraPhotoLab._Str_23652(this._component.context.configuration.getProperty("image.library.url"), this._component.getProperty("camera.available.effects"), _localizations);
            }
            if (this._photoLab != null)
            {
                this._photoLab.dispose();
            }
            this._viewFinder._Str_22715(k);
        }

        public var component(get,never):RoomUI;
public function  get_component():RoomUI
        {
            return this._component;
        }

        public function getXmlWindow(name:String, layer:UInt=1):IWindow
        {
            var asset:IAsset = null;
            var xmlAsset:XmlAsset = null;
            var window:IWindow = null;
            try
            {
                asset = assets.getAssetByName((name + "_xml"));
                xmlAsset = cast(asset, XmlAsset);
                window = windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(xmlAsset.content), layer);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("HabboNavigator", (((((("Failed to build window " + name) + "_xml, ") + asset) + ", ") + windowManager) + "!"));
                throw e;
            }
 }            return window;
        }

        function onRoomDisposed(k:RoomEngineEvent)
        {
            this.hide();
        }

        function onRoomZoomed(k:RoomEngineEvent)
        {
            if (((this.roomEngine != null) && (!(this.roomEngine.getRoomCanvasScale() == 1))))
            {
                this.hide();
            }
        }

        function hide()
        {
            if (this._viewFinder != null)
            {
                this._viewFinder.hide();
            }
            if (this._photoLab != null)
            {
                this._photoLab.dispose();
            }
        }

        public function _Str_23027(k:BitmapData, _arg_2:Matrix, _arg_3:Bool):Bool
        {
            var _local_4= this.container.roomSession;
            return this.roomEngine.snapshotRoomCanvasToBitmap(_local_4.roomId, this.container.getFirstCanvasId(), k, _arg_2, _arg_3);
        }

        public function _Str_23751()
        {
            this.container.soundManager.playSound(HabboSoundTypesEnum.CAMERA_SHUTTER);
        }

        public function _Str_24657(k:BitmapData)
        {
            this._photoLab = new CameraPhotoLab(this);
            this._photoLab._Str_23895(k);
        }
        
        public function _Str_25345(k:String, _arg_2:Bool=false)
        {
            if (this._photoLab != null)
            {
                this._photoLab._Str_19577(k);
                if (_arg_2)
                {
                    this._photoLab.show();
                    this._photoLab._Str_23866();
                }
            }
        }

        public function _Str_14786():Rectangle
        {
            if (this._viewFinder != null)
            {
                return this._viewFinder._Str_14786();
            }
            return new Rectangle(0, 0, 0, 0);
        }

        public function _Str_25644()
        {
            if (this._photoLab != null)
            {
                this._photoLab._Str_22386();
            }
        }

        public function _Str_16763(k:String)
        {
            if (this._photoLab != null)
            {
                this._photoLab._Str_16763(k);
            }
        }

        public function _Str_12205(k:CameraPublishStatusMessageEvent)
        {
            if (this._photoLab != null)
            {
                this._photoLab._Str_12205(k);
            }
        }

        public function competitionStatus(k:CompetitionStatusMessageEvent)
        {
            if (this._photoLab != null)
            {
                this._photoLab.competitionStatus(k);
            }
        }

        public function sendPhotoData():Bool
        {
            var k= this._viewFinder.getRenderRoomMessage();
            if (this._photoLab != null)
            {
                k.addEffectData(this._photoLab._Str_22711());
                k.setZoom(this._photoLab._Str_25820());
            }
            k.compressData();
            if (k.isSendable())
            {
                this.handler.sendPhotoData(k);
                return true;
            }
            return false;
        }
    }

