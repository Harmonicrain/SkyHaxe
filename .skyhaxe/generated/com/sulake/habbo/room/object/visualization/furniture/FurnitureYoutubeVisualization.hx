package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureYoutubeVisualization extends ExternalIsometricImageFurniVisualization
    {
        static inline final THUMBNAIL_URL= "THUMBNAIL_URL";


        override function getThumbnailURL():String
        {
            var k= object.getModel();
            var _local_2= k.getStringToStringMap(RoomObjectVariableEnum.FURNITURE_DATA);
            
            return _local_2.getValue(THUMBNAIL_URL);
        }

	public function new() { super(); }
    }

