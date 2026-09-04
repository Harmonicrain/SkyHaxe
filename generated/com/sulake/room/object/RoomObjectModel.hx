package com.sulake.room.object
;
    import com.sulake.core.utils.Map;

     class RoomObjectModel implements IRoomObjectModelController 
    {
        static inline final ROMC_MAP_KEYS_= "ROMC_MAP_KEYS_";
        static inline final ROMC_MAP_VALUES_= "ROMC_MAP_VALUES_";

        var _numberDataList:ASDictionary<ASAny,ASAny>;
        var _stringDataList:ASDictionary<ASAny,ASAny>;
        var _numberArrayDataList:ASDictionary<ASAny,ASAny>;
        var _stringArrayDataList:ASDictionary<ASAny,ASAny>;
        var _numberReadOnlyList:Array<ASAny>;
        var _stringReadOnlyList:Array<ASAny>;
        var _numberArrayReadOnlyList:Array<ASAny>;
        var _stringArrayReadOnlyList:Array<ASAny>;
        var _updateID:Int = 0;

        public function new()
        {
            this._numberDataList = new ASDictionary<ASAny,ASAny>();
            this._stringDataList = new ASDictionary<ASAny,ASAny>();
            this._numberArrayDataList = new ASDictionary<ASAny,ASAny>();
            this._stringArrayDataList = new ASDictionary<ASAny,ASAny>();
            this._numberReadOnlyList = [];
            this._stringReadOnlyList = [];
            this._numberArrayReadOnlyList = [];
            this._stringArrayReadOnlyList = [];
            this._updateID = 0;
        }

        public function dispose()
        {
            var k:String;
            if (this._numberDataList != null)
            {
                for (_tmp_ in this._numberDataList.keys())
                {
var k:String  = _tmp_;
                    this._numberDataList.remove(k);
                }
                this._numberDataList = null;
            }
            if (this._stringDataList != null)
            {
                for (_tmp_ in this._stringDataList.keys())
                {
var k:String  = _tmp_;
                    this._stringDataList.remove(k);
                }
                this._stringDataList = null;
            }
            if (this._numberArrayDataList != null)
            {
                for (_tmp_ in this._numberArrayDataList.keys())
                {
var k:String  = _tmp_;
                    this._numberArrayDataList.remove(k);
                }
                this._numberArrayDataList = null;
            }
            if (this._stringArrayDataList != null)
            {
                for (_tmp_ in this._stringArrayDataList.keys())
                {
var k:String  = _tmp_;
                    this._stringArrayDataList.remove(k);
                }
                this._stringArrayDataList = null;
            }
            this._stringReadOnlyList = [];
            this._numberReadOnlyList = [];
            this._stringArrayReadOnlyList = [];
            this._numberArrayReadOnlyList = [];
        }

        public function hasNumber(k:String):Bool
        {
            return !(this._numberDataList[k] == null);
        }

        public function hasNumberArray(k:String):Bool
        {
            return !(this._numberArrayDataList[k] == null);
        }

        public function hasString(k:String):Bool
        {
            return !(this._stringDataList[k] == null);
        }

        public function hasStringArray(k:String):Bool
        {
            return !(this._stringArrayDataList[k] == null);
        }

        public function getNumber(k:String):Float
        {
            return ASCompat.toNumber(this._numberDataList[k]);
        }

        public function getString(k:String):String
        {
            return this._stringDataList[k];
        }

        public function getNumberArray(k:String):Array<ASAny>
        {
            var _local_2:Array<ASAny> = this._numberArrayDataList[k];
            if (_local_2 != null)
            {
                _local_2 = _local_2.slice(0);
            }
            return _local_2;
        }

        public function getStringArray(k:String):Array<ASAny>
        {
            var _local_2:Array<ASAny> = this._stringArrayDataList[k];
            if (_local_2 != null)
            {
                _local_2 = _local_2.slice(0);
            }
            return _local_2;
        }

        public function getStringToStringMap(k:String):Map
        {
            var _local_5:Int;
            var _local_2= new Map();
            var _local_3= this.getStringArray((ROMC_MAP_KEYS_ + k));
            var _local_4= this.getStringArray((ROMC_MAP_VALUES_ + k));
            if ((((!(_local_3 == null)) && (!(_local_4 == null))) && (_local_3.length == _local_4.length)))
            {
                _local_5 = 0;
                while (_local_5 < _local_3.length)
                {
                    _local_2.add(_local_3[_local_5], _local_4[_local_5]);
                    _local_5++;
                }
            }
            return _local_2;
        }

        public function setNumber(k:String, _arg_2:Float, _arg_3:Bool=false)
        {
            if (this._numberReadOnlyList.indexOf(k) >= 0)
            {
                return;
            }
            if (_arg_3)
            {
                this._numberReadOnlyList.push(k);
            }
            if (this._numberDataList[k] != _arg_2)
            {
                this._numberDataList[k] = _arg_2;
                this._updateID++;
            }
        }

        public function setString(k:String, _arg_2:String, _arg_3:Bool=false)
        {
            if (this._stringReadOnlyList.indexOf(k) >= 0)
            {
                return;
            }
            if (_arg_3)
            {
                this._stringReadOnlyList.push(k);
            }
            if (this._stringDataList[k] != _arg_2)
            {
                this._stringDataList[k] = _arg_2;
                this._updateID++;
            }
        }

        public function setNumberArray(k:String, _arg_2:Array<ASAny>, _arg_3:Bool=false)
        {
            if (_arg_2 == null)
            {
                return;
            }
            if (this._numberArrayReadOnlyList.indexOf(k) >= 0)
            {
                return;
            }
            if (_arg_3)
            {
                this._numberArrayReadOnlyList.push(k);
            }
            var _local_4:Array<ASAny> = [];
            var _local_5:Int;
            _local_5 = 0;
            while (_local_5 < _arg_2.length)
            {
                if (Std.is(_arg_2[_local_5] , Float))
                {
                    _local_4.push(_arg_2[_local_5]);
                }
                _local_5++;
            }
            var _local_6:Array<ASAny> = this._numberArrayDataList[k];
            var _local_7= true;
            if (((!(_local_6 == null)) && (_local_6.length == _local_4.length)))
            {
                _local_5 = (_local_4.length - 1);
                while (_local_5 >= 0)
                {
                    if (ASCompat.toNumber(_local_4[_local_5] ) != ASCompat.toNumber(_local_6[_local_5] ))
                    {
                        _local_7 = false;
                        break;
                    }
                    _local_5--;
                }
            }
            else
            {
                _local_7 = false;
            }
            if (_local_7)
            {
                return;
            }
            this._numberArrayDataList[k] = _local_4;
            this._updateID++;
        }

        public function setStringArray(k:String, _arg_2:Array<ASAny>, _arg_3:Bool=false)
        {
            if (_arg_2 == null)
            {
                return;
            }
            if (this._stringArrayReadOnlyList.indexOf(k) >= 0)
            {
                return;
            }
            if (_arg_3)
            {
                this._stringArrayReadOnlyList.push(k);
            }
            var _local_4:Array<ASAny> = [];
            var _local_5:Int;
            _local_5 = 0;
            while (_local_5 < _arg_2.length)
            {
                if (Std.is(_arg_2[_local_5] , String))
                {
                    _local_4.push(_arg_2[_local_5]);
                }
                _local_5++;
            }
            var _local_6:Array<ASAny> = this._stringArrayDataList[k];
            var _local_7= true;
            if (((!(_local_6 == null)) && (_local_6.length == _local_4.length)))
            {
                _local_5 = (_local_4.length - 1);
                while (_local_5 >= 0)
                {
                    if (ASCompat.toString(_local_4[_local_5] ) != ASCompat.toString(_local_6[_local_5] ))
                    {
                        _local_7 = false;
                        break;
                    }
                    _local_5--;
                }
            }
            else
            {
                _local_7 = false;
            }
            if (_local_7)
            {
                return;
            }
            this._stringArrayDataList[k] = _local_4;
            this._updateID++;
        }

        public function setStringToStringMap(k:String, _arg_2:Map, _arg_3:Bool=false)
        {
            if (_arg_2 == null)
            {
                return;
            }
            this.setStringArray((ROMC_MAP_KEYS_ + k), _arg_2.getKeys(), _arg_3);
            this.setStringArray((ROMC_MAP_VALUES_ + k), _arg_2.getValues(), _arg_3);
        }

        public function getUpdateID():Int
        {
            return this._updateID;
        }
    }

