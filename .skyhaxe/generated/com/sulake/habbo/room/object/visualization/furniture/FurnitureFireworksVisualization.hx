package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureFireworksVisualization extends FurnitureAnimatedVisualization 
    {
        var _particleSystems:ASDictionary<ASAny,ASAny>;
        var _currentParticleSystem:FurnitureParticleSystem;


        override public function dispose()
        {
            var k:FurnitureParticleSystem = null;
            super.dispose();
            this._currentParticleSystem = null;
            if (this._particleSystems != null)
            {
                final _iter_ = this._particleSystems; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.dispose();
                }
                this._particleSystems = null;
            }
        }

        override function updateObject(k:Float, _arg_2:Float):Bool
        {
            var _local_3 = false;
            var _local_4:FurnitureParticleSystem = null;
            if (super.updateObject(k, _arg_2))
            {
                _local_3 = false;
                if (this._particleSystems == null)
                {
                    this._Str_18684();
                    if (this._particleSystems != null)
                    {
                        this._currentParticleSystem = this._particleSystems[k];
                        _local_3 = true;
                    }
                    else
                    {
                        Logger.log([("ERROR Particle systems could not be read! " + this.object.getType())]);
                    }
                }
                else
                {
                    if (((!(k == _currentScale)) || (!(this._particleSystems[k] == this._currentParticleSystem))))
                    {
                        _local_4 = this._particleSystems[k];
                        _local_4._Str_17988(this._currentParticleSystem);
                        if (this._currentParticleSystem != null)
                        {
                            this._currentParticleSystem.reset();
                        }
                        this._currentParticleSystem = _local_4;
                        _local_3 = true;
                    }
                }
                return true;
            }
            return false;
        }

        override function updateSprites(k:Int, _arg_2:Bool, _arg_3:Int)
        {
            super.updateSprites(k, _arg_2, _arg_3);
            if (this._currentParticleSystem != null)
            {
                this._currentParticleSystem.updateSprites();
            }
        }

        override function updateAnimation(k:Float):Int
        {
            if (this._currentParticleSystem != null)
            {
                this._currentParticleSystem.updateAnimation();
            }
            return super.updateAnimation(k);
        }

        override function setAnimation(k:Int)
        {
            if (this._currentParticleSystem != null)
            {
                this._currentParticleSystem.setAnimation(k);
            }
            super.setAnimation(k);
        }

        override function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (((this._currentParticleSystem != null) && this._currentParticleSystem.controlsSprite(_arg_3)))
            {
                return this._currentParticleSystem.getSpriteYOffset(k, _arg_2, _arg_3);
            }
            return super.getSpriteYOffset(k, _arg_2, _arg_3);
        }

        function _Str_18684():Bool
        {
            var _local_5:FurnitureParticleSystem = null;
            var _local_6 = 0;
            var _local_7:com.sulake.core.utils.xml.XML = null;
            var k= object;
            if (k == null)
            {
                return false;
            }
            var _local_2= k.getModel();
            if (_local_2 == null)
            {
                return false;
            }
            var _local_3= _local_2.getString(RoomObjectVariableEnum.FURNITURE_FIREWORKS_DATA);
            if (((!ASCompat.stringAsBool(_local_3)) || (_local_3.length == 0)))
            {
                Logger.log(["No Particle System Data Found."]);
                return false;
            }
            var _local_4= new com.sulake.core.utils.xml.XML(_local_3);
            this._particleSystems = new ASDictionary<ASAny,ASAny>();
            final _iter_ = _local_4.child("particlesystem"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_7  = _tmp_;
                if (!_local_7.hasOwnProperty("@size"))
                {
                    Logger.log(["Particle System does not have size property!"]);
                }
                else
                {
                    _local_6 = ASCompat.toInt(ASCompat.xmlListToString(_local_7.attribute("size")));
                    _local_5 = new FurnitureParticleSystem(this);
                    _local_5.parseData(_local_7);
                    this._particleSystems[_local_6] = _local_5;
                }
            }
            return true;
        }

	public function new() { super(); }
    }

