package com.sulake.habbo.avatar.actions
;
    import com.sulake.core.assets.IAssetLibrary;

     class AvatarActionManager 
    {
        var _assets:IAssetLibrary;
        var _actions:ASDictionary<ASAny,ASAny>;
        var _defaultAction:ActionDefinition;
        var _defaultLayAction:ActionDefinition;

        public function new(k:IAssetLibrary, _arg_2:com.sulake.core.utils.xml.XML)
        {
            this._assets = k;
            this._actions = new ASDictionary<ASAny,ASAny>();
            this.updateActions(_arg_2);
        }

        public function updateActions(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:String = null;
            var _local_4:ActionDefinition = null;
            this._defaultAction = null;
            this._defaultLayAction = null;
            final _iter_ = k.child("action"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = _local_2.attribute("state").toString();
                if (_local_3 != "")
                {
                    _local_4 = new ActionDefinition(_local_2);
                    this._actions[_local_3] = _local_4;
                }
            }
            this.parseActionOffsets();
        }

        function parseActionOffsets()
        {
            var k:ActiveActionData = null;
            var _local_2:ActionDefinition = null;
            var _local_3:String = null;
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:String = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = Math.NaN;
            var _local_10:com.sulake.core.utils.xml.XML = null;
            final _iter_ = this._actions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = _local_2.state;
                if (this._assets.hasAsset(("action_offset_" + _local_3)))
                {
                    _local_4 = ((this._assets.getAssetByName(("action_offset_" + _local_3)).content : com.sulake.core.utils.xml.XML) );
                    final _iter_ = _local_4.child("offset"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_10  = _tmp_;
                        _local_5 = _local_10.attribute("size").toString();
                        _local_6 = ASCompat.parseInt(_local_10.attribute("direction").toString());
                        _local_7 = ASCompat.parseInt(_local_10.attribute("x").toString());
                        _local_8 = ASCompat.parseInt(_local_10.attribute("y").toString());
                        _local_9 = ASCompat.toNumber(ASCompat.xmlListToString(_local_10.attribute("z")));
                        _local_2.setOffsets(_local_5, _local_6, [_local_7, _local_8, _local_9]);
                    }
                }
            }
        }

        public function _Str_1675(k:String):ActionDefinition
        {
            var _local_2:ActionDefinition = null;
            final _iter_ = this._actions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.id == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_2018(k:String):ActionDefinition
        {
            return this._actions[k];
        }

        public function getDefaultAction():ActionDefinition
        {
            var k:ActionDefinition = null;
            if (this._defaultAction != null)
            {
                return this._defaultAction;
            }
            final _iter_ = this._actions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.isDefault)
                {
                    this._defaultAction = k;
                    return k;
                }
            }
            return null;
        }

        public function getDefaultLayAction():ActionDefinition
        {
            if (this._defaultLayAction != null)
            {
                return this._defaultLayAction;
            }
            this._defaultLayAction = this.getDefaultAction().copy();
            this._defaultLayAction.setGeometryType("horizontal");
            this._defaultLayAction.setState("lay");
            this._defaultLayAction.setAssetPartDefinition("lay");
            return this._defaultLayAction;
        }

        public function _Str_781(k:Array<ASAny>, _arg_2:String, _arg_3:Int):Array<ASAny>
        {
            var _local_4:Array<ASAny> = null;
            var _local_5:ActiveActionData = null;
            var _local_6:ActionDefinition = null;
            var _local_7 = 0;
            _local_7 = 0;
            while (_local_7 < k.length)
            {
                _local_5 = ASCompat.dynamicAs(k[_local_7] , ActiveActionData);
                _local_6 = ASCompat.dynamicAs(this._actions[_local_5.actionType] , ActionDefinition);
                if (((!(_local_6 == null)) && (!(_local_6.getOffsets(_arg_2, _arg_3) == null))))
                {
                    _local_4 = _local_6.getOffsets(_arg_2, _arg_3);
                }
                _local_7++;
            }
            return _local_4;
        }

        public function isHeadTurnPreventedByAction(k:Array<ASAny>):Array<ASAny>
        {
            var _local_3:IActiveActionData = null;
            var _local_4:ActionDefinition = null;
            k = this._Str_1247(k);
            var _local_2= new Array<ASAny>();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                _local_4 = this._actions[_local_3.actionType];
                if (_local_4 != null)
                {
                    _local_3.definition = _local_4;
                    _local_2.push(_local_3);
                }
            }
            ASCompat.ASArray.sort(_local_2, this.orderByPrecedence);
            return _local_2;
        }

        function _Str_1247(k:Array<ASAny>):Array<ASAny>
        {
            var _local_4:ActiveActionData = null;
            var _local_5:ActionDefinition = null;
            var _local_6 = 0;
            var _local_7:String = null;
            var _local_2= new Array<ASAny>();
            var _local_3= new Array<ASAny>();
            _local_6 = 0;
            while (_local_6 < k.length)
            {
                _local_4 = ASCompat.dynamicAs(k[_local_6] , ActiveActionData);
                _local_5 = ASCompat.dynamicAs(this._actions[_local_4.actionType] , ActionDefinition);
                if (_local_5 != null)
                {
                    _local_3 = _local_3.concat(_local_5.getPrevents(_local_4.actionParameter));
                }
                _local_6++;
            }
            _local_6 = 0;
            while (_local_6 < k.length)
            {
                _local_4 = ASCompat.dynamicAs(k[_local_6] , ActiveActionData);
                _local_7 = _local_4.actionType;
                if (_local_4.actionType == "fx")
                {
                    _local_7 = (_local_7 + ("." + _local_4.actionParameter));
                }
                if (_local_3.indexOf(_local_7) == -1)
                {
                    _local_2.push(_local_4);
                }
                _local_6++;
            }
            return _local_2;
        }

        function orderByPrecedence(k:IActiveActionData, _arg_2:IActiveActionData):Float
        {
            var _local_3:Float = k.definition.precedence;
            var _local_4:Float = _arg_2.definition.precedence;
            if (_local_3 < _local_4)
            {
                return 1;
            }
            if (_local_3 > _local_4)
            {
                return -1;
            }
            return 0;
        }
    }


