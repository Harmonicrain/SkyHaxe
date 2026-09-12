package com.sulake.habbo.sound
;
    import flash.media.SoundChannel;
    import flash.media.Sound;
    import flash.events.Event;
    import flash.media.SoundTransform;

     class HabboSoundBase implements IHabboSound 
    {
        var _soundChannel:SoundChannel = null;
        var _complete:Bool = false;
        var _volume:Float = Math.NaN;
        var _loopCount:Int = 0;
        var _soundObject:Sound = null;

        public function new(k:Sound, _arg_2:Int=0)
        {
            this._soundObject = k;
            this._soundObject.addEventListener(Event.COMPLETE, (this.onComplete : ASAny));
            this._volume = 1;
            this._complete = false;
            this._loopCount = _arg_2;
        }

        function _Str_26043():Sound
        {
            return this._soundObject;
        }

        function _Str_15495():SoundChannel
        {
            return this._soundChannel;
        }

        function _Str_20695(k:SoundChannel)
        {
            this._soundChannel = k;
        }

        function _Str_22198(k:Bool)
        {
            this._complete = k;
        }

        public function dispose()
        {
            this.stop();
            this._soundChannel = null;
            this._soundObject = null;
        }

        public function play(k:Float=0):Bool
        {
            this._complete = false;
            this._soundChannel = this._soundObject.play(0, this._loopCount);
            this.volume = this._volume;
            return true;
        }

        public function stop():Bool
        {
            if (this._soundChannel != null)
            {
                this._soundChannel.stop();
            }
            return true;
        }

        
        public var volume(get,set):Float;
public function  get_volume():Float
        {
            return this._volume;
        }
public function  set_volume(k:Float):Float        {
            this._volume = k;
            this._Str_7399(k);
return k;
        }

        function _Str_7399(k:Float)
        {
            if (this._soundChannel != null)
            {
                this._soundChannel.soundTransform = new SoundTransform(k);
            }
        }

        
        public var position(get,set):Float;
public function  get_position():Float
        {
            return this._soundChannel.position;
        }
public function  set_position(k:Float):Float        {
return k;
        }

        public var length(get,never):Float;
public function  get_length():Float
        {
            return this._soundObject.length;
        }

        public var ready(get,never):Bool;
public function  get_ready():Bool
        {
            return !this._soundObject.isBuffering;
        }

        public var finished(get,never):Bool;
public function  get_finished():Bool
        {
            return !this._complete;
        }

        
        public var fadeOutSeconds(get,set):Float;
public function  get_fadeOutSeconds():Float
        {
            return 0;
        }
public function  set_fadeOutSeconds(k:Float):Float        {
return k;
        }

        
        public var fadeInSeconds(get,set):Float;
public function  get_fadeInSeconds():Float
        {
            return 0;
        }
public function  set_fadeInSeconds(k:Float):Float        {
return k;
        }

        function onComplete(k:Event)
        {
            this._complete = true;
        }
    }

