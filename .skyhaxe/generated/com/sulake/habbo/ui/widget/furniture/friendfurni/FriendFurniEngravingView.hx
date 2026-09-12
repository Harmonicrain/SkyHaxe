package com.sulake.habbo.ui.widget.furniture.friendfurni
;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.display.Bitmap;
    import com.sulake.core.window.IWindow;
    import flash.errors.IllegalOperationError;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class FriendFurniEngravingView implements IAvatarImageListener implements  IDisposable 
    {
        var _stuffData:StringArrayStuffData;
        var _widget:FriendFurniEngravingWidget;
        var _window:IWindowContainer = null;
        var _disposed:Bool = false;

        public function new(k:FriendFurniEngravingWidget, _arg_2:StringArrayStuffData)
        {
            this._widget = k;
            this._stuffData = _arg_2;
        }

        static function setElementImage(k:IWindow, _arg_2:BitmapData, _arg_3:Int=0, _arg_4:Int=0, _arg_5:Int=0)
        {
            var _local_9:IBitmapWrapperWindow = null;
            var _local_10:IDisplayObjectWrapper = null;
            if (_arg_2 == null)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            if (k.disposed)
            {
                return;
            }
            var _local_6= ((_arg_3 > 0) ? _arg_3 : k.height);
            var _local_7= Std.int(((k.width - _arg_2.width) / 2) + _arg_4);
            var _local_8= Std.int(((_local_6 - _arg_2.height) / 2) + _arg_5);
            if (Std.downcast(k , IBitmapWrapperWindow) != null)
            {
                _local_9 = cast(k, IBitmapWrapperWindow);
                if (((_local_9.bitmap == null) || (_arg_3 > 0)))
                {
                    _local_9.bitmap = new BitmapData(k.width, _local_6, true, 0);
                }
                _local_9.bitmap.fillRect(_local_9.bitmap.rect, 0);
                _local_9.bitmap.copyPixels(_arg_2, _arg_2.rect, new Point(_local_7, _local_8), null, null, false);
                k.invalidate();
            }
            else
            {
                if (Std.downcast(k , IDisplayObjectWrapper) != null)
                {
                    _local_10 = cast(k, IDisplayObjectWrapper);
                    _local_10.setDisplayObject(new Bitmap(_arg_2));
                }
            }
        }


        var stuffData(get,never):StringArrayStuffData;
function  get_stuffData():StringArrayStuffData
        {
            return this._stuffData;
        }

        var widget(get,never):FriendFurniEngravingWidget;
function  get_widget():FriendFurniEngravingWidget
        {
            return this._widget;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                this.destroyWindow();
                this._widget = null;
                this._stuffData = null;
                this._disposed = true;
            }
        }

        public function open()
        {
            this.createWindow();
        }

        public function close()
        {
            this.destroyWindow();
        }

        function assetName():String
        {
            throw new IllegalOperationError("Must implement in concrete view!");
        }

        function createWindow()
        {
            var k:IAvatarImage = null;
            var _local_2:IAvatarImage = null;
            if (this._window == null)
            {
                this._window = cast(this.widget.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(this.widget.assets.getAssetByName(this.assetName()).content)), IWindowContainer);
                this._window.procedure = this._Str_12416;
                this._window.center();
                this._window.findChildByName("name_left").caption = this.stuffData.getValue(1);
                this._window.findChildByName("name_right").caption = this.stuffData.getValue(2);
                this._window.findChildByName("date").caption = this.stuffData.getValue(5);
                k = this.widget._Str_11963.container.avatarRenderManager.createAvatarImage(this.stuffData.getValue(3), AvatarScaleType.LARGE, null, this);
                _local_2 = this.widget._Str_11963.container.avatarRenderManager.createAvatarImage(this.stuffData.getValue(4), AvatarScaleType.LARGE, null, this);
                if (!k.isPlaceholder())
                {
this.setAvatarImage("avatar_left", k.getCroppedImage(AvatarSetType.FULL));
                }
                if (!_local_2.isPlaceholder())
                {
                    _local_2.setDirection(AvatarSetType.FULL, 4);
this.setAvatarImage("avatar_right", _local_2.getCroppedImage(AvatarSetType.FULL));
                }
            }
        }

        public function avatarImageReady(k:String)
        {
            var _local_2:IAvatarImage = null;
            var _local_3:IAvatarImage = null;
            if (k == this.stuffData.getValue(3))
            {
                _local_2 = this.widget._Str_11963.container.avatarRenderManager.createAvatarImage(this.stuffData.getValue(3), AvatarScaleType.LARGE, null, this);
this.setAvatarImage("avatar_left", _local_2.getCroppedImage(AvatarSetType.FULL));
            }
            if (k == this.stuffData.getValue(4))
            {
                _local_3 = this.widget._Str_11963.container.avatarRenderManager.createAvatarImage(this.stuffData.getValue(4), AvatarScaleType.LARGE, null, this);
                _local_3.setDirection(AvatarSetType.FULL, 4);
this.setAvatarImage("avatar_right", _local_3.getCroppedImage(AvatarSetType.FULL));
            }
        }

        function setAvatarImage(k:String, _arg_2:BitmapData)
        {
            var _local_3= cast(this._window.findChildByName(k), IBitmapWrapperWindow);
            setElementImage(_local_3, _arg_2, 0, 0, 0);
        }

        function destroyWindow()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function _Str_12416(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "header_button_close":
                        this.widget.close(this.widget.stuffId);
                        return;
                }
            }
        }
    }

