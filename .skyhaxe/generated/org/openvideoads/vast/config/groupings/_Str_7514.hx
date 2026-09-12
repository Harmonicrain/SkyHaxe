package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.util.NetworkResource;
    import org.openvideoads.vast.config._Str_2741;

     class _Str_7514 extends NetworkResource implements _Str_2741 
    {
        var _Str_23188:String = "http://tracker.openvideoads.org/log-event.php";
        var _Str_26384:String = "http://debug.openvideoads.org/log-debug.php";

        public function new()
        {
            super();
            this._Str_24796();
        }

        public function initialise(k:ASObject=null)
        {
            this.onOVAConfigLoaded();
        }

        public function isOVAConfigLoading():Bool
        {
            return false;
        }

        public function _Str_6073():Bool
        {
            return false;
        }

        public function onOVAConfigLoaded()
        {
        }

        public function _Str_3144()
        {
        }

        function _Str_24796()
        {
        }

        public var _Str_26167(get,never):String;
public function  get__Str_26167():String
        {
            return this._Str_23188;
        }
    }

