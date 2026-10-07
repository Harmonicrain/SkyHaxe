package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueMessageData;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ModMessageMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ModBanMessageComposer;
    import com.sulake.habbo.window.utils.IAlertDialog;

     class SendMsgsCtrl implements IDisposable implements  ITrackedWindow 
    {
        static inline final TOPIC_ID_NOT_SELECTED= -999;

        var _main:ModerationManager;
        var _targetUserId:Int = 0;
        var _targetUserName:String;
        var _issue:IssueMessageData;
        var _frame:IFrameWindow;
        var _msgSelect:IDropMenuWindow;
        var _msgInput:ITextFieldWindow;
        var _disposed:Bool = false;
        var _placeHolderMessage:Bool = true;

        public function new(k:ModerationManager, _arg_2:Int, _arg_3:String, _arg_4:IssueMessageData)
        {
            this._main = k;
            this._targetUserId = _arg_2;
            this._targetUserName = _arg_3;
            this._issue = _arg_4;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function show()
        {
            this._frame = cast(this._main.getXmlWindow("send_msgs"), IFrameWindow);
            this._frame.caption = ("Msg To: " + this._targetUserName);
            this._frame.findChildByName("send_message_but").procedure = this.onSendMessageButton;
            this._msgInput = cast(this._frame.findChildByName("message_input"), ITextFieldWindow);
            this._msgInput.procedure = this.onInputClick;
            this._msgSelect = cast(this._frame.findChildByName("msgTemplatesSelect"), IDropMenuWindow);
            this.prepareMessageSelection(this._msgSelect);
            this._msgSelect.procedure = this.onSelectTemplate;
            var k= this._frame.findChildByTag("close");
            k.procedure = this.onClose;
            this._frame.visible = true;
        }

        public function getType():Int
        {
            return WindowTracker._Str_18900;
        }

        public function getId():String
        {
            return this._targetUserName;
        }

        public function getFrame():IFrameWindow
        {
            return this._frame;
        }

        function prepareMessageSelection(k:IDropMenuWindow)
        {
            Logger.log([("MSG TEMPLATES: " + Std.string(this._main.initMsg._Str_15690.length))]);
            k.populate(this._main.initMsg._Str_15690);
        }

        function onSelectTemplate(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowEvent.WINDOW_EVENT_SELECTED)
            {
                return;
            }
            var _local_3:String = this._main.initMsg._Str_15690[this._msgSelect.selection];
            if (_local_3 != null)
            {
                this._placeHolderMessage = false;
                this._msgInput.text = _local_3;
            }
        }

        function onSendMessageButton(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if ((this._placeHolderMessage || (this._msgInput.text == "")))
            {
                this._main.windowManager.alert("Alert", "You must input a message to the user", 0, this.onAlertClose);
                return;
            }
            Logger.log(["Sending message..."]);
            this._main.connection.send(new ModMessageMessageComposer(this._targetUserId, this._msgInput.text, TOPIC_ID_NOT_SELECTED, ((this._issue != null) ? this._issue._Str_2869 : ModBanMessageComposer.NO_ISSUE_ID)));
            this.dispose();
        }

        function onClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.dispose();
        }

        function onInputClick(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowEvent.WINDOW_EVENT_FOCUSED)
            {
                return;
            }
            if (this._placeHolderMessage)
            {
                this._msgInput.text = "";
                this._placeHolderMessage = false;
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._frame != null)
            {
                this._frame.destroy();
                this._frame = null;
            }
            this._msgSelect = null;
            this._msgInput = null;
            this._main = null;
        }

        function onAlertClose(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }
    }

