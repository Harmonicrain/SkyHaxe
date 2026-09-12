package com.sulake.habbo.navigator.inroom
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.navigator.TextFieldManager;
    import com.sulake.habbo.communication.messages.incoming.navigator.RoomEventData;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.navigator.EditEventMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.CancelEventMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.advertisement.RoomAdErrorEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;

     class RoomEventViewCtrl implements IDisposable
    {
        var _navigator:IHabboTransitionalNavigator;
        var _window:IFrameWindow;
        var _eventNameInput:TextFieldManager;
        var _eventDescInput:TextFieldManager;

        public function new(k:IHabboTransitionalNavigator)
        {
            this._navigator = k;
        }

        public function dispose()
        {
            this._navigator = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._eventNameInput = null;
            this._eventDescInput = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._navigator == null;
        }

        public function show()
        {
            if (((!(this._window == null)) && this._window.visible))
            {
                this._window.visible = false;
                return;
            }
            this.prepareWindow();
            this.clearErrors();
            var k= this._navigator.data.roomEventData;
            if (k == null)
            {
                this.createEvent();
            }
            else
            {
                this.editEvent(k);
            }
            this._window.visible = true;
            this._window.activate();
        }

        function editEvent(k:RoomEventData)
        {
            this._window.caption = this._navigator.getText("navigator.eventsettings.editcaption");
            this._eventNameInput.setText(k.eventName);
            this._eventDescInput.setText(k.eventDescription);
        }

        function createEvent()
        {
            this._window.caption = this._navigator.getText("navigator.createevent");
            this._eventDescInput.goBackToInitialState();
            this._eventNameInput.goBackToInitialState();
        }

        function getInput(k:String):ITextFieldWindow
        {
            return cast(this._window.findChildByName(k), ITextFieldWindow);
        }

        function onClose(k:WindowEvent)
        {
            this.close();
        }

        function save()
        {
            var k= this._navigator.data.roomEventData.adId;
            var _local_2= this._eventNameInput.getText();
            var _local_3= this._eventDescInput.getText();
            if (!this.isMandatoryFieldsFilled())
            {
                return;
            }
            this._navigator.send(new EditEventMessageComposer(k, _local_2, _local_3));
        }

        function onEndButtonClick(k:WindowEvent)
        {
            this._navigator.send(new CancelEventMessageComposer(this._navigator.data.roomEventData.adId));
            this.close();
        }

        function _Str_4604(k:WindowEvent)
        {
            this.close();
        }

        function _Str_5137(k:WindowEvent)
        {
            if (this._navigator.data.roomEventData != null)
            {
                this.save();
            }
        }

        function _Str_24049(k:RoomAdErrorEvent)
        {
            this.clearErrors();
            var _local_2= k.getParser();
            var _local_3= _local_2.errorCode;
            if (_local_3 == 0)
            {
                this._eventNameInput.displayError(this._navigator.getText("roomad.error.0.description"));
                this._eventNameInput.setText(_local_2.filteredText);
            }
            else
            {
                if (_local_3 == 1)
                {
                    this._eventDescInput.displayError(this._navigator.getText("roomad.error.0.description"));
                    this._eventDescInput.setText(_local_2.filteredText);
                }
            }
        }

        function isMandatoryFieldsFilled():Bool
        {
            this.clearErrors();
            if (!this._eventNameInput.checkMandatory(this._navigator.getText("navigator.eventsettings.nameerr")))
            {
                return false;
            }
            return true;
        }

        function clearErrors()
        {
            this._eventNameInput.clearErrors();
            this._eventDescInput.clearErrors();
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._navigator.getXmlWindow("iro_event_settings"), IFrameWindow);
            this.addMouseClickListener(this._window.findChildByTag("close"), this.onClose);
            this._eventNameInput = new TextFieldManager(this._navigator, this.getInput("event_name"), 25);
            this._eventDescInput = new TextFieldManager(this._navigator, this.getInput("event_desc"), 100);
            this._eventNameInput.input.addEventListener(WindowEvent.WINDOW_EVENT_UNFOCUSED, this._Str_5137);
            this._eventDescInput.input.addEventListener(WindowEvent.WINDOW_EVENT_UNFOCUSED, this._Str_5137);
            this._navigator.communication.addHabboConnectionMessageEvent(new RoomAdErrorEvent(this._Str_24049));
            this._window.center();
        }

        function addMouseClickListener(k:IWindow, _arg_2:ASFunction)
        {
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, _arg_2);
            }
        }

        function find(k:String):IWindow
        {
            var _local_2= this._window.findChildByName(k);
            if (_local_2 == null)
            {
                throw new ASError((("Window element with name: " + k) + " cannot be found!"));
            }
            return _local_2;
        }

        function _Str_26299()
        {
            var _local_4:String = null;
            var _local_5:String = null;
            var k= new Array<ASAny>();
            var _local_2= 100;
            var _local_3= 1;
            while (_local_3 < _local_2)
            {
                _local_4 = ("roomevent_type_" + Std.string(_local_3));
                _local_5 = this._navigator.getText(_local_4);
                if (((_local_5 == null) || (_local_5 == _local_4)))
                {
                    return;
                }
                k.push(_local_5);
                _local_3++;
            }
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }
    }

