package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObjectModel;

     class FurnitureBBVisualization extends FurnitureBrandedImageVisualization 
    {
        override function getAdClickUrl(k:IRoomObjectModel):String
        {
            return k.getString(RoomObjectVariableEnum.FURNITURE_BRANDING_URL);
        }

        override function getSpriteXOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            return super.getSpriteXOffset(k, _arg_2, _arg_3) + offsetX;
        }

        override function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            return super.getSpriteYOffset(k, _arg_2, _arg_3) + offsetY;
        }

        override function getSpriteZOffset(k:Int, _arg_2:Int, _arg_3:Int):Float
        {
            return super.getSpriteZOffset(k, _arg_2, _arg_3) + (offsetZ * -1);
        }

	public function new() { super(); }
    }

