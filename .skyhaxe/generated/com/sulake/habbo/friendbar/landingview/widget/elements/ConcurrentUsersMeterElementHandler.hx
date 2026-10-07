package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IFloatingElement;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.incoming.quest.ConcurrentUsersGoalProgressMessageEvent;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

     class ConcurrentUsersMeterElementHandler implements IElementHandler implements  IFloatingElement 
    {
        var _image:IStaticBitmapWrapperWindow;
        var _state:Int = 0;
        var _userCount:Int = 0;
        var _userCountGoal:Int = 0;


        public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            this._image = cast(_arg_2, IStaticBitmapWrapperWindow);
            var _local_5:String = _arg_3[1];
            this._image.assetUri = _local_5;
            this._image.x = ((_arg_3.length > 2) ? ASCompat.toInt(_arg_3[2]) : 0);
            this._image.y = ((_arg_3.length > 3) ? ASCompat.toInt(_arg_3[3]) : 0);
            Logger.log([("Init Concurrent users meter: " + _local_5)]);
            k.communicationManager.addHabboConnectionMessageEvent(new ConcurrentUsersGoalProgressMessageEvent(this._Str_16345));
        }

        public function refresh()
        {
        }

        public function _Str_7806(k:Bool):Bool
        {
            return true;
        }

        function _Str_16345(k:ConcurrentUsersGoalProgressMessageEvent)
        {
            this._state = k.getParser().state;
            this._userCount = k.getParser().userCount;
            this._userCountGoal = k.getParser()._Str_21827;
            var _local_2= Std.int((this._userCount / this._userCountGoal) * 100);
            _local_2 = Std.int(Math.max(20, Math.min(100, _local_2)));
            _local_2 = Std.int(Math.ffloor((_local_2 / 10)) * 10);
            var _local_3= ("challenge_meter_" + Std.string(_local_2));
            this._image.assetUri = (("${image.library.url}reception/" + _local_3) + ".png");
            Logger.log([("Updating meter: " + _local_3)]);
        }
public function new(){}
    }

