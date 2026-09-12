package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.room.events.RoomObjectFurniIconAssetEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectFurniIconUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.data.MapStuffData;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class FurnitureFurniChestLogic extends FurnitureChestLogic
    {
        static inline final LOADING_ICON_PLACEHOLDER= "loading_icon";
        static inline final VISUALS_KEY= "visuals";

        var _visuals:String = "";
        var _assetNamesForVisuals:Map = new Map();

        static function itemTypeToString(wallItem:Bool, typeId:Int, extra:String):String
        {
            var value= Std.string(wallItem) + "," + Std.string(typeId);
            if (extra != null && extra != "")
            {
                value += "," + extra;
            }
            return value;
        }

        static function stringToItemType(value:String):ASObject
        {
            var parts:Array<ASAny> = (cast value.split(","));
            if (parts.length < 2)
            {
                return null;
            }
            return {
                "isWallItem": parts[0] == "true",
                "typeId": ASCompat.toInt(parts[1]),
                "extra": parts.length > 2 ? parts[2] : ""
            };
        }

        override public function dispose()
        {
            if (this._assetNamesForVisuals != null)
            {
                this._assetNamesForVisuals.dispose();
                this._assetNamesForVisuals = null;
            }
            super.dispose();
        }

        override public function getEventTypes():Array<ASAny>
        {
            return getAllEventTypes(super.getEventTypes(), [RoomObjectFurniIconAssetEvent.LOAD_FURNI_ICON]);
        }

        override public function processUpdateMessage(message:RoomObjectUpdateMessage)
        {
var mapData:MapStuffData  = null, visuals:String  = null;            super.processUpdateMessage(message);

            var dataUpdate= Std.downcast(message , RoomObjectDataUpdateMessage);
            if (dataUpdate != null)
            {
mapData= Std.downcast(dataUpdate.data , MapStuffData);
                if (mapData != null)
                {
visuals= mapData.getValue(VISUALS_KEY);
                    if (dataUpdate.state % 2 != 1)
                    {
                        visuals = "";
                    }
                    if (visuals != null && visuals != this._visuals)
                    {
                        this._visuals = visuals;
                        this.onVisualsChange();
                        this.storeShownAssets();
                    }
                }
            }

            var iconUpdate= Std.downcast(message , RoomObjectFurniIconUpdateMessage);
            if (iconUpdate == null || iconUpdate.assetName == null || iconUpdate.assetName.length == 0 || iconUpdate.assetName == LOADING_ICON_PLACEHOLDER)
            {
                return;
            }

            var itemType= itemTypeToString(iconUpdate.wallItem, iconUpdate.typeId, iconUpdate.extra);
            if (this._assetNamesForVisuals.hasKey(itemType) && this._assetNamesForVisuals.getValue(itemType) == LOADING_ICON_PLACEHOLDER)
            {
                this._assetNamesForVisuals.setProperty(itemType, iconUpdate.assetName);
                this.storeShownAssets();
            }
        }

        function onVisualsChange()
        {
var itemTypeString:String  = null, itemType:ASObject  = null;            this._assetNamesForVisuals.dispose();
            this._assetNamesForVisuals = new Map();

            final _iter_ = this._visuals.split(";"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
itemTypeString = _tmp_;
                if (itemTypeString == "")
                {
                    continue;
                }
itemType= stringToItemType(itemTypeString);
                if (itemType == null)
                {
                    continue;
                }

                this._assetNamesForVisuals.add(itemTypeString, LOADING_ICON_PLACEHOLDER);
                if (eventDispatcher != null && object != null)
                {
                    eventDispatcher.dispatchEvent(new RoomObjectFurniIconAssetEvent(RoomObjectFurniIconAssetEvent.LOAD_FURNI_ICON, object, itemType.isWallItem, ASCompat.toInt(itemType.typeId), itemType.extra));
                }
            }
        }

        function storeShownAssets()
        {
            if (object == null || object.getModelController() == null)
            {
                return;
            }
            object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_FURNI_CHEST_SHOWN_ASSET_NAMES, this.shownAssetsString);
            update(flash.Lib.getTimer());
        }

        var shownAssetsString(get,never):String;
function  get_shownAssetsString():String
        {
var itemTypeString:String  = null, assetName:String  = null;            var assetNames:Array<ASAny> = [];
            final _iter_ = this._visuals.split(";"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
itemTypeString = _tmp_;
                if (itemTypeString != "" && this._assetNamesForVisuals.hasKey(itemTypeString))
                {
assetName= this._assetNamesForVisuals.getValue(itemTypeString);
                    assetNames.push(assetName == null ? "" : assetName);
                }
            }
            return assetNames.join(",");
        }

	public function new() { super(); }
    }

