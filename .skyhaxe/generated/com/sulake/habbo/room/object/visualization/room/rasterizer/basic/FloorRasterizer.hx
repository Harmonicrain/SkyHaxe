package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import com.sulake.room.utils.XMLValidator;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.object.visualization.room.utils.PlaneBitmapData;
    import com.sulake.room.utils.IVector3d;

     class FloorRasterizer extends PlaneRasterizer 
    {
        override function initializePlanes()
        {
            if (data == null)
            {
                return;
            }
            var k= data.child("floors");
            if (k.length() > 0)
            {
                this.parseFloors(k.at(0));
            }
        }

        function parseFloors(k:com.sulake.core.utils.xml.XML)
        {
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:String = null;
            var _local_6:com.sulake.core.utils.xml.XMLList = null;
            var _local_7:FloorPlane = null;
            if (k == null)
            {
                return;
            }
            var _local_2= k.child("floor");
            var _local_3 = 0;
            while (_local_3 < _local_2.length())
            {
                _local_4 = _local_2.at(_local_3);
                if (XMLValidator.checkRequiredAttributes(_local_4, ["id"]))
                {
                    _local_5 = _local_4.attribute("id").toString();
                    _local_6 = _local_4.child("visualization");
                    _local_7 = new FloorPlane();
                    parseVisualizations(_local_7, _local_6);
                    if (!_Str_3453(_local_5, _local_7))
                    {
                        _local_7.dispose();
                    }
                }
                _local_3++;
            }
        }

        override public function render(canvas:BitmapData, id:String, width:Float, height:Float, scale:Float, normal:IVector3d, useTexture:Bool, offsetX:Float=0, offsetY:Float=0, maxX:Float=0, maxY:Float=0, timeSinceStartMs:Int=0):PlaneBitmapData
        {
            var bitmapData:BitmapData = null;
            var floor= Std.downcast(getPlane(id) , FloorPlane);
            if (floor == null)
            {
                floor = Std.downcast(getPlane(PlaneRasterizer.DEFAULT) , FloorPlane);
            }
            if (floor == null)
            {
                return null;
            }
            if (canvas != null)
            {
                canvas.fillRect(canvas.rect, 0xFFFFFF);
            }
            bitmapData = floor.render(canvas, width, height, scale, normal, useTexture, offsetX, offsetY);
            if (((!(bitmapData == null)) && (!(bitmapData == canvas))))
            {
                try
                {
                    bitmapData = bitmapData.clone();
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    if (bitmapData != null)
                    {
                        bitmapData.dispose();
                    }
                    return null;
                }
 }            }
            var planeBitmapData= new PlaneBitmapData(bitmapData, -1);
            return planeBitmapData;
        }

	public function new() { super(); }
    }

