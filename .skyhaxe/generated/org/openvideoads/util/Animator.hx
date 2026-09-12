package org.openvideoads.util
;
    import org.openvideoads.base.Debuggable;
    import flash.display.Sprite;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

     class Animator extends Debuggable 
    {
        var _Str_2529:Sprite = null;
        var _timer:Timer = null;
        var _Str_20047:Float = 0;


        public function stop()
        {
            if (this._timer != null)
            {
                this._timer.stop();
                this._timer = null;
            }
        }

        public function fade(target:Sprite, properties:ASObject)
        {
            if (target != null)
            {
                if (properties != null)
                {
                    if (this._timer != null)
                    {
                        this._timer.stop();
                    }
                    this._Str_2529 = target;
                    this._Str_20047 = (ASCompat.toNumber(ASCompat.toNumber(properties.alpha) - target.alpha) / ASCompat.toNumber(properties.times));
                    this._timer = new Timer(ASCompat.toNumber(properties.rate), ASCompat.toInt(properties.times));
                    this._timer.addEventListener(TimerEvent.TIMER, (function onTimer (k:TimerEvent)
                    {
                        _Str_2529.alpha = (_Str_2529.alpha + _Str_20047);
                    } : ASAny));
                    this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, (function onTimerComplete (k:TimerEvent)
                    {
                        _Str_2529.alpha = ASCompat.toNumber(properties.alpha);
                        if (properties.onComplete != /*undefined*/null)
                        {
                            properties.onComplete();
                        }
                    } : ASAny));
                    this._timer.start();
                }
            }
        }

	public function new() { super(); }
    }

