package com.sulake.habbo.avatar.effects
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.avatar.IHabboAvatarEditorAvatarEffect;
    import flash.display.BitmapData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import flash.geom.Rectangle;

     class AvatarEditorGridItemEffect 
    {
        var _window:IWindowContainer;
        var _Str_2779:IWindow;
        var _Str_2968:Bool = false;
        var _Str_18530:IHabboAvatarEditorAvatarEffect;

        public function new(k:IHabboAvatarEditorAvatarEffect, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            this._window = cast(_arg_2.buildFromXML(((_arg_3.getAssetByName("avatar_editor_effect_griditem_xml").content : com.sulake.core.utils.xml.XML) )), IWindowContainer);
            this._Str_2779 = this._window.findChildByTag("BG_COLOR");
            this._Str_18530 = k;
            if (k != null)
            {
                this.bitmap = k.icon;
                this.amount = k.amount;
                if (k.isPermanent)
                {
                    this._Str_10660(k.duration, k.duration);
                }
                else
                {
                    if (k.isActive)
                    {
                        this._Str_10660(k.secondsRemaining, k.duration);
                    }
                }
            }
            else
            {
                this.bitmap = cast(_arg_2.assets.getAssetByName("avatar_editor_generic_remove_selection").content, BitmapData);
                this.amount = 1;
            }
            this.selected = false;
            this._window.addEventListener(WindowMouseEvent.OVER, this.onMouseOver);
            this._window.addEventListener(WindowMouseEvent.OUT, this._Str_17495);
        }

        public var effectType(get,never):Int;
public function  get_effectType():Int
        {
            return (this._Str_18530 != null) ? this._Str_18530.type : -1;
        }

        function _Str_17495(k:WindowMouseEvent)
        {
            if (!this._Str_2968)
            {
                this._Str_2779.visible = false;
            }
            this._Str_2779.blend = 1;
        }

        function onMouseOver(k:WindowMouseEvent)
        {
            if (!this._Str_2968)
            {
                this._Str_2779.visible = true;
                this._Str_2779.blend = 0.5;
            }
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._window;
        }

        public var selected(never,set):Bool;
public function  set_selected(k:Bool):Bool        {
            this._Str_2968 = k;
            this._Str_2779.visible = this._Str_2968;
            this._Str_2779.blend = 1;
return k;
        }

        var bitmap(never,set):BitmapData;
function  set_bitmap(k:BitmapData):BitmapData        {
            return cast(this._window.findChildByName("bitmap"), IBitmapWrapperWindow).bitmap = k;
        }

        var amount(never,set):Int;
function  set_amount(k:Int):Int        {
            var _local_2= cast(this._window.findChildByName("effect_amount_bg1"), IWindowContainer);
            var _local_3= cast(this._window.findChildByName("effect_amount"), ITextWindow);
            _local_2.visible = (k > 1);
            _local_3.text = Std.string(k);
return k;
        }

        function _Str_10660(k:Int, _arg_2:Int)
        {
            this._window.findChildByName("duration_container").visible = true;
            var _local_3= cast(this._window.findChildByName("progress_bar"), IBitmapWrapperWindow);
            var _local_4= new BitmapData(_local_3.width, _local_3.height, false, 0);
            var _local_5= new Rectangle(0, 0, Std.int((_local_4.width * (k / _arg_2))), _local_4.height);
            _local_4.fillRect(_local_5, 2146080);
            _local_3.bitmap = _local_4;
        }
    }

