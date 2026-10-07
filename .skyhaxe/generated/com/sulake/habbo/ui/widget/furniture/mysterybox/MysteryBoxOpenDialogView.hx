package com.sulake.habbo.ui.widget.furniture.mysterybox
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.ui.widget.furniture.contextmenu.FurnitureContextMenuWidget;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.communication.messages.incoming.mysterybox._Str_7564;
    import com.sulake.habbo.communication.messages.incoming.mysterybox._Str_7433;
    import com.sulake.habbo.communication.messages.incoming.mysterybox.GotMysteryBoxPrizeMessageEvent;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.mysterybox.MysteryBoxWaitingCanceledMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.UseFurnitureMessageComposer;
    import com.sulake.core.communication.connection.IConnection;

     class MysteryBoxOpenDialogView implements IDisposable implements  IGetImageListener 
    {
        var _disposed:Bool = false;
        var _widget:FurnitureContextMenuWidget;
        var _dialog:IModalDialog;
        var _window:IWindowContainer;
        var _object:IRoomObject;
        var _showMysteryBoxWaitMessageEvent:_Str_7564;
        var _cancelMysteryBoxWaitMessageEvent:_Str_7433;
        var _gotMysteryBoxPrizeMessageEvent:GotMysteryBoxPrizeMessageEvent;
        var _imageId:Int = -1;

        public function new(k:FurnitureContextMenuWidget)
        {
            this._widget = k;
            this._showMysteryBoxWaitMessageEvent = new _Str_7564(this._Str_25289);
            this._cancelMysteryBoxWaitMessageEvent = new _Str_7433(this._Str_24696);
            this._gotMysteryBoxPrizeMessageEvent = new GotMysteryBoxPrizeMessageEvent(this._Str_22645);
            this.connection.addMessageEvent(this._showMysteryBoxWaitMessageEvent);
            this.connection.addMessageEvent(this._cancelMysteryBoxWaitMessageEvent);
            this.connection.addMessageEvent(this._gotMysteryBoxPrizeMessageEvent);
        }

        function _Str_25289(k:_Str_7564)
        {
            this._Str_25850();
        }

        function _Str_24696(k:_Str_7433)
        {
            this.closeWindow();
        }

        function _Str_22645(k:GotMysteryBoxPrizeMessageEvent)
        {
            var _local_2= k.getParser();
            this._Str_22444(_local_2.contentType, _local_2.classId);
        }

        function _Str_25850()
        {
            this.closeWindow();
            var k= ((this._widget.assets.getAssetByName("mystery_box_open_dialog").content : com.sulake.core.utils.xml.XML) );
            this._dialog = this._widget.handler.container.windowManager.buildModalDialogFromXML(k);
            this._window = Std.downcast(this._dialog.rootWindow , IWindowContainer);
            this._window.procedure = this._Str_25449;
            var _local_2= this._widget.handler.container.isOwnerOfFurniture(this._object);
            var _local_3= (_local_2 ? "mysterybox.dialog.owner." : "mysterybox.dialog.other.");
            this._window.caption = (("${" + _local_3) + "title}");
            this._window.findChildByName("subtitle_text").caption = (("${" + _local_3) + "subtitle}");
            this._window.findChildByName("description_text").caption = (("${" + _local_3) + "description}");
            this._window.findChildByName("waiting_text").caption = (("${" + _local_3) + "waiting}");
            this._window.findChildByName("cancel_button").caption = (("${" + _local_3) + "cancel}");
            cast(this._window.findChildByName("reward_base"), IStaticBitmapWrapperWindow).assetUri = (_local_2 ? "mysterybox_box_base" : "mysterybox_key_base");
            cast(this._window.findChildByName("reward_overlay"), IStaticBitmapWrapperWindow).assetUri = (_local_2 ? "mysterybox_box_overlay" : "mysterybox_key_overlay");
            cast(this._window.findChildByName("needed_base"), IStaticBitmapWrapperWindow).assetUri = (_local_2 ? "mysterybox_key_base" : "mysterybox_box_base");
            cast(this._window.findChildByName("needed_overlay"), IStaticBitmapWrapperWindow).assetUri = (_local_2 ? "mysterybox_key_overlay" : "mysterybox_box_overlay");
            var _local_4= this._widget.handler.container.sessionDataManager;
            var _local_5= (_local_2 ? _local_4.mysteryBoxColor : _local_4.mysteryKeyColor);
            if (((_local_5 == null) || (_local_5 == "")))
            {
                return;
            }
            var _local_6= ASCompat.toUInt(MysteryBoxToolbarExtension.KEY_COLORS[_local_5.toLowerCase()]);
            this._window.findChildByName("reward_base").color = _local_6;
            this._window.findChildByName("needed_base").color = _local_6;
        }

        function _Str_25449(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (k.target.name)
            {
                case "header_button_close"
                   | "cancel_button":
                    this.closeWindow();
                    this.connection.send(new MysteryBoxWaitingCanceledMessageComposer(this._widget.handler.container.getFurnitureOwnerId(this._object)));
                    return;
            }
        }

        function _Str_22444(k:String, _arg_2:Int)
        {
            this.closeWindow();
            var _local_3= ((this._widget.assets.getAssetByName("mystery_box_reward").content : com.sulake.core.utils.xml.XML) );
            this._dialog = this._widget.handler.container.windowManager.buildModalDialogFromXML(_local_3);
            this._window = Std.downcast(this._dialog.rootWindow , IWindowContainer);
            this._window.procedure = this._Str_24015;
            this._imageId = -1;
            var _local_4:ImageResult = null;
            switch (k)
            {
                case ProductTypeEnum.FLOOR:
                    _local_4 = this._widget.handler.container.roomEngine.getFurnitureImage(_arg_2, new Vector3d(90, 0, 0), 64, this, 0);
                    
                case ProductTypeEnum.WALL:
                    _local_4 = this._widget.handler.container.roomEngine.getWallItemImage(_arg_2, new Vector3d(90, 0, 0), 64, this, 0);
                    
                case ProductTypeEnum.EFFECT:
                    this._Str_15419 = this._widget.handler.container.catalog.getPixelEffectIcon(_arg_2);
                    
                case ProductTypeEnum.HABBO_CLUB:
                    this._Str_15419 = this._widget.handler.container.catalog.getSubscriptionProductIcon(_arg_2);
                    
                default:
                    return;
            }
            if (_local_4 != null)
            {
                if (_local_4.data != null)
                {
                    this._Str_15419 = _local_4.data;
                }
                this._imageId = _local_4.id;
            }
        }

        var _Str_15419(never,set):BitmapData;
function  set__Str_15419(k:BitmapData):BitmapData        {
            if (((this._window == null) || this._window.disposed))
            {
                return k;
            }
            var _local_2= Std.downcast(this._window.findChildByName("reward_image") , IBitmapWrapperWindow);
            var _local_3= this._window.findChildByName("bitmap_container");
            _local_2.bitmap = k;
            _local_3.width = k.width;
            _local_3.height = k.height;
            _local_3.width++;
return k;
        }

        function _Str_24015(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (k.target.name)
            {
                case "header_button_close"
                   | "close_button":
                    this.closeWindow();
                    return;
            }
        }

        function closeWindow()
        {
            if (((!(this._dialog == null)) && (!this._dialog.disposed)))
            {
                this._window = null;
                this._dialog.dispose();
                this._dialog = null;
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this.closeWindow();
            this.connection.removeMessageEvent(this._showMysteryBoxWaitMessageEvent);
            this.connection.removeMessageEvent(this._cancelMysteryBoxWaitMessageEvent);
            this.connection.removeMessageEvent(this._gotMysteryBoxPrizeMessageEvent);
            this._showMysteryBoxWaitMessageEvent = null;
            this._cancelMysteryBoxWaitMessageEvent = null;
            this._gotMysteryBoxPrizeMessageEvent = null;
            this._object = null;
            this._widget = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function _Str_24779(k:IRoomObject)
        {
            this._object = k;
            this.connection.send(new UseFurnitureMessageComposer(k.getId()));
        }

        var connection(get,never):IConnection;
function  get_connection():IConnection
        {
            return this._widget.handler.container.connection;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (k == this._imageId)
            {
                this._imageId = -1;
                this._Str_15419 = _arg_2;
            }
        }

        public function imageFailed(k:Int)
        {
        }
    }

