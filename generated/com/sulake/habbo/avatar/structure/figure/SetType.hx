package com.sulake.habbo.avatar.structure.figure
;
    import com.sulake.core.utils.Map;

     class SetType implements ISetType 
    {
        var _partSets:Map;
        var _type:String;
        var _paletteID:Int = 0;
        var _isMandatory:ASDictionary<ASAny,ASAny>;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            this._type = k.attribute("type").toString();
            this._paletteID = ASCompat.parseInt(k.attribute("paletteid").toString());
            this._isMandatory = new ASDictionary<ASAny,ASAny>();
            this._isMandatory["F"] = new Array<ASAny>();
            this._isMandatory["M"] = new Array<ASAny>();
            this._isMandatory["F"][0] = ASCompat.toBool(ASCompat.parseInt(k.attribute("mand_f_0").toString()));
            this._isMandatory["F"][1] = ASCompat.toBool(ASCompat.parseInt(k.attribute("mand_f_1").toString()));
            this._isMandatory["M"][0] = ASCompat.toBool(ASCompat.parseInt(k.attribute("mand_m_0").toString()));
            this._isMandatory["M"][1] = ASCompat.toBool(ASCompat.parseInt(k.attribute("mand_m_1").toString()));
            this._partSets = new Map();
            this._Str_2015(k);
        }

        public function dispose()
        {
            var k:FigurePartSet;
            for (_tmp_ in this._partSets.getValues())
            {
k  = _tmp_;
                k.dispose();
            }
            this._partSets.dispose();
            this._partSets = null;
        }

        public function cleanUp(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML;
            var _local_3:String;
            var _local_4:FigurePartSet;
            for (_tmp_ in k.child("set"))
            {
_local_2  = _tmp_;
                _local_3 = _local_2.attribute("id").toString();
                _local_4 = this._partSets.getValue(_local_3);
                if (_local_4 != null)
                {
                    _local_4.dispose();
                    this._partSets.remove(_local_3);
                }
            }
        }

        public function _Str_2015(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML;
            for (_tmp_ in k.child("set"))
            {
_local_2  = _tmp_;
                this._partSets.add(_local_2.attribute("id").toString(), new FigurePartSet(_local_2, this._type));
            }
        }

        public function _Str_2264(k:String):IFigurePartSet
        {
            var _local_4:IFigurePartSet;
            var _local_2= this._partSets.getKeys();
            var _local_3= (_local_2.length - 1);
            while (_local_3 >= 0)
            {
                _local_4 = this._partSets.getValue(_local_2[_local_3]);
                if ((((_local_4 != null) && (_local_4.clubLevel == 0)) && ((_local_4.gender == k) || (_local_4.gender == "U"))))
                {
                    return _local_4;
                }
                _local_3--;
            }
            return null;
        }

        public function _Str_1020(k:Int):IFigurePartSet
        {
            return this._partSets.getValue(Std.string(k));
        }

        public var type(get,never):String;
function  get_type():String
        {
            return this._type;
        }

        public var _Str_734(get,never):Int;
function  get__Str_734():Int
        {
            return this._paletteID;
        }

        public function _Str_895(k:String, _arg_2:Int):Bool
        {
            return this._isMandatory[k.toUpperCase()][Math.min(_arg_2, 1)];
        }

        public function _Str_1002(k:String):Int
        {
            var _local_2:Array<ASAny> = this._isMandatory[k.toUpperCase()];
            return _local_2.indexOf(false);
        }

        public var _Str_710(get,never):Map;
function  get__Str_710():Map
        {
            return this._partSets;
        }
    }

