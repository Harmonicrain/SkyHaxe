package com.sulake.habbo.friendbar.view.tabs.tokens
;
    import com.sulake.habbo.friendbar.data.IFriendEntity;
    import com.sulake.habbo.friendbar.data.IFriendNotification;

     class MessengerToken extends Token 
    {
        public function new(k:IFriendEntity, _arg_2:IFriendNotification)
        {
            super(_arg_2);
            prepare("${friendbar.notify.messenger}", _arg_2.message, "message_piece_xml", "messenger_notification_icon");
        }
    }

