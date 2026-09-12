package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.habbo.window._enum._Str_3142;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.habbo.utils._Str_988;

     class BalloonWidget implements _Str_13291 
    {
        public static inline final BALLOON= "balloon";
        static final arrowPivotPropertyKey:String = (BALLOON + ":arrow_pivot");
        static final arrowDisplacementPropertyKey:String = (BALLOON + ":arrow_displacement");
        static final _Str_15799:PropertyStruct = new PropertyStruct(arrowPivotPropertyKey, _Str_3142._Str_14331, PropertyStruct.STRING, false, _Str_3142.ALL);
        static final _Str_13694:PropertyStruct = new PropertyStruct(arrowDisplacementPropertyKey, 0, PropertyStruct.INT);
        static inline final ILLUMINA_LIGHT_BALLOON_ARROW_= "illumina_light_balloon_arrow_";
        static inline final _Str_5411= 6;
        static inline final _Str_5290= 6;
        static inline final _Str_6859= 9;

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _settingProperties:Bool = false;
        var _resizingWidget:Bool = false;
        var _root:IWindowContainer;
        var _contents:IWindowContainer;
        var _arrowHead:IStaticBitmapWrapperWindow;
        var _arrowPivot:String;
        var _arrowDisplacement:Int = 0;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._arrowPivot = ASCompat.toString(_Str_15799.value);
            this._arrowDisplacement = ASCompat.toInt(_Str_13694.value);
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("balloon_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._arrowHead = Std.downcast(this._root.findChildByName("bitmap") , IStaticBitmapWrapperWindow);
            this._contents = Std.downcast(this._root.findChildByName("border") , IWindowContainer);
            this._Str_19710();
            this._widgetWindow.addEventListener(WindowEvent.WINDOW_EVENT_RESIZE, this._Str_2832);
            this._widgetWindow.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_2832);
            this._contents.addEventListener(WindowEvent.WINDOW_EVENT_RESIZE, this._Str_2832);
            this._contents.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_2832);
            this._widgetWindow.rootWindow = this._root;
            this._root.width = this._widgetWindow.width;
            this._root.height = this._widgetWindow.height;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._contents != null)
                {
                    this._contents.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZE, this._Str_2832);
                    this._contents.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_2832);
                    this._contents = null;
                }
                this._arrowHead = null;
                if (this._root != null)
                {
                    this._root.dispose();
                    this._root = null;
                }
                if (this._widgetWindow != null)
                {
                    this._widgetWindow.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZE, this._Str_2832);
                    this._widgetWindow.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_2832);
                    this._widgetWindow.rootWindow = null;
                    this._widgetWindow = null;
                }
                this._windowManager = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return (this._contents == null) ? EmptyIterator.INSTANCE : this._contents.iterator;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(_Str_15799.withValue(this._arrowPivot));
            k.push(_Str_13694.withValue(this._arrowDisplacement));
            return k;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            this._settingProperties = true;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case arrowPivotPropertyKey:
                        this._Str_12978 = ASCompat.toString(_local_2.value);
                        
                    case arrowDisplacementPropertyKey:
                        this._Str_12751 = ASCompat.toInt(_local_2.value);
                        
                }
            }
            this._settingProperties = false;
            this.refresh();
return k;
        }

        
        public var _Str_12978(get,set):String;
public function  get__Str_12978():String
        {
            return this._arrowPivot;
        }
public function  set__Str_12978(k:String):String        {
            this._arrowPivot = k;
            this._Str_23150();
            this.refresh();
            this._Str_19710();
            this.refresh();
return k;
        }

        
        public var _Str_12751(get,set):Int;
public function  get__Str_12751():Int
        {
            return this._arrowDisplacement;
        }
public function  set__Str_12751(k:Int):Int        {
            this._arrowDisplacement = k;
            this.refresh();
return k;
        }

        function _Str_2832(k:WindowEvent)
        {
            this.refresh();
        }

        function _Str_19710()
        {
            if (this._contents != null)
            {
                this._contents.setParamFlag(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN, this._widgetWindow.getParamFlag(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN));
                this._contents.setParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN, this._widgetWindow.getParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN));
            }
        }

        function _Str_23150()
        {
            if (this._contents != null)
            {
                this._contents.setParamFlag(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN, false);
                this._contents.setParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN, false);
            }
        }

        function refresh()
        {
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4 = 0;
            if ((((this._settingProperties || this._resizingWidget) || this._disposed) || (this._contents == null)))
            {
                return;
            }
            var k= _Str_3142._Str_22659(this._arrowPivot);
            switch (k)
            {
                case _Str_3142.UP
                   | _Str_3142.DOWN:
                    _local_2 = this._contents.width;
                    _local_3 = ((this._contents.height + _Str_5290) - 1);
                    
                case _Str_3142.LEFT
                   | _Str_3142.RIGHT:
                    _local_2 = ((this._contents.width + _Str_5290) - 1);
                    _local_3 = this._contents.height;
                    
            }
            this._resizingWidget = true;
            if (this._widgetWindow.testParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN))
            {
                this._root.width = _local_2;
                this._root.height = _local_3;
            }
            else
            {
                if (this._widgetWindow.testParamFlag(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN))
                {
                    this._root.width = Std.int(Math.max(this._widgetWindow.width, _local_2));
                    this._root.height = Std.int(Math.max(this._widgetWindow.height, _local_3));
                }
                else
                {
                    this._root.width = this._widgetWindow.width;
                    this._root.height = this._widgetWindow.height;
                }
            }
            this._widgetWindow.width = this._root.width;
            this._widgetWindow.height = this._root.height;
            this._resizingWidget = false;
            this._arrowHead.assetUri = (ILLUMINA_LIGHT_BALLOON_ARROW_ + k);
            switch (k)
            {
                case _Str_3142.UP
                   | _Str_3142.DOWN:
                    switch (_Str_3142._Str_20849(this._arrowPivot))
                    {
                        case _Str_3142.MINIMUM:
                            _local_4 = _Str_5411;
                            
                        case _Str_3142.MIDDLE:
                            _local_4 = Std.int((this._root.width - _Str_6859) / 2);
                            
                        case _Str_3142.MAXIMUM:
                            _local_4 = ((this._root.width - _Str_5411) - _Str_6859);
                            
                    }
                    this._resizingWidget = true;
                    this._contents.rectangle = new Rectangle(0, ((k == _Str_3142.UP) ? (_Str_5290 - 1) : 0), this._root.width, ((this._root.height + 1) - _Str_5290));
                    this._resizingWidget = false;
                    this._arrowHead.rectangle = new Rectangle(_Str_988._Str_2040((_local_4 + this._arrowDisplacement), _Str_5411, (this._root.width - _Str_5411)), ((k == _Str_3142.UP) ? 0 : (this._contents.bottom - 1)), _Str_6859, _Str_5290);
                    return;
                case _Str_3142.LEFT
                   | _Str_3142.RIGHT:
                    switch (_Str_3142._Str_20849(this._arrowPivot))
                    {
                        case _Str_3142.MINIMUM:
                            _local_4 = _Str_5411;
                            
                        case _Str_3142.MIDDLE:
                            _local_4 = Std.int((this._root.height - _Str_6859) / 2);
                            
                        case _Str_3142.MAXIMUM:
                            _local_4 = ((this._root.height - _Str_5411) - _Str_6859);
                            
                    }
                    this._resizingWidget = true;
                    this._contents.rectangle = new Rectangle(((k == _Str_3142.LEFT) ? (_Str_5290 - 1) : 0), 0, ((this._root.width + 1) - _Str_5290), this._root.height);
                    this._resizingWidget = false;
                    this._arrowHead.rectangle = new Rectangle(((k == _Str_3142.LEFT) ? 0 : (this._contents.right - 1)), _Str_988._Str_2040((_local_4 + this._arrowDisplacement), _Str_5411, (this._root.height - _Str_5411)), _Str_5290, _Str_6859);
                    return;
            }
        }
    }

