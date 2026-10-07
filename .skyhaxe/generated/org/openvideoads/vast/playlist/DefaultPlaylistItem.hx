package org.openvideoads.vast.playlist
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.vast.schedule.Stream;
    import org.openvideoads.vast.config.groupings.ProvidersConfigGroup;
    import org.openvideoads.vast.schedule.ads.AdSlot;
    import org.openvideoads.util.Timestamp;
    import org.openvideoads.util.StringUtils;

     class DefaultPlaylistItem extends Debuggable implements _Str_3480 
    {
        var _Str_1430:Stream = null;
        var _Str_5596:Bool = false;
        var _Str_5542:Int = -1;
        var _Str_4904:String = "http";
        var _Str_20147:String = null;
        var _Str_1858:String = "Not available";
        var _title:String = "";
        var _Str_1676:String = "Not available";
        var _Str_18387:String = "Not available";
        var _Str_18379:String = "Not available";
        var _Str_2467:String = "00:00:00";
        var _Str_990:String = "00:00:00";
        var _Str_577:String = null;
        var _Str_1673:String = null;
        var _Str_2230:String = null;
        var _Str_4454:ProvidersConfigGroup = null;
        var _index:Int = -1;

        public function new(k:Int=-1)
        {
            super();
            this._index = k;
        }

        
        public var guid(get,set):String;
public function  set_guid(k:String):String        {
            return this._Str_18387 = k;
        }
public function  get_guid():String
        {
            return this._Str_18387;
        }

        
        public var index(get,set):Int;
public function  set_index(k:Int):Int        {
            return this._index = k;
        }
public function  get_index():Int
        {
            return this._index;
        }

        
        public var provider(get,set):String;
public function  set_provider(k:String):String        {
            return this._Str_4904 = k;
        }
public function  get_provider():String
        {
            return this._Str_4904;
        }

        
        public var providers(get,set):ProvidersConfigGroup;
public function  set_providers(k:ProvidersConfigGroup):ProvidersConfigGroup        {
            return this._Str_4454 = k;
        }
public function  get_providers():ProvidersConfigGroup
        {
            return this._Str_4454;
        }

        
        public var streamer(get,set):String;
public function  set_streamer(k:String):String        {
            return this._Str_20147 = k;
        }
public function  get_streamer():String
        {
            return this._Str_20147;
        }

        
        public var _Str_20606(get,set):String;
public function  set__Str_20606(k:String):String        {
            return this._Str_18379 = k;
        }
public function  get__Str_20606():String
        {
            return this._Str_18379;
        }

        public function _Str_12928():String
        {
            if (this._Str_1430 != null)
            {
                return this._Str_1430.previewImage;
            }
            return null;
        }

        public function _Str_24712():Bool
        {
            return !(this._Str_12928() == null);
        }

        public function reset()
        {
            this._Str_5596 = false;
        }

        public function rewind()
        {
            if (this.playOnce == false)
            {
                this._Str_6097 = false;
            }
            this._Str_5542 = -1;
        }

        public var playOnce(get,never):Bool;
public function  get_playOnce():Bool
        {
            if (this._Str_1430 != null)
            {
                return this._Str_1430.playOnce;
            }
            return false;
        }

        public function canPlay():Bool
        {
            if (this.playOnce)
            {
                return !this._Str_6097;
            }
            return true;
        }

        public function markAsPlayed()
        {
            this._Str_6097 = true;
        }

        
        public var _Str_6097(get,set):Bool;
public function  set__Str_6097(k:Bool):Bool        {
            return this._Str_5596 = k;
        }
public function  get__Str_6097():Bool
        {
            return this._Str_5596;
        }

        function _Str_26315():Bool
        {
            return !(this._Str_1430 == null);
        }

        
        public var stream(get,set):Stream;
public function  set_stream(k:Stream):Stream        {
            this._Str_1430 = k;
            this._Str_1430._Str_21333 = this;
return k;
        }
public function  get_stream():Stream
        {
            return this._Str_1430;
        }

        public var adSlot(get,never):AdSlot;
public function  get_adSlot():AdSlot
        {
            return Std.downcast(this._Str_1430 , AdSlot);
        }

        
        public var title(get,set):String;
public function  set_title(k:String):String        {
            return this._title = k;
        }
public function  get_title():String
        {
            return this._title;
        }

        
        public var link(get,set):String;
public function  set_link(k:String):String        {
            return this._Str_1676 = k;
        }
public function  get_link():String
        {
            return this._Str_1676;
        }

        
        public var description(get,set):String;
public function  set_description(k:String):String        {
            return this._Str_1858 = k;
        }
public function  get_description():String
        {
            return this._Str_1858;
        }

        
        public var duration(get,set):String;
public function  set_duration(k:String):String        {
            return this._Str_2467 = k;
        }
public function  get_duration():String
        {
            if (this._Str_1430 != null)
            {
                return this._Str_1430._Str_24960();
            }
            return this._Str_2467;
        }

        public function _Str_17310():Int
        {
            if (this._Str_1430 != null)
            {
                if (Std.is(this._Str_1430 , AdSlot))
                {
                    return Std.downcast(this._Str_1430 , AdSlot)._Str_19793();
                }
                return this._Str_1430.getDurationAsInt();
            }
            return 0;
        }

        public function _Str_26008():String
        {
            return Std.string(this._Str_17310());
        }

        public function _Str_25907():Int
        {
            if (this._Str_1430 != null)
            {
                return this._Str_1430._Str_21832();
            }
            return this._Str_17310();
        }

        public function _Str_9456():Bool
        {
            return this._Str_5542 > -1;
        }

        public var overrideStartTimeSeconds(never,set):Int;
public function  set_overrideStartTimeSeconds(k:Int):Int        {
            return this._Str_5542 = k;
        }

        public function _Str_24674():String
        {
            if (this._Str_1430 != null)
            {
                if (Std.is(this._Str_1430 , AdSlot))
                {
                    if (this._Str_9456())
                    {
                        return Timestamp._Str_4110(this._Str_5542);
                    }
                    return "00:00:00";
                }
                if (this._Str_9456())
                {
                    return Timestamp._Str_4110(this._Str_5542);
                }
                return this._Str_1430.startTime;
            }
            if (this._Str_9456())
            {
                return Timestamp._Str_4110(this._Str_5542);
            }
            return this._Str_990;
        }

        public function getStartTimeAsSeconds():Int
        {
            if (this._Str_1430 != null)
            {
                if (Std.is(this._Str_1430 , AdSlot))
                {
                    if (this._Str_9456())
                    {
                        return this._Str_5542;
                    }
                    return 0;
                }
                if (this._Str_9456())
                {
                    return this._Str_5542;
                }
                return this._Str_1430.getStartTimeAsSeconds();
            }
            if (this._Str_9456())
            {
                return this._Str_5542;
            }
            return 0;
        }

        public function _Str_17397():String
        {
            return "Author not available";
        }

        public function getType():String
        {
            return this.isRTMP() ? "rtmp" : "http";
        }

        public function _Str_21970():String
        {
            if (this._Str_1430 != null)
            {
                return this._Str_1430.baseURL;
            }
            return null;
        }

        
        public var filename(get,set):String;
public function  set_filename(k:String):String        {
            return this._Str_1673 = k;
        }
public function  get_filename():String
        {
            return this._Str_1673;
        }

        public function _Str_5059(k:Bool=true):String
        {
            if (this._Str_1430 != null)
            {
                if (k)
                {
                    return this._Str_1430.streamName;
                }
                return this._Str_1430._Str_24252;
            }
            return this._Str_1673;
        }

        
        public var url(get,set):String;
public function  set_url(k:String):String        {
            return this._Str_577 = k;
        }
public function  get_url():String
        {
            if (this._Str_1430 != null)
            {
                return this._Str_1430.url;
            }
            return this._Str_577;
        }

        
        public var mimeType(get,set):String;
public function  set_mimeType(k:String):String        {
            return this._Str_2230 = k;
        }
public function  get_mimeType():String
        {
            return this._Str_2230;
        }

        public function isInteractive():Bool
        {
            if (this._Str_1430 != null)
            {
                if (Std.is(this._Str_1430 , AdSlot))
                {
                    return cast(this._Str_1430, AdSlot).isInteractive();
                }
            }
            return false;
        }

        public var loadOnDemand(get,never):Bool;
public function  get_loadOnDemand():Bool
        {
            if (this._Str_1430 != null)
            {
                if (Std.is(this._Str_1430 , AdSlot))
                {
                    return cast(this._Str_1430, AdSlot).loadOnDemand;
                }
            }
            return false;
        }

        public function getQualifiedStreamAddress():String
        {
            if (this._Str_1430 != null)
            {
                return this._Str_1430.getQualifiedStreamAddress();
            }
            if (this.url != null)
            {
                if (this.filename != null)
                {
                    if (StringUtils._Str_17635(StringUtils.trim(this.url), "/"))
                    {
                        if (!StringUtils._Str_4861(StringUtils.trim(this.filename), "/"))
                        {
                            return this.url + this.filename;
                        }
                        return this.url + StringUtils.trim(this.filename).substr(1);
                    }
                    if (StringUtils._Str_4861(StringUtils.trim(this.filename), "/"))
                    {
                        return this.url + this.filename;
                    }
                    return (this.url + "/") + this.filename;
                }
                return StringUtils.trim(this.url);
            }
            if (this.filename != null)
            {
                return this.filename;
            }
            return null;
        }

        public function _Str_16634():Bool
        {
            return Std.is(this._Str_1430 , AdSlot);
        }

        public function isRTMP():Bool
        {
            if (this._Str_1430 != null)
            {
                return this._Str_1430.isRTMP();
            }
            return StringUtils._Str_4861(StringUtils.trim(this._Str_577), "rtmp://");
        }

        public function _Str_25252():Bool
        {
            return !this.isRTMP();
        }

        public function _Str_11204()
        {
            if (this._Str_16634())
            {
                cast(this._Str_1430, AdSlot)._Str_11204();
            }
        }

        public function _Str_10174():Bool
        {
            if (this._Str_16634())
            {
                return cast(this._Str_1430, AdSlot)._Str_10174();
            }
            return false;
        }

        public function _Str_22734():Bool
        {
            return true;
        }

        public function toShowStreamConfigObject():ASObject
        {
            var k:ASObject = new ASObject();
            k.file = this.getQualifiedStreamAddress();
            k.duration = this.duration;
            return k;
        }

        public function toShortString(k:Bool=false):String
        {
            return ((("{ type: " + (this.isInteractive() ? "interactive" : (this.isRTMP() ? "rtmp" : "http"))) + ", ") + this._Str_1430.toShortString()) + " }";
        }

        public function toString(k:Bool=false):String
        {
            return (((((((((((((((((((((((((((((("{ type: " + (this.isInteractive() ? "interactive" : (this.isRTMP() ? "rtmp" : "http"))) + ", stream: (") + this._Str_1430) + ")") + ", played: ") + Std.string(this._Str_5596)) + ", overrideStartTimeSeconds: ") + Std.string(this._Str_5542)) + ", provider: ") + this._Str_4904) + ", description: ") + this._Str_1858) + ", title: ") + this._title) + ", link: ") + this._Str_1676) + ", guid: ") + this._Str_18387) + ", publishDate: ") + this._Str_18379) + ", startTime: ") + this._Str_990) + ", duration: ") + this._Str_2467) + ", url: ") + this._Str_577) + ", filename: ") + this._Str_1673) + ", mimeType: ") + this._Str_2230) + "}";
        }
    }

