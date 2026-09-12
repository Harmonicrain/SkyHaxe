package com.sulake.core.localization
;

     class Localization implements ILocalization 
    {
        var _manager:ICoreLocalizationManager;
        var _key:String;
        var _value:String;
        var _parameters:ASDictionary<ASAny,ASAny>;
        var _listeners:Array<ASAny>;
        var _isInitialized:Bool = false;

        public function new(manager:ICoreLocalizationManager, key:String, value:String=null)
        {
            this._manager = manager;
            this._key = key;
            this._value = value;
        }

        public var isInitialized(get,never):Bool;
public function  get_isInitialized():Bool
        {
            return !(this._value == null);
        }

        public var value(get,never):String;
public function  get_value():String
        {
            return this.fillParameterValues();
        }

        public var raw(get,never):String;
public function  get_raw():String
        {
            return this._value;
        }

        public function setValue(value:String)
        {
            this._value = value;
            this.updateListeners();
        }

        public function registerListener(listener:ILocalizable)
        {
            if (this._listeners == null)
            {
                this._listeners = [];
            }
            if (this._listeners.indexOf(listener) == -1)
            {
                this._listeners.push(listener);
            }
            listener.localization = this.value;
        }

        public function removeListener(listener:ILocalizable)
        {
var index = 0;            if (this._listeners != null)
            {
index= this._listeners.indexOf(listener);
                if (index >= 0)
                {
                    this._listeners.splice(index, 1);
                }
            }
        }

        public function registerParameter(parameter:String, value:String, id:String="%")
        {
            if (this._parameters == null)
            {
                this._parameters = new ASDictionary<ASAny,ASAny>();
            }
            this._parameters[parameter] = {
                "id":id,
                "value":value
            }
;            this.updateListeners();
        }

        public function updateListeners()
        {
var listener:ILocalizable  = null;            if (this._listeners != null)
            {
                final _iter_ = this._listeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
listener = _tmp_;
                    listener.localization = this.value;
                }
            }
        }

        function fillParameterValues():String
        {
var _local_4:String  = null;            var _local_4:String = null;
            var _local_5:ASObject = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8:compat.RegExp = null;
            var _local_9 = 0;
            var _local_10:compat.RegExp = null;
            var _local_11:compat.RegExp = null;
            var _local_12 = 0;
            var _local_13:String = null;
            var _local_14:String = null;
            var _local_15:String = null;
            var k= this._value;
            if (k == null)
            {
                return null;
            }
            if (this._parameters != null)
            {
                final _iter_ = this._parameters; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
_local_4 = _tmp_;
                    _local_5 = this._parameters[_local_4];
                    _local_6 = ((_local_5.id + _local_4) + _local_5.id);
                    _local_7 = _local_5.value;
                    _local_8 = new compat.RegExp(_local_6, "gim");
                    k = _local_8.replace(k, _local_7);
                    if (k.toLowerCase().indexOf(((_local_5.id + "{") + _local_4)) >= 0)
                    {
                        switch (ASCompat.toInt(_local_7))
                        {
                            case 0:
                                _local_9 = 1;
                                
                            case 1:
                                _local_9 = 2;
                                
                            default:
                                _local_9 = 3;
                        }
                        _local_10 = new compat.RegExp((((_local_5.id + "\\{") + _local_4) + "\\|([^|]*)\\|([^|]*)\\|([^}]*)\\}"), "gim");
                        _local_11 = new compat.RegExp((_local_5.id + _local_5.id), "gim");
                        k = _local_10.replace(k, ("$" + Std.string(_local_9)));
                        k = _local_11.replace(k, _local_7);
                    }
                }
            }
            var _local_2= new compat.RegExp("%%%([A-Za-z0-9_])+%%%", "g");
            var _local_3:Array<ASAny> = (cast ASCompat.stringMatch(k, _local_2));
            if (_local_3 != null)
            {
                _local_12 = (_local_3.length - 1);
                while (_local_12 >= 0)
                {
                    _local_13 = _local_3[_local_12].substring(3, (ASCompat.toNumber(_local_3[_local_12].length) - 3));
                    _local_14 = ((this._key + ".") + _local_13);
                    _local_15 = this._manager.getLocalization(_local_14, _local_13);
                    k = ASCompat.stringReplace(k, _local_3[_local_12], _local_15);
                    _local_12--;
                }
            }
            return k;
        }
    }

