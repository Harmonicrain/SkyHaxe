package com.apdevblog.model.vo
;
     class VideoMetadataVo 
    {
        public var duration:Float = Math.NaN;
        public var width:Float = Math.NaN;
        public var height:Float = Math.NaN;
        public var keyframes:ASObject;
        public var _Str_19283:Bool = false;

        public function new(k:ASObject=null)
        {
var _local_2:String  = null;            var _local_2:String = null;
            if (k != null)
            {
                this.width = ASCompat.toNumber(ASCompat.getDynamicProperty(k, "width"));
                this.height = ASCompat.toNumber(ASCompat.getDynamicProperty(k, "height"));
                this.duration = ASCompat.toNumber(ASCompat.getDynamicProperty(k, "duration"));
                if (ASCompat.getDynamicProperty(k, "keyframes")!= null)
                {
                    this._Str_19283 = false;
                    this.keyframes = ASCompat.getDynamicProperty(k, "keyframes");
                }
                else
                {
                    if (ASCompat.getDynamicProperty(k, "seekpoints")!= null)
                    {
                        this._Str_19283 = true;
                        this.keyframes = new ASObject();
ASCompat.setDynamicProperty(                        this.keyframes, "times", new Array<ASAny>());
ASCompat.setDynamicProperty(                        this.keyframes, "filepositions", new Array<ASAny>());
                        final _iter_:ASAny = ASCompat.getDynamicProperty(k, "seekpoints"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
                        {
_local_2 = _tmp_;
ASCompat.setDynamicProperty(ASCompat.getDynamicProperty(                            this.keyframes, "times"), _local_2, ASCompat.asNumber(ASCompat.getDynamicProperty(k, "seekpoints")[_local_2]["time"] ));
ASCompat.setDynamicProperty(ASCompat.getDynamicProperty(                            this.keyframes, "filepositions"), _local_2, ASCompat.asNumber(ASCompat.getDynamicProperty(k, "seekpoints")[_local_2]["offset"] ));
                        }
                    }
                    else
                    {
                        this.keyframes = null;
                    }
                }
            }
        }
    }

