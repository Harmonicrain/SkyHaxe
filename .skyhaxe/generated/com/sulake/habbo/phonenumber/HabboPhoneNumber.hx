package com.sulake.habbo.phonenumber
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.habbo.communication.messages.incoming.gifts.PhoneCollectionStateMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.gifts.TryPhoneNumberResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.gifts.TryVerificationCodeResultMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.gifts.TryPhoneNumberMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.gifts.VerifyCodeMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.gifts.SetPhoneNumberVerificationStatusMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.gifts.ResetPhoneNumberStateMessageComposer;
    import com.sulake.habbo.toolbar.ToolbarDisplayExtensionIds;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;

     class HabboPhoneNumber extends Component 
    {
        var _communicationManager:IHabboCommunicationManager;
        var _localizationManager:IHabboLocalizationManager;
        var _sessionDataManager:ISessionDataManager;
        var _Str_2290:IHabboToolbar;
        var _windowManager:IHabboWindowManager;
        var _connection:IConnection;
        var _Str_9469:PhoneNumberCollectView;
        var _Str_7950:PhoneNumberCollectMinimizedView;
        var _Str_9578:VerificationCodeInputView;
        var _Str_8160:VerificationCodeInputMinimizedView;
        var _Str_15062:Int = 0;

        public function new(k:IContext, _arg_2:UInt, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }, true), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localizationManager = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _Str_2290 = k;
            })]));
        }

        override function initComponent()
        {
            if (getBoolean("sms.identity.verification.enabled"))
            {
                this._connection = this._communicationManager.connection;
                this._connection.addMessageEvent(new PhoneCollectionStateMessageEvent(this._Str_24899));
                this._connection.addMessageEvent(new TryPhoneNumberResultMessageEvent(this._Str_23318));
                this._connection.addMessageEvent(new TryVerificationCodeResultMessageEvent(this._Str_22688));
            }
        }

        public function _Str_22965(k:String, _arg_2:String)
        {
            this._connection.send(new TryPhoneNumberMessageComposer(k, _arg_2));
        }

        public function _Str_24369(k:String)
        {
            if (!ASCompat.stringAsBool(k))
            {
                return;
            }
            k = k.toUpperCase();
            this._connection.send(new VerifyCodeMessageComposer(k));
        }

        public function _Str_23711()
        {
            this._connection.send(new SetPhoneNumberVerificationStatusMessageComposer(ClientPhoneVerificationStatusEnum.NEVER_AGAIN));
            this._Str_7383();
        }

        public function _Str_17799(k:Bool)
        {
            if (k)
            {
                this._Str_7383();
                this._Str_25774();
            }
            else
            {
                this._Str_21501();
                this._Str_16750();
            }
        }

        public function _Str_16951(k:Bool)
        {
            if (k)
            {
                this._Str_9778();
                this._Str_19391();
            }
            else
            {
                this._Str_20335();
                this._Str_13939();
            }
        }

        public function _Str_24068()
        {
            this._Str_9778();
            this._connection.send(new ResetPhoneNumberStateMessageComposer());
        }

        function _Str_23318(k:TryPhoneNumberResultMessageEvent)
        {
            switch (k.getParser().resultCode)
            {
                case PhoneNumberStatusEnum.VERIFIED:
                    this._Str_7383();
                    return;
                case PhoneNumberStatusEnum.OK
                   | PhoneNumberStatusEnum.NON_VERIFIED
                   | PhoneNumberStatusEnum.TOKEN_SENT:
                    this._Str_7383();
                    this._Str_15062 = (k.getParser().millisToAllowProcessReset + flash.Lib.getTimer());
                    this._Str_13939();
                    return;
                case PhoneNumberStatusEnum.ERROR
                   | PhoneNumberStatusEnum.RATE_LIMIT
                   | PhoneNumberStatusEnum.NUMBER_MISTYPED
                   | PhoneNumberStatusEnum.NUMBER_ALREADY_VERIFIED:
                    if (((!(this._Str_7950 != null)) && (!(this._Str_9469 != null))))
                    {
                        this._Str_16750();
                    }
                    else
                    {
                        if (this._Str_7950 != null)
                        {
                            this._Str_17799(false);
                        }
                    }
                    this._windowManager.alert("${generic.alert.title}", (("${phone.number.collect.error." + Std.string(k.getParser().resultCode)) + "}"), 0, null);
                    this._Str_9469._Str_16661(k.getParser().resultCode);
                    return;
            }
        }

        function _Str_22688(k:TryVerificationCodeResultMessageEvent)
        {
            switch (k.getParser().resultCode)
            {
                case PhoneNumberStatusEnum.VERIFIED
                   | PhoneNumberStatusEnum.OK:
                    this._Str_9778();
                    return;
                case PhoneNumberStatusEnum.ERROR:
                    if (((!(this._Str_8160 != null)) && (!(this._Str_9578 != null))))
                    {
                        this._Str_15062 = (flash.Lib.getTimer() + k.getParser().millisecondsToAllowProcessReset);
                        this._Str_13939();
                    }
                    else
                    {
                        if (this._Str_8160 != null)
                        {
                            this._Str_16951(false);
                        }
                    }
                    this._Str_9578._Str_16661(k.getParser().resultCode);
                    return;
            }
        }

        function _Str_24899(k:PhoneCollectionStateMessageEvent)
        {
            var _local_2= k.getParser().collectionStatusCode;
            var _local_3= k.getParser().phoneStatusCode;
            context.configuration.setProperty("phone.collection.status", Std.string(_local_2));
            context.configuration.setProperty("phone.verification.status", Std.string(_local_3));
            if (_local_2 == ClientPhoneVerificationStatusEnum.NEVER_AGAIN)
            {
                return;
            }
            if (((_local_2 == ClientPhoneVerificationStatusEnum.TOKEN_INPUT) && ((_local_3 == PhoneNumberStatusEnum.NON_VERIFIED) || (_local_3 == PhoneNumberStatusEnum.TOKEN_SENT))))
            {
                this._Str_7383();
                if (_local_2 == ClientPhoneVerificationStatusEnum.MINIMIZED)
                {
                    this._Str_19391();
                }
                else
                {
                    this._Str_15062 = (k.getParser().millisecondsToAllowProcessReset + flash.Lib.getTimer());
                    this._Str_13939();
                }
                return;
            }
            switch (_local_3)
            {
                case PhoneNumberStatusEnum.NON_EXISTING
                   | PhoneNumberStatusEnum.NON_VERIFIED:
                    this._Str_16750();
                    return;
                case PhoneNumberStatusEnum.VERIFIED
                   | PhoneNumberStatusEnum.OK:
                    this._Str_7383();
                    this._Str_9778();
                    return;
                case PhoneNumberStatusEnum.ERROR
                   | PhoneNumberStatusEnum.RATE_LIMIT
                   | PhoneNumberStatusEnum.NUMBER_MISTYPED:
                    Logger.log(["INVALID STATE!! Phone number / verify errors should not be handled here!"]);
                    return;
            }
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var localizationManager(get,never):IHabboLocalizationManager;
public function  get_localizationManager():IHabboLocalizationManager
        {
            return this._localizationManager;
        }

        public var _Str_20480(get,never):Int;
public function  get__Str_20480():Int
        {
            return this._Str_15062;
        }

        function _Str_16750()
        {
            this._Str_7383();
            var k= context.configuration.getProperty("phone.number.preferred.countries");
            var _local_2:Array<ASAny> = (cast k.split(","));
            this._Str_9469 = new PhoneNumberCollectView(this, _local_2);
        }

        function _Str_13939()
        {
            this._Str_9778();
            this._Str_9578 = new VerificationCodeInputView(this);
        }

        function _Str_25774()
        {
            this._Str_21501();
            this._Str_7950 = new PhoneNumberCollectMinimizedView(this);
            this._Str_2290.extensionView.attachExtension(ToolbarDisplayExtensionIds.PHONE_NUMBER, this._Str_7950.window, ExtensionFixedSlotsEnum._Str_13012);
        }

        function _Str_19391()
        {
            this._Str_20335();
            this._Str_8160 = new VerificationCodeInputMinimizedView(this);
            this._Str_2290.extensionView.attachExtension(ToolbarDisplayExtensionIds.VERIFICATION_CODE, this._Str_8160.window, ExtensionFixedSlotsEnum._Str_13012);
        }

        function _Str_7383()
        {
            if (this._Str_9469 != null)
            {
                this._Str_9469.dispose();
                this._Str_9469 = null;
            }
        }

        function _Str_9778()
        {
            if (this._Str_9578 != null)
            {
                this._Str_9578.dispose();
                this._Str_9578 = null;
            }
        }

        function _Str_21501()
        {
            this._Str_2290.extensionView.detachExtension(ToolbarDisplayExtensionIds.PHONE_NUMBER);
            if (this._Str_7950 != null)
            {
                this._Str_7950.dispose();
                this._Str_7950 = null;
            }
        }

        function _Str_20335()
        {
            this._Str_2290.extensionView.detachExtension(ToolbarDisplayExtensionIds.VERIFICATION_CODE);
            if (this._Str_8160 != null)
            {
                this._Str_8160.dispose();
                this._Str_8160 = null;
            }
        }
    }

