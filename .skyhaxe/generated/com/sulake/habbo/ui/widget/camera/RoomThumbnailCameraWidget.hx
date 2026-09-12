package com.sulake.habbo.ui.widget.camera
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.ui.RoomUI;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.handler.RoomThumbnailCameraWidgetHandler;
    import com.sulake.habbo.room.IRoomEngine;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import com.sulake.habbo.session.IRoomSession;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import com.sulake.habbo.sound.HabboSoundTypesEnum;
    import com.sulake.habbo.communication.messages.outgoing.camera.RenderRoomThumbnailMessageComposer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class RoomThumbnailCameraWidget extends RoomWidgetBase implements IUpdateReceiver implements  ILinkEventTracker
    {
        var _component:RoomUI;
        var _window:IFrameWindow = null;
        var _imageWindow:IBitmapWrapperWindow;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboConfigurationManager, _arg_5:IHabboLocalizationManager, _arg_6:RoomUI)
        {
            super(k, _arg_2, _arg_3, _arg_5);
            this._component = _arg_6;
            this.handler.widget = this;
            if (this.roomEngine != null)
            {
                this.roomEngine.events.addEventListener(RoomEngineEvent.DISPOSED, this.onRoomDisposed);
                this.roomEngine.events.addEventListener(RoomEngineEvent.ROOM_ZOOMED, this.onRoomZoomed);
            }
            ASCompat.reinterpretAs(_arg_2 , Component).context.addLinkEventTracker(this);
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            ASCompat.reinterpretAs(windowManager , Component).context.removeLinkEventTracker(this);
            super.dispose();
        }

        public var container(get,never):IRoomWidgetHandlerContainer;
public function  get_container():IRoomWidgetHandlerContainer
        {
            return (this.handler != null) ? this.handler.container : null;
        }

        public var handler(get,never):RoomThumbnailCameraWidgetHandler;
public function  get_handler():RoomThumbnailCameraWidgetHandler
        {
            return Std.downcast(_handler , RoomThumbnailCameraWidgetHandler);
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return (this.container != null) ? this.container.roomEngine : null;
        }

        public function update(k:UInt)
        {
            var _local_2:Point = null;
            var _local_3:Matrix = null;
            var _local_4:IRoomSession = null;
            if (((this._window != null) && (this._imageWindow != null)))
            {
                if (this._imageWindow.bitmap == null)
                {
                    this._imageWindow.bitmap = new BitmapData(this._imageWindow.width, this._imageWindow.height, false, 0);
                }
                this._imageWindow.bitmap.fillRect(this._imageWindow.bitmap.rect, this.handler._Str_6647.roomBackgroundColor);
                _local_2 = new Point(0, 0);
                this._imageWindow.getGlobalPosition(_local_2);
                _local_3 = new Matrix();
                _local_3.translate(-_local_2.x, -_local_2.y);
                _local_4 = this.container.roomSession;
                this.roomEngine.snapshotRoomCanvasToBitmap(_local_4.roomId, this.container.getFirstCanvasId(), this._imageWindow.bitmap, _local_3, false);
                this._imageWindow.invalidate();
            }
        }

        public function startTakingPhoto()
        {
            if (((this.roomEngine != null) && (!(this.roomEngine.getRoomCanvasScale() == 1))))
            {
                windowManager.alert("Camera only works on normal zoom!", "Return to normal zoom level and try again!", 0, null);
                return;
            }
            if (this._window == null)
            {
                this.createWindow();
            }
        }

        function createWindow()
        {
            if (this._window != null)
            {
                this.destroy();
            }
            this._window = cast(windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(this._component.assets.getAssetByName("iro_room_thumbnail_camera_xml").content)), IFrameWindow);
            this._imageWindow = cast(this._window.findChildByName("viewfinder"), IBitmapWrapperWindow);
            this._window.procedure = this.windowProcedure;
            this._window.center();
            this._component.registerUpdateReceiver(this, 10);
        }

        public function destroy()
        {
            if (this._window != null)
            {
                this._window.destroy();
                this._window = null;
                this._component.removeUpdateReceiver(this);
            }
        }

        public var viewPort(get,never):Rectangle;
public function  get_viewPort():Rectangle
        {
            var k= new Point(0, 0);
            this._imageWindow.getGlobalPosition(k);
            return new Rectangle(k.x, k.y, this._imageWindow.width, this._imageWindow.height);
        }

        function onRoomDisposed(k:RoomEngineEvent)
        {
            this.destroy();
        }

        function onRoomZoomed(k:RoomEngineEvent)
        {
            if (((this.roomEngine != null) && (!(this.roomEngine.getRoomCanvasScale() == 1))))
            {
                this.destroy();
            }
        }

        public function triggerCameraShutterSound()
        {
            this.container.soundManager.playSound(HabboSoundTypesEnum.CAMERA_SHUTTER);
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:RenderRoomThumbnailMessageComposer = null;
            var _local_3= Std.downcast(k , WindowMouseEvent);
            if (((_local_3 != null) && (_local_3.type == WindowMouseEvent.CLICK)))
            {
                switch (_arg_2.name)
                {
                    case "button_capture":
                        this.triggerCameraShutterSound();
                        _local_4 = this.handler.collectPhotoData();
                        if (_local_4 == null)
                        {
                            return;
                        }
                        if (_local_4.isSendable())
                        {
                            this.handler.sendPhotoData(_local_4);
                            this._window.findChildByName("button_capture").disable();
                            this._window.findChildByName("button_cancel").disable();
                            this._component.removeUpdateReceiver(this);
                        }
                        else
                        {
                            windowManager.alert("${generic.alert.title}", "${camera.alert.too_much_stuff}", 0, null);
                        }
                        return;
                    case "header_button_close"
                       | "button_cancel":
                        this.destroy();
                        return;
                }
            }
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "roomThumbnailCamera";
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = (cast k.split("/"));
            var _local_3= _local_2.length;
            if (_local_3 < 2)
            {
                return;
            }
            if (_local_2[1] == "open")
            {
                this.startTakingPhoto();
            }
        }
    }

