package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.IWidgetFactory;
    import com.sulake.core.window.IWidget;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;

     class WidgetWindowController extends WindowController implements IWidgetWindow
    {
        var _widgetFactory:IWidgetFactory;
        var _widgetType:String = "";
        var _widget:IWidget;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            this._widgetFactory = _arg_5.getWidgetFactory();
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        override public function dispose()
        {
            if (!disposed)
            {
                if (this._widget != null)
                {
                    this._widget.dispose();
                    this._widget = null;
                }
                this._widgetFactory = null;
                super.dispose();
            }
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= ((this._widget != null) ? this._widget.properties : []);
            k.unshift(createProperty(PropertyKeys.WIDGET_TYPE, this._widgetType));
            return super.properties.concat(k);
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            var _local_3:String = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                if (_local_2.key == PropertyKeys.WIDGET_TYPE)
                {
                    _local_3 = ASCompat.toString(_local_2.value);
                    if (this._widgetType != _local_3)
                    {
                        if (this._widget != null)
                        {
                            removeChildAt(0);
                            this._widget.dispose();
                        }
                        this._widget = this._widgetFactory.createWidget(ASCompat.toString(_local_2.value), this);
                        this._widgetType = _local_3;
                    }
                    break;
                }
            }
            if (this._widget != null)
            {
                this._widget.properties = k;
            }
            return super.properties = k;
        }

        override public function  set_color(k:UInt):UInt        {
            var _local_3:IWindow = null;
            super.color = k;
            var _local_2= new Array<ASAny>();
            groupChildrenWithTag(WindowController._COLORIZE, _local_2, -1);
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                _local_3.color = k;
            }
return k;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return (this._widget != null) ? this._widget.iterator : EmptyIterator.INSTANCE;
        }

        public var widget(get,never):IWidget;
public function  get_widget():IWidget
        {
            return this._widget;
        }

        
        public var rootWindow(get,set):IWindow;
public function  get_rootWindow():IWindow
        {
            return getChildAt(0);
        }
public function  set_rootWindow(k:IWindow):IWindow        {
            removeChildAt(0);
            if (k == null)
            {
                return k;
            }
            addChild(k);
            if (k.tags.indexOf(WindowController.TAG_EXCLUDE) < 0)
            {
                k.tags.push(WindowController.TAG_EXCLUDE);
            }
return k;
        }
    }

