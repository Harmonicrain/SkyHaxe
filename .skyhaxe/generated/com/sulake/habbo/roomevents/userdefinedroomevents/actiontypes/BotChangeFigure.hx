package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class BotChangeFigure extends DefaultActionType 
    {
        static inline final _Str_4332= "\t";

        var _component:HabboUserDefinedRoomEvents;
        var _figureString:String;
        var _botName:String;
        var _window:IWindowContainer;

        override public function  get_code():Int
        {
            return ActionTypeCodes.BOT_CHANGE_FIGURE;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_5431;
        }

        override public function onInit(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents)
        {
            this._component = _arg_2;
        }

        override public function readStringParamFromForm(k:IWindowContainer):String
        {
            var _local_2= this.getInput(k, "bot_name").text;
            return (_local_2 + _Str_4332) + this._figureString;
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            var _local_3:Array<ASAny> = (cast _arg_2.stringData.split(_Str_4332));
            if (_local_3.length > 0)
            {
                this._botName = _local_3[0];
            }
            if (_local_3.length > 1)
            {
                this._figureString = _local_3[1];
            }
            this.getInput(k, "bot_name").text = this._botName;
            cast(cast(k.findChildByName("avatar_image"), IWidgetWindow).widget, IAvatarImageWidget).figure = this._figureString;
            k.findChildByName("capture_figure").procedure = this._Str_24248;
            this._window = k;
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function getInput(k:IWindowContainer, _arg_2:String):ITextFieldWindow
        {
            var _local_3= cast(k.findChildByName(_arg_2), ITextFieldWindow);
            return _local_3;
        }

        function _Str_24248(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._figureString = this._component.sessionDataManager.figure;
                cast(cast(this._window.findChildByName("avatar_image"), IWidgetWindow).widget, IAvatarImageWidget).figure = this._figureString;
            }
        }
public function new(){	super();
}
    }

