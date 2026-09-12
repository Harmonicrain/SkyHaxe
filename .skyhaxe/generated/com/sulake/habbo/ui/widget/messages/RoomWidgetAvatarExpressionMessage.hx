package com.sulake.habbo.ui.widget.messages
;
    import com.sulake.habbo.ui.widget.enums.AvatarExpressionEnum;

     class RoomWidgetAvatarExpressionMessage extends RoomWidgetMessage 
    {
        public static inline final RWCM_MESSAGE_AVATAR_EXPRESSION= "RWCM_MESSAGE_AVATAR_EXPRESSION";

        var _animation:AvatarExpressionEnum;

        public function new(k:AvatarExpressionEnum)
        {
            super(RWCM_MESSAGE_AVATAR_EXPRESSION);
            this._animation = k;
        }

        public var animation(get,never):AvatarExpressionEnum;
public function  get_animation():AvatarExpressionEnum
        {
            return this._animation;
        }
    }

