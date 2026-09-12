package org.openvideoads.vast.server.request
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.util.BrowserUtils;
    import org.openvideoads.vast.model.VideoAdServingTemplate;
    import org.openvideoads.vast.server.response._Str_3802;
    import org.openvideoads.vast.server.response.AdServerTemplate;

     class AdServerRequest extends Debuggable 
    {
        var _Str_2297:AdServerConfig = null;
        var _Str_6221:Array<ASAny>;
        var _Str_8930:Int = 0;
        var _Str_4164:String = null;
        var _Str_15941:Bool = false;
        var _Str_18991:Bool = false;
        var _index:Int = 0;

        public function new(k:AdServerConfig=null)
        {
            this._Str_6221 = new Array<ASAny>();
            super();
            if (k != null)
            {
                this._Str_2297 = k;
            }
        }

        
        public var config(get,set):AdServerConfig;
public function  set_config(k:AdServerConfig):AdServerConfig        {
            return this._Str_2297 = k;
        }
public function  get_config():AdServerConfig
        {
            if (this._Str_2297 == null)
            {
                this._Str_2297 = new AdServerConfig();
            }
            return this._Str_2297;
        }

        
        public var callOnDemand(get,set):Bool;
public function  set_callOnDemand(k:Bool):Bool        {
            return this._Str_18991 = k;
        }
public function  get_callOnDemand():Bool
        {
            return this._Str_18991;
        }

        public function forceImpressionServing():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297.forceImpressionServing;
            }
            return false;
        }

        public function _Str_14997():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297.ensureSingleAdUnitRecordedPerInlineAd;
            }
            return true;
        }

        public var timeoutInSeconds(get,never):Int;
public function  get_timeoutInSeconds():Int
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297.timeoutInSeconds;
            }
            return -1;
        }

        public function isWrapped():Bool
        {
            return false;
        }

        public function includesLinearAds():Bool
        {
            return this._Str_15941;
        }

        public function _Str_22402():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297._Str_25364();
            }
            return false;
        }

        public function _Str_19604(k:String, _arg_2:String, _arg_3:String)
        {
            if (this._Str_6221 == null)
            {
                this._Str_6221 = new Array<ASAny>();
            }
            var _local_4:ASObject = new ASObject();
            _local_4.id = k;
            _local_4.zone = _arg_2;
            _local_4.slotType = _arg_3;
            _local_4.assigned = false;
            if (this._Str_15941 == false)
            {
                this._Str_15941 = StringUtils._Str_4861(_arg_3, "LINEAR");
            }
            this._Str_6221.push(_local_4);
        }

        public function _Str_19077():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297.addCacheBuster;
            }
            return false;
        }

        public function parseWrappedAdTags():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297.parseWrappedAdTags;
            }
            return false;
        }

        public function serverType():String
        {
            return this.config.serverType;
        }

        public var _Str_20400(get,never):Bool;
public function  get__Str_20400():Bool
        {
            return true;
        }

        public var _Str_23137(get,never):Array<ASAny>;
public function  get__Str_23137():Array<ASAny>
        {
            return this._Str_6221;
        }

        function _Str_24947(k:String):String
        {
            var _local_2= new compat.RegExp("__api-address__", "g");
            k = _local_2.replace(k, this.config.apiServerAddress);
            return k;
        }

        function _Str_23999(k:String, _arg_2:ASObject):String
        {
            return this._Str_2297.customProperties.completeTemplate(k, ((this._Str_2297 != null) ? this._Str_2297._Str_22972() : false));
        }

        function _Str_22310(k:String):String
        {
            var _local_2:compat.RegExp = null;
            if (this._Str_6221 != null)
            {
                if (this._Str_6221.length > 0)
                {
                    _local_2 = new compat.RegExp("__zone__", "g");
                    k = _local_2.replace(k, this._Str_6221[0].zone);
                }
            }
            return k;
        }

        function _Str_22322(k:String):String
        {
            return k;
        }

        function _Str_25758(k:String):String
        {
            var _local_2= new compat.RegExp("__allow-vpaid__", "g");
            k = ASCompat.stringReplace(k, _local_2, this.config.allowVPAID);
            return k;
        }

        function _Str_23118(k:String):String
        {
            var _local_2= new compat.RegExp("__max-duration__", "g");
            k = ASCompat.stringReplace(k, _local_2, this.config.maxDuration);
            return k;
        }

        function _Str_25350(k:String):String
        {
            var _local_2= new compat.RegExp("__as-version__", "g");
            k = _local_2.replace(k, this.config.asVersion);
            return k;
        }

        function _Str_22954(k:String):String
        {
            var _local_2= new compat.RegExp("__player-height__", "g");
            k = ASCompat.stringReplace(k, _local_2, this.config.playerHeight);
            return k;
        }

        function _Str_22498(k:String):String
        {
            var _local_2= new compat.RegExp("__player-width__", "g");
            k = ASCompat.stringReplace(k, _local_2, this.config.playerWidth);
            return k;
        }

        function _Str_22616(k:String):String
        {
            var _local_2= new compat.RegExp("__media-url__", "g");
            k = _local_2.replace(k, this.config.mediaUrl);
            return k;
        }

        function _Str_25869(k:String):String
        {
            var _local_2= new compat.RegExp("__stream-url__", "g");
            k = _local_2.replace(k, this.config.streamUrl);
            return k;
        }

        function _Str_24017(k:String):String
        {
            var _local_2= new compat.RegExp("__page-stream-url__", "g");
            k = _local_2.replace(k, this.config.pageStreamUrl);
            return k;
        }

        function _Str_24226(k:String):String
        {
            var _local_2:compat.RegExp = null;
            if (k.indexOf("__page-url__") > -1)
            {
                _local_2 = new compat.RegExp("__page-url__", "g");
                k = _local_2.replace(k, BrowserUtils._Str_11172(true, this._Str_2297.encodeVars));
            }
            return k;
        }

        function _Str_22628(k:String):String
        {
            var _local_2:compat.RegExp = null;
            if (k.indexOf("__referrer__") > -1)
            {
                _local_2 = new compat.RegExp("__referrer__", "g");
                k = _local_2.replace(k, BrowserUtils._Str_18507(true, this._Str_2297.encodeVars));
            }
            return k;
        }

        function _Str_22630(k:String):String
        {
            var _local_2:compat.RegExp = null;
            if (k.indexOf("__domain__") > -1)
            {
                _local_2 = new compat.RegExp("__domain__", "g");
                k = _local_2.replace(k, BrowserUtils._Str_12788(true, this._Str_2297.encodeVars));
            }
            return k;
        }

        function _Str_23956(k:String):String
        {
            var _local_2= new compat.RegExp("__format__", "g");
            k = _local_2.replace(k, this.config.format);
            return k;
        }

        function _Str_22276(k:String):String
        {
            var _local_2= new compat.RegExp("__random-number__", "g");
            k = _local_2.replace(k, ("R" + Std.string(Math.random())));
            return k;
        }

        function _Str_24848(k:String):String
        {
            var _local_2= new compat.RegExp("__timestamp__", "g");
            k = _local_2.replace(k, Std.string(Date.now().getTime()));
            return k;
        }

        function _Str_24505(k:String):String
        {
            var _local_2= new compat.RegExp("__allow-duplicates-as-binary__", "g");
            k = _local_2.replace(k, (this._Str_2297.allowAdRepetition ? "1" : "0"));
            return k;
        }

        function _Str_24981(k:String):String
        {
            var _local_2= new compat.RegExp("__allow-duplicates-as-boolean__", "g");
            k = _local_2.replace(k, (this._Str_2297.allowAdRepetition ? "true" : "false"));
            return k;
        }

        function _Str_23868(k:String):String
        {
            var _local_2= new compat.RegExp("__amp__", "g");
            k = _local_2.replace(k, "&");
            return k;
        }

        function _Str_25597(k:String):String
        {
            var _local_2= new compat.RegExp("__partner-id__", "g");
            k = _local_2.replace(k, this.config.partnerId);
            return k;
        }

        function _Str_24502(k:String):String
        {
            var _local_2= new compat.RegExp("__media-id__", "g");
            k = _local_2.replace(k, this.config.mediaId);
            return k;
        }

        function _Str_22983(k:String):String
        {
            var _local_2= new compat.RegExp("__media-title__", "g");
            k = _local_2.replace(k, this.config.mediaTitle);
            return k;
        }

        function _Str_22049(k:String):String
        {
            var _local_2= new compat.RegExp("__media-description__", "g");
            k = _local_2.replace(k, this.config.mediaDescription);
            return k;
        }

        function _Str_24664(k:String):String
        {
            var _local_2= new compat.RegExp("__media-categories__", "g");
            k = _local_2.replace(k, this.config.mediaCategories);
            return k;
        }

        function _Str_25301(k:String):String
        {
            var _local_2= new compat.RegExp("__media-keywords__", "g");
            k = _local_2.replace(k, this.config.mediaKeywords);
            return k;
        }

        
        public var index(get,set):Int;
public function  set_index(k:Int):Int        {
            return this._index = k;
        }
public function  get_index():Int
        {
            return this._index;
        }

        public function _Str_19881():Bool
        {
            if (this._Str_2297._Str_23936())
            {
                return this._Str_8930 < this._Str_2297._Str_14867;
            }
            return false;
        }

        public var _Str_26371(get,never):Int;
public function  get__Str_26371():Int
        {
            return this._Str_8930;
        }

        public function _Str_25223():AdServerRequest
        {
            var k:AdServerConfig = null;
            var _local_2:AdServerRequest = null;
            if (this._Str_19881())
            {
                k = this._Str_2297._Str_24012(this._Str_8930);
                if (k != null)
                {
                    _local_2 = AdServerRequestType.create(k.serverType);
                    this._Str_8930++;
                    _local_2.config = k;
                    _local_2.index = this._Str_8930;
                    return _local_2;
                }
            }
            return null;
        }

        public function formRequest(k:Array<ASAny>=null):String
        {
            if (this._Str_2297.tag == null)
            {
                this._Str_4164 = this._Str_15243(this.config.template, k);
            }
            else
            {
                this._Str_4164 = this._Str_15243(this._Str_2297.tag, k);
            }
            return this._Str_4164;
        }

        public var _Str_25921(get,never):String;
public function  get__Str_25921():String
        {
            return this._Str_4164;
        }

        function _Str_15243(k:String, _arg_2:Array<ASAny>=null):String
        {
            var _local_3:String = null;
            if (k != null)
            {
                _local_3 = k;
                if (_arg_2 != null)
                {
                    this._Str_6221 = _arg_2;
                }
                _local_3 = this._Str_24947(_local_3);
                _local_3 = this._Str_23868(_local_3);
                _local_3 = this._Str_23999(_local_3, this.config.customProperties);
                _local_3 = this._Str_22276(_local_3);
                _local_3 = this._Str_24848(_local_3);
                _local_3 = this._Str_24505(_local_3);
                _local_3 = this._Str_24981(_local_3);
                _local_3 = this._Str_22310(_local_3);
                _local_3 = this._Str_22322(_local_3);
                _local_3 = this._Str_24226(_local_3);
                _local_3 = this._Str_22628(_local_3);
                _local_3 = this._Str_22630(_local_3);
                _local_3 = this._Str_25869(_local_3);
                _local_3 = this._Str_22616(_local_3);
                _local_3 = this._Str_24017(_local_3);
                _local_3 = this._Str_25758(_local_3);
                _local_3 = this._Str_23956(_local_3);
                _local_3 = this._Str_23118(_local_3);
                _local_3 = this._Str_25350(_local_3);
                _local_3 = this._Str_22954(_local_3);
                _local_3 = this._Str_22498(_local_3);
                _local_3 = this._Str_25597(_local_3);
                _local_3 = this._Str_24502(_local_3);
                _local_3 = this._Str_22983(_local_3);
                _local_3 = this._Str_22049(_local_3);
                _local_3 = this._Str_22049(_local_3);
                _local_3 = this._Str_24664(_local_3);
                _local_3 = this._Str_25301(_local_3);
                return _local_3;
            }
            return "";
        }

        public function _Str_26440(k:String, _arg_2:ASObject):String
        {
            return k;
        }

        public function _Str_19422(k:_Str_3802):AdServerTemplate
        {
            var _local_2= new VideoAdServingTemplate(k, this, this._Str_20400, this._Str_23137);
            _local_2.isMaster = true;
            return _local_2;
        }

        override public function toJSObject():ASObject
        {
            var k:ASObject = new ASObject();
            k = {
                "uid":_uid,
                "index":this._index,
                "adServerType":((this.config != null) ? this.config.type : "unknown"),
                "formedTag":this._Str_4164,
                "onDemand":this._Str_18991
            }
;            return k;
        }
    }

