package com.sulake.habbo.avatar.animation
;
    import com.sulake.habbo.avatar.actions.IActiveActionData;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.avatar.actions.ActiveActionData;
    import com.sulake.habbo.avatar.actions.IActionDefinition;

     class AnimationLayerData implements IAnimationLayerData 
    {
        public static inline final BODYPART= "bodypart";
        public static inline final FX= "fx";

        var _id:String;
        var _action:IActiveActionData;
        var _animationFrame:Int = 0;
        var _dx:Int = 0;
        var _dy:Int = 0;
        var _dz:Int = 0;
        var _directionOffset:Int = 0;
        var _type:String;
        var _base:String;
        var _items:Map;

        public function new(k:com.sulake.core.utils.xml.XML, _arg_2:String, _arg_3:IActionDefinition)
        {
            var _local_4:com.sulake.core.utils.xml.XML;
            var _local_5:String;
            this._items = new Map();
            this._id = k.attribute("id").toString();
            this._animationFrame = ASCompat.parseInt(k.attribute("frame").toString());
            this._dx = ASCompat.parseInt(k.attribute("dx").toString());
            this._dy = ASCompat.parseInt(k.attribute("dy").toString());
            this._dz = ASCompat.parseInt(k.attribute("dz").toString());
            this._directionOffset = ASCompat.parseInt(k.attribute("dd").toString());
            this._type = _arg_2;
            this._base = k.attribute("base").toString();
            for (_tmp_ in k.child("item"))
            {
_local_4  = _tmp_;
                this._items.setValue(_local_4.attribute("id").toString(), _local_4.attribute("base").toString());
            }
            _local_5 = "";
            if (this._base != "")
            {
                _local_5 = Std.string(this._Str_2108());
            }
            if (_arg_3 != null)
            {
                this._action = new ActiveActionData(_arg_3.state, this.base);
                this._action.definition = _arg_3;
            }
        }

        public var items(get,never):Map;
function  get_items():Map
        {
            return this._items;
        }

        function _Str_2108():Int
        {
            var k = 0;
            var _local_2 = 0;
            while (_local_2 < this._base.length)
            {
                k = (k + this._base.charCodeAt(_local_2));
                _local_2++;
            }
            return k;
        }

        public var id(get,never):String;
function  get_id():String
        {
            return this._id;
        }

        public var animationFrame(get,never):Int;
function  get_animationFrame():Int
        {
            return this._animationFrame;
        }

        public var dx(get,never):Int;
function  get_dx():Int
        {
            return this._dx;
        }

        public var dy(get,never):Int;
function  get_dy():Int
        {
            return this._dy;
        }

        public var dz(get,never):Int;
function  get_dz():Int
        {
            return this._dz;
        }

        public var dd(get,never):Int;
function  get_dd():Int
        {
            return this._directionOffset;
        }

        public var type(get,never):String;
function  get_type():String
        {
            return this._type;
        }

        public var base(get,never):String;
function  get_base():String
        {
            return this._base;
        }

        public var action(get,never):IActiveActionData;
function  get_action():IActiveActionData
        {
            return this._action;
        }
    }

