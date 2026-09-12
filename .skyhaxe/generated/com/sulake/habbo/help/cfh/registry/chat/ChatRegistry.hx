package com.sulake.habbo.help.cfh.registry.chat
;
	import com.sulake.habbo.help.cfh.registry.chat.ChatRegistryItem;

     class ChatRegistry 
    {
        static inline final _Str_14285= 120;
        static inline final _Str_7723= 20;

        var _registry:Vector<ChatRegistryItem>;
        var _nextIndex:UInt = 0;
        var _holdPurges:Bool = false;

        public function new()
        {
            this._registry = new Vector<ChatRegistryItem>(0);
        }

        public function _Str_24133():Bool
        {
            return this._registry.length > 0;
        }

        public function _Str_20222(k:Int):Bool
        {
            return this._Str_23394(k).length > 0;
        }

        public function _Str_6828():Vector<ChatRegistryItem>
        {
            return this._registry;
        }

        public function addItem(k:Int, _arg_2:String, _arg_3:Int, _arg_4:String, _arg_5:String)
        {
            this._registry.push(new ChatRegistryItem(this._nextIndex++, k, _arg_2, _arg_3, _arg_4, _arg_5));
            this._Str_18273();
        }

        public var _Str_7724(never,set):Bool;
public function  set__Str_7724(k:Bool):Bool        {
            return this._holdPurges = k;
        }

        function _Str_18273()
        {
            var _local_3 = 0;
            var _local_4 = 0;
            if (this._holdPurges)
            {
                return;
            }
            var k= new Vector<ChatRegistryItem>(0);
            var _local_2 = 0;
            while (_local_2 < this._registry.length)
            {
                _local_3 = Std.int(Date.now().getTime() - this._registry[_local_2].chatTime.getTime());
                _local_4 = Std.int(_local_3 / 65500);
                if (_local_4 <= 15)
                {
                    k.push(this._registry[_local_2]);
                }
                _local_2++;
            }
            if (k.length > _Str_14285)
            {
                k.splice(0, (k.length - (_Str_14285 - _Str_7723)));
            }
            this._registry.splice(0, this._registry.length);
            this._registry = this._registry.concat(k);
        }

        public function getItem(k:UInt):ChatRegistryItem
        {
            var _local_2 = 0;
            while (_local_2 < this._registry.length)
            {
                if ((this._registry[_local_2].index : UInt) == k)
                {
                    return this._registry[_local_2];
                }
                _local_2++;
            }
            return null;
        }

        public function getItemsByUser(k:Int):Vector<ChatRegistryItem>
        {
            var _local_2= new Vector<ChatRegistryItem>(0);
            var _local_3 = 0;
            while (_local_3 < this._registry.length)
            {
                if (this._registry[_local_3].userId == k)
                {
                    _local_2.push(this._registry[_local_3]);
                }
                _local_3++;
            }
            return _local_2;
        }

        function _Str_23394(k:Int):Vector<ChatRegistryItem>
        {
            var _local_2= new Vector<ChatRegistryItem>(0);
            var _local_3 = 0;
            while (_local_3 < this._registry.length)
            {
                if (this._registry[_local_3].userId != k)
                {
                    _local_2.push(this._registry[_local_3]);
                }
                _local_3++;
            }
            return _local_2;
        }
    }

