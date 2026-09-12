package org.openvideoads.vast.playlist
;
    import org.openvideoads.base.Debuggable;
    import flash.net.URLLoader;
    import org.openvideoads.vast.schedule.StreamSequence;
    import org.openvideoads.vast.config.groupings.ProvidersConfigGroup;
    import org.openvideoads.vast.schedule.ads.AdSlot;
    import org.openvideoads.vast.schedule.Stream;
    import flash.events.Event;
    import flash.events.ErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.events.*;
    import flash.net.*;
    import flash.xml.*;

     class DefaultPlaylist extends Debuggable implements _Str_4575 
    {
        var _Str_2519:Array<ASAny>;
        var _Str_2672:Int = 0;
        var _Str_15511:Int = 0;
        var _Str_3081:URLLoader = null;
        var _Str_20984:String = null;
        var _Str_17958:_Str_6835 = null;
        var _Str_7591:Bool = false;

        public function new(k:StreamSequence=null, _arg_2:ProvidersConfigGroup=null, _arg_3:ProvidersConfigGroup=null)
        {
            this._Str_2519 = new Array<ASAny>();
            super();
            this._Str_25631(k, _arg_2, _arg_3);
        }

        function initialise()
        {
            this._Str_2519 = new Array<ASAny>();
            this._Str_15511 = 0;
            this._Str_2672 = 0;
            this._Str_7591 = false;
        }

        public function _Str_25631(k:StreamSequence, _arg_2:ProvidersConfigGroup, _arg_3:ProvidersConfigGroup)
        {
            var _local_4 = 0;
            var _local_5:_Str_3480 = null;
            if (k != null)
            {
                _local_4 = 0;
                while (_local_4 < k.length)
                {
                    _local_5 = this.newPlaylistItem();
                    _local_5.index = _local_4;
                    _local_5.stream = k._Str_21989(_local_4);
                    if (Std.is(_local_5.stream , AdSlot))
                    {
                        if (!cast(_local_5.stream, AdSlot).isInteractive())
                        {
                            _local_5.provider = (_local_5.stream.isRTMP() ? _arg_3.rtmpProvider : _arg_3.httpProvider);
                            _local_5.streamer = (_local_5.stream.isRTMP() ? _arg_3._Str_10294 : _arg_3._Str_10463);
                        }
                        _local_5.providers = _arg_3;
                    }
                    else
                    {
                        _local_5.provider = (_local_5.stream.isRTMP() ? _arg_2.rtmpProvider : _arg_2.httpProvider);
                        _local_5.streamer = (_local_5.stream.isRTMP() ? _arg_2._Str_10294 : _arg_2._Str_10463);
                        _local_5.providers = _arg_2;
                    }
                    this._Str_2519.push(_local_5);
                    _local_4++;
                }
            }
        }

        public function _Str_25970():Bool
        {
            if (this.length > 0)
            {
                return this._Str_11606(0).loadOnDemand && this._Str_11606(0)._Str_10174();
            }
            return false;
        }

        public function _Str_24195():Bool
        {
            if (this.length > 0)
            {
                return this._Str_11606(0).isInteractive();
            }
            return false;
        }

        public function _Str_24277(k:Stream, _arg_2:Int)
        {
            if (((_arg_2 >= 0) && (_arg_2 < this._Str_2519.length)))
            {
                this._Str_2519[_arg_2].stream = k;
            }
        }

        public function _Str_16925(k:String, _arg_2:_Str_6835=null)
        {
            this._Str_17958 = _arg_2;
            this._Str_3081 = new URLLoader();
            this._Str_3081.addEventListener(Event.COMPLETE, (this._Str_13562 : ASAny));
            this._Str_3081.addEventListener(ErrorEvent.ERROR, (this.errorHandler : ASAny));
            this._Str_3081.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.errorHandler : ASAny));
            this._Str_3081.addEventListener(IOErrorEvent.IO_ERROR, (this.errorHandler : ASAny));
            this._Str_3081.load(new URLRequest(k));
        }

        function _Str_19142()
        {
            if (this._Str_17958 != null)
            {
                this._Str_17958._Str_16701(this);
            }
        }

        function _Str_13562(k:Event)
        {
            this._Str_20984 = this._Str_3081.data;
            this.loadFromString(this._Str_20984);
            this._Str_19142();
        }

        function errorHandler(k:Event)
        {
            this._Str_19142();
        }

        public function loadFromString(k:String)
        {
        }

        public function _Str_11606(k:Int):_Str_3480
        {
            if (this.length > k)
            {
                return this._Str_2519[k];
            }
            return null;
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            return this._Str_2519.length;
        }

        public function playlist():Array<ASAny>
        {
            return this._Str_2519;
        }

        public function newPlaylistItem():_Str_3480
        {
            return new DefaultPlaylistItem();
        }

        public function _Str_21786(k:_Str_3480)
        {
            this._Str_2519.push(k);
        }

        public function _Str_26029():Bool
        {
            return this._Str_7591;
        }

        public function rewind()
        {
            var k = 0;
            this._Str_2672 = 0;
            this._Str_7591 = true;
            if (this._Str_2519 != null)
            {
                k = 0;
                while (k < this._Str_2519.length)
                {
                    this._Str_2519[k].rewind();
                    k++;
                }
            }
        }

        public function reset()
        {
            var k = 0;
            this._Str_2672 = 0;
            if (this._Str_2519 != null)
            {
                k = 0;
                while (k < this._Str_2519.length)
                {
                    this._Str_2519[k].reset();
                    k++;
                }
            }
        }

        public var _Str_24840(get,never):Int;
public function  get__Str_24840():Int
        {
            return this._Str_15511;
        }

        public var _Str_23049(get,never):Int;
public function  get__Str_23049():Int
        {
            return this._Str_2672;
        }

        public function _Str_23946(k:Int=-1, _arg_2:Bool=false):com.sulake.core.utils.xml.XML
        {
            var _local_3 = 0;
            var _local_4:String = null;
            if (this._Str_2519 != null)
            {
                _local_3 = ((this._Str_2672 > 0) ? (this._Str_2672 - 1) : 0);
                if (_local_3 < this._Str_2519.length)
                {
                    if (k > -1)
                    {
                        this._Str_2519[_local_3].overrideStartTimeSeconds = k;
                    }
                    _local_4 = this.header();
                    _local_4 = (_local_4 + this._Str_2519[_local_3].toString(_arg_2));
                    _local_4 = (_local_4 + this.footer());
                    return new com.sulake.core.utils.xml.XML(_local_4);
                }
            }
            return null;
        }

        public function _Str_26276(k:Int=-1, _arg_2:Bool=false):_Str_3480
        {
            var _local_3 = 0;
            if (this._Str_2519 != null)
            {
                _local_3 = ((this._Str_2672 > 0) ? (this._Str_2672 - 1) : 0);
                if (_local_3 < this._Str_2519.length)
                {
                    if (k > -1)
                    {
                        this._Str_2519[_local_3].overrideStartTimeSeconds = k;
                    }
                    return this._Str_2519[_local_3];
                }
            }
            return null;
        }

        public function _Str_18453(k:Bool=false, _arg_2:Bool=true):String
        {
            var _local_3:String = null;
            if (this._Str_2519 != null)
            {
                if (((this._Str_2672 > 0) && _arg_2))
                {
                    this._Str_7591 = false;
                }
                if (this._Str_2672 < this._Str_2519.length)
                {
                    this._Str_15511 = this._Str_2672;
                    if (this._Str_2519[this._Str_2672].canPlay())
                    {
                        _local_3 = this.header();
                        _local_3 = (_local_3 + this._Str_2519[this._Str_2672].toString(k));
                        this._Str_2519[this._Str_2672].markAsPlayed();
                        _local_3 = (_local_3 + this.footer());
                        this._Str_2672++;
                        return _local_3;
                    }
                    this._Str_2672++;
                    return this._Str_18453(k, false);
                }
            }
            return null;
        }

        public function _Str_22737(k:Bool=false):com.sulake.core.utils.xml.XML
        {
            var _local_2= this._Str_18453(k);
            if (_local_2 != null)
            {
                return new com.sulake.core.utils.xml.XML(_local_2);
            }
            return null;
        }

        public function _Str_24342(k:Bool=false, _arg_2:Bool=true):_Str_3480
        {
            if (this._Str_2519 != null)
            {
                if (((this._Str_2672 > 0) && _arg_2))
                {
                    this._Str_7591 = false;
                }
                if (this._Str_2672 < this._Str_2519.length)
                {
                    this._Str_15511 = this._Str_2672;
                    if (this._Str_2519[this._Str_2672].canPlay())
                    {
                        this._Str_2519[this._Str_2672].markAsPlayed();
                        this._Str_2672++;
                        return this._Str_2519[(this._Str_2672 - 1)];
                    }
                    this._Str_2672++;
                    return this._Str_24342(k, false);
                }
            }
            return null;
        }

        public function _Str_18213(k:Bool=false):String
        {
            var _local_2:String = null;
            this._Str_7591 = false;
            if (this._Str_2519 != null)
            {
                if (this._Str_2672 >= 0)
                {
                    if (this._Str_2519[this._Str_2672].canPlay())
                    {
                        _local_2 = this.header();
                        _local_2 = (_local_2 + this._Str_2519[this._Str_2672].toString(k));
                        this._Str_2519[this._Str_2672].markAsPlayed();
                        _local_2 = (_local_2 + this.footer());
                        this._Str_2672--;
                        return _local_2;
                    }
                    this._Str_2672--;
                    return this._Str_18213(k);
                }
            }
            return null;
        }

        public function _Str_22903(k:Bool=false):com.sulake.core.utils.xml.XML
        {
            var _local_2= this._Str_18213(k);
            if (_local_2 != null)
            {
                return new com.sulake.core.utils.xml.XML(_local_2);
            }
            return null;
        }

        public function _Str_25316(k:Bool=false):_Str_3480
        {
            this._Str_7591 = false;
            if (this._Str_2519 != null)
            {
                if (this._Str_2672 >= 0)
                {
                    if (this._Str_2519[this._Str_2672].canPlay())
                    {
                        this._Str_2519[this._Str_2672].markAsPlayed();
                        this._Str_2672--;
                        return this._Str_2519[(this._Str_2672 + 1)];
                    }
                    this._Str_2672--;
                    return this._Str_25316(k);
                }
            }
            return null;
        }

        public function getModel():Array<ASAny>
        {
            return this._Str_2519;
        }

        public function _Str_23134(k:Bool=false):com.sulake.core.utils.xml.XML
        {
            return new com.sulake.core.utils.xml.XML(this.toString(k));
        }

        function header():String
        {
            return "";
        }

        function footer():String
        {
            return "";
        }

        public function _Str_10087():Array<ASAny>
        {
            var k= new Array<ASAny>();
            var _local_2 = 0;
            while (_local_2 < this._Str_2519.length)
            {
                k.push(this._Str_2519[_local_2].toShowStreamConfigObject());
                _local_2++;
            }
            return k;
        }

        public function toShortString(k:Bool=false):String
        {
            return this.toString(k);
        }

        public function toString(k:Bool=false):String
        {
            var _local_2= "";
            var _local_3 = 0;
            while (_local_3 < this._Str_2519.length)
            {
                _local_2 = (_local_2 + this._Str_2519[_local_3].toString(k));
                _local_3++;
            }
            return _local_2;
        }
    }

