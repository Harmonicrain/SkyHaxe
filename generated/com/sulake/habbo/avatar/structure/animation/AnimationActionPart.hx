package com.sulake.habbo.avatar.structure.animation
;
     class AnimationActionPart 
    {
        var _frames:Array<ASAny>;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML;
            var _local_3:Int;
            this._frames = new Array<ASAny>();
            for (_tmp_ in k.child("frame"))
            {
_local_2  = _tmp_;
                this._frames.push(new AnimationFrame(_local_2));
                _local_3 = ASCompat.parseInt(_local_2.attribute("repeats").toString());
                if (_local_3 > 1)
                {
                    while (--_local_3 > 0)
                    {
                        this._frames.push(this._frames[(this._frames.length - 1)]);
                    }
                }
            }
        }

        public var frames(get,never):Array<ASAny>;
function  get_frames():Array<ASAny>
        {
            return this._frames;
        }
    }

