package org.openvideoads.vast.model
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.util.NetworkResource;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.util.Timestamp;
    import org.openvideoads.util.ArrayUtils;

     class TrackedVideoAd extends Debuggable 
    {
        var _id:String;
        var _Str_9867:String;
        var _Str_3053:Array<ASAny>;
        var _Str_3772:Array<ASAny>;
        var _Str_4684:Array<ASAny>;
        var _Str_9886:Array<ASAny>;
        var _Str_4662:Array<ASAny>;
        var _Str_4070:VideoAd = null;
        var _scale:Bool = false;
        var _Str_6419:Bool = false;
        var _Str_6407:Int = -1;
        var _index:Int = -1;
        var _Str_15300:Bool = false;

        public function new()
        {
            this._Str_3053 = new Array<ASAny>();
            this._Str_3772 = new Array<ASAny>();
            this._Str_4684 = new Array<ASAny>();
            this._Str_9886 = new Array<ASAny>();
            this._Str_4662 = new Array<ASAny>();
            super();
        }

        public function unload()
        {
            var k = 0;
            var _local_2 = 0;
            var _local_3 = 0;
            if (this._Str_18876())
            {
                k = 0;
                while (k < this._Str_4684.length)
                {
                    cast(this._Str_4684[k], NetworkResource).close();
                    k++;
                }
            }
            if (this._Str_24086())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_4662.length)
                {
                    cast(this._Str_4662[_local_2], NetworkResource).close();
                    _local_2++;
                }
            }
            if (this._Str_22268())
            {
                _local_3 = 0;
                while (_local_3 < this._Str_9886.length)
                {
                    cast(this._Str_9886[_local_3], NetworkResource).close();
                    _local_3++;
                }
            }
        }

        
        public var id(get,set):String;
public function  set_id(k:String):String        {
            return this._id = k;
        }
public function  get_id():String
        {
            return this._id;
        }

        public override function  set_uid(k:String):String        {
            _uid = uid;
return k;
        }

        
        public var _Str_18431(get,set):String;
public function  set__Str_18431(k:String):String        {
            return this._Str_9867 = k;
        }
public function  get__Str_18431():String
        {
            return this._Str_9867;
        }

        
        public var index(get,set):Int;
public function  get_index():Int
        {
            return this._index;
        }
public function  set_index(k:Int):Int        {
            return this._index = k;
        }

        
        public var isVAST2(get,set):Bool;
public function  set_isVAST2(k:Bool):Bool        {
            return this._Str_15300 = k;
        }
public function  get_isVAST2():Bool
        {
            return this._Str_15300;
        }

        
        public var scale(get,set):Bool;
public function  set_scale(k:ASAny):Bool        {
            this._scale = StringUtils._Str_2810(k);
return k;
        }
public function  get_scale():Bool
        {
            return this._scale;
        }

        
        public var maintainAspectRatio(get,set):Bool;
public function  set_maintainAspectRatio(k:ASAny):Bool        {
            this._Str_6419 = StringUtils._Str_2810(k);
return k;
        }
public function  get_maintainAspectRatio():Bool
        {
            return this._Str_6419;
        }

        
public var duration(get,set):String;
public function  get_duration():String
        {
            return Timestamp._Str_4110(this._Str_6407);
        }

        public function getDurationAsInt():Int
        {
            return Timestamp.timestampToSeconds(this.duration);
        }

        
        public var recommendedMinDuration(get,set):Int;
public function  get_recommendedMinDuration():Int
        {
            return this._Str_6407;
        }
public function  set_recommendedMinDuration(k:ASAny):Int        {
            if (ASCompat.typeOf(k) == "string")
            {
                this._Str_6407 = ASCompat.parseInt(k);
            }
            else
            {
                this._Str_6407 = ASCompat.toInt(k);
            }
return ASCompat.toInt(k);
        }

        public function hasRecommendedMinDuration():Bool
        {
            return this._Str_6407 > -1;
        }

        
        public var parentAdContainer(get,set):VideoAd;
public function  set_parentAdContainer(k:VideoAd):VideoAd        {
            return this._Str_4070 = k;
        }
public function  get_parentAdContainer():VideoAd
        {
            return this._Str_4070;
        }

        
        public var trackingEvents(get,set):Array<ASAny>;
public function  set_trackingEvents(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_3053 = k;
        }
public function  get_trackingEvents():Array<ASAny>
        {
            return this._Str_3053;
        }

        public function hasTrackingEvents():Bool
        {
            return this._Str_3053.length > 0;
        }

        public function _Str_10620(k:TrackingEvent)
        {
            this._Str_3053.push(k);
        }

        public function addTrackingEventItems(k:Array<ASAny>)
        {
            this._Str_3053 = this._Str_3053.concat(k);
        }

        public function triggerTrackingEvent(k:String)
        {
            var _local_2 = 0;
            var _local_3:TrackingEvent = null;
            if (((!(this._Str_3053 == null)) && (!(k == null))))
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3053.length)
                {
                    _local_3 = this._Str_3053[_local_2];
                    if (_local_3.eventType != null)
                    {
                        if (_local_3.eventType.toUpperCase() == k.toUpperCase())
                        {
                            _local_3.execute();
                        }
                    }
                    _local_2++;
                }
            }
        }

        public function getTrackingEventList():Array<ASAny>
        {
            var _local_2 = 0;
            var k= new Array<ASAny>();
            if (this.hasTrackingEvents())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3053.length)
                {
                    k.push({
                        "type":this._Str_3053[_local_2].eventType,
                        "urls":this._Str_3053[_local_2].getURLList()
                    });
                    _local_2++;
                }
            }
            return k;
        }

        public function _Str_26233(k:Array<ASAny>)
        {
            if (this._Str_3772 != null)
            {
                this._Str_3772.concat(k);
            }
            else
            {
                this._Str_3772 = k;
            }
        }

        
        public var clickThroughs(get,set):Array<ASAny>;
public function  set_clickThroughs(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_3772 = k;
        }
public function  get_clickThroughs():Array<ASAny>
        {
            return this._Str_3772;
        }

        public function _Str_26023():Int
        {
            return this._Str_3772.length;
        }

        public function getClickThroughURLString():String
        {
            if (this._Str_10419())
            {
                return this._Str_3772[0].qualifiedUrl;
            }
            return null;
        }

        public function _Str_26161():Array<ASAny>
        {
            var _local_2 = 0;
            var k= new Array<ASAny>();
            if (this._Str_10419())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3772.length)
                {
                    k.push(this._Str_3772[_local_2].qualifiedHTTPUrl);
                    _local_2++;
                }
            }
            return k;
        }

        public function _Str_7230(k:NetworkResource)
        {
            this._Str_3772.push(k);
        }

        public function _Str_10419():Bool
        {
            return this._Str_3772.length > 0;
        }

        public function _Str_6447():String
        {
            if (this._Str_10419())
            {
                return this._Str_3772[0].qualifiedHTTPUrl;
            }
            return null;
        }

        public function _Str_18876():Bool
        {
            return this._Str_4684.length > 0;
        }

        
        public var clickTracking(get,set):Array<ASAny>;
public function  set_clickTracking(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_4684 = k;
        }
public function  get_clickTracking():Array<ASAny>
        {
            return this._Str_4684;
        }

        public function _Str_26002():Int
        {
            return this._Str_4684.length;
        }

        public function _Str_10053(k:NetworkResource)
        {
            this._Str_4684.push(k);
        }

        public function fireClickTracking()
        {
        }

        public function addClickTrackingItems(k:Array<ASAny>)
        {
            if (k != null)
            {
                this._Str_4684 = this._Str_4684.concat(k);
            }
        }

        
        public var customClicks(get,set):Array<ASAny>;
public function  set_customClicks(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_4662 = k;
        }
public function  get_customClicks():Array<ASAny>
        {
            return this._Str_4662;
        }

        public function _Str_26329():Int
        {
            return this._Str_4662.length;
        }

        public function _Str_10085(k:NetworkResource)
        {
            this._Str_4662.push(k);
        }

        public function addCustomClickTrackingItems(k:Array<ASAny>)
        {
            if (k != null)
            {
                this._Str_4662 = this._Str_4662.concat(k);
            }
        }

        public function _Str_24086():Bool
        {
            return this._Str_4662.length > 0;
        }

        public function _Str_26040()
        {
        }

        public function _Str_5569():Bool
        {
            return this._Str_3772.length > 0;
        }

        public function _Str_22268():Bool
        {
            if (this._Str_9886 != null)
            {
                return this._Str_9886.length > 0;
            }
            return false;
        }

        function _Str_25176( k:Array<ASAny> = null):ASAny
        {
if (k == null) k = [];

return ASCompat.undefinedValue();         }

        public function clone(k:ASAny=null):ASAny
        {
            var _local_2:TrackedVideoAd = null;
            var _local_3:TrackingEvent = null;
            var _local_4:NetworkResource = null;
            var _local_5:NetworkResource = null;
            var _local_6:NetworkResource = null;
            if (k == null)
            {
                _local_2 = new TrackedVideoAd();
            }
            else
            {
                _local_2 = k;
            }
            _local_2.id = this._id;
            _local_2.uid = _uid;
            _local_2._Str_18431 = this._Str_9867;
            _local_2.parentAdContainer = this._Str_4070;
            _local_2.scale = this._scale;
            _local_2.maintainAspectRatio = this._Str_6419;
            _local_2.recommendedMinDuration = this._Str_6407;
            _local_2.index = this._index;
            _local_2.isVAST2 = this._Str_15300;
            final _iter_ = this._Str_3053; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_2._Str_10620(_local_3.clone());
            }
            final _iter_ = this._Str_3772; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_2._Str_7230(_local_4.clone());
            }
            final _iter_ = this._Str_4684; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                _local_2._Str_10053(_local_5.clone());
            }
            final _iter_ = this._Str_4662; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6  = _tmp_;
                _local_2._Str_10085(_local_6.clone());
            }
            return _local_2;
        }

        override public function toJSObject():ASObject
        {
            var k:ASObject = new ASObject();
            k = {
                "adId":this._Str_9867,
                "id":this._id,
                "uid":_uid,
                "trackingEvents":ArrayUtils._Str_6975(this._Str_3053),
                "clickThroughs":ArrayUtils._Str_6975(this._Str_3772),
                "clickTracking":ArrayUtils._Str_6975(this._Str_4684),
                "customClicks":ArrayUtils._Str_6975(this._Str_4662),
                "scale":this._scale,
                "maintainAspectRatio":this._Str_6419,
                "recommendedMinDuration":this._Str_6407,
                "index":this._index,
                "isVAST2":this._Str_15300
            }
;            return k;
        }
public 
function  set_duration(k:String):String{throw "Accessor unavailable on base instance: duration"; return k;
}    }

