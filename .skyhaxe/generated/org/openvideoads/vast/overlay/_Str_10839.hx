package org.openvideoads.vast.overlay
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.regions.view.RegionView;
    import flash.utils.Timer;

     class _Str_10839 extends Debuggable 
    {
        var _Str_14323:String = null;
        var _Str_2467:Int = 0;
        var _Str_4771:RegionView = null;
        var _timer:Timer = null;

        public function new(k:String, _arg_2:Int, _arg_3:RegionView)
        {
            super();
            this._Str_14323 = k;
            this._Str_2467 = _arg_2;
            this._Str_4771 = _arg_3;
        }

        public function show()
        {
            if (this._Str_25183())
            {
                this._Str_25022();
            }
            else
            {
                this._Str_25805();
            }
        }

        public function hide()
        {
            this._Str_24263();
        }

        function _Str_25183():Bool
        {
            if (this._Str_14323 != null)
            {
                return this._Str_14323.indexOf("_countdown_") > -1;
            }
            return false;
        }

        function _Str_25022()
        {
            if (this._Str_4771 != null)
            {
                this._Str_21375(this._Str_2467);
            }
        }

        function _Str_24263()
        {
            if (this._timer != null)
            {
                this._timer.stop();
                this._timer = null;
            }
            if (this._Str_4771 != null)
            {
                this._Str_4771.hide();
            }
        }

        function _Str_19421(k:String, _arg_2:Int):String
        {
            var _local_3= new compat.RegExp(k, "g");
            return ASCompat.stringReplace(this._Str_14323, _local_3, _arg_2);
        }

        function _Str_25805()
        {
            if (this._Str_4771 != null)
            {
                this._Str_4771._Str_19536();
                this._Str_4771.html = this._Str_19421("_seconds_", this._Str_2467);
                this._Str_4771.visible = true;
            }
        }

        public function _Str_21375(k:Int)
        {
            if (this._Str_4771 != null)
            {
                this._Str_4771._Str_19536();
                this._Str_4771.html = this._Str_19421("_countdown_", k);
                this._Str_4771.visible = true;
            }
        }
    }

