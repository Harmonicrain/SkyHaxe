package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.utils.IIterator;

     class RoomThumbnailWidget implements _Str_13613 
    {
        public static inline final ROOM_THUMBNAIL= "room_thumbnail";

        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IWindowContainer;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("room_thumbnail_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._widgetWindow.rootWindow = this._root;
            this._root.width = this._widgetWindow.width;
            this._root.height = this._widgetWindow.height;
        }

        public function reset()
        {
        }

        public var flatId(never,set):Int;
public function  set_flatId(k:Int):Int        {
return k;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            return null;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
return k;
        }

        public function dispose()
        {
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return null;
        }
    }


