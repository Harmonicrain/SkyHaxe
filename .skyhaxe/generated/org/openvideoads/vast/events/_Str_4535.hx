package org.openvideoads.vast.events
;
    import flash.events.Event;
    import org.openvideoads.vast.model.NonLinearVideoAd;

     class _Str_4535 extends Event 
    {
        var _Str_17935:NonLinearVideoAd = null;

        public function new(k:String, _arg_2:NonLinearVideoAd, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._Str_17935 = _arg_2;
        }

        public function _Str_19052():Bool
        {
            return !(this.nonLinearVideoAd == null);
        }

        
        public var nonLinearVideoAd(get,set):NonLinearVideoAd;
public function  set_nonLinearVideoAd(k:NonLinearVideoAd):NonLinearVideoAd        {
            this._Str_17935 = this.nonLinearVideoAd;
return k;
        }
public function  get_nonLinearVideoAd():NonLinearVideoAd
        {
            return this._Str_17935;
        }

        public function _Str_21016():Bool
        {
            if (this._Str_19052())
            {
                return this.nonLinearVideoAd.isInteractive();
            }
            return false;
        }
    }

