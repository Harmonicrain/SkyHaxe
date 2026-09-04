package com.sulake.habbo.room.object.visualization.room.rasterizer.animated
;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.PlaneRasterizer;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.PlaneVisualization;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.PlaneMaterial;
    import com.sulake.room.utils.XMLValidator;
    import com.sulake.habbo.room.object.visualization.room.utils.Randomizer;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.PlaneVisualizationLayer;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.object.visualization.room.utils.PlaneBitmapData;
    import com.sulake.room.utils.IVector3d;

     class LandscapeRasterizer extends PlaneRasterizer 
    {
        static inline final UPDATE_INTERVAL= 500;

        var _landscapeWidth:Int = 0;
        var _landscapeHeight:Int = 0;


        override public function initializeDimensions(k:Int, _arg_2:Int):Bool
        {
            if (k < 0)
            {
                k = 0;
            }
            if (_arg_2 < 0)
            {
                _arg_2 = 0;
            }
            this._landscapeWidth = k;
            this._landscapeHeight = _arg_2;
            return true;
        }

        override function initializePlanes()
        {
            if (data == null)
            {
                return;
            }
            var k= data.child("landscapes");
            if (k.length() > 0)
            {
                this.parseLandscapes(k.at(0));
            }
        }

        function parseLandscapes(k:com.sulake.core.utils.xml.XML)
        {
            var _local_6:com.sulake.core.utils.xml.XML;
            var _local_7:String;
            var _local_8:com.sulake.core.utils.xml.XMLList;
            var _local_9:LandscapePlane;
            var _local_10:Int;
            var _local_11:com.sulake.core.utils.xml.XML;
            var _local_12:Int;
            var _local_13:String;
            var _local_14:String;
            var _local_15:Float;
            var _local_16:Float;
            var _local_17:Int;
            var _local_18:PlaneVisualization;
            var _local_19:Int;
            var _local_20:com.sulake.core.utils.xml.XML;
            var _local_21:com.sulake.core.utils.xml.XML;
            var _local_22:PlaneMaterial;
            var _local_23:Int;
            var _local_24:String;
            var _local_25:Int;
            var _local_26:String;
            var _local_27:UInt;
            var _local_28:String;
            var _local_29:String;
            var _local_30:com.sulake.core.utils.xml.XMLList;
            var _local_31:com.sulake.core.utils.xml.XML;
            var _local_32:Int;
            var _local_33:com.sulake.core.utils.xml.XML;
            var _local_34:Int;
            var _local_35:String;
            var _local_36:Float;
            var _local_37:Float;
            var _local_38:Float;
            var _local_39:Float;
            if (k == null)
            {
                return;
            }
            var _local_2:Array<ASAny> = ["id", "assetId"];
            var _local_3= Std.int((Math.random() * 654321));
            var _local_4= k.child("landscape");
            var _local_5 = 0;
            while (_local_5 < _local_4.length())
            {
                _local_6 = _local_4.at(_local_5);
                if (XMLValidator.checkRequiredAttributes(_local_6, ["id"]))
                {
                    _local_7 = _local_6.attribute("id").toString();
                    _local_8 = _local_6.child("animatedVisualization");
                    _local_9 = new LandscapePlane();
                    _local_10 = 0;
                    while (_local_10 < _local_8.length())
                    {
                        _local_11 = _local_8.at(_local_10);
                        if (XMLValidator.checkRequiredAttributes(_local_11, ["size"]))
                        {
                            _local_12 = ASCompat.parseInt(_local_11.attribute("size").toString());
                            _local_13 = _local_11.attribute("horizontalAngle").toString();
                            _local_14 = _local_11.attribute("verticalAngle").toString();
                            _local_15 = LandscapePlane.HORIZONTAL_ANGLE_DEFAULT;
                            if (_local_13 != "")
                            {
                                _local_15 = Std.parseFloat(_local_13);
                            }
                            _local_16 = LandscapePlane.VERTICAL_ANGLE_DEFAULT;
                            if (_local_14 != "")
                            {
                                _local_16 = Std.parseFloat(_local_14);
                            }
                            _local_17 = (_local_11.child("visualizationLayer").length() + _local_11.child("animationLayer").length());
                            _local_18 = _local_9.createPlaneVisualization(_local_12, _local_17, getGeometry(_local_12, _local_15, _local_16));
                            if (_local_18 != null)
                            {
                                Randomizer.setSeed(_local_3);
                                _local_19 = 0;
                                while (_local_19 < _local_11.children().length())
                                {
                                    _local_20 = _local_11.children().at(_local_19);
                                    if (_local_20.name() == "visualizationLayer")
                                    {
                                        _local_21 = _local_20;
                                        _local_22 = null;
                                        _local_23 = PlaneVisualizationLayer.ALIGN_DEFAULT;
                                        if (XMLValidator.checkRequiredAttributes(_local_21, ["materialId"]))
                                        {
                                            _local_29 = _local_21.attribute("materialId").toString();
                                            _local_22 = material(_local_29);
                                        }
                                        _local_24 = _local_21.attribute("offset").toString();
                                        _local_25 = PlaneVisualizationLayer.DEFAULT_OFFSET;
                                        if (_local_24.length > 0)
                                        {
                                            _local_25 = ASCompat.parseInt(_local_24);
                                        }
                                        _local_26 = _local_21.attribute("color").toString();
                                        _local_27 = LandscapePlane.DEFAULT_COLOR;
                                        if (_local_26.length > 0)
                                        {
                                            _local_27 = ASCompat.parseInt(_local_26);
                                        }
                                        _local_28 = _local_21.attribute("align").toString();
                                        if (_local_28 == "bottom")
                                        {
                                            _local_23 = PlaneVisualizationLayer.ALIGN_BOTTOM;
                                        }
                                        else
                                        {
                                            if (_local_28 == "top")
                                            {
                                                _local_23 = PlaneVisualizationLayer.ALIGN_TOP;
                                            }
                                        }
                                        _local_18.setLayer(_local_19, _local_22, _local_27, _local_23, _local_25);
                                    }
                                    else
                                    {
                                        if (_local_20.name() == "animationLayer")
                                        {
                                            _local_30 = _local_20.child("animationItem");
                                            _local_31 = new com.sulake.core.utils.xml.XML("<animation/>")
                                            ;
                                            _local_32 = 0;
                                            while (_local_32 < _local_30.length())
                                            {
                                                _local_33 = ((_local_30.at(_local_32) : com.sulake.core.utils.xml.XML));
                                                if (_local_33 != null)
                                                {
                                                    if (XMLValidator.checkRequiredAttributes(_local_33, _local_2))
                                                    {
                                                        _local_34 = ASCompat.parseInt(_local_33.attribute("id").toString());
                                                        _local_35 = _local_33.attribute("assetId").toString();
                                                        _local_36 = 0;
                                                        _local_37 = 0;
                                                        _local_36 = this.getCoordinateValue(_local_33.attribute("x").toString(), _local_33.attribute("randomX").toString());
                                                        _local_37 = this.getCoordinateValue(_local_33.attribute("y").toString(), _local_33.attribute("randomY").toString());
                                                        _local_38 = 0;
                                                        _local_39 = 0;
                                                        _local_38 = Std.parseFloat(_local_33.attribute("speedX").toString());
                                                        _local_39 = Std.parseFloat(_local_33.attribute("speedY").toString());
                                                        _local_31.appendChild(Type.createInstance(com.sulake.core.utils.xml.XML, [(((((((((('<item x="' + _local_36) + '" y="') + _local_37) + '" speedX="') + _local_38) + '" speedY="') + _local_39) + '" asset="') + _local_35) + '"/>')]));
                                                    }
                                                }
                                                _local_32++;
                                            }
                                            _local_18.setAnimationLayer(_local_19, _local_31, assetCollection);
                                        }
                                    }
                                    _local_19++;
                                }
                            }
                        }
                        _local_10++;
                    }
                    if (!_Str_3453(_local_7, _local_9))
                    {
                        _local_9.dispose();
                    }
                }
                _local_5++;
            }
        }

        function getCoordinateValue(k:String, _arg_2:String):Float
        {
            var _local_4:Float;
            var _local_5:Array<ASAny>;
            var _local_6:Float;
            var _local_3:Float = 0;
            if (k.length > 0)
            {
                if (k.charAt((k.length - 1)) == "%")
                {
                    k = k.substr(0, (k.length - 1));
                    _local_3 = (Std.parseFloat(k) / 100);
                }
            }
            if (_arg_2.length > 0)
            {
                _local_4 = 10000;
                _local_5 = Randomizer.getValues(1, 0, Std.int(_local_4));
                _local_6 = (ASCompat.toNumber(_local_5[0]) / _local_4);
                if (_arg_2.charAt((_arg_2.length - 1)) == "%")
                {
                    _arg_2 = _arg_2.substr(0, (_arg_2.length - 1));
                    _local_3 = (_local_3 + ((_local_6 * Std.parseFloat(_arg_2)) / 100));
                }
            }
            return _local_3;
        }

        override public function render(canvas:BitmapData, id:String, width:Float, height:Float, scale:Float, normal:IVector3d, useTexture:Bool, offsetX:Float=0, offsetY:Float=0, maxX:Float=0, maxY:Float=0, timeSinceStartMs:Int=0):PlaneBitmapData
        {
            var bitmapData:BitmapData;
            var landscape= Std.downcast(getPlane(id) , LandscapePlane);
            if (landscape == null)
            {
                landscape = Std.downcast(getPlane(PlaneRasterizer.DEFAULT) , LandscapePlane);
            }
            if (landscape == null)
            {
                return null;
            }
            if (canvas != null)
            {
                canvas.fillRect(canvas.rect, 0xFFFFFF);
            }
            bitmapData = landscape.render(canvas, width, height, scale, normal, useTexture, offsetX, offsetY, maxX, maxY, timeSinceStartMs);
            if (((!(bitmapData == null)) && (!(bitmapData == canvas))))
            {
                try
                {
                    bitmapData = bitmapData.clone();
                }
                catch(e:ASError)
                {
                    bitmapData.dispose();
                    return null;
                }
            }
            var planeBitmapData:PlaneBitmapData;
            if (((!landscape.isStatic(Std.int(scale))) && (UPDATE_INTERVAL > 0)))
            {
                planeBitmapData = new PlaneBitmapData(bitmapData, Std.int((Math.fround((timeSinceStartMs / UPDATE_INTERVAL)) * UPDATE_INTERVAL) + UPDATE_INTERVAL));
            }
            else
            {
                planeBitmapData = new PlaneBitmapData(bitmapData, -1);
            }
            return planeBitmapData;
        }

        override public function getTextureIdentifier(k:Float, _arg_2:IVector3d):String
        {
            if (_arg_2 != null)
            {
                if (_arg_2.x < 0)
                {
                    return (k + "_0");
                }
                return (k + "_1");
            }
            return super.getTextureIdentifier(k, _arg_2);
        }

	public function new() { super(); }
    }

