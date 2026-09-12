package com.sulake.habbo.avatar.actions
;
    import com.sulake.core.utils.Map;

     class ActionDefinition implements IActionDefinition 
    {
        var _id:String;
        var _state:String;
        var _precedence:Int = 0;
        var _activePartSet:String;
        var _assetPartDefinition:String;
        var _lay:String;
        var _geometryType:String;
        var _isMain:Bool = false;
        var _isDefault:Bool = false;
        var _isAnimation:Bool = false;
        var _startFromFrameZero:Bool = false;
        var _prevents:Array<ASAny>;
        var _preventHeadTurn:Bool = false;
        var _canvasOffsets:Map;
        var _types:ASDictionary<ASAny,ASAny>;
        var _params:ASDictionary<ASAny,ASAny>;
        var _defaultParameterValue:String = "";

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:String = null;
            var _local_6:String = null;
            var _local_7:String = null;
            this._prevents = new Array<ASAny>();
            this._types = new ASDictionary<ASAny,ASAny>();
            this._params = new ASDictionary<ASAny,ASAny>();
            this._id = k.attribute("id").toString();
            this._state = k.attribute("state").toString();
            this._precedence = ASCompat.parseInt(k.attribute("precedence").toString());
            this._activePartSet = k.attribute("activepartset").toString();
            this._assetPartDefinition = k.attribute("assetpartdefinition").toString();
            this._lay = k.attribute("lay").toString();
            this._geometryType = k.attribute("geometrytype").toString();
            this._isMain = ASCompat.toBool(ASCompat.parseInt(k.attribute("main").toString()));
            this._isDefault = ASCompat.toBool(ASCompat.parseInt(k.attribute("isdefault").toString()));
            this._isAnimation = ASCompat.toBool(ASCompat.parseInt(k.attribute("animation").toString()));
            this._startFromFrameZero = com.sulake.core.utils.xml.XML.equalsStringOperands(k.attribute("startfromframezero") , "true");
            this._preventHeadTurn = com.sulake.core.utils.xml.XML.equalsStringOperands(k.attribute("preventheadturn") , "true");
            var _local_2= k.attribute("prevents").toString();
            if (_local_2 != "")
            {
                this._prevents = (cast _local_2.split(","));
            }
            final _iter_ = k.child("param"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_5 = _local_3.attribute("id").toString();
                _local_6 = _local_3.attribute("value").toString();
                if (_local_5 == "default")
                {
                    this._defaultParameterValue = _local_6;
                }
                else
                {
                    this._params[_local_5] = _local_6;
                }
            }
            final _iter_ = k.child("type"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_7 = _local_4.attribute("id").toString();
                this._types[_local_7] = new ActionType(_local_4);
            }
        }

        public function setOffsets(k:String, _arg_2:Int, _arg_3:Array<ASAny>)
        {
            if (this._canvasOffsets == null)
            {
                this._canvasOffsets = new Map();
            }
            if (this._canvasOffsets.getValue(k) == null)
            {
                this._canvasOffsets.add(k, new Map());
            }
            var _local_4:Map = this._canvasOffsets.getValue(k);
            _local_4.add(_arg_2, _arg_3);
        }

        public function getOffsets(k:String, _arg_2:Int):Array<ASAny>
        {
            if (this._canvasOffsets == null)
            {
                return null;
            }
            var _local_3= ASCompat.dynamicAs(this._canvasOffsets.getValue(k) , Map);
            if (_local_3 == null)
            {
                return null;
            }
            return ASCompat.dynamicAs(_local_3.getValue(_arg_2) , Array);
        }

        public function getParameterValue(k:String):String
        {
            if (k == "")
            {
                return "";
            }
            var _local_2:String = this._params[k];
            if (_local_2 == null)
            {
                _local_2 = this._defaultParameterValue;
            }
            return _local_2;
        }

        function _Str_1889(k:String):Array<ASAny>
        {
            if (k == "")
            {
                return [];
            }
            var _local_2:ActionType = this._types[k];
            if (_local_2 != null)
            {
                return _local_2.prevents;
            }
            return [];
        }

        public function toString():String
        {
            return ((((((((((((((((((((((("[ActionDefinition]\n" + "id:           ") + this.id) + "\n") + "state:        ") + this.state) + "\n") + "main:         ") + Std.string(this.isMain)) + "\n") + "default:      ") + Std.string(this.isDefault)) + "\n") + "geometry:     ") + this.state) + "\n") + "precedence:   ") + Std.string(this.precedence)) + "\n") + "activepartset:") + this.activePartSet) + "\n") + "activepartdef:") + this.assetPartDefinition) + "";
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public var state(get,never):String;
public function  get_state():String
        {
            return this._state;
        }

        public var precedence(get,never):Int;
public function  get_precedence():Int
        {
            return this._precedence;
        }

        public var activePartSet(get,never):String;
public function  get_activePartSet():String
        {
            return this._activePartSet;
        }

        public var isMain(get,never):Bool;
public function  get_isMain():Bool
        {
            return this._isMain;
        }

        public var isDefault(get,never):Bool;
public function  get_isDefault():Bool
        {
            return this._isDefault;
        }

        public var assetPartDefinition(get,never):String;
public function  get_assetPartDefinition():String
        {
            return this._assetPartDefinition;
        }

        public var lay(get,never):String;
public function  get_lay():String
        {
            return this._lay;
        }

        public var geometryType(get,never):String;
public function  get_geometryType():String
        {
            return this._geometryType;
        }

        public var isAnimation(get,never):Bool;
public function  get_isAnimation():Bool
        {
            return this._isAnimation;
        }

        public function getPrevents(k:String=""):Array<ASAny>
        {
            return this._prevents.concat(this._Str_1889(k));
        }

        public function getPreventHeadTurn(k:String=""):Bool
        {
            if (k == "")
            {
                return this._preventHeadTurn;
            }
            var _local_2:ActionType = this._types[k];
            if (_local_2 != null)
            {
                return _local_2.preventHeadTurn;
            }
            return this._preventHeadTurn;
        }

        public function isAnimated(k:String):Bool
        {
            if (k == "")
            {
                return true;
            }
            var _local_2:ActionType = this._types[k];
            if (_local_2 != null)
            {
                return _local_2.isAnimated;
            }
            return true;
        }

        public var startFromFrameZero(get,never):Bool;
public function  get_startFromFrameZero():Bool
        {
            return this._startFromFrameZero;
        }

        public var params(get,never):ASDictionary<ASAny,ASAny>;
public function  get_params():ASDictionary<ASAny,ASAny>
        {
            return this._params;
        }

        public function setGeometryType(k:String)
        {
            this._geometryType = k;
        }

        public function setState(k:String)
        {
            this._state = k;
        }

        public function setAssetPartDefinition(k:String)
        {
            this._assetPartDefinition = k;
        }

        public function copy():ActionDefinition
        {
            var k= new ActionDefinition(new com.sulake.core.utils.xml.XML("<action/>"));
            k._id = this._id;
            k._state = this._state;
            k._precedence = this._precedence;
            k._activePartSet = this._activePartSet;
            k._assetPartDefinition = this._assetPartDefinition;
            k._lay = this._lay;
            k._geometryType = this._geometryType;
            k._isMain = this._isMain;
            k._isDefault = this._isDefault;
            k._isAnimation = this._isAnimation;
            k._startFromFrameZero = this._startFromFrameZero;
            k._prevents = this._prevents;
            k._preventHeadTurn = this._preventHeadTurn;
            k._canvasOffsets = this._canvasOffsets;
            k._types = this._types;
            k._params = this._params;
            k._defaultParameterValue = this._defaultParameterValue;
            return k;
        }
    }

