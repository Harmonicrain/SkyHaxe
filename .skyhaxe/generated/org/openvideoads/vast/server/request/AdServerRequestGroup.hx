package org.openvideoads.vast.server.request
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.vast.schedule.ads.AdSlot;

     class AdServerRequestGroup extends Debuggable 
    {
        var _Str_5295:String = null;
        var _Str_7775:Bool = false;
        var _Str_2407:Array<ASAny>;

        public function new(k:String, _arg_2:Bool=false)
        {
            this._Str_2407 = new Array<ASAny>();
            super();
            this._Str_5295 = k;
            this._Str_7775 = _arg_2;
        }

        public var oneAdPerRequest(get,never):Bool;
public function  get_oneAdPerRequest():Bool
        {
            return this._Str_7775;
        }

        public function addAdSlot(k:AdSlot)
        {
            this._Str_2407.push(k);
        }

        
        public var serverType(get,set):String;
public function  get_serverType():String
        {
            return this._Str_5295;
        }
public function  set_serverType(k:String):String        {
            return this._Str_5295 = k;
        }

        public function getAdServerRequests():Array<ASAny>
        {
            var _local_2:AdServerRequest = null;
            var _local_3 = 0;
            var k= new Array<ASAny>();
            if (this._Str_2407.length > 0)
            {
                _local_3 = 0;
                while (_local_3 < this._Str_2407.length)
                {
                    _local_2 = AdServerRequestType.create(this._Str_2407[_local_3].adServerConfig.serverType);
                    _local_2.config = this._Str_2407[_local_3].adServerConfig;
                    _local_2._Str_19604(this._Str_2407[_local_3].adSlotID, this._Str_2407[_local_3].zone, this._Str_2407[_local_3].slotType);
                    k.push(_local_2);
                    _local_3++;
                }
            }
            return k;
        }

        public function getSingleAdServerRequest():AdServerRequest
        {
            var k:AdServerRequest = null;
            var _local_2 = 0;
            if (this._Str_2407.length > 0)
            {
                if (this._Str_2407[0].adServerConfig.serverType != null)
                {
                    k = AdServerRequestType.create(this._Str_2407[0].adServerConfig.serverType);
                    k.config = this._Str_2407[0].adServerConfig;
                    if (k != null)
                    {
                        _local_2 = 0;
                        while (_local_2 < this._Str_2407.length)
                        {
                            k._Str_19604(this._Str_2407[_local_2].adSlotID, this._Str_2407[_local_2].zone, this._Str_2407[_local_2].slotType);
                            _local_2++;
                        }
                        return k;
                    }
                }
            }
            return null;
        }
    }

