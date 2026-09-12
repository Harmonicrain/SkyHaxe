package com.sulake.habbo.friendbar.view.tabs.tokens
;
    import com.sulake.habbo.game.GameAssetEnum;
    import com.sulake.habbo.friendbar.data.IFriendEntity;
    import com.sulake.habbo.friendbar.data.IFriendNotification;

     class GameToken extends Token 
    {
        public function new(k:IFriendEntity, _arg_2:IFriendNotification)
        {
            super(_arg_2);
            var _local_3= _arg_2.message;
            var _local_4:ASAny = (("${gamecenter." + _local_3) + ".name}");
            var _local_5= Token._Str_9155.getGameId(_arg_2.message);
            var _local_6= Token._Str_9155.getGameAssetURL(_local_5, GameAssetEnum.SMALL_ICON);
            prepare("${friendbar.notify.game}", _local_4, "message_piece_xml", _local_6);
        }
    }

