package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

     class FurnitureBadgeDisplayVisualization extends FurnitureAnimatedVisualization 
    {
        static inline final BADGE= "BADGE";

        var _badgeAssetNameNormalScale:String = "";
        var _badgeAssetNameSmallScale:String = "";
        var _badgeVisibleInState:Int = -1;


        override function updateModel(k:Float):Bool
        {
            var _local_3 = false;
            var _local_2= super.updateModel(k);
            if (!Math.isNaN(object.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_BADGE_IMAGE_STATUS)))
            {
                _local_3 = (!(object.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_BADGE_IMAGE_STATUS) == 0));
                if ((_local_3 && (this._badgeAssetNameNormalScale == "")))
                {
                    this._badgeAssetNameNormalScale = object.getModel().getString(RoomObjectVariableEnum.FURNITURE_BADGE_ASSET_NAME);
                    if (this._badgeAssetNameSmallScale == "")
                    {
                        this._badgeAssetNameSmallScale = (this._badgeAssetNameNormalScale + "_32");
                    }
                    if (object.getModel().hasNumber(RoomObjectVariableEnum.FURNITURE_BADGE_VISIBLE_IN_STATE))
                    {
                        this._badgeVisibleInState = Std.int(object.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_BADGE_VISIBLE_IN_STATE));
                    }
                    _local_2 = true;
                }
            }
            return _local_2;
        }

        override function getSpriteAssetName(k:Int, _arg_2:Int):String
        {
            var _local_3= getSpriteTag(k, direction, _arg_2);
            if (((!(_local_3 == BADGE)) || ((!(this._badgeVisibleInState == -1)) && (!(object.getState(0) == this._badgeVisibleInState)))))
            {
                return super.getSpriteAssetName(k, _arg_2);
            }
            if (k == 32)
            {
                return this._badgeAssetNameSmallScale;
            }
            return this._badgeAssetNameNormalScale;
        }

        override function getSpriteXOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_5:IGraphicAsset = null;
            var _local_4= super.getSpriteXOffset(k, _arg_2, _arg_3);
            if (getSpriteTag(k, _arg_2, _arg_3) == BADGE)
            {
                _local_5 = getAsset(((k == 32) ? this._badgeAssetNameSmallScale : this._badgeAssetNameNormalScale), _arg_3);
                if (k == 64)
                {
                    _local_4 = Std.int(_local_4 + ((40 - _local_5.width) / 2));
                }
                else
                {
                    _local_4 = Std.int(_local_4 + ((20 - _local_5.width) / 2));
                }
            }
            return _local_4;
        }

        override function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_5:IGraphicAsset = null;
            var _local_4= super.getSpriteYOffset(k, _arg_2, _arg_3);
            if (getSpriteTag(k, _arg_2, _arg_3) == BADGE)
            {
                _local_5 = getAsset(((k == 32) ? this._badgeAssetNameSmallScale : this._badgeAssetNameNormalScale), _arg_3);
                if (k == 64)
                {
                    _local_4 = Std.int(_local_4 + ((40 - _local_5.height) / 2));
                }
                else
                {
                    _local_4 = Std.int(_local_4 + ((20 - _local_5.height) / 2));
                }
            }
            return _local_4;
        }

        override function getLibraryAssetNameForSprite(k:IGraphicAsset, _arg_2:IRoomObjectSprite):String
        {
            if (_arg_2.tag == BADGE)
            {
                return (("%image.library.url%" + "album1584/") + ASCompat.stringReplace(_arg_2.assetName, "badge_", "")) + ".gif";
            }
            return super.getLibraryAssetNameForSprite(k, _arg_2);
        }

	public function new() { super(); }
    }

