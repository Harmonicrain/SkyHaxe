package org.openvideoads.vast.tracking
;
    import org.openvideoads.base.Debuggable;

     class TrackingTable extends Debuggable 
    {
        var _Str_24074:String = "-no-id-";
        var _points:Array<ASAny>;
        var _Str_9567:Float = -1;
        var _Str_11057:Float = 0;
        var _Str_8737:Float = -1;
        var _index:Int = -1;

        public function new(k:String, _arg_2:Int, _arg_3:Int)
        {
            this._points = new Array<ASAny>();
            super();
            this._Str_24074 = k;
            this._index = _arg_2;
            this._Str_8737 = _arg_3;
        }

        public var _Str_25961(get,never):Float;
public function  get__Str_25961():Float
        {
            return this._Str_9567;
        }

        public var _Str_26096(get,never):Float;
public function  get__Str_26096():Float
        {
            return this._Str_11057;
        }

        function _Str_26205():String
        {
            return (Std.string(this._index) + ":") + Std.string(this._Str_8737);
        }

        public function _Str_24378(k:_Str_2460, _arg_2:Bool=false)
        {
            k._Str_20299 = _arg_2;
            this._points[this._points.length] = {
                "point":k,
                "hit":false,
                "childLinear":_arg_2
            }
;            if (!_arg_2)
            {
                if (((this._Str_9567 < 0) || (k.milliseconds < this._Str_9567)))
                {
                    this._Str_9567 = k.milliseconds;
                }
                if (k.milliseconds > this._Str_11057)
                {
                    this._Str_11057 = k.milliseconds;
                }
            }
        }

        public function _Str_26013(k:String)
        {
            var _local_2 = 0;
            while (_local_2 < this._points.length)
            {
                if (k.indexOf(this._points[_local_2].point.label) > -1)
                {
                    this._points.splice(_local_2, 1);
                }
                else
                {
                    _local_2++;
                }
            }
        }

        public function resetAllTrackingPoints()
        {
            var k = 0;
            while (k < this._points.length)
            {
                this._points[k].hit = false;
                k++;
            }
        }

        public function resetRepeatableTrackingPoints()
        {
            this._Str_24916(0);
        }

        public function _Str_24916(k:Float)
        {
            var _local_3:ASObject = null;
            var _local_2 = 0;
            while (_local_2 < this._points.length)
            {
                _local_3 = this._points[_local_2];
                if (_local_3.point.milliseconds >= k)
                {
                    if (_local_3.point.repeatable())
                    {
                        _local_3.hit = false;
                    }
                }
                _local_2++;
            }
        }

        public function isTimeInBaseRange(k:Float):Bool
        {
            if (this._Str_9567 == -1)
            {
                return false;
            }
            return (this._Str_9567 <= k) && (this._Str_11057 >= k);
        }

        public function timeBetweenTwoPoints(k:Float, _arg_2:String, _arg_3:String):Bool
        {
            var _local_4= this.getTrackingPointOfType(_arg_2);
            var _local_5= this.getTrackingPointOfType(_arg_3);
            if (((!(_local_4 == null)) && (!(_local_5 == null))))
            {
                return (_local_4.milliseconds <= k) && (_local_5.milliseconds >= k);
            }
            return false;
        }

        public function getTrackingPointOfType(k:String, _arg_2:Bool=false, _arg_3:Bool=false):_Str_2460
        {
            var _local_5:ASObject = null;
            var _local_4 = 0;
            while (_local_4 < this._points.length)
            {
                _local_5 = this._points[_local_4];
                if (!((!_arg_2) && ASCompat.toBool(_local_5.childLinear)))
                {
                    if (_local_5.point.label == k)
                    {
                        if (_arg_3)
                        {
                            _local_5.hit = true;
                        }
                        return _local_5.point;
                    }
                }
                _local_4++;
            }
            return null;
        }

        public function _Str_26408(k:_Str_4278, _arg_2:Bool=true):_Str_2460
        {
            var _local_4:ASObject = null;
            var _local_3 = 0;
            while (_local_3 < this._points.length)
            {
                _local_4 = this._points[_local_3];
                if (!(((!_arg_2) && ASCompat.toBool(_local_4.childLinear)) || (_arg_2 && (!_local_4.childLinear))))
                {
                    if (!_local_4.hit)
                    {
                        if (k.label != null)
                        {
                            if (((_local_4.point.milliseconds <= k.milliseconds) && (_local_4.point.label == k.label)))
                            {
                                _local_4.hit = true;
                                return _local_4.point;
                            }
                        }
                        else
                        {
                            if ((_local_4.point.milliseconds <= k.milliseconds))
                            {
                                _local_4.hit = true;
                                return _local_4.point;
                            }
                            if (_local_4.milliseconds > k.milliseconds)
                            {
                                return null;
                            }
                        }
                    }
                }
                _local_3++;
            }
            return null;
        }

        public function _Str_25880(k:Bool=false):Bool
        {
            var _local_3:ASObject = null;
            var _local_2 = 0;
            while (_local_2 < this._points.length)
            {
                _local_3 = this._points[_local_2];
                if ((k && ASCompat.toBool(_local_3.childLinear)))
                {
                    if (_local_3.hit)
                    {
                        return true;
                    }
                }
                else
                {
                    if (((!k) && (!_local_3.childLinear)))
                    {
                        if (_local_3.hit)
                        {
                            return true;
                        }
                    }
                }
                _local_2++;
            }
            return false;
        }

        public function activeTrackingPoints(k:_Str_4278, _arg_2:Bool=true):Array<ASAny>
        {
            var _local_4:ASObject = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_3= new Array<ASAny>();
            if ((((_arg_2 == false) && (k.milliseconds > this._Str_11057)) && (k.label == null)))
            {
                _local_5 = 0;
                while (_local_5 < this._points.length)
                {
                    _local_4 = this._points[_local_5];
                    if (_local_4.hit)
                    {
                    }
                    else
                    {
                        if (((_local_4.childLinear == false) && ((!(_local_4.point.label == "NS")) && (!(_local_4.point.label == "CS")))))
                        {
                            _local_4.hit = true;
                            _local_3.push(_local_4.point);
                        }
                    }
                    _local_5++;
                }
            }
            else
            {
                if ((_arg_2 || this.isTimeInBaseRange(k.milliseconds)))
                {
                    _local_6 = 0;
                    while (_local_6 < this._points.length)
                    {
                        _local_4 = this._points[_local_6];
                        if (!(((!_arg_2) && ASCompat.toBool(_local_4.childLinear)) || (_arg_2 && (!_local_4.childLinear))))
                        {
                            if (_local_4.hit)
                            {
                            }
                            else
                            {
                                if (k.label != null)
                                {
                                    if (((_local_4.point.milliseconds <= k.milliseconds) && (_local_4.point.label == k.label)))
                                    {
                                        _local_4.hit = true;
                                        _local_3.push(_local_4.point);
                                    }
                                }
                                else
                                {
                                    if ((_local_4.point.milliseconds <= k.milliseconds))
                                    {
                                        _local_4.hit = true;
                                        _local_3.push(_local_4.point);
                                    }
                                    else
                                    {
                                        if (_local_4.milliseconds > k.milliseconds)
                                        {
                                        }
                                    }
                                }
                            }
                        }
                        _local_6++;
                    }
                }
            }
            return _local_3;
        }

        public function _Str_26188(k:Int):_Str_2460
        {
            if (k < this.length)
            {
                return this._points[k].point;
            }
            return null;
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            return this._points.length;
        }

        public function _Str_26426(k:Int):_Str_2460
        {
            if (k < (this.length - 1))
            {
                return this._points[k].point;
            }
            return null;
        }
    }

