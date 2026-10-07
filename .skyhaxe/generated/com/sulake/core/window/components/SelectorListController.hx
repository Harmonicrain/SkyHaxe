package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;

     class SelectorListController extends SelectorController implements ISelectorListWindow 
    {
        var _spacing:Int = 0;
        var _repositioning:Bool = false;
        var _vertical:Bool = false;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            _Str_16599 = false;
        }

        
        public var spacing(get,set):Int;
public function  get_spacing():Int
        {
            return this._spacing;
        }
public function  set_spacing(k:Int):Int        {
            this._spacing = k;
            this.updateSelectableRegion();
return k;
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_CHILD_ADDED)
            {
                this.updateSelectableRegion();
            }
            else
            {
                if (_arg_2.type == WindowEvent.WINDOW_EVENT_CHILD_RESIZED)
                {
                    this.updateSelectableRegion();
                }
                else
                {
                    if (_arg_2.type == WindowEvent.WINDOW_EVENT_CHILD_RELOCATED)
                    {
                        this.updateSelectableRegion();
                    }
                }
            }
            return super.update(k, _arg_2);
        }

        function updateSelectableRegion()
        {
            var _local_2:IWindow = null;
            var _local_4:UInt = 0;
            if (this._repositioning)
            {
                return;
            }
            this._repositioning = true;
            var k= numSelectables;
            var _local_3 = 0;
            _local_4 = 0;
            while (_local_4 < k)
            {
                _local_2 = getSelectableAt(ASCompat.toInt(_local_4));
                if (this._vertical)
                {
                    _local_2.y = _local_3;
                    _local_3 = (_local_3 + (_local_2.height + this._spacing));
                }
                else
                {
                    _local_2.x = _local_3;
                    _local_3 = (_local_3 + (_local_2.width + this._spacing));
                }
                _local_4++;
            }
            this._repositioning = false;
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            k.push(createProperty(PropertyKeys.SPACING, this._spacing));
            k.push(createProperty(PropertyKeys.VERTICAL, this._vertical));
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
                        if (_local_2.value != this._spacing)
                        {
                            this.spacing = ASCompat.asInt(_local_2.value );
                        }
                        
                    case PropertyKeys.VERTICAL:
                        if (_local_2.value != this._vertical)
                        {
                            this.vertical = ASCompat.asBoolean(_local_2.value );
                        }
                        
                }
            }
            return super.properties = k;
        }

        
        public var vertical(get,set):Bool;
public function  get_vertical():Bool
        {
            return this._vertical;
        }
public function  set_vertical(k:Bool):Bool        {
            this._vertical = k;
            this.updateSelectableRegion();
return k;
        }
    }

