package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.userdefinedroomevents.common.SliderWindowController;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IRadioButtonWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.Util;

     class GiveReward extends DefaultActionType 
    {
        static inline final _Str_12675= 20;

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _prizeLimitSlider:SliderWindowController;
        var _displayedRewards:Int = 5;


        override public function  get_code():Int
        {
            return ActionTypeCodes.GIVE_REWARD;
        }

        override public function validate(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents):String
        {
            var _local_6:IWindowContainer = null;
            var _local_7:String = null;
            var _local_3= cast(k.findChildByName("rewards_container"), IWindowContainer);
            var _local_4 = 0;
            var _local_5 = 0;
            while (_local_5 < _local_3.numChildren)
            {
                _local_6 = cast(_local_3.getChildAt(_local_5), IWindowContainer);
                if (_local_6.visible)
                {
                    _local_7 = this._Str_22801(_local_6, this._Str_8311(k).Selected);
                    if (_local_7 != null)
                    {
                        return _local_7;
                    }
                    _local_4 = (_local_4 + ASCompat.toInt(this._Str_11801(_local_6).text));
                }
                _local_5++;
            }
            if (_local_4 > 100)
            {
                return ("The sum of probabilities cannot exceed 100. You now have " + Std.string(_local_4)) + ".";
            }
            return null;
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_2= new Array<ASAny>();
            _local_2.push(this._Str_20392(k).getSelected().id);
            _local_2.push((this._Str_8311(k).Selected ? 1 : 0));
            _local_2.push((this._Str_11667(k).Selected ? this._prizeLimitSlider.getValue() : 0));
            var _local_3= ASCompat.toInt(this._Str_18135(k).caption);
            _local_2.push(((_local_3 >= 1) ? _local_3 : 1));
            return _local_2;
        }

        override public function readStringParamFromForm(k:IWindowContainer):String
        {
            var _local_5:IWindowContainer = null;
            var _local_6:String = null;
            var _local_2= "";
            var _local_3= cast(k.findChildByName("rewards_container"), IWindowContainer);
            var _local_4 = 0;
            while (_local_4 < _local_3.numChildren)
            {
                _local_5 = cast(_local_3.getChildAt(_local_4), IWindowContainer);
                if (_local_5.visible)
                {
                    _local_6 = this._Str_25605(_local_5);
                    if (_local_6 != null)
                    {
                        _local_2 = (_local_2 + (((_local_2 == "") ? "" : ";") + _local_6));
                    }
                }
                _local_4++;
            }
            return _local_2;
        }

        function _Str_22801(k:IWindowContainer, _arg_2:Bool):String
        {
            var _local_6 = 0;
            var _local_3= this._Str_17924(k).text;
            var _local_4= this._Str_11801(k).text;
            if (((_local_3 == "") && (_local_4 == "")))
            {
                return null;
            }
            if (_local_3.indexOf(",") > 0)
            {
                return "Product/badge codes must not contain ',' characters.";
            }
            if (_local_3.indexOf(";") > 0)
            {
                return "Product/badge codes must not contain ';' characters.";
            }
            var _local_5= 100;
            if (_local_3.length > _local_5)
            {
                return ("Product/badge codes cannot contain more than " + Std.string(_local_5)) + " characters.";
            }
            if (_local_3 == "")
            {
                return "Remember to define product/badge codes for all rewards (fill all fields or leave all fields empty).";
            }
            if (!_arg_2)
            {
                if (_local_4 == "")
                {
                    return "Remember to define probabilities for all rewards (fill all fields or leave all fields empty).";
                }
                if (Math.isNaN(ASCompat.toNumber(_local_4)))
                {
                    return "Make sure are probabilities are numbers.";
                }
                _local_6 = ASCompat.toInt(_local_4);
                if (((_local_6 < 1) || (_local_6 > 100)))
                {
                    return "Make sure all probabilities are numbers between 1 and 100.";
                }
            }
            return null;
        }

        function _Str_25605(k:IWindowContainer):String
        {
            var _local_2= this._Str_17924(k).text;
            var _local_3= this._Str_11801(k).text;
            var _local_4= this._Str_18678(k).Selected;
            _local_2 = this._Str_19618(_local_2, ";", "");
            _local_2 = this._Str_19618(_local_2, ",", "");
            if (_local_2 == "")
            {
                return null;
            }
            var _local_5= (Math.isNaN(ASCompat.toNumber(_local_3)) ? 0 : ASCompat.toInt(_local_3));
            return ((((_local_4 ? "0" : "1") + ",") + _local_2) + ",") + Std.string(_local_5);
        }

        function _Str_25823(k:Int, _arg_2:IWindowContainer, _arg_3:String)
        {
            var _local_4:Array<ASAny> = ((_arg_3 == null) ? new Array<ASAny>() : (cast _arg_3.split(",")));
            this._Str_17924(_arg_2).text = (_local_4[1] ? _local_4[1] : "");
            this._Str_11801(_arg_2).text = (_local_4[2] ? _local_4[2] : "");
            if ((ASCompat.toBool(_local_4[0]) && (_local_4[0] == "0")))
            {
                this._Str_18678(_arg_2).select();
            }
            else
            {
                this._Str_18678(_arg_2).unselect();
            }
        }

        function _Str_19618(k:String, _arg_2:String, _arg_3:String):String
        {
            var _local_4= 100;
            while (k.indexOf(_arg_2) > -1)
            {
                k = ASCompat.stringReplace(k, _arg_2, _arg_3);
                _local_4--;
                if (_local_4 < 1)
                {
                    break;
                }
            }
            return k;
        }

        override public function onInit(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents)
        {
            var _local_5:IWindowContainer = null;
            this._roomEvents = _arg_2;
            this._prizeLimitSlider = new SliderWindowController(_arg_2, this._Str_21165(k), _arg_2.assets, 1, 1000, 1);
            this._prizeLimitSlider.addEventListener(Event.CHANGE, this.onSliderChange);
            this._prizeLimitSlider.setValue(1);
            this._Str_11667(k).procedure = this._Str_23342;
            this._Str_8311(k).procedure = this._Str_22410;
            k.findChildByName("add_reward_txt").procedure = this._Str_24613;
            var _local_3= cast(k.findChildByName("rewards_container"), IWindowContainer);
            var _local_4 = 0;
            while (_local_4 < GiveReward._Str_12675)
            {
                _local_5 = cast(this._roomEvents.getXmlWindow("ude_action_inputs_17_reward"), IWindowContainer);
                _local_3.addChild(_local_5);
                _local_5.y = (_local_4 * 14);
                _local_5.id = _local_4;
                _local_4++;
            }
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            var _local_9:IWindowContainer = null;
            var _local_3= ASCompat.toInt(_arg_2.intData[0]);
            this._Str_20392(k).setSelected(this._Str_23398(k, _local_3));
            if (((_local_3 > 0) && (_arg_2.intData.length == 4)))
            {
                this._Str_18135(k).caption = ASCompat.toString(_arg_2.intData[3]);
            }
            else
            {
                this._Str_18135(k).caption = "1";
            }
            var _local_4:ASAny = (_arg_2.intData[1] == 1);
            if (_local_4)
            {
                this._Str_8311(k).select();
            }
            else
            {
                this._Str_8311(k).unselect();
            }
            var _local_5= ASCompat.toInt(_arg_2.intData[2]);
            if (_local_5 > 0)
            {
                this._prizeLimitSlider.setValue(_local_5);
                this._Str_11667(k).select();
            }
            else
            {
                this._Str_11667(k).unselect();
            }
            this._Str_19833(k);
            var _local_6:Array<ASAny> = (cast _arg_2.stringData.split(";"));
            var _local_7= cast(k.findChildByName("rewards_container"), IWindowContainer);
            var _local_8 = 0;
            while (_local_8 < GiveReward._Str_12675)
            {
                _local_9 = cast(_local_7.getChildAt(_local_8), IWindowContainer);
                this._Str_25823(_local_8, _local_9, _local_6[_local_8]);
                if (_local_6[_local_8])
                {
                    this._displayedRewards = (_local_8 + 1);
                }
                _local_8++;
            }
            this._Str_20059(k);
            this._Str_20031(k);
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function _Str_17924(k:IWindowContainer):ITextFieldWindow
        {
            return cast(k.findChildByName("reward_code_input"), ITextFieldWindow);
        }

        function _Str_11801(k:IWindowContainer):ITextFieldWindow
        {
            return cast(k.findChildByName("propability_input"), ITextFieldWindow);
        }

        function _Str_18678(k:IWindowContainer):ICheckBoxWindow
        {
            return cast(k.findChildByName("is_badge_checkbox"), ICheckBoxWindow);
        }

        function _Str_21165(k:IWindowContainer):IWindowContainer
        {
            return cast(k.findChildByName("slider_container"), IWindowContainer);
        }

        function _Str_8311(k:IWindowContainer):ICheckBoxWindow
        {
            return cast(k.findChildByName("unique_prize_checkbox"), ICheckBoxWindow);
        }

        function _Str_11667(k:IWindowContainer):ICheckBoxWindow
        {
            return cast(k.findChildByName("prize_limit_checkbox"), ICheckBoxWindow);
        }

        function _Str_23398(k:IWindowContainer, _arg_2:Int):IRadioButtonWindow
        {
            return cast(k.findChildByName((("interval_" + Std.string(_arg_2)) + "_radio")), IRadioButtonWindow);
        }

        function _Str_20392(k:IWindowContainer):ISelectorWindow
        {
            return cast(k.findChildByName("user_reward_interval_selector"), ISelectorWindow);
        }

        function _Str_18135(k:IWindowContainer):ITextFieldWindow
        {
            return cast(k.findChildByName("interval_input"), ITextFieldWindow);
        }

        function onSliderChange(k:Event)
        {
            var _local_2:SliderWindowController = null;
            var _local_3 = Math.NaN;
            var _local_4 = 0;
            if (k.type == Event.CHANGE)
            {
                _local_2 = ASCompat.dynamicAs(k.target , SliderWindowController);
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getValue();
                    _local_4 = Std.int(_local_3);
                    this._Str_21816(("" + Std.string(_local_4)));
                }
            }
        }

        function _Str_23342(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._Str_19833(cast(_arg_2.parent, IWindowContainer));
            }
        }

        function _Str_22410(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._Str_20031(cast(_arg_2.parent, IWindowContainer));
            }
        }

        function _Str_24613(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._displayedRewards++;
                this._Str_20059(cast(_arg_2.parent.parent, IWindowContainer));
            }
        }

        function _Str_19833(k:IWindowContainer)
        {
            var _local_2= this._Str_11667(k).Selected;
            k.findChildByName("prize_limit_warning_txt").visible = (!_local_2);
            this._Str_21165(k).visible = _local_2;
            this._Str_21816((_local_2 ? ("" + Std.string(this._prizeLimitSlider.getValue())) : ""));
        }

        function _Str_21816(k:String)
        {
            this._roomEvents.localization.registerParameter("wiredfurni.params.prizelimit", "amount", k);
        }

        function _Str_20059(k:IWindowContainer)
        {
            var _local_4:IWindowContainer = null;
            var _local_2= cast(k.findChildByName("rewards_container"), IWindowContainer);
            var _local_3 = 0;
            while (_local_3 < GiveReward._Str_12675)
            {
                _local_4 = cast(_local_2.getChildAt(_local_3), IWindowContainer);
                _local_4.visible = (_local_3 < this._displayedRewards);
                _local_3++;
            }
            _local_2.height = Util.getLowestPoint(_local_2);
            k.height = Util.getLowestPoint(k);
            this._roomEvents._Str_7247.refresh();
        }

        function _Str_20031(k:IWindowContainer)
        {
            var _local_5:IWindowContainer = null;
            var _local_2= cast(k.findChildByName("rewards_container"), IWindowContainer);
            var _local_3= this._Str_8311(k).Selected;
            k.findChildByName("propability_txt").visible = (!_local_3);
            var _local_4 = 0;
            while (_local_4 < GiveReward._Str_12675)
            {
                _local_5 = cast(_local_2.getChildAt(_local_4), IWindowContainer);
                this._Str_11801(_local_5).visible = (!_local_3);
                _local_4++;
            }
        }
public function new(){	super();
}
    }

