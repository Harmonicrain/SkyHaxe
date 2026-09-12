package com.sulake.habbo.help.cfh.registry.instantmessage
;
    import com.sulake.core.utils.Map;

     class InstantMessageRegistry 
    {
        static inline final _Str_7723= 5;
        static inline final _Str_12594= 20;

        var _registry:Map;
        var _nextIndex:Int = 0;
        var _purgeCounter:Int = 0;
        var _holdPurges:Bool = false;

        public function new()
        {
            this._registry = new Map();
        }

        public function addItem(k:Int, _arg_2:String, _arg_3:String)
        {
            var _local_4:Vector<InstantMessageRegistryItem> = null;
            var _local_5:Vector<InstantMessageRegistryItem> = null;
            if (this._registry.hasKey(k))
            {
                _local_4 = this._registry.getValue(k);
                _local_4.push(new InstantMessageRegistryItem(this._nextIndex++, k, _arg_2, _arg_3));
                this._registry.remove(k);
                this._registry.add(k, _local_4);
            }
            else
            {
                _local_5 = new Vector<InstantMessageRegistryItem>();
                _local_5.push(new InstantMessageRegistryItem(this._nextIndex++, k, _arg_2, _arg_3));
                this._registry.add(k, _local_5);
            }
            this._purgeCounter++;
            if ((this._purgeCounter % 3) == 0)
            {
                this._Str_18273();
            }
        }

        function _Str_18273()
        {
            var _local_2:Vector<InstantMessageRegistryItem> = null;
            var _local_3:Vector<InstantMessageRegistryItem> = null;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            if (this._holdPurges)
            {
                return;
            }
            var k = 0;
            while ((k : UInt) < this._registry.length)
            {
                _local_2 = this._registry.getWithIndex(k);
                _local_3 = new Vector<InstantMessageRegistryItem>(0);
                if (((_local_2 != null) && (_local_2.length > 0)))
                {
                    _local_4 = _local_2[0].userId;
                    _local_5 = 0;
                    while (_local_5 < _local_2.length)
                    {
                        _local_6 = Std.int(Date.now().getTime() - _local_2[_local_5].chatTime.getTime());
                        _local_7 = Std.int(_local_6 / 65500);
                        if (_local_7 <= 15)
                        {
                            _local_3.push(_local_2[_local_5]);
                        }
                        _local_5++;
                    }
                    if (_local_3.length > _Str_12594)
                    {
                        _local_3.splice(0, (_local_3.length - (_Str_12594 - _Str_7723)));
                    }
                    _local_2.splice(0, _local_2.length);
                    _local_2 = _local_2.concat(_local_3);
                    this._registry.remove(_local_4);
                    this._registry.add(_local_4, _local_2);
                }
                k++;
            }
        }

        public var _Str_7724(never,set):Bool;
public function  set__Str_7724(k:Bool):Bool        {
            return this._holdPurges = k;
        }

        public function getItemsByUser(k:Int):Vector<InstantMessageRegistryItem>
        {
            return this._registry.getValue(k);
        }

        public function _Str_23839(k:Int):Bool
        {
            var _local_2= this.getItemsByUser(k);
            if (_local_2 != null)
            {
                return this.getItemsByUser(k).length > 0;
            }
            return false;
        }

        public function _Str_24133():Bool
        {
            return this._registry.length > 0;
        }

        public function _Str_6828():Map
        {
            return this._registry;
        }

        public function getItem(k:Int, _arg_2:UInt):InstantMessageRegistryItem
        {
            var _local_3= this.getItemsByUser(k);
            var _local_4 = 0;
            while (_local_4 < _local_3.length)
            {
                if ((_local_3[_local_4].index : UInt) == _arg_2)
                {
                    return _local_3[_local_4];
                }
                _local_4++;
            }
            return null;
        }
    }

