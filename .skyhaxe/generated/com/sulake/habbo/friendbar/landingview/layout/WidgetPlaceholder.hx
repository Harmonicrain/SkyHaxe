package com.sulake.habbo.friendbar.landingview.layout
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces._Str_10584;
    import com.sulake.habbo.friendbar.landingview.interfaces.IDisableAwareWidget;

     class WidgetPlaceholder implements IDisposable 
    {
        var _widget:ILandingViewWidget;
        var _Str_17931:String;
        var _Str_18534:IWindowContainer;
        var _initialized:Bool = false;
        var _commonWidgetSettings:CommonWidgetSettings;

        public function new(k:ILandingViewWidget, _arg_2:String, _arg_3:CommonWidgetSettings, _arg_4:IWindowContainer=null)
        {
            this._widget = k;
            this._Str_17931 = _arg_2;
            this._commonWidgetSettings = _arg_3;
            this._Str_18534 = _arg_4;
        }

        public function dispose()
        {
            if (this._widget != null)
            {
                this._widget.dispose();
                this._widget = null;
            }
            if (this._commonWidgetSettings != null)
            {
                this._commonWidgetSettings = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return (this._widget == null) && (this._commonWidgetSettings == null);
        }

        public function refresh(k:IWindowContainer)
        {
            var _local_3:IWindow = null;
            var _local_2= cast(k.findChildByName("content_background"), IWindowContainer);
            if (!this._initialized)
            {
                this._initialized = true;
                if (this._Str_17931 != null)
                {
                    _local_3 = _local_2.getChildByName(this._Str_17931);
                    if (_local_3 == null)
                    {
                        return;
                    }
                    this._widget.initialize();
                    _local_2.addChildAt(this._widget.container, _local_2.getChildIndex(_local_3));
                    this._widget.container.x = _local_3.x;
                    this._widget.container.y = _local_3.y;
                    _local_2.removeChild(_local_3);
                    _local_3.dispose();
                }
                else
                {
                    if (((!(this._Str_18534 == null)) && (!(this._widget == null))))
                    {
                        this._widget.initialize();
                        this._Str_18534.addChild(this._widget.container);
                    }
                    else
                    {
                        return;
                    }
                }
            }
            if (this._widget.container != null)
            {
                if ((Std.is(this._widget , ISettingsAwareWidget) && (!(this._commonWidgetSettings == null))))
                {
                    cast(this._widget, ISettingsAwareWidget).settings = this._commonWidgetSettings;
                }
                this._widget.refresh();
            }
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._widget.container;
        }

        public function _Str_17674()
        {
            if ((((!(this._widget == null)) && (!(this._widget.container == null))) && Std.is(this._widget , _Str_10584)))
            {
                cast(this._widget, _Str_10584)._Str_17674();
            }
        }

        public function disable()
        {
            if ((((!(this._widget == null)) && (!(this._widget.container == null))) && Std.is(this._widget , IDisableAwareWidget)))
            {
                cast(this._widget, IDisableAwareWidget).disable();
            }
        }
    }

