package com.sulake.habbo.avatar
;
    import com.sulake.core.utils.Map;

     class AvatarFigureContainer implements IAvatarFigureContainer 
    {
        var _parts:Map;

        public function new(k:String)
        {
            this._parts = new Map();
            this.parseAvatarFigure(k);
        }

        public function _Str_1016():Array<ASAny>
        {
            return this.partSets().getKeys();
        }

        public function _Str_744(k:String):Bool
        {
            return !(this.partSets().getValue(k) == null);
        }

        public function getPartSetId(k:String):Int
        {
            var _local_2= ASCompat.dynamicAs(this.partSets().getValue(k) , Map);
            if (_local_2 != null)
            {
                return ASCompat.toInt(_local_2.getValue("setid") );
            }
            return 0;
        }

        public function _Str_815(k:String):Array<ASAny>
        {
            var _local_2= ASCompat.dynamicAs(this.partSets().getValue(k) , Map);
            if (_local_2 != null)
            {
                return ASCompat.dynamicAs(_local_2.getValue("colorids") , Array);
            }
            return null;
        }

        public function _Str_830(k:String, _arg_2:Int, _arg_3:Array<ASAny>)
        {
            var _local_4= new Map();
            _local_4.add("type", k);
            _local_4.add("setid", _arg_2);
            _local_4.add("colorids", _arg_3);
            var _local_5= this.partSets();
            _local_5.remove(k);
            _local_5.add(k, _local_4);
        }

        public function _Str_923(k:String)
        {
            this.partSets().remove(k);
        }

        public function getFigureString():String
        {
            var _local_2:String;
            var _local_3:Array<ASAny>;
            var k:Array<ASAny> = [];
            for (_tmp_ in this.partSets().getKeys())
            {
_local_2  = _tmp_;
                _local_3 = [];
                _local_3.push(_local_2);
                _local_3.push(this.getPartSetId(_local_2));
                _local_3 = _local_3.concat(this._Str_815(_local_2));
                k.push(_local_3.join("-"));
            }
            return k.join(".");
        }

        function partSets():Map
        {
            if (this._parts == null)
            {
                this._parts = new Map();
            }
            return this._parts;
        }

        function parseAvatarFigure(k:String)
        {
            var _local_2:String;
            var _local_3:Array<ASAny>;
            var _local_4:String;
            var _local_5:Int;
            var _local_6:Array<ASAny>;
            var _local_7:Int;
            if (k == null)
            {
                k = "";
            }
            for (_tmp_ in k.split("."))
            {
_local_2  = _tmp_;
                _local_3 = (cast _local_2.split("-"));
                if (_local_3.length >= 2)
                {
                    _local_4 = ASCompat.toString(_local_3[0]);
                    _local_5 = ASCompat.parseInt(_local_3[1]);
                    _local_6 = new Array<ASAny>();
                    _local_7 = 2;
                    while (_local_7 < _local_3.length)
                    {
                        _local_6.push(ASCompat.parseInt(_local_3[_local_7]));
                        _local_7++;
                    }
                    this._Str_830(_local_4, _local_5, _local_6);
                }
            }
        }
    }

