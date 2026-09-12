package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.WindowContext;
    import com.sulake.core.window.graphics.IGraphicContext;
    import com.sulake.core.window.events.WindowEvent;

     class SubstituteParentController extends WindowController 
    {
        public function new(k:WindowContext)
        {
            super("_CONTEXT_SUBSTITUTE_PARENT", 0, 0, WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT, k, new Rectangle(0, 0, 2000, 2000), null, null, null, null, 0);
            _children = new Vector<IWindow>();
            _drawable = false;
        }

        override public function getGraphicContext(k:Bool):IGraphicContext
        {
            return null;
        }

        override public function setupGraphicsContext():IGraphicContext
        {
            return null;
        }

        function _Str_25902(k:WindowEvent)
        {
            var _local_2= k.window;
            if (getChildIndex(_local_2) != -1)
            {
                if (!_local_2.testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT))
                {
                    _local_2.desktop.addChild(_local_2);
                }
            }
        }

        override public function addChild(k:IWindow):IWindow
        {
            _children.push(k);
            return k;
        }

        override public function addChildAt(k:IWindow, _arg_2:Int):IWindow
        {
            var _local_3= cast(k, WindowController);
            if (_local_3.parent != null)
            {
                cast(_local_3.parent, WindowController).removeChild(_local_3);
            }
            _children.insertAt(_arg_2, k);
            _local_3.parent = this;
            return k;
        }

        override public function getChildAt(k:Int):IWindow
        {
            return (_children != null) ? ((k < _children.length) ? _children[k] : null) : null;
        }

        override public function getChildByID(k:Int):IWindow
        {
            var _local_2:IWindow = null;
            if (_children != null)
            {
                final _iter_ = _children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.id == k)
                    {
                        return _local_2;
                    }
                }
            }
            return null;
        }

        override public function getChildByName(k:String):IWindow
        {
            var _local_2:IWindow = null;
            if (_children != null)
            {
                final _iter_ = _children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.name == k)
                    {
                        return _local_2;
                    }
                }
            }
            return null;
        }

        override public function findChildByName(k:String):IWindow
        {
            var _local_2:WindowController = null;
            if (_children != null)
            {
                final _iter_ = _children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = cast(_tmp_, WindowController);
                    if (_local_2.name == k)
                    {
                        return _local_2;
                    }
                }
                final _iter_ = _children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = cast(_tmp_, WindowController);
                    _local_2 = Std.downcast(_local_2.findChildByName(k) , WindowController);
                    if (_local_2 != null)
                    {
                        return _local_2 ;
                    }
                }
            }
            return null;
        }

        override public function removeChild(k:IWindow):IWindow
        {
            var _local_2= _children.indexOf(k);
            if (_local_2 > -1)
            {
                _children.splice(_local_2, 1);
                k.parent = null;
                return k;
            }
            return null;
        }

        override public function setChildIndex(k:IWindow, _arg_2:Int)
        {
            var _local_3= _children.indexOf(k);
            if (((_local_3 > -1) && (!(_arg_2 == _local_3))))
            {
                _children.splice(_local_3, 1);
                _children.insertAt(_arg_2, k);
            }
        }

        override public function swapChildren(k:IWindow, _arg_2:IWindow)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5:IWindow = null;
            var _local_6 = 0;
            if ((((!(k == null)) && (!(_arg_2 == null))) && (!(k == _arg_2))))
            {
                _local_3 = _children.indexOf(k);
                if (_local_3 < 0)
                {
                    return;
                }
                _local_4 = _children.indexOf(_arg_2);
                if (_local_4 < 0)
                {
                    return;
                }
                if (_local_4 < _local_3)
                {
                    _local_5 = k;
                    k = _arg_2;
                    _arg_2 = _local_5;
                    _local_6 = _local_3;
                    _local_3 = _local_4;
                    _local_4 = _local_6;
                }
                _children.splice(_local_4, 1);
                _children.splice(_local_3, 1);
                _children.insertAt(_local_3, _arg_2);
                _children.insertAt(_local_4, k);
            }
        }

        override public function swapChildrenAt(k:Int, _arg_2:Int)
        {
            this.swapChildren(_children[k], _children[_arg_2]);
        }
    }

