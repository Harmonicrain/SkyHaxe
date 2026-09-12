package com.sulake.habbo.ui.widget.avatarinfo.botskills
;
    import com.sulake.habbo.ui.widget.avatarinfo.AvatarInfoWidget;
    import flash.geom.Point;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.bots.CommandBotComposer;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class BotChangeNameConfiguration extends BotSkillConfigurationViewBase 
    {
        var _newName:String = "";

        public function new(k:AvatarInfoWidget)
        {
            super(k);
        }

        override function  get_windowAssetName():String
        {
            return "name_configuration_xml";
        }

        override function  get_skillType():Int
        {
            return BotSkillsEnum.CHANGE_BOT_NAME;
        }

        override public function dispose()
        {
            close();
            super.dispose();
        }

        override public function open(k:Int, _arg_2:Point=null)
        {
            super.open(k, _arg_2);
            window.procedure = this.procedure;
        }

        override public function parseConfiguration(k:String)
        {
            this.nameInput = k;
        }

        var nameInput(never,set):String;
function  set_nameInput(k:String):String        {
            this._newName = k;
            var _local_2= cast(window.findChildByName("name_input"), ITextWindow);
            _local_2.text = this._newName;
            _local_2.activate();
return k;
        }

        override function deactivateInputs()
        {
            window.findChildByName("name_input").deactivate();
        }

        function procedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "save_button":
                        _widget.handler.container.connection.send(new CommandBotComposer(_botId, BotSkillsEnum.CHANGE_BOT_NAME, this._newName));
                        close();
                        
                    case "cancel_button":
                        close();
                        
                }
            }
            if (k.type == WindowKeyboardEvent.WINDOW_EVENT_KEY_UP)
            {
                this._newName = cast(window.findChildByName("name_input"), ITextWindow).text;
            }
        }
    }

