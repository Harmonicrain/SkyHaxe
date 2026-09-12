package com.sulake.core.utils
;
    import com.sulake.core.runtime.IDisposable;


     class Map implements IDisposable 
    {
        var _length:UInt = 0;
        var _dictionary:ASDictionary<ASAny,ASAny>;
        var _array:Array<ASAny>;
        var _keys:Array<ASAny>;

        public function new()
        {
            this._length = 0;
            this._dictionary = new ASDictionary<ASAny,ASAny>();
            this._array = [];
            this._keys = [];
        }

        public var length(get,never):UInt;
public function  get_length():UInt
        {
            return this._length;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._dictionary == null;
        }

        public function dispose()
        {
var key:ASObject  = null;            if (this._dictionary != null)
            {
                final _iter_ = this._dictionary; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
key = _tmp_;
                    this._dictionary.remove(key);
                }
                this._dictionary = null;
            }
            this._length = 0;
            this._array = null;
            this._keys = null;
        }

        public function reset()
        {
var key:ASObject  = null;            final _iter_ = this._dictionary; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
key = _tmp_;
                this._dictionary.remove(key);
            }
            this._length = 0;
            this._array = [];
            this._keys = [];
        }

        public function unshift(key:ASAny, value:ASAny):Bool
        {
            if (this._dictionary[key] != null)
            {
                return false;
            }
            this._dictionary[key] = value;
            this._array.unshift(value);
            this._keys.unshift(key);
            this._length++;
            return true;
        }

        public function add(key:ASAny, value:ASAny):Bool
        {
            if (this._dictionary[key] != null)
            {
                return false;
            }
            this._dictionary[key] = value;
            this._array[ASCompat.toInt(this._length)] = value;
            this._keys[ASCompat.toInt(this._length)] = key;
            this._length++;
            return true;
        }

        public function remove(key:ASAny):ASAny
        {
            var value:ASObject = this._dictionary[key];
            if (value == null)
            {
                return null;
            }
            var objectIndex= this._array.indexOf(value);
            if (objectIndex >= 0)
            {
                this._array.splice(objectIndex, 1);
                this._keys.splice(objectIndex, 1);
                this._length--;
            }
            this._dictionary.remove(key);
            return value;
        }

        public function getWithIndex(index:Int):ASAny
        {
            if (((index < 0) || ((index : UInt) >= this._length)))
            {
                return null;
            }
            return this._array[index];
        }

        public function getKey(index:Int):ASAny
        {
            if (((index < 0) || ((index : UInt) >= this._length)))
            {
                return null;
            }
            return this._keys[index];
        }

        public function getKeys():Array<ASAny>
        {
            return this._keys.slice(0);
        }

        public function hasKey(key:ASAny):Bool
        {
            return this._keys.indexOf(key) > -1;
        }

        public function getValue(key:ASAny):ASAny
        {
            return this._dictionary[key];
        }

        public function getValues():Array<ASAny>
        {
            return this._array.slice(0);
        }

        public function hasValue(value:ASAny):Bool
        {
            return this._array.indexOf(value) > -1;
        }

        public function indexOf(value:ASAny):Int
        {
            return this._array.indexOf(value);
        }

        public function concatenate(newValues:Map)
        {
var key:ASAny  = null;            final _iter_ = newValues._keys; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
key = _tmp_;
                this.add(key, newValues.getValue(key));
            }
        }

        public function clone():Map
        {
            var copy= new Map();
            copy.concatenate(this);
            return copy;
        }

        public function getProperty(key:ASAny):ASAny
        {
            return this._dictionary[key];
        }

        public function setProperty(key:ASAny, value:ASAny)
        {
            this._dictionary[key] = value;
            var _local_3= this._keys.indexOf(key);
            if (_local_3 == -1)
            {
                this._array[ASCompat.toInt(this._length)] = value;
                this._keys[ASCompat.toInt(this._length)] = key;
                this._length++;
            }
            else
            {
                ASCompat.arraySplice(this._array, _local_3, 1, [value]);
            }
        }

        public function nextNameIndex(index:Int):Int
        {
            return ((index : UInt) < this._length) ? (index + 1) : 0;
        }

        public function nextName(index:Int):String
        {
            return this._keys[(index - 1)];
        }

        public function nextValue(index:Int):ASAny
        {
            return this._array[(index - 1)];
        }

        public function callProperty(property:ASAny,  _args:Array<ASAny> = null):ASAny
        {
if (_args == null) _args = [];
            return (property.localName == "toString") ? "Map" : null;
        }
    }

