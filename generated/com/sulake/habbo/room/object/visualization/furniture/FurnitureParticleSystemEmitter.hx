package com.sulake.habbo.room.object.visualization.furniture
;
    import flash.geom.Vector3D;

     class FurnitureParticleSystemEmitter extends FurnitureParticleSystemParticle 
    {
        public static inline final CONE= "cone";
        public static inline final PLANE= "plane";
        public static inline final SPHERE= "sphere";

        var _name:String;
        var _roomObjectSpriteId:Int = -1;
        var _force:Float = Math.NaN;
        var _direction__com_sulake_habbo_room_object_visualization_furniture_FurnitureParticleSystemEmitter/*redefined private*/:Vector3D;
        var _timeStep:Float = 0.1;
        var _gravity:Float = Math.NaN;
        var _airFriction:Float = Math.NaN;
        var _explosionShape:String;
        var _particleConfigurations:Array<ASAny>;
        var _particles:Array<ASAny>;
        var _maxNumberOfParticles:Int = 0;
        var _particlesPerFrame:Int = 0;
        var _emittedParticles:Int = 0;
        var _fuseTime:Int = 10;
        var _energy:Float = 1;
        var _hasIgnited:Bool = false;
        var _burstPulse:Int = 1;

        public function new(k:String="", _arg_2:Int=-1)
        {
            this._particles = [];
            super();
            this._name = k;
            this._roomObjectSpriteId = _arg_2;
            this._particleConfigurations = [];
        }

        override public function dispose()
        {
            var k:FurnitureParticleSystemParticle;
            for (_tmp_ in this._particles)
            {
k  = _tmp_;
                k.dispose();
            }
            this._particles = null;
            this._direction__com_sulake_habbo_room_object_visualization_furniture_FurnitureParticleSystemEmitter = null;
            this._particleConfigurations = null;
            super.dispose();
        }

        public function setup(k:Int, _arg_2:Int, _arg_3:Float, _arg_4:Vector3D, _arg_5:Float, _arg_6:Float, _arg_7:String, _arg_8:Float, _arg_9:Int, _arg_10:Int)
        {
            this._maxNumberOfParticles = k;
            this._particlesPerFrame = _arg_2;
            this._force = _arg_3;
            this._direction__com_sulake_habbo_room_object_visualization_furniture_FurnitureParticleSystemEmitter = _arg_4;
            this._direction__com_sulake_habbo_room_object_visualization_furniture_FurnitureParticleSystemEmitter.normalize();
            this._gravity = _arg_5;
            this._airFriction = _arg_6;
            this._explosionShape = _arg_7;
            this._fuseTime = _arg_9;
            this._energy = _arg_8;
            this._burstPulse = _arg_10;
            this.reset();
        }

        public function reset()
        {
            var k:FurnitureParticleSystemParticle;
            for (_tmp_ in this._particles)
            {
k  = _tmp_;
                k.dispose();
            }
            this._particles = [];
            this._emittedParticles = 0;
            this._hasIgnited = false;
            this.init(0, 0, 0, this._direction__com_sulake_habbo_room_object_visualization_furniture_FurnitureParticleSystemEmitter, this._force, this._timeStep, this._fuseTime, true);
        }

        public function _Str_17988(k:FurnitureParticleSystemEmitter, _arg_2:Float)
        {
            super.copy(k, _arg_2);
            this._force = k._force;
            this._direction__com_sulake_habbo_room_object_visualization_furniture_FurnitureParticleSystemEmitter = k._direction__com_sulake_habbo_room_object_visualization_furniture_FurnitureParticleSystemEmitter;
            this._gravity = k._gravity;
            this._airFriction = k._airFriction;
            this._explosionShape = k._explosionShape;
            this._fuseTime = k._fuseTime;
            this._energy = k._energy;
            this._burstPulse = k._burstPulse;
            this._timeStep = k._timeStep;
            this._hasIgnited = k._hasIgnited;
        }

        public function configureParticle(k:Int, _arg_2:Bool, _arg_3:Array<ASAny>, _arg_4:Bool)
        {
            var _local_5= new ASDictionary<ASAny,ASAny>();
            _local_5["lifeTime"] = k;
            _local_5["isEmitter"] = _arg_2;
            _local_5["frames"] = _arg_3;
            _local_5["fade"] = _arg_4;
            this._particleConfigurations.push(_local_5);
        }

        override function ignite()
        {
            this._hasIgnited = true;
            if ((this._emittedParticles < this._maxNumberOfParticles))
            {
                if (this.age > 1)
                {
                    this.releaseParticles(this, this.direction);
                }
            }
        }

        function releaseParticles(k:FurnitureParticleSystemParticle, _arg_2:Vector3D=null)
        {
            var _local_4:FurnitureParticleSystemParticle;
            var _local_5:ASDictionary<ASAny,ASAny>;
            var _local_6:Int;
            var _local_9:Array<ASAny>;
            if (_arg_2 == null)
            {
                _arg_2 = new Vector3D();
            }
            var _local_3= new Vector3D();
            var _local_7:Bool;
            var _local_8 = false;
            _local_5 = this.getRandomParticleConfiguration();
            var _local_10 = 0;
            while (_local_10 < this._particlesPerFrame)
            {
                switch (this._explosionShape)
                {
                    case CONE:
                        _local_3.x = (this.randomBoolean(0.5) ? Math.random() : -Math.random());
                        _local_3.y = -(Math.random() + 1);
                        _local_3.z = (this.randomBoolean(0.5) ? Math.random() : -Math.random());
                        
                    case PLANE:
                        _local_3.x = (this.randomBoolean(0.5) ? Math.random() : -Math.random());
                        _local_3.y = 0;
                        _local_3.z = (this.randomBoolean(0.5) ? Math.random() : -Math.random());
                        
                    case SPHERE:
                        _local_3.x = (this.randomBoolean(0.5) ? Math.random() : -Math.random());
                        _local_3.y = (this.randomBoolean(0.5) ? Math.random() : -Math.random());
                        _local_3.z = (this.randomBoolean(0.5) ? Math.random() : -Math.random());
                        
                }
                _local_3.normalize();
                _local_4 = new FurnitureParticleSystemParticle();
                if (_local_5 != null)
                {
                    _local_6 = Math.floor(ASCompat.toNumber((Math.random() * ASCompat.toNumber(_local_5["lifeTime"])) + 10));
                    _local_7 = _local_5["isEmitter"];
                    _local_9 = _local_5["frames"];
                    _local_8 = _local_5["fade"];
                }
                else
                {
                    _local_6 = Std.int(Math.ffloor(((Math.random() * 20) + 10)));
                    _local_7 = false;
                    _local_9 = [];
                }
                _local_4.init(k.x, k.y, k.z, _local_3, this._energy, this._timeStep, _local_6, _local_7, _local_9, _local_8);
                this._particles.push(_local_4);
                this._emittedParticles++;
                _local_10++;
            }
        }

        function getRandomParticleConfiguration():ASDictionary<ASAny,ASAny>
        {
            var k= Std.int(Math.ffloor((Math.random() * this._particleConfigurations.length)));
            return this._particleConfigurations[k];
        }

        override public function update()
        {
            super.update();
            this.accumulateForces();
            this.verlet();
            this.satisfyConstraints();
            if (((!isAlive) && (this._emittedParticles < this._maxNumberOfParticles)))
            {
                if ((this.age % this._burstPulse) == 0)
                {
                    this.releaseParticles(this, this.direction);
                }
            }
        }

        public function verlet()
        {
            var _local_2:FurnitureParticleSystemParticle;
            var _local_3:Float;
            var _local_4:Float;
            var _local_5:Float;
            if ((isAlive || (this._emittedParticles < this._maxNumberOfParticles)))
            {
                _local_3 = this.x;
                _local_4 = this.y;
                _local_5 = this.z;
                this.x = (((2 - this._airFriction) * this.x) - ((1 - this._airFriction) * this._Str_10744));
                this.y = ((((2 - this._airFriction) * this.y) - ((1 - this._airFriction) * this._Str_12459)) + ((this._gravity * this._timeStep) * this._timeStep));
                this.z = (((2 - this._airFriction) * this.z) - ((1 - this._airFriction) * this._Str_11680));
                this._Str_10744 = _local_3;
                this._Str_12459 = _local_4;
                this._Str_11680 = _local_5;
            }
            var k:Array<ASAny> = [];
            for (_tmp_ in this._particles)
            {
_local_2  = _tmp_;
                _local_2.update();
                _local_3 = _local_2.x;
                _local_4 = _local_2.y;
                _local_5 = _local_2.z;
                _local_2.x = (((2 - this._airFriction) * _local_2.x) - ((1 - this._airFriction) * _local_2._Str_10744));
                _local_2.y = ((((2 - this._airFriction) * _local_2.y) - ((1 - this._airFriction) * _local_2._Str_12459)) + ((this._gravity * this._timeStep) * this._timeStep));
                _local_2.z = (((2 - this._airFriction) * _local_2.z) - ((1 - this._airFriction) * _local_2._Str_11680));
                _local_2._Str_10744 = _local_3;
                _local_2._Str_12459 = _local_4;
                _local_2._Str_11680 = _local_5;
                if (((_local_2.y > 10) || (!_local_2.isAlive)))
                {
                    k.push(_local_2);
                }
            }
            for (_tmp_ in k)
            {
_local_2  = _tmp_;
                if (_local_2.isEmitter)
                {
                }
                this._particles.splice(this._particles.indexOf(_local_2), 1);
                _local_2.dispose();
            }
        }

        function satisfyConstraints()
        {
        }

        function accumulateForces()
        {
            var k:FurnitureParticleSystemParticle;
            for (_tmp_ in this._particles)
            {
k  = _tmp_;
            }
        }

        public var particles(get,never):Array<ASAny>;
function  get_particles():Array<ASAny>
        {
            return this._particles;
        }

        public var hasIgnited(get,never):Bool;
function  get_hasIgnited():Bool
        {
            return this._hasIgnited;
        }

        function randomBoolean(k:Float):Bool
        {
            return Math.random() < k;
        }

        public var roomObjectSpriteId(get,never):Int;
function  get_roomObjectSpriteId():Int
        {
            return this._roomObjectSpriteId;
        }
    }

