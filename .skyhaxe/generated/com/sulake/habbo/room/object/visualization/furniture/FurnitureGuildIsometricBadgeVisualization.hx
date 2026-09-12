package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

     class FurnitureGuildIsometricBadgeVisualization extends IsometricImageFurniVisualization
    {
        static inline final PRIMARY_COLOUR_SPRITE_TAG= "COLOR1";
        static inline final SECONDARY_COLOUR_SPRITE_TAG= "COLOR2";
        static inline final DEFAULT_COLOR_1= 0xEEEEEE;
        static inline final DEFAULT_COLOR_2= 0x4B4B4B;

        var _color1:Int = 0;
        var _color2:Int = 0;


        override function updateModel(k:Float):Bool
        {
            var _local_5:String = null;
            var _local_2= super.updateModel(k);
            if (!hasThumbnailImage)
            {
                _local_5 = object.getModel().getString(RoomObjectVariableEnum.FURNITURE_GUILD_CUSTOMIZED_ASSET_NAME);
                if (_local_5 != null)
                {
                    setThumbnailImages(this.safeGetBitmapAsset(_local_5), this.safeGetBitmapAsset((_local_5 + "_32")));
                }
            }
            var _local_3= object.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_GUILD_CUSTOMIZED_COLOR_1);
            this._color1 = (Math.isNaN(_local_3) ? DEFAULT_COLOR_1 : ASCompat.asInt(_local_3 ));
            var _local_4= object.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_GUILD_CUSTOMIZED_COLOR_2);
            this._color2 = (Math.isNaN(_local_3) ? DEFAULT_COLOR_2 : ASCompat.asInt(_local_4 ));
            return _local_2;
        }

        function safeGetBitmapAsset(k:String):BitmapData
        {
            var _local_2= assetCollection.getAsset(k);
            if (((_local_2 == null) || (_local_2.asset == null)))
            {
                return null;
            }
            return cast(_local_2.asset.content, BitmapData);
        }

        override function getSpriteColor(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= getSpriteTag(k, direction, _arg_2);
            switch (_local_4)
            {
                case PRIMARY_COLOUR_SPRITE_TAG:
                    return this._color1;
                case SECONDARY_COLOUR_SPRITE_TAG:
                    return this._color2;
            }
            return super.getSpriteColor(k, _arg_2, _arg_3);
        }

        override function getLibraryAssetNameForSprite(k:IGraphicAsset, _arg_2:IRoomObjectSprite):String
        {
            if (_arg_2.tag == IsometricImageFurniVisualization.THUMBNAIL)
            {
                if (((object != null) && ASCompat.stringAsBool(object.getModel().getString(RoomObjectVariableEnum.FURNITURE_GUILD_CUSTOMIZED_ASSET_NAME))))
                {
                    return "%group.badge.url%" + ASCompat.stringReplace(object.getModel().getString(RoomObjectVariableEnum.FURNITURE_GUILD_CUSTOMIZED_ASSET_NAME), "badge_", "");
                }
            }
            return super.getLibraryAssetNameForSprite(k, _arg_2);
        }

	public function new() { super(); }
    }

