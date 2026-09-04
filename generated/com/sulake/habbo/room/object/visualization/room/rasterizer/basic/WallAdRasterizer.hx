package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.utils.XMLValidator;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.object.visualization.room.utils.PlaneBitmapData;

     class WallAdRasterizer extends WallRasterizer 
    {


        override public function getTextureIdentifier(k:Float, _arg_2:IVector3d):String
        {
            return Std.string(k);
        }

        override function initializePlanes()
        {
            if (data == null)
            {
                return;
            }
            var k= data.child("wallAds");
            if (k.length() > 0)
            {
                this.parseWalls(k.at(0));
            }
        }

        override function parseWalls(k:com.sulake.core.utils.xml.XML)
        {
            var _local_4:com.sulake.core.utils.xml.XML;
            var _local_5:String;
            var _local_6:com.sulake.core.utils.xml.XMLList;
            var _local_7:WallPlane;
            if (k == null)
            {
                return;
            }
            var _local_2= k.child("wallAd");
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
                    if (getPlane(_local_5) == null)
                    {
                        _Str_3453(_local_5, _local_7);
                    }
                    else
                    {
                        _local_7.dispose();
                    }
                }
                _local_3++;
            }
        }

        override public function render(k:BitmapData, _arg_2:String, _arg_3:Float, _arg_4:Float, _arg_5:Float, _arg_6:IVector3d, _arg_7:Bool, _arg_8:Float=0, _arg_9:Float=0, _arg_10:Float=0, _arg_11:Float=0, _arg_12:Int=0):PlaneBitmapData
        {
            var _local_13= Std.downcast(getPlane(_arg_2) , WallPlane);
            if (_local_13 == null)
            {
                _local_13 = Std.downcast(getPlane(PlaneRasterizer.DEFAULT) , WallPlane);
            }
            if (_local_13 == null)
            {
                return null;
            }
            if (k != null)
            {
                k.fillRect(k.rect, 0xFFFFFF);
            }
            var _local_14= _local_13.render(k, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            if (((!(_local_14 == null)) && (!(_local_14 == k))))
            {
                _local_14 = _local_14.clone();
            }
            var _local_15= new PlaneBitmapData(_local_14, -1);
            return _local_15;
        }

	public function new() { super(); }
    }

