package snowwar._str_231
;
	import com.sulake.core.utils.Map;
	import com.sulake.core.runtime.exceptions.Exception;
    import snowwar._str_254._SafeStr_4669;
    import snowwar._str_39.HumanGameObject;

     class SynchronizedGameStage extends _SafeStr_4025 
    {
        var _gameObjects:Map;
        var _deletedGameObjects:Array<ASAny>;
        var _removedGameObjects:Array<ASAny>;

        public function new()
        {
            this._gameObjects = new Map();
            this._deletedGameObjects = [];
            this._removedGameObjects = [];
            super();
        }

        static function intToDoubleDigitsString(num:Int):String
        {
            if (num < 10)
            {
                return "0" + Std.string(num);
            }
            return Std.string(num);
        }


        override public function dispose()
        {
            var gameObject:ISnowWarGameObject = null;
            super.dispose();
            if (this._gameObjects != null)
            {
                final _iter_ = this._gameObjects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
gameObject  = _tmp_;
                    gameObject.dispose();
                }
                this._gameObjects.dispose();
                this._gameObjects = null;
            }
            this._deletedGameObjects = [];
            this._removedGameObjects = [];
        }

        public function addActiveGameObject(k:Int, gameObject:ISnowWarGameObject)
        {
            this._gameObjects.add(k, gameObject);
            gameObject.isActive = true;
        }

        public function addInactiveGameObject(k:Int, gameObject:ISnowWarGameObject)
        {
            this._gameObjects.add(k, gameObject);
            gameObject.isActive = false;
        }

        public function _SafeStr_18708(id:Int, gameObject:ISnowWarGameObject)
        {
            this._gameObjects.add(id, gameObject);
            gameObject.isActive = true;
            if (gameObject._SafeStr_13236 != id)
            {
                throw new Exception(("Could not add gameobject with id:" + Std.string(id)));
            }
        }

        public function removeGameObject(id:Int)
        {
            var gameObject:ISnowWarGameObject = this._gameObjects.remove(id);
            if (gameObject != null)
            {
                gameObject.onRemove();
                this._removedGameObjects.push(gameObject);
            }
        }

        public function _SafeStr_18709()
        {
            var gameObject:ISnowWarGameObject = null;
            final _iter_ = this._gameObjects.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
gameObject  = _tmp_;
                gameObject.onRemove();
                this._removedGameObjects.push(gameObject);
            }
            this._gameObjects = new Map();
        }

        public function _SafeStr_18710(gameObject:ISnowWarGameObject)
        {
            if (gameObject == null)
            {
                HabboGamesCom.log(["Trying to put null in delete list."]);
                return;
            }
            this._deletedGameObjects.push(gameObject);
            gameObject.isActive = false;
        }

        public function getGameObject(id:Int):ISnowWarGameObject
        {
            return ASCompat.dynamicAs(this._gameObjects.getValue(id) , ISnowWarGameObject);
        }

        public function _SafeStr_18711():Array<ASAny>
        {
            return this._gameObjects.getValues();
        }

        public function subturn()
        {
            var gameObject:ISnowWarGameObject = null;
            var deletedObject:_SafeStr_4028 = null;
            final _iter_ = this._gameObjects.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
gameObject  = _tmp_;
                gameObject.subturn(this);
            }
            if (this._deletedGameObjects.length > 0)
            {
                final _iter_ = this._deletedGameObjects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
deletedObject  = _tmp_;
                    this.removeGameObject(deletedObject._SafeStr_13236);
                }
                this._deletedGameObjects = [];
            }
        }

        public function _SafeStr_18712(turn:Int):Int
        {
            var gameObject:ISnowWarGameObject = null;
            var _local_8 = 0;
            var variableCount = 0;
            var count = 0;
            var checkSum= _SafeStr_4669._SafeStr_18715(turn);
            var _local_4 = 0;
            var logString= "";
            var parms= "";
            if (HabboGamesCom.logEnabled)
            {
                logString = "";
                logString = (logString + (("\nturn ### " + Std.string(turn)) + " ###\n"));
                logString = (logString + (("seed " + Std.string(checkSum)) + "\n"));
                parms = "";
            }
            final _iter_ = this._gameObjects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
gameObject  = _tmp_;
                if ((gameObject._SafeStr_18700 && Std.is(gameObject , HumanGameObject)))
                {
                    cast(gameObject, HumanGameObject)._SafeStr_13262(turn);
                }
                else
                {
                    if (((!gameObject.isActive) || gameObject._SafeStr_18700))
                    {
                    }
                    else
                    {
                        _local_8 = 1;
                        variableCount = gameObject.numberOfVariables;
                        count = 0;
                        while (count < variableCount)
                        {
                            checkSum = (checkSum + (gameObject.getVariable(count) * _local_8));
                            _local_8++;
                            if (HabboGamesCom.logEnabled)
                            {
                                parms = (parms + Std.string(gameObject.getVariable(count)));
                                if (count < (variableCount - 1))
                                {
                                    parms = (parms + ",");
                                }
                            }
                            count++;
                        }
                        if (HabboGamesCom.logEnabled)
                        {
                            logString = (logString + (((((('++ "O' + intToDoubleDigitsString((_local_4 + 1))) + "-CS:") + Std.string(checkSum)) + " Parms:") + parms) + '"\n'));
                            parms = "";
                            _local_4++;
                        }
                    }
                }
            }
            HabboGamesCom.log([logString]);
            return checkSum;
        }

        public function _SafeStr_18713(k:ASObject)
        {
            var _local_3:ISnowWarGameObject = null;
            var _local_2 = 0;
            final _iter_ = this._gameObjects.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.isActive)
                {
                    _local_2++;
                }
            }
            k.writeInt(_local_2);
            final _iter_ = this._gameObjects.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.isActive)
                {
                }
            }
        }

        public function resetRemovedGameObjects():Array<ASAny>
        {
            var k= this._removedGameObjects;
            this._removedGameObjects = [];
            return k;
        }
    }

