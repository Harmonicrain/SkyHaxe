package com.sulake.core.window.components
;
    import com.sulake.core.window.utils.IIterable;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.iterators.SelectorIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.WindowController;

     class SelectorController extends InteractiveController implements ISelectorWindow implements  IIterable 
    {
        var _Str_1007:ISelectableWindow;
        var _Str_16599:Bool = true;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return new SelectorIterator(this);
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_CHILD_ACTIVATED)
            {
                if (Std.is(k , ISelectableWindow))
                {
                    this.setSelected(ASCompat.reinterpretAs(k , ISelectableWindow));
                }
            }
            return super.update(k, _arg_2);
        }

        public var numSelectables(get,never):UInt;
public function  get_numSelectables():UInt
        {
            return numChildren;
        }

        public function getSelected():ISelectableWindow
        {
            return this._Str_1007 ;
        }

        public function setSelected(k:ISelectableWindow)
        {
            var _local_2:ISelectableWindow = null;
            if (k != null)
            {
                if (k != this._Str_1007)
                {
                    if (this._Str_1007 != null)
                    {
                        if (!this._Str_1007.unselect())
                        {
                            return;
                        }
                    }
                    _local_2 = this._Str_1007;
                    this._Str_1007 = k;
                    if (this._Str_1007.select())
                    {
                        if (getChildIndex(k) > -1)
                        {
                            if (this._Str_16599)
                            {
                                if (getChildIndex(k) != (numChildren - 1))
                                {
                                    setChildIndex(k, (numChildren - 1));
                                }
                            }
                        }
                    }
                    else
                    {
                        this._Str_1007 = _local_2;
                        if (this._Str_1007 != null)
                        {
                            this._Str_1007.select();
                        }
                    }
                }
            }
        }

        public function addSelectable(k:ISelectableWindow):ISelectableWindow
        {
            var _local_2= cast(addChild(k), ISelectableWindow);
            return _local_2;
        }

        public function addSelectableAt(k:ISelectableWindow, _arg_2:Int):ISelectableWindow
        {
            var _local_3= cast(addChildAt(k, _arg_2), ISelectableWindow);
            return _local_3;
        }

        public function getSelectableAt(k:Int):ISelectableWindow
        {
            return Std.downcast(getChildAt(k) , ISelectableWindow);
        }

        public function getSelectableByID(k:UInt):ISelectableWindow
        {
            return Std.downcast(getChildByID(ASCompat.toInt(k)) , ISelectableWindow);
        }

        public function getSelectableByTag(k:String):ISelectableWindow
        {
            return Std.downcast(getChildByTag(k) , ISelectableWindow);
        }

        public function getSelectableByName(k:String):ISelectableWindow
        {
            return Std.downcast(getChildByName(k) , ISelectableWindow);
        }

        public function getSelectableIndex(k:ISelectableWindow):Int
        {
            return getChildIndex(k);
        }

        public function removeSelectable(k:ISelectableWindow):ISelectableWindow
        {
            var _local_2= getChildIndex(k);
            if (_local_2 > -1)
            {
                if (k == this._Str_1007)
                {
                    if (this.numSelectables > 1)
                    {
                        this.setSelected(this.getSelectableAt(((_local_2 == 0) ? 1 : 0)));
                    }
                    else
                    {
                        this._Str_1007 = null;
                    }
                }
                return cast(removeChild(k), ISelectableWindow);
            }
            return null;
        }
    }

