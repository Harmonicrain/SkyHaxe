package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import com.sulake.room.utils.XMLValidator;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.object.visualization.room.utils.PlaneBitmapData;
    import com.sulake.room.utils.IVector3d;

     class WallRasterizer extends PlaneRasterizer 
    {


        override function initializePlanes()
        {
            if (data == null)
            {
                return;
            }
            var k= data.child("walls");
            if (k.length() > 0)
            {
                this.parseWalls(k.at(0));
            }
        }

        function parseWalls(k:com.sulake.core.utils.xml.XML)
        {
            var _local_4:com.sulake.core.utils.xml.XML;
            var _local_5:String;
            var _local_6:com.sulake.core.utils.xml.XMLList;
            var _local_7:WallPlane;
            if (k == null)
            {
                return;
            }
            var _local_2= k.child("wall");
            var _local_3 = 0;
            while (_local_3 < _local_2.length())
            {
                _local_4 = _local_2.at(_local_3);
                if (XMLValidator.checkRequiredAttributes(_local_4, ["id"]))
                {
                    _local_5 = _local_4.attribute("id").toString();
                    _local_6 = _local_4.child("visualization");
                    _local_7 = new WallPlane();
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
            var bitmapData:BitmapData;
            var wall= Std.downcast(getPlane(id) , WallPlane);
            if (wall == null)
            {
                wall = Std.downcast(getPlane(PlaneRasterizer.DEFAULT) , WallPlane);
            }
            if (wall == null)
            {
                return null;
            }
            if (canvas != null)
            {
                canvas.fillRect(canvas.rect, 0xFFFFFF);
            }
            bitmapData = wall.render(canvas, width, height, scale, normal, useTexture);
            if (((!(bitmapData == null)) && (!(bitmapData == canvas))))
            {
                try
                {
                    bitmapData = bitmapData.clone();
                }
                catch(e:ASError)
                {
                    if (bitmapData != null)
                    {
                        bitmapData.dispose();
                    }
                    return null;
                }
            }
            var planeBitmapData= new PlaneBitmapData(bitmapData, -1);
            return planeBitmapData;
        }

        override public function getTextureIdentifier(k:Float, _arg_2:IVector3d):String
        {
            if (_arg_2 != null)
            {
                return ((((((k + "_") + _arg_2.x) + "_") + _arg_2.y) + "_") + _arg_2.z);
            }
            return super.getTextureIdentifier(k, _arg_2);
        }

	public function new() { super(); }
    }

