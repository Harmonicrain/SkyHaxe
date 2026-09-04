package com.sulake.habbo.avatar
;
    import com.sulake.habbo.avatar.structure.figure.IPartColor;
    import com.sulake.habbo.avatar.actions.IActionDefinition;
    import flash.geom.ColorTransform;
    import com.sulake.habbo.avatar.structure.animation.AnimationFrame;

     class AvatarImagePartContainer 
    {
        var _bodyPartId:String;
        var _partType:String;
        var _flippedPartType:String;
        var _partId:String;
        var _color:IPartColor;
        var _frames:Array<ASAny>;
        var _action:IActionDefinition;
        var _isColorable:Bool = false;
        var _isBlendable:Bool = false;
        var _blendTransform:ColorTransform;
        var _paletteMapId:Int = 0;

        public function new(k:String, _arg_2:String, _arg_3:String, _arg_4:IPartColor, _arg_5:Array<ASAny>, _arg_6:IActionDefinition, _arg_7:Bool, _arg_8:Int, _arg_9:String="", _arg_10:Bool=false, _arg_11:Float=1)
        {
            this._bodyPartId = k;
            this._partType = _arg_2;
            this._partId = _arg_3;
            this._color = _arg_4;
            this._frames = _arg_5;
            this._action = _arg_6;
            this._isColorable = _arg_7;
            this._paletteMapId = _arg_8;
            this._flippedPartType = _arg_9;
            this._isBlendable = _arg_10;
            this._blendTransform = new ColorTransform(1, 1, 1, _arg_11);
            if (this._frames == null)
            {
                Logger.log(["Null frame list"]);
            }
            if (this._partType == "ey")
            {
                this._isColorable = false;
            }
        }

        public function _Str_1674(k:Int):Int
        {
            var _local_3:AnimationFrame;
            if (((!(this._frames != null)) || (this._frames.length == 0)))
            {
                return 0;
            }
            var _local_2= (k % this._frames.length);
            if (Std.is(this._frames[_local_2] , AnimationFrame))
            {
                _local_3 = this._frames[_local_2];
                return _local_3.number;
            }
            return _local_2;
        }

        public function getAnimationFrame(k:Int):AnimationFrame
        {
            var _local_2= (k % this._frames.length);
            if (((this._frames != null) && (this._frames.length > _local_2)))
            {
                if (Std.is(this._frames[_local_2] , AnimationFrame))
                {
                    return ASCompat.dynamicAs(this._frames[_local_2] , AnimationFrame);
                }
            }
            return null;
        }

        public function getCacheableKey(k:Int):String
        {
            var _local_3:AnimationFrame;
            var _local_2= (k % this._frames.length);
            if (((this._frames != null) && (this._frames.length > _local_2)))
            {
                if (Std.is(this._frames[_local_2] , AnimationFrame))
                {
                    _local_3 = ASCompat.dynamicAs(this._frames[_local_2] , AnimationFrame);
                    return (((this.partId + ":") + _local_3.assetPartDefinition) + ":") + _local_3.number;
                }
            }
            return (this.partId + ":") + _local_2;
        }

        public var bodyPartId(get,never):String;
function  get_bodyPartId():String
        {
            return this._bodyPartId;
        }

        public var partType(get,never):String;
function  get_partType():String
        {
            return this._partType;
        }

        public var partId(get,never):String;
function  get_partId():String
        {
            return this._partId;
        }

        public var color(get,never):IPartColor;
function  get_color():IPartColor
        {
            return this._color;
        }

        public var action(get,never):IActionDefinition;
function  get_action():IActionDefinition
        {
            return this._action;
        }

        
        public var isColorable(get,set):Bool;
function  set_isColorable(k:Bool):Bool        {
            return this._isColorable = k;
        }
function  get_isColorable():Bool
        {
            return this._isColorable;
        }

        public var paletteMapId(get,never):Int;
function  get_paletteMapId():Int
        {
            return this._paletteMapId;
        }

        public var flippedPartType(get,never):String;
function  get_flippedPartType():String
        {
            return this._flippedPartType;
        }

        public var isBlendable(get,never):Bool;
function  get_isBlendable():Bool
        {
            return this._isBlendable;
        }

        public var blendTransform(get,never):ColorTransform;
function  get_blendTransform():ColorTransform
        {
            return this._blendTransform;
        }

        public function toString():String
        {
            return [this._bodyPartId, this._partType, this._partId].join(":");
        }
    }

