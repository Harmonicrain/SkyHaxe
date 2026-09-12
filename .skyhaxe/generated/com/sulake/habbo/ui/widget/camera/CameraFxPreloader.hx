package com.sulake.habbo.ui.widget.camera
;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.display.BitmapData;
    import flash.net.URLRequest;
    import flash.display.Bitmap;

     class CameraFxPreloader 
    {
        static var ASSETS:ASDictionary<ASAny,ASAny>;
        static var instance:CameraFxPreloader;
        static var _urls:Array<ASAny>;
        static var _baseUrl:String;

        var _loader:Loader;
        var _preloadFinished:Bool = false;

        public function new()
        {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, (this._Str_22779 : ASAny));
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, (this._Str_22357 : ASAny));
            this._Str_17534();
        }

        public static function init(k:String, _arg_2:Array<ASAny>)
        {
            if (instance == null)
            {
                ASSETS = new ASDictionary<ASAny,ASAny>();
                _baseUrl = k;
                _urls = _arg_2;
                instance = Type.createInstance(CameraFxPreloader, []);
            }
        }

        public static function _Str_25462():Bool
        {
            return (instance != null) ? instance._preloadFinished : false;
        }

        public static function getImage(k:String):BitmapData
        {
            return (ASSETS != null) ? ASSETS[k] : null;
        }


        function _Str_17534()
        {
            var k:String = null;
            if (_urls.length > 0)
            {
                k = (((_baseUrl + "Habbo-Stories/") + _urls[0]) + ".png");
                this._loader.load(new URLRequest(k));
            }
            else
            {
                this._preloadFinished = true;
            }
        }

        function _Str_22779(k:Event)
        {
            ASSETS[_urls.shift()] = cast(this._loader.content, Bitmap).bitmapData.clone();
            this._Str_17534();
        }

        function _Str_22357(k:Event)
        {
            Logger.log([("Camera Fx preloading failed for " + this._loader.contentLoaderInfo.loaderURL)]);
            _urls.shift();
            this._Str_17534();
        }
    }

