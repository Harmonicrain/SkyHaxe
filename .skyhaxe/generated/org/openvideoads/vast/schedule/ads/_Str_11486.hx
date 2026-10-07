package org.openvideoads.vast.schedule.ads
;
    import org.openvideoads.vast.schedule.StreamSequence;
    import org.openvideoads.vast.VASTController;
    import org.openvideoads.vast.config.Config;

     class _Str_11486 extends AdSlot 
    {
        var _Str_4544:String = null;
        var _Str_10823:String = "relative";

        public function new(k:StreamSequence, _arg_2:AdSchedule, _arg_3:VASTController, _arg_4:Int=0, _arg_5:Int=0, _arg_6:String=null, _arg_7:String=null, _arg_8:String=null, _arg_9:Array<ASAny>=null, _arg_10:String=null, _arg_11:String="00:00:00", _arg_12:ASObject=null, _arg_13:Bool=true, _arg_14:Array<ASAny>=null, _arg_15:Array<ASAny>=null, _arg_16:String=null, _arg_17:String=null, _arg_18:String=null)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_10, _arg_11, _arg_12, _arg_13, _arg_14, _arg_15, _arg_16);
            this._Str_4544 = _arg_18;
            if (this._Str_10823 != null)
            {
                this._Str_10823 = _arg_17;
            }
        }

        
        public var html(get,set):String;
public function  set_html(k:String):String        {
            return this._Str_4544 = k;
        }
public function  get_html():String
        {
            return this._Str_4544;
        }

        
        public var startPoint(get,set):String;
public function  set_startPoint(k:String):String        {
            return this._Str_10823 = k;
        }
public function  get_startPoint():String
        {
            return this._Str_10823;
        }

        public function _Str_26169():Bool
        {
            return this._Str_10823.toUpperCase() == "RELATIVE";
        }

        override public function hasVideoAd():Bool
        {
            return false;
        }

        override public function isNonLinear():Bool
        {
            return true;
        }

        function _Str_25994(k:ASObject=null, _arg_2:Config=null)
        {
        }

        function _Str_26322(k:ASObject=null, _arg_2:Config=null)
        {
        }
    }

