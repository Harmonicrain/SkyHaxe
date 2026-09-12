package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.catalog.viewer.ICatalogPage;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;

     class CatalogWidget 
    {
        var _window:IWindowContainer;
        var _events:IEventDispatcher;
        var _page:ICatalogPage;
        var _disposed:Bool = false;
        var _embedded:Bool = false;

        public function new(k:IWindowContainer)
        {
            this._window = k;
            this._embedded = (k.tags.indexOf("EMBEDDED") > -1);
        }

        
        public var page(get,set):ICatalogPage;
public function  set_page(k:ICatalogPage):ICatalogPage        {
            return this._page = k;
        }

        
        public var events(get,set):IEventDispatcher;
public function  set_events(k:IEventDispatcher):IEventDispatcher        {
            return this._events = k;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }
public function  get_events():IEventDispatcher
        {
            return this._events;
        }
public function  get_page():ICatalogPage
        {
            return this._page;
        }

        public function dispose()
        {
            this._events = null;
            this._page = null;
            this._window = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function init():Bool
        {
            return true;
        }

        public function closed()
        {
        }

        function getAssetXML(k:String):com.sulake.core.utils.xml.XML
        {
            if (((((!(this.page != null)) || (!(this.page.viewer != null))) || (!(this.page.viewer.catalog != null))) || (!(this.page.viewer.catalog.assets != null))))
            {
                return null;
            }
            var _local_2= Std.downcast(this.page.viewer.catalog.assets.getAssetByName(k) , XmlAsset);
            if (_local_2 == null)
            {
                return null;
            }
            return (_local_2.content : com.sulake.core.utils.xml.XML) ;
        }

        function _Str_2819(k:String)
        {
            if (this._embedded)
            {
                return;
            }
            var _local_2= this.getAssetXML(k);
            if (_local_2 == null)
            {
                return;
            }
            this.window.removeChildAt(0);
            if (((((!(this.window != null)) || (!(this.page != null))) || (!(this.page.viewer != null))) || (!(this.page.viewer.catalog != null))))
            {
                return;
            }
            this.window.addChild(this.page.viewer.catalog.windowManager.buildFromXML(_local_2));
        }

        function _Str_21202(k:String):BitmapData
        {
            var _local_2= Std.downcast(this.page.viewer.catalog.assets.getAssetByName(k) , BitmapDataAsset);
            if (_local_2 == null)
            {
                return null;
            }
            return ASCompat.dynamicAs(_local_2.content , BitmapData);
        }
    }

