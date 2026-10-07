package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;

     class BoxSizerController extends ContainerController implements IBoxSizerWindow 
    {
        var _spacing:Int = 5;
        var _horizontalPadding:Int = 8;
        var _verticalPadding:Int = 8;
        var _vertical:Bool = false;
        var _autoArrange:Bool = true;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            switch (_arg_2.type)
            {
                case WindowEvent.WINDOW_EVENT_CHILD_RELOCATED
                   | WindowEvent.WINDOW_EVENT_CHILD_REMOVED
                   | WindowEvent.WINDOW_EVENT_CHILD_ADDED
                   | WindowEvent.WINDOW_EVENT_CHILD_RESIZED
                   | WindowEvent.WINDOW_EVENT_RESIZED
                   | WindowEvent.WINDOW_EVENT_CHILD_VISIBILITY:
                    this.arrangeChildren();
                    
            }
            return super.update(k, _arg_2);
        }

        function arrangeChildren()
        {
            var _local_2:IWindow = null;
            if (!this._autoArrange)
            {
                return;
            }
            var k:IWindow = null;
            var _local_3= this.calculateSpaceForRelatives();
            var _local_4= this.getRelativeValuesSum();
            if (!this._vertical)
            {
                final _iter_ = _children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.visible)
                    {
                        if (k == null)
                        {
                            _local_2.x = this._horizontalPadding;
                        }
                        else
                        {
                            _local_2.x = ((k.x + k.width) + this._spacing);
                        }
                        _local_2.y = this._verticalPadding;
                        if (this.getRelativeValue(_local_2) > 0)
                        {
                            _local_2.width = Std.int((_local_3 * this.getRelativeValue(_local_2)) / _local_4);
                        }
                        k = _local_2;
                    }
                }
            }
            else
            {
                final _iter_ = _children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.visible)
                    {
                        if (k == null)
                        {
                            _local_2.y = this._verticalPadding;
                        }
                        else
                        {
                            _local_2.y = ((k.y + k.height) + this._spacing);
                        }
                        _local_2.x = this._horizontalPadding;
                        if (this.getRelativeValue(_local_2) > 0)
                        {
                            _local_2.height = Std.int((_local_3 * this.getRelativeValue(_local_2)) / _local_4);
                        }
                        k = _local_2;
                    }
                }
            }
        }

        function getRelativeValue(k:IWindow):Int
        {
            var _local_3:String = null;
            var _local_2 = 0;
            var _local_4 = 0;
            while (_local_4 < k.tags.length)
            {
                _local_3 = k.tags[_local_4];
                if (_local_3.indexOf("relative") != -1)
                {
                    _local_2 = ASCompat.toInt(_local_3.substring((_local_3.indexOf("(") + 1), _local_3.indexOf(")")));
                    if (_local_2 < 0)
                    {
                        _local_2 = 0;
                    }
                    ASCompat.arraySplice(k.tags, _local_4, 1, [(("relative(" + Std.string(_local_2)) + ")")]);
                }
                _local_4++;
            }
            return _local_2;
        }

        function getRelativeValuesSum():Int
        {
            var _local_2:IWindow = null;
            var k = 0;
            final _iter_ = _children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.visible)
                {
                    k = (k + this.getRelativeValue(_local_2));
                }
            }
            return k;
        }

        function calculateSpaceForRelatives():Int
        {
            var _local_2:IWindow = null;
            var k= (this._vertical ? (this.height - (this._verticalPadding * 2)) : (this.width - (this._horizontalPadding * 2)));
            final _iter_ = _children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.visible != false)
                {
                    if (this.getRelativeValue(_local_2) == 0)
                    {
                        if (this._vertical)
                        {
                            k = (k - (_local_2.height + this._spacing));
                        }
                        else
                        {
                            k = (k - (_local_2.width + this._spacing));
                        }
                    }
                    else
                    {
                        k = (k - this._spacing);
                    }
                }
            }
            return k + this._spacing;
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            k.push(createProperty(PropertyKeys.SPACING, this._spacing));
            k.push(createProperty(PropertyKeys.VERTICAL, this._vertical));
            k.push(createProperty(PropertyKeys.PADDING_HORIZONTAL, this._horizontalPadding));
            k.push(createProperty(PropertyKeys.PADDING_VERTICAL, this._verticalPadding));
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.SPACING:
                        this._spacing = ASCompat.asInt(_local_2.value );
                        
                    case PropertyKeys.PADDING_HORIZONTAL:
                        this._horizontalPadding = ASCompat.asInt(_local_2.value );
                        
                    case PropertyKeys.PADDING_VERTICAL:
                        this._verticalPadding = ASCompat.asInt(_local_2.value );
                        
                    case PropertyKeys.VERTICAL:
                        this._vertical = ASCompat.asBoolean(_local_2.value );
                        
                }
            }
            super.properties = k;
            this.arrangeChildren();
return k;
        }

        public function setHorizontalPadding(k:Int)
        {
            this._horizontalPadding = k;
            this.arrangeChildren();
        }

        public function setVerticalPadding(k:Int)
        {
            this._verticalPadding = k;
            this.arrangeChildren();
        }

        public function setSpacing(k:Int)
        {
            this._spacing = k;
            this.arrangeChildren();
        }

        public function setVertical(k:Bool)
        {
            this._vertical = k;
            this.arrangeChildren();
        }

        public function setAutoRearrange(k:Bool)
        {
            this._autoArrange = k;
            if (k)
            {
                this.arrangeChildren();
            }
        }

        public function getAutoRearrange():Bool
        {
            return this._autoArrange;
        }
    }

