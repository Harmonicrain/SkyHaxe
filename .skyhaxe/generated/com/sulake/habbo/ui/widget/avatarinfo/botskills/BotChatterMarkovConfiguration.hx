package com.sulake.habbo.ui.widget.avatarinfo.botskills
;
    import com.sulake.habbo.ui.widget.avatarinfo.AvatarInfoWidget;
    import flash.geom.Point;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.bots.CommandBotComposer;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class BotChatterMarkovConfiguration extends BotSkillConfigurationViewBase 
    {
        public function new(k:AvatarInfoWidget)
        {
            super(k);
        }

        static function _Str_20174(k:String):String
        {
            var _local_2= k;
            _local_2 = new compat.RegExp(";#;", "g").replace(_local_2, " ");
            return _local_2;
        }


        override function  get_windowAssetName():String
        {
            return "chatter_configuration_xml";
        }

        override function  get_skillType():Int
        {
            return BotSkillsEnum.SETUP_CHAT;
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
            var _local_2:Array<ASAny> = null;
            if (k.indexOf(";#;") == -1)
            {
                _local_2 = (cast k.split(";"));
            }
            else
            {
                _local_2 = (cast k.split(";#;"));
            }
            if (((_local_2.length == 3) && (window != null)))
            {
                this.text = _local_2[0];
                this._Str_14755 = ((ASCompat.toString(_local_2[1]).toLowerCase() == "true") || (_local_2[1] == "1"));
                this._Str_12879 = ASCompat.toInt(_local_2[2]);
                this._Str_15838 = false;
            }
            else
            {
                if (((_local_2.length == 4) && (window != null)))
                {
                    this.text = _local_2[0];
                    this._Str_14755 = ((ASCompat.toString(_local_2[1]).toLowerCase() == "true") || (_local_2[1] == "1"));
                    this._Str_12879 = ASCompat.toInt(_local_2[2]);
                    this._Str_15838 = ((ASCompat.toString(_local_2[3]).toLowerCase() == "true") || (_local_2[3] == "1"));
                }
            }
        }

        override function deactivateInputs()
        {
            window.findChildByName("chat_text").deactivate();
            window.findChildByName("auto_chat_checkbox").deactivate();
            window.findChildByName("markov_checkbox").deactivate();
            window.findChildByName("chat_delay_text").deactivate();
        }

        
        var text(get,set):String;
function  set_text(k:String):String        {
            var _local_2= cast(window.findChildByName("chat_text"), ITextWindow);
            _local_2.text = k;
            _local_2.activate();
return k;
        }
function  get_text():String
        {
            return cast(window.findChildByName("chat_text"), ITextWindow).text;
        }

        
        var _Str_14755(get,set):Bool;
function  set__Str_14755(k:Bool):Bool        {
            var _local_2= cast(window.findChildByName("auto_chat_checkbox"), ICheckBoxWindow);
            _local_2.Selected = k;
            _local_2.activate();
return k;
        }
function  get__Str_14755():Bool
        {
            return cast(window.findChildByName("auto_chat_checkbox"), ICheckBoxWindow).Selected;
        }

        
        var _Str_15838(get,set):Bool;
function  set__Str_15838(k:Bool):Bool        {
            var _local_2= cast(window.findChildByName("markov_checkbox"), ICheckBoxWindow);
            _local_2.Selected = k;
            _local_2.activate();
return k;
        }
function  get__Str_15838():Bool
        {
            return cast(window.findChildByName("markov_checkbox"), ICheckBoxWindow).Selected;
        }

        
        var _Str_12879(get,set):Int;
function  set__Str_12879(k:Int):Int        {
            var _local_2= cast(window.findChildByName("chat_delay_text"), ITextWindow);
            _local_2.text = Std.string(k);
            _local_2.activate();
return k;
        }
function  get__Str_12879():Int
        {
            return ASCompat.toInt(cast(window.findChildByName("chat_delay_text"), ITextWindow).text);
        }

        var _Str_23395(get,never):String;
function  get__Str_23395():String
        {
            return (((((_Str_20174(this.text) + ";#;") + Std.string(this._Str_14755)) + ";#;") + Std.string(this._Str_12879)) + ";#;") + Std.string(this._Str_15838);
        }

        function procedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "save_button":
                        _widget.handler.container.connection.send(new CommandBotComposer(_botId, BotSkillsEnum.SETUP_CHAT, this._Str_23395));
                        close();
                        return;
                    case "cancel_button":
                        close();
                        return;
                    case "help_link":
                        HabboWebTools.navigateToURL(_widget.configuration.getProperty("link.format.bots.help"), "habboMain");
                        return;
                }
            }
        }
    }

