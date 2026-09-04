package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

     class ExpressionAddition implements IExpressionAddition 
    {
        var _id:Int = 0;
        var _Str_1070:AvatarVisualization;
        var _type:Int = -1;

        public function new(k:Int, _arg_2:Int, _arg_3:AvatarVisualization)
        {
            this._type = _arg_2;
            this._id = k;
            this._Str_1070 = _arg_3;
        }

        public var type(get,never):Int;
function  get_type():Int
        {
            return this._type;
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._Str_1070 == null;
        }

        public function dispose()
        {
            this._Str_1070 = null;
        }

        public function update(k:IRoomObjectSprite, _arg_2:Float)
        {
        }

        public function animate(k:IRoomObjectSprite):Bool
        {
            return false;
        }
    }

