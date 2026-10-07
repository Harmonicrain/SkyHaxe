package org.openvideoads.vast.tracking
;
     class _Str_2460 
    {
        var _Str_5970:Float = Math.NaN;
        var _Str_6324:String;
        var _id:String;
        var _Str_18606:Bool = false;

        public function new(k:Float, _arg_2:String, _arg_3:String=null)
        {
            this._Str_5970 = k;
            this._Str_6324 = _arg_2;
            this._id = _arg_3;
        }

        public var milliseconds(get,never):Float;
public function  get_milliseconds():Float
        {
            return this._Str_5970;
        }

        public var seconds(get,never):Float;
public function  get_seconds():Float
        {
            return this._Str_5970 / 1000;
        }

        public var label(get,never):String;
public function  get_label():String
        {
            return this._Str_6324;
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        
        public var _Str_20299(get,set):Bool;
public function  set__Str_20299(k:Bool):Bool        {
            return this._Str_18606 = k;
        }
public function  get__Str_20299():Bool
        {
            return this._Str_18606;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            if (this.label != null)
            {
                return this.label.substr(0, 2);
            }
            return null;
        }

        public function repeatable():Bool
        {
            var k= "SN HN EC DC CS CE DS HS";
            return k.indexOf(this.type) > -1;
        }

        public function isLinear():Bool
        {
            var k= "BS ES BA EA DS HS 1Q HW 3Q CS CE SN HN EC DC TN";
            return k.indexOf(this.type) > -1;
        }

        public function isNonLinear():Bool
        {
            var k= "NS NE CS CE";
            return k.indexOf(this.type) > -1;
        }

        public function toString():String
        {
            return ((((("TrackingPoint(time point: " + Std.string(this._Str_5970)) + ", label: ") + this._Str_6324) + ", isForLinearChild:") + Std.string(this._Str_18606)) + ")";
        }
    }

