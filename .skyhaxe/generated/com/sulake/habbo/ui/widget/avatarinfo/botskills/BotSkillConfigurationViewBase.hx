package com.sulake.habbo.ui.widget.avatarinfo.botskills
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.ui.widget.avatarinfo.AvatarInfoWidget;
    import com.sulake.core.window.IWindowContainer;
    import flash.geom.Rectangle;
    import com.sulake.habbo.communication.messages.incoming.room.bots.BotCommandConfigurationEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.bots.GetBotCommandConfigurationDataComposer;
    import flash.geom.Point;

     class BotSkillConfigurationViewBase implements BotSkillConfigurationView 
    {
        var _Str_9057:IMessageEvent;
        var _widget:AvatarInfoWidget;
        var window:IWindowContainer;
        var _botId:Int = 0;

        public function new(k:AvatarInfoWidget)
        {
            this._widget = k;
        }

        public function dispose()
        {
            if (this.window != null)
            {
                this.window.dispose();
                this.window = null;
            }
            if (this._widget != null)
            {
                if (((this._widget.handler.container.connection != null) && (this._Str_9057 != null)))
                {
                    this._widget.handler.container.connection.removeMessageEvent(this._Str_9057);
                    this._Str_9057 = null;
                }
                this._widget = null;
            }
            this._botId = -1;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._widget == null;
        }

        public function open(k:Int, _arg_2:Point=null)
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4:Rectangle = null;
            this._botId = k;
            if (this._Str_9057 == null)
            {
                this._Str_9057 = new BotCommandConfigurationEvent(this._Str_22412);
                this._widget.handler.container.connection.addMessageEvent(this._Str_9057);
            }
            this._widget.handler.container.connection.send(new GetBotCommandConfigurationDataComposer(this._botId, this.skillType));
            if (this.window == null)
            {
                _local_3 = ((this._widget.assets.getAssetByName(this.windowAssetName).content : com.sulake.core.utils.xml.XML) );
                this.window = Std.downcast(this._widget.windowManager.buildFromXML(_local_3, 1) , IWindowContainer);
            }
            if (_arg_2 != null)
            {
                _local_4 = this.window.rectangle;
                this.window.x = Std.int(_arg_2.x - (_local_4.width / 2));
                this.window.y = Std.int(_arg_2.y - _local_4.height);
            }
            this._Str_23587();
            this.window.visible = true;
            this.deactivateInputs();
        }

        public function close()
        {
            if (this.window != null)
            {
                this.window.dispose();
                this.window = null;
            }
        }

        public function parseConfiguration(k:String)
        {
        }

        function deactivateInputs()
        {
        }

        var windowAssetName(get,never):String;
function  get_windowAssetName():String
        {
            return "";
        }

        var skillType(get,never):Int;
function  get_skillType():Int
        {
            return -1;
        }

        function _Str_22412(k:BotCommandConfigurationEvent)
        {
            if (((k.getParser().botId == this._botId) && (k.getParser().commandId == this.skillType)))
            {
                this.parseConfiguration(k.getParser().data);
            }
        }

        function _Str_23587()
        {
            var k= new Rectangle();
            this.window.getGlobalRectangle(k);
            if (k.top < 0)
            {
                this.window.y = Std.int(this.window.y + -k.top);
            }
            if (k.left < 0)
            {
                this.window.x = Std.int(this.window.x + -k.left);
            }
            if (k.right > this.window.desktop.width)
            {
                this.window.x = Std.int(this.window.x - (k.right - this.window.desktop.width));
            }
            if (k.bottom > this.window.desktop.height)
            {
                this.window.y = Std.int(this.window.y - (k.bottom - this.window.desktop.height));
            }
        }
    }

