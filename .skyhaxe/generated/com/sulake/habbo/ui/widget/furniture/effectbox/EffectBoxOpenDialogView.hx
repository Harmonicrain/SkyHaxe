package com.sulake.habbo.ui.widget.furniture.effectbox
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.widget.furniture.contextmenu.FurnitureContextMenuWidget;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.UseFurnitureMessageComposer;
    import com.sulake.core.communication.connection.IConnection;

     class EffectBoxOpenDialogView implements IDisposable 
    {
        static inline final HEADER_BUTTON_CLOSE= "header_button_close";
        static inline final CANCEL= "cancel";
        static inline final OK= "ok";

        var _window:IWindowContainer;
        var _disposed:Bool = false;
        var _widget:FurnitureContextMenuWidget;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _requestRoomObjectId:Int = 0;

        public function new(k:FurnitureContextMenuWidget)
        {
            this._widget = k;
            this._windowManager = k.windowManager;
            this._assets = this._widget.assets;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public function open(k:Int)
        {
            this._requestRoomObjectId = k;
            this._Str_3248();
            this._window.visible = true;
        }

        function _Str_3248()
        {
            var k:String = null;
            if (this._window == null)
            {
                k = "effectbox_xml";
                this._window = Std.downcast(this._windowManager.buildFromXML(((this._assets.getAssetByName(k).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
                this.addClickListener(OK);
                this.addClickListener(CANCEL);
                this.addClickListener(HEADER_BUTTON_CLOSE);
                this._window.center();
            }
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        function addClickListener(k:String)
        {
            this._window.findChildByName(k).addEventListener(WindowMouseEvent.CLICK, this.onMouseClick);
        }

        function onMouseClick(k:WindowMouseEvent)
        {
            var _local_2:RoomWidgetMessage = null;
            switch (k.target.name)
            {
                case HEADER_BUTTON_CLOSE
                   | CANCEL:
                    this.close();
                    
                case OK:
                    this.connection.send(new UseFurnitureMessageComposer(this._requestRoomObjectId));
                    this.close();
                    
            }
            if (_local_2 != null)
            {
                this._widget.messageListener.processWidgetMessage(_local_2);
            }
        }

        var connection(get,never):IConnection;
function  get_connection():IConnection
        {
            return this._widget.handler.container.connection;
        }
    }

