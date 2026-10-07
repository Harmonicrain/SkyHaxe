package com.sulake.habbo.friendlist
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IBorderWindow;
    import flash.geom.Point;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class _Str_9231 implements IDisposable 
    {
        var _habboFriendList:HabboFriendList;
        var _window:IBorderWindow;
        var _Str_5045:Int = 0;
        var _disposed:Bool = false;

        public function new(k:HabboFriendList)
        {
            this._habboFriendList = k;
            this.createWindow();
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this.destroyWindow();
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function _Str_24722(k:IWindow, _arg_2:IWindow)
        {
            var _local_3= new Point();
            k.getGlobalPosition(_local_3);
            this._window.x = Std.int(_local_3.x);
            this._window.y = Std.int(_local_3.y);
            this._window.visible = true;
            this._window.activate();
        }

        public function _Str_17733()
        {
            this._window.visible = false;
        }

        public var _Str_9566(never,set):Int;
public function  set__Str_9566(k:Int):Int        {
            return this._Str_5045 = k;
        }

        function createWindow()
        {
            this._window = cast(this._habboFriendList.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(this._habboFriendList.assets.getAssetByName("relationship_chooser_xml").content)), IBorderWindow);
            this._window.procedure = this.onWindowEvent;
            this._window.visible = false;
        }

        function destroyWindow()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function onWindowEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "item_none":
                        this._habboFriendList.setRelationshipStatus(this._Str_5045, RelationshipStatusEnum.NONE);
                        
                    case "item_heart":
                        this._habboFriendList.setRelationshipStatus(this._Str_5045, RelationshipStatusEnum._Str_9205);
                        
                    case "item_smile":
                        this._habboFriendList.setRelationshipStatus(this._Str_5045, RelationshipStatusEnum._Str_8388);
                        
                    case "item_bobba":
                        this._habboFriendList.setRelationshipStatus(this._Str_5045, RelationshipStatusEnum._Str_8824);
                        
                }
                this._window.visible = false;
            }
            if (k.type == WindowEvent.WINDOW_EVENT_UNFOCUSED)
            {
                this._window.visible = false;
            }
        }
    }

