package com.sulake.habbo.moderation
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IFrameWindow;

     class WindowTracker 
    {
        public static inline final _Str_17385= 1;
        public static inline final _Str_18900= 2;
        public static inline final _Str_15411= 3;
        public static inline final _Str_10414= 4;
        public static inline final _Str_15435= 5;
        public static inline final _Str_14197= 6;
        public static inline final _Str_18770= 7;
        public static inline final _Str_18611= 8;
        public static inline final _Str_16350= 9;

        var _windowsByType:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._windowsByType = new ASDictionary<ASAny,ASAny>();
        }

        public function show(k:ITrackedWindow, _arg_2:IFrameWindow, _arg_3:Bool, _arg_4:Bool, _arg_5:Bool, _arg_6:Bool=false, _arg_7:Int=0, _arg_8:Int=0, _arg_9:Int=0, _arg_10:Int=0)
        {
            var _local_12:IWindow = null;
            var _local_13 = 0;
            var _local_14:IWindow = null;
            var _local_11= this.removeWindow(k.getType(), k.getId());
            if (((!(_local_11 == null)) && (!_local_11.disposed)))
            {
                if (_arg_5)
                {
                    k.dispose();
                    _local_11.dispose();
                    return;
                }
                k.show();
                _local_12 = _local_11.getFrame();
                k.getFrame().x = (_arg_6 ? _arg_7 : _local_12.x);
                k.getFrame().y = (_arg_6 ? _arg_8 : _local_12.y);
                k.getFrame().width = (_arg_6 ? _arg_9 : _local_12.width);
                k.getFrame().height = (_arg_6 ? _arg_10 : _local_12.height);
                this._Str_17883(k.getType())[k.getId()] = k;
                _local_11.dispose();
            }
            else
            {
                if (!_arg_4)
                {
                    k.show();
                    if (_arg_2 != null)
                    {
                        _local_13 = 5;
                        if (_arg_3)
                        {
                            k.getFrame().x = (_arg_6 ? _arg_7 : _arg_2.x);
                            k.getFrame().y = (_arg_6 ? _arg_8 : ((_arg_2.y + _arg_2.height) + _local_13));
                        }
                        else
                        {
                            k.getFrame().x = (_arg_6 ? _arg_7 : ((_arg_2.x + _arg_2.width) + _local_13));
                            k.getFrame().y = (_arg_6 ? _arg_8 : _arg_2.y);
                        }
                    }
                    else
                    {
                        if (_arg_6)
                        {
                            k.getFrame().x = _arg_7;
                            k.getFrame().y = _arg_8;
                        }
                        else
                        {
                            _local_14 = k.getFrame().desktop;
                            k.getFrame().x = Std.int((_local_14.width / 2) - (k.getFrame().width / 2));
                            k.getFrame().y = Std.int((_local_14.height / 2) - (k.getFrame().height / 2));
                        }
                    }
                    k.getFrame().x = Std.int(Math.max(0, Math.min(k.getFrame().x, (k.getFrame().desktop.width - k.getFrame().width))));
                    k.getFrame().y = Std.int(Math.max(0, Math.min(k.getFrame().y, (k.getFrame().desktop.height - k.getFrame().height))));
                    this._Str_17883(k.getType())[k.getId()] = k;
                }
            }
        }

        function removeWindow(k:Int, _arg_2:String):ITrackedWindow
        {
            var _local_3= this._Str_17883(k);
            var _local_4:ITrackedWindow = _local_3[_arg_2];
            _local_3[_arg_2] = null;
            return _local_4;
        }

        function _Str_17883(k:Int):ASDictionary<ASAny,ASAny>
        {
            var _local_2:ASDictionary<ASAny,ASAny> = this._windowsByType[k];
            if (_local_2 == null)
            {
                _local_2 = new ASDictionary<ASAny,ASAny>();
                this._windowsByType[k] = _local_2;
            }
            return _local_2;
        }
    }

