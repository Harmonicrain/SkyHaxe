package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.IDisposable;
	import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.habbo.communication.messages.parser.room.engine.RoomEntryInfoMessageParser;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.moderator.GetRoomChatlogMessageComposer;
	import com.sulake.core.window.components.IBitmapWrapperWindow;
	import flash.display.BitmapData;
	import com.sulake.habbo.avatar._enum.AvatarScaleType;
	import com.sulake.habbo.avatar.IAvatarImage;
	import com.sulake.habbo.avatar._enum.AvatarSetType;

     class StartPanelCtrl implements IDisposable 
    {
        var _main:ModerationManager;
        var _frame:IFrameWindow;
        var _userId:Int = 0;
        var _isGuestRoom:Bool = false;
        var _roomId:Int = 0;
        var _disposed:Bool = false;

        public function new(k:ModerationManager)
        {
            this._main = k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._main = null;
                if (this._frame != null)
                {
                    this._frame.dispose();
                    this._frame = null;
                }
            }
        }

        public function userSelected(k:Int, _arg_2:String, figure:String=null, gender:String=null)
        {
var _local_3:IAvatarImage  = null, _local_4:BitmapData  = null;            if (this._frame == null)
            {
                return;
            }
            this._userId = k;
            this._frame.findChildByName("userinfo_but").enable();
            Std.downcast(cast(this._frame.findChildByName("userinfo_but"), IWindowContainer).findChildByName("offence_name") , ILabelWindow).textColor = 0;
            cast(this._frame.findChildByName("userinfo_but"), IWindowContainer).findChildByName("offence_name").caption = ("User info: " + _arg_2);
			
			if (figure != null && gender != null)
			{
_local_3= this._main.avatarRenderManager.createAvatarImage(figure, AvatarScaleType.LARGE, gender, null);
				if (_local_3 == null)
				{
					return;
				};
				_local_3.setDirection(AvatarSetType.HEAD, 2);
_local_4= _local_3.getCroppedImage(AvatarSetType.HEAD, 0.5);
			
				if (_local_4 != null)
				{
					cast(cast(this._frame.findChildByName("userinfo_but"), IWindowContainer).findChildByName("head"), IBitmapWrapperWindow).bitmap = _local_4;
				}
			}
        }
		
		public function setVisible(visible:Bool)
		{
			if (this._frame == null)
			{
				return;
			}
			
			this._frame.visible = visible;
			
			if (this._main != null)
			{
				this._main.moderationIcon.show(!this._frame.visible);
			}
		}
		
		public function toggleVisible()
		{
			if (this._frame == null || !this._frame.visible)
			{
				this.show();
			}
			else
			{
				this.setVisible(false);
			}
		}

        public function _Str_25175(k:RoomEntryInfoMessageParser)
        {
            if (((this._frame == null) || (k == null)))
            {
                return;
            }
            this._frame.findChildByName("room_tool_but").enable();
            Std.downcast(cast(this._frame.findChildByName("room_tool_but"), IWindowContainer).findChildByName("offence_name") , ILabelWindow).textColor = 0;
            this._Str_22550();
            this._isGuestRoom = true;
            this._roomId = k.guestRoomId;
        }

        public function _Str_25510()
        {
            if (this._frame == null)
            {
                return;
            }
            this._frame.findChildByName("room_tool_but").disable();
            this._frame.findChildByName("chatlog_but").disable();
        }

        public function show()
        {
            if (this._frame == null)
            {
                this._frame = cast(this._main.getXmlWindow("start_panel"), IFrameWindow);
                this._frame.findChildByName("room_tool_but").addEventListener(WindowMouseEvent.CLICK, this._Str_22877);
                this._frame.findChildByName("chatlog_but").addEventListener(WindowMouseEvent.CLICK, this._Str_16926);
                this._frame.findChildByName("ticket_queue_but").addEventListener(WindowMouseEvent.CLICK, this._Str_22945);
                this._frame.findChildByName("userinfo_but").addEventListener(WindowMouseEvent.CLICK, this._Str_22876);
                this._frame.findChildByName("room_tool_but").addEventListener(WindowMouseEvent.OVER, this.onMouseOver);
                this._frame.findChildByName("chatlog_but").addEventListener(WindowMouseEvent.OVER, this.onMouseOver);
                this._frame.findChildByName("ticket_queue_but").addEventListener(WindowMouseEvent.OVER, this.onMouseOver);
                this._frame.findChildByName("userinfo_but").addEventListener(WindowMouseEvent.OVER, this.onMouseOver);
                this._frame.findChildByName("room_tool_but").addEventListener(WindowMouseEvent.OUT, this.onMouseOut);
                this._frame.findChildByName("chatlog_but").addEventListener(WindowMouseEvent.OUT, this.onMouseOut);
                this._frame.findChildByName("ticket_queue_but").addEventListener(WindowMouseEvent.OUT, this.onMouseOut);
                this._frame.findChildByName("userinfo_but").addEventListener(WindowMouseEvent.OUT, this.onMouseOut);
                this._frame.findChildByName("userinfo_but").disable();
                this._frame.findChildByName("room_tool_but").disable();
                this._frame.findChildByName("chatlog_but").disable();
                if (!this._main.initMsg._Str_24070)
                {
                    this._frame.findChildByName("ticket_queue_but").disable();
                }
                if (!this._main.initMsg._Str_12765)
                {
                    this._frame.findChildByName("chatlog_but").disable();
                }
                Std.downcast(cast(this._frame.findChildByName("userinfo_but"), IWindowContainer).findChildByName("offence_name") , ILabelWindow).textColor = 0x666666;
                Std.downcast(cast(this._frame.findChildByName("room_tool_but"), IWindowContainer).findChildByName("offence_name") , ILabelWindow).textColor = 0x666666;
                Std.downcast(cast(this._frame.findChildByName("chatlog_but"), IWindowContainer).findChildByName("offence_name") , ILabelWindow).textColor = 0x666666;
				this._frame.procedure = this.procedureHandler;
            }
            this.setVisible(true);
        }

        function _Str_22550()
        {
            if (this._main.initMsg._Str_12765)
            {
                this._frame.findChildByName("chatlog_but").enable();
                Std.downcast(cast(this._frame.findChildByName("chatlog_but"), IWindowContainer).findChildByName("offence_name") , ILabelWindow).textColor = 0;
            }
        }

        function onMouseOver(k:WindowEvent)
        {
            if (!k.window.isEnabled())
            {
                return;
            }
            Std.downcast(k.window , IWindowContainer).findChildByName("mouseover").visible = true;
        }

        function onMouseOut(k:WindowEvent)
        {
            Std.downcast(k.window , IWindowContainer).findChildByName("mouseover").visible = false;
        }

        function _Str_22877(k:WindowEvent)
        {
            this._main.windowTracker.show(new RoomToolCtrl(this._main, this._roomId), this._frame, false, false, true);
        }

        function _Str_16926(k:WindowEvent)
        {
            this._main.windowTracker.show(new ChatlogCtrl(new GetRoomChatlogMessageComposer((this._isGuestRoom ? 0 : 1), this._roomId), this._main, WindowTracker._Str_10414, this._roomId), this._frame, false, false, true);
        }

        function _Str_22876(k:WindowEvent)
        {
            this._main.windowTracker.show(new UserInfoFrameCtrl(this._main, this._userId), this._frame, false, false, true);
        }

        function _Str_22945(k:WindowEvent)
        {
            this._main.issueManager.init();
        }
		
		function procedureHandler(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "header_button_close":
                        this.setVisible(false);
                        return;
				}
			}
		}
    }

