package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.core.utils.Map;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import flash.geom.Point;
    import flash.display.BlendMode;
    import flash.geom.Vector3D;

     class FurnitureParticleSystem 
    {
        var _emitters:Map;
        var _visualization:FurnitureAnimatedVisualization;
        var _size:Int = 0;
        var _canvasId:Int = 0;
        var _offsetY:Int = 0;
        var _currentEmitter:FurnitureParticleSystemEmitter;
        var _canvas:BitmapData;
        var _roomSprite:IRoomObjectSprite;
        var _hasIgnited:Bool = false;
        var _centerX:Int = 0;
        var _centerY:Int = 0;
        var _scaleMultiplier:Float = 1;
        var _blackOverlay:BitmapData;
        var _blackOverlayAlphaTransform:ColorTransform;
        var _particleColorTransform:ColorTransform;
        var _identityMatrix:Matrix;
        var _translationMatrix:Matrix;
        var _blend:Float = 1;
        var _bgColor:UInt = 0xFF000000;

        public function new(k:FurnitureAnimatedVisualization)
        {
            this._emitters = new Map();
            this._visualization = k;
            this._blackOverlayAlphaTransform = new ColorTransform();
            this._blackOverlayAlphaTransform.alphaMultiplier = 1;
            this._particleColorTransform = new ColorTransform();
            this._identityMatrix = new Matrix();
            this._translationMatrix = new Matrix();
        }

        public function dispose()
        {
            var k:FurnitureParticleSystemEmitter;
            for (_tmp_ in this._emitters.getValues())
            {
k  = _tmp_;
                k.dispose();
            }
            this._emitters = null;
            if (this._canvas != null)
            {
                this._canvas.dispose();
                this._canvas = null;
            }
            if (this._blackOverlay != null)
            {
                this._blackOverlay.dispose();
                this._blackOverlay = null;
            }
            this._blackOverlayAlphaTransform = null;
            this._particleColorTransform = null;
            this._identityMatrix = null;
            this._translationMatrix = null;
        }

        public function reset()
        {
            if (this._currentEmitter != null)
            {
                this._currentEmitter.reset();
            }
            this._currentEmitter = null;
            this._hasIgnited = false;
            this.updateCanvas();
        }

        public function setAnimation(k:Int)
        {
            if (this._currentEmitter != null)
            {
                this._currentEmitter.reset();
            }
            this._currentEmitter = this._emitters.getValue(k);
            this._hasIgnited = false;
            this.updateCanvas();
        }

        function updateCanvas()
        {
            if (this._currentEmitter == null)
            {
                return;
            }
            if (this._canvasId >= 0)
            {
                this._roomSprite = this._visualization.getSprite(this._canvasId);
                if (((this._roomSprite != null) && (this._roomSprite.asset != null)))
                {
                    if (((this._roomSprite.width <= 1) || (this._roomSprite.height <= 1)))
                    {
                        return;
                    }
                    if (((this._canvas != null) && ((!(this._canvas.width == this._roomSprite.width)) || (!(this._canvas.height == this._roomSprite.height)))))
                    {
                        this._canvas = null;
                    }
                    if (this._canvas == null)
                    {
                        this._canvas = this._roomSprite.asset.clone();
                        if (this._blackOverlayAlphaTransform.alphaMultiplier != 1)
                        {
                            this._blackOverlay = new BitmapData(this._canvas.width, this._canvas.height, true, this._bgColor);
                        }
                    }
                    this._centerX = -this._roomSprite.offsetX;
                    this._centerY = -this._roomSprite.offsetY;
                    this._roomSprite.asset = this._canvas;
                }
                if (this._canvas != null)
                {
                    this._canvas.fillRect(this._canvas.rect, this._bgColor);
                }
                if (this._blackOverlay != null)
                {
                    this._blackOverlay.fillRect(this._blackOverlay.rect, this._bgColor);
                }
            }
        }

        public function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (((this._currentEmitter != null) && (this._currentEmitter.roomObjectSpriteId == _arg_3)))
            {
                return Std.int(this._currentEmitter.y * this._scaleMultiplier);
            }
            return 0;
        }

        public function controlsSprite(k:Int):Bool
        {
            if (this._currentEmitter != null)
            {
                return this._currentEmitter.roomObjectSpriteId == k;
            }
            return false;
        }

        public function updateSprites()
        {
            if (((!(this._currentEmitter != null)) || (!(this._roomSprite != null))))
            {
                return;
            }
            if (((this._canvas != null) && (!(this._roomSprite.asset == this._canvas))))
            {
                this._roomSprite.asset = this._canvas;
                this._roomSprite.asset.width;
            }
            if (this._hasIgnited)
            {
                if (this._currentEmitter.roomObjectSpriteId >= 0)
                {
                    this._visualization.getSprite(this._currentEmitter.roomObjectSpriteId).visible = false;
                }
            }
        }

        public function updateAnimation()
        {
            var _local_3:Int;
            var _local_4:Int;
            var _local_5:Rectangle;
            var _local_6:IGraphicAsset;
            var _local_7:BitmapData;
            var _local_9:Point;
            var _local_10:Point;
            var _local_11:FurnitureParticleSystemParticle;
            if (((!(this._currentEmitter != null)) || (!(this._roomSprite != null))))
            {
                return;
            }
            var k:Float = 10;
            var _local_2:Float = 0;
            var _local_8:Int;
            if (((!this._hasIgnited) && this._currentEmitter.hasIgnited))
            {
                this._hasIgnited = true;
            }
            _local_8 = Std.int(this._offsetY * this._scaleMultiplier);
            this._currentEmitter.update();
            if (this._hasIgnited)
            {
                if (this._currentEmitter.roomObjectSpriteId >= 0)
                {
                    this._visualization.getSprite(this._currentEmitter.roomObjectSpriteId).visible = false;
                }
                if (this._canvas == null)
                {
                    this.updateCanvas();
                }
                this._canvas.lock();
                if (this._blackOverlayAlphaTransform.alphaMultiplier == 1)
                {
                    this._canvas.fillRect(this._canvas.rect, this._bgColor);
                }
                else
                {
                    this._canvas.draw(this._blackOverlay, this._identityMatrix, this._blackOverlayAlphaTransform, BlendMode.NORMAL, null, false);
                }
                for (_tmp_ in this._currentEmitter.particles)
                {
_local_11  = _tmp_;
                    _local_2 = _local_11.y;
                    _local_3 = Std.int(this._centerX + ((((_local_11.x - _local_11.z) * k) / 10) * this._scaleMultiplier));
                    _local_4 = Std.int((this._centerY - _local_8) + ((((_local_2 + ((_local_11.x + _local_11.z) / 2)) * k) / 10) * this._scaleMultiplier));
                    _local_6 = _local_11.getAsset();
                    if (_local_6 != null)
                    {
                        _local_7 = ASCompat.dynamicAs(_local_6.asset.content , BitmapData);
                        if ((_local_11.fade && (_local_11.alphaMultiplier < 1)))
                        {
                            this._translationMatrix.identity();
                            this._translationMatrix.translate((_local_3 + _local_6.offsetX), (_local_4 + _local_6.offsetY));
                            this._particleColorTransform.alphaMultiplier = _local_11.alphaMultiplier;
                            this._canvas.draw(_local_7, this._translationMatrix, this._particleColorTransform, BlendMode.NORMAL, null, false);
                        }
                        else
                        {
                            _local_10 = new Point((_local_3 + _local_6.offsetX), (_local_4 + _local_6.offsetY));
                            this._canvas.copyPixels(_local_7, _local_7.rect, _local_10, null, null, true);
                        }
                    }
                    else
                    {
                        _local_5 = new Rectangle((_local_3 - 1), (_local_4 - 1), 2, 2);
                        this._canvas.fillRect(_local_5, 0xFFFFFFFF);
                    }
                }
                this._canvas.unlock();
            }
        }

        public function parseData(k:com.sulake.core.utils.xml.XML)
        {
            var _local_3:IRoomObjectSprite;
            var _local_4:com.sulake.core.utils.xml.XML;
            var _local_5:Int;
            var _local_6:String;
            var _local_7:Int;
            var _local_8:FurnitureParticleSystemEmitter;
            var _local_9:Int;
            var _local_10:Int;
            var _local_11:Int;
            var _local_12:Int;
            var _local_13:Float;
            var _local_14:Float;
            var _local_15:Float;
            var _local_16:Float;
            var _local_17:String;
            var _local_18:Float;
            var _local_19:Int;
            var _local_20:Bool;
            var _local_21:Bool;
            var _local_22:Array<ASAny>;
            var _local_23:IGraphicAsset;
            var _local_24:com.sulake.core.utils.xml.XML;
            var _local_25:com.sulake.core.utils.xml.XML;
            this._size = ASCompat.parseInt(k.attribute("size").toString());
            this._canvasId = (k.hasOwnProperty("@canvas_id") ? ASCompat.parseInt(k.attribute("canvas_id").toString()) : -1);
            this._offsetY = (k.hasOwnProperty("@offset_y") ? ASCompat.parseInt(k.attribute("offset_y").toString()) : 10);
            this._scaleMultiplier = (this._size / 64);
            this._blend = (k.hasOwnProperty("@blend") ? ASCompat.toNumber(k.attribute("blend").toString()) : 1);
            this._blend = Math.min(this._blend, 1);
            this._blackOverlayAlphaTransform.alphaMultiplier = this._blend;
            var _local_2= (k.hasOwnProperty("@bgcolor") ? k.attribute("bgcolor").toString() : "0");
            this._bgColor = (k.hasOwnProperty("@bgcolor") ? ASCompat.parseInt(_local_2, 16) : 0xFF000000);
            for (_tmp_ in k.child("emitter"))
            {
_local_4  = _tmp_;
                _local_5 = ASCompat.parseInt(_local_4.attribute("id").toString());
                _local_6 = _local_4.attribute("name").toString();
                _local_7 = ASCompat.parseInt(_local_4.attribute("sprite_id").toString());
                _local_8 = new FurnitureParticleSystemEmitter(_local_6, _local_7);
                this._emitters.setValue(_local_5, _local_8);
                _local_9 = ASCompat.parseInt(_local_4.attribute("max_num_particles").toString());
                _local_10 = ASCompat.parseInt(_local_4.attribute("particles_per_frame").toString());
                _local_11 = (_local_4.hasOwnProperty("@burst_pulse") ? ASCompat.parseInt(_local_4.attribute("burst_pulse").toString()) : 1);
                _local_12 = ASCompat.parseInt(_local_4.attribute("fuse_time").toString());
                _local_13 = ASCompat.toNumber(_local_4.child("simulation").attribute("force").toString());
                _local_14 = ASCompat.toNumber(_local_4.child("simulation").attribute("direction").toString());
                _local_15 = ASCompat.toNumber(_local_4.child("simulation").attribute("gravity").toString());
                _local_16 = ASCompat.toNumber(_local_4.child("simulation").attribute("airfriction").toString());
                _local_17 = _local_4.child("simulation").attribute("shape").toString();
                _local_18 = ASCompat.toNumber(_local_4.child("simulation").attribute("energy").toString());
                for (_tmp_ in _local_4.child("particles").child("particle"))
                {
_local_24  = _tmp_;
                    _local_19 = ASCompat.parseInt(_local_24.attribute("lifetime").toString());
                    _local_20 = ((_local_24.attribute("is_emitter") .toString()== "false") ? false : true);
                    _local_21 = ((_local_24.hasOwnProperty("@fade") && (_local_24.attribute("fade") .toString()== "true")) ? true : false);
                    _local_22 = [];
                    for (_tmp_ in _local_24.child("frame"))
                    {
_local_25  = _tmp_;
                        _local_23 = this._visualization.assetCollection.getAsset(_local_25.attribute("name").toString());
                        _local_22.push(_local_23);
                    }
                    _local_8.configureParticle(_local_19, _local_20, _local_22, _local_21);
                }
                _local_8.setup(_local_9, _local_10, _local_13, new Vector3D(0, _local_14, 0), _local_15, _local_16, _local_17, _local_18, _local_12, _local_11);
            }
        }

        public function _Str_17988(k:FurnitureParticleSystem)
        {
            var _local_2 = 0;
            if (((k._emitters != null) && (k._currentEmitter != null)))
            {
                _local_2 = ASCompat.toInt(k._emitters.getKey(k._emitters.getValues().indexOf(k._currentEmitter)));
            }
            this.setAnimation(_local_2);
            if (this._currentEmitter != null)
            {
                this._currentEmitter._Str_17988(k._currentEmitter, (k._size / this._size));
            }
            this._canvas = null;
        }
    }

