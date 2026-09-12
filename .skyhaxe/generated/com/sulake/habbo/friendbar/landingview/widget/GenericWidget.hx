package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISlotAwareWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces._Str_6397;
    import com.sulake.habbo.friendbar.landingview.interfaces.IDisableAwareWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.layout.DynamicLayoutManager;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.friendbar.landingview.widget.elements.WidgetElementHandler;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.ILayoutNameProvider;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IFloatingElement;
    import com.sulake.habbo.friendbar.landingview.widget.elements.TitleElementHandler;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IDisableAwareElement;
    import com.sulake.habbo.friendbar.landingview.*;

     class GenericWidget implements ILandingViewWidget implements  ISlotAwareWidget implements  ISettingsAwareWidget implements  _Str_6397 implements  IDisableAwareWidget 
    {
        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _slot:Int = 0;
        var _configurationCode:String;
        var _elements:Map;

        public function new(k:HabboLandingView)
        {
            this._landingView = k;
            this._elements = new Map();
        }

        public static function _Str_18803(k:HabboLandingView, _arg_2:Int, _arg_3:String, _arg_4:IWindowContainer)
        {
            var _local_9:String = null;
            var _local_10:Array<ASAny> = null;
            var _local_11:String = null;
            var _local_12:String = null;
            var _local_5= _Str_13923(k, _arg_2, _arg_3, "layout");
            var _local_6:Array<ASAny> = (cast _local_5.split(";"));
            var _local_7= cast(_arg_4.findChildByName("bitmap"), IStaticBitmapWrapperWindow);
            var _local_8= _arg_4.findChildByName("content_container");
            _local_8.x = (_Str_6981(_arg_2) ? DynamicLayoutManager._Str_16813 : 0);
            _arg_4.width = (_Str_6981(_arg_2) ? k.dynamicLayoutLeftPaneWidth : k.dynamicLayoutRightPaneWidth);
            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
            {
_local_9  = _tmp_;
                _local_10 = (cast _local_9.split(","));
                _local_11 = _local_10[0];
                _local_12 = _local_10[1];
                switch (_local_11)
                {
                    case "bitmap.uri":
                        _local_7.assetUri = _local_12;
                        
                    case "bitmap.width":
                        _local_7.width = ASCompat.parseInt(_local_12);
                        
                    case "bitmap.height":
                        _local_7.height = ASCompat.parseInt(_local_12);
                        
                    case "bitmap.x":
                        _local_7.x = ASCompat.parseInt(_local_12);
                        
                    case "bitmap.y":
                        _local_7.y = ASCompat.parseInt(_local_12);
                        
                    case "content.x":
                        _local_8.x = ASCompat.parseInt(_local_12);
                        
                    case "content.y":
                        _local_8.y = ASCompat.parseInt(_local_12);
                        
                    case "content.width":
                        _local_8.width = ASCompat.parseInt(_local_12);
                        
                    case "container.height":
                        _arg_4.height = Std.int(Math.max(ASCompat.parseInt(_local_12), _arg_4.height));
                        
                }
            }
        }

        static function _Str_13923(k:HabboLandingView, _arg_2:Int, _arg_3:String, _arg_4:String):String
        {
            var _local_5= ((_arg_3 != null) ? ((("landing.view." + _arg_3) + ".") + _arg_4) : ((("landing.view.dynamic.slot." + Std.string(_arg_2)) + ".") + _arg_4));
            return k.getProperty(_local_5);
        }

        static function _Str_6981(k:Int):Bool
        {
            return (!(k == 3)) && (!(k == 5));
        }


        public var slot(never,set):Int;
public function  set_slot(k:Int):Int        {
            return this._slot = k;
        }

        
        public var _Str_12275(get,set):String;
public function  get__Str_12275():String
        {
            return this._configurationCode;
        }
public function  set__Str_12275(k:String):String        {
            return this._configurationCode = k;
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._container;
        }

        public function dispose()
        {
            var k:IElementHandler = null;
            this._landingView = null;
            this._container = null;
            final _iter_ = this._elements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                if (Std.is(k , IDisposable))
                {
                    cast(k, IDisposable).dispose();
                }
            }
            this._elements = null;
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow("generic_widget"), IWindowContainer);
            this._Str_23364();
            _Str_18803(this._landingView, this._slot, this._configurationCode, this._container);
        }

        public function _Str_19931(k:String):IElementHandler
        {
            return ASCompat.dynamicAs(this._elements.getValue(k) , IElementHandler);
        }

        function _Str_23364()
        {
            var elementData:String = null;
            var fields:Array<ASAny> = null;
            var elementName:String = null;
            var handler:IElementHandler = null;
            var layoutName:String = null;
            var elementWindow:IWindow = null;
            var data= _Str_13923(this._landingView, this._slot, this._configurationCode, "conf");
            var elementDatas:Array<ASAny> = (cast data.split(";"));
            if (((data == null) || (data == "")))
            {
                return;
            }
            var itemlist= cast(this._container.findChildByName("content_container"), IItemListWindow);
            if (checkNullIteratee(elementDatas)) for (_tmp_ in elementDatas)
            {
elementData  = _tmp_;
                fields = (cast elementData.split(","));
                elementName = fields[0];
                handler = WidgetElementHandler._Str_24129(elementName);
                layoutName = (Std.is(handler , ILayoutNameProvider) ? cast(handler, ILayoutNameProvider).layoutName : ("element_" + elementName));
                Logger.log([("Element: " + layoutName)]);
                try
                {
                    elementWindow = this._landingView.getXmlWindow(layoutName);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    return;
                }
 }                if (elementWindow == null)
                {
                    return;
                }
                if (handler != null)
                {
                    handler.initialize(this._landingView, elementWindow, fields, this);
                    this._elements.add(elementName, handler);
                }
                if ((Std.is(handler , IFloatingElement) && cast(handler, IFloatingElement)._Str_7806(_Str_6981(this._slot))))
                {
                    if (Std.is(handler , TitleElementHandler))
                    {
                        elementWindow.width = (_Str_6981(this._slot) ? this._landingView.dynamicLayoutLeftPaneWidth : this._landingView.dynamicLayoutRightPaneWidth);
                    }
                    this._container.addChild(elementWindow);
                }
                else
                {
                    itemlist.addListItem(elementWindow);
                }
            }
        }

        public function refresh()
        {
            var k:IElementHandler = null;
            final _iter_ = this._elements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                k.refresh();
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        public var settings(never,set):CommonWidgetSettings;
public function  set_settings(k:CommonWidgetSettings):CommonWidgetSettings        {
            WidgetContainerLayout.applyCommonWidgetSettings(this._container, k);
return k;
        }

        public function disable()
        {
            var k:IElementHandler = null;
            final _iter_ = this._elements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                if (Std.is(k , IDisableAwareElement))
                {
                    cast(k, IDisableAwareElement).disable();
                }
            }
        }
    }

