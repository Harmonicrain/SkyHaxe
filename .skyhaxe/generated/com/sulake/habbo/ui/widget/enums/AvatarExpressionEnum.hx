package com.sulake.habbo.ui.widget.enums
;
     class AvatarExpressionEnum 
    {
        public static final NONE:AvatarExpressionEnum = new AvatarExpressionEnum(0);
        public static final WAVE:AvatarExpressionEnum = new AvatarExpressionEnum(1);
        public static final BLOW:AvatarExpressionEnum = new AvatarExpressionEnum(2);
        public static final EXPRESSION_67:AvatarExpressionEnum = new AvatarExpressionEnum(67);
        public static final LAUGH:AvatarExpressionEnum = new AvatarExpressionEnum(3);
        public static final CRY:AvatarExpressionEnum = new AvatarExpressionEnum(4);
        public static final IDLE:AvatarExpressionEnum = new AvatarExpressionEnum(5);
        public static final JUMP:AvatarExpressionEnum = new AvatarExpressionEnum(6);
        public static final RESPECT:AvatarExpressionEnum = new AvatarExpressionEnum(7);

        var _ordinal:Int = 0;

        public function new(k:Int)        {
            this._ordinal = k;
        }

        public var ordinal(get,never):Int;
public function  get_ordinal():Int
        {
            return this._ordinal;
        }

        public function equals(k:AvatarExpressionEnum):Bool
        {
            return (k != null) && (k._ordinal == this._ordinal);
        }
    }

