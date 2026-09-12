package com.sulake.habbo.navigator.mainview
;
    import com.sulake.habbo.communication.messages.incoming.navigator.PromotedRoomCategoryData;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.habbo.navigator.domain.RoomSessionTags;

     class PromotedRoomsGuestRoomListCtrl extends GuestRoomListCtrl 
    {
        var _category:PromotedRoomCategoryData;

        public function new(k:HabboNavigator)
        {
            super(k, -6, false);
        }

        public var category(never,set):PromotedRoomCategoryData;
public function  set_category(k:PromotedRoomCategoryData):PromotedRoomCategoryData        {
            return this._category = k;
        }

        override public function getRooms():Array<ASAny>
        {
            return this._category.rooms;
        }

        override public function beforeEnterRoom(k:Int)
        {
            navigator.data.roomSessionTags = new RoomSessionTags(this._category.code, ("" + Std.string(k + 2)));
        }
    }

