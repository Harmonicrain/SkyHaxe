package com.sulake.habbo.notifications.feed.view.content
;
    import com.sulake.habbo.notifications.feed.data.GenericNotificationItemData;

     class EntityFactory 
    {
        public function dispose()
        {
        }

        public function _Str_23084(k:GenericNotificationItemData):IFeedEntity
        {
            if (Std.is(k , GenericNotificationItemData))
            {
                return this._Str_25180(k);
            }
            return null;
        }

        function _Str_25180(k:GenericNotificationItemData):IFeedEntity
        {
            var _local_2= FeedEntity._Str_2363();
            _local_2.icon = k.icon;
            _local_2.title = k.title;
            _local_2._Str_19059 = Std.int(((k.timeStamp - flash.Lib.getTimer()) / 1000) / 60);
            _local_2.message = k.description;
            _local_2.decoration = k._Str_22203;
            _local_2._Str_24362(k._Str_15192, k.buttonCaption);
            _local_2._Str_21184();
            return _local_2;
        }
public function new(){}
    }

