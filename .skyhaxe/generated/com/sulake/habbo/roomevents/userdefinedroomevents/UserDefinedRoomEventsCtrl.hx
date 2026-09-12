package com.sulake.habbo.roomevents.userdefinedroomevents
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
	import com.sulake.habbo.roomevents.userdefinedroomevents.IUserDefinedRoomEventsCtrl;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.UserDefinedRoomEventsTriggersCtrl;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.UserDefinedRoomEventsConditionsCtrl;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.help.UserDefinedRoomEventsHelp;
    import com.sulake.habbo.roomevents.userdefinedroomevents.common.SliderWindowController;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.TriggerDefinition;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.ActionDefinition;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.ConditionDefinition;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.SelectorDefinition;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AddonDefinition;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.VariableDefinition;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesInRoom;
    import com.sulake.habbo.roomevents.Util;
    import flash.events.Event;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.TriggerOnce;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionType;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTrigger;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.UpdateTriggerMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.UpdateActionMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.UpdateConditionMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.UpdateSelectorMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.UpdateAddonMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.UpdateVariableMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.ApplySnapshotMessageComposer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.core.window.events.*;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.habbo.roomevents.wired_setup.BuilderTypeHolder;
    import com.sulake.habbo.roomevents.wired_setup.IWiredElement;
    import com.sulake.habbo.roomevents.wired_setup.IWiredTypeHolder;
    import com.sulake.habbo.roomevents.wired_setup.WiredConfigurationCache;
    import com.sulake.habbo.roomevents.wired_setup.ClipboardWiredEntry;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.actiontypes.*;
    import com.sulake.habbo.roomevents.wired_setup.actiontypes.chests.*;
    import com.sulake.habbo.roomevents.wired_setup.addons.*;
    import com.sulake.habbo.roomevents.wired_setup.addons.chests.*;
    import com.sulake.habbo.roomevents.wired_setup.conditions.*;
    import com.sulake.habbo.roomevents.wired_setup.conditions.chests.*;
    import com.sulake.habbo.roomevents.wired_setup.selectors.*;
    import com.sulake.habbo.roomevents.wired_setup.triggerconfs.*;
    import com.sulake.habbo.roomevents.wired_setup.variables.*;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.AdvancedSettingsWrapperPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FooterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FramePreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.HeaderPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.InputSourceSection;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.IlluminaWiredStyle;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;

     class UserDefinedRoomEventsCtrl 
    {
        public static var _Str_5431:Int = 0;
        public static var _Str_4873:Int = 1;
        public static var _Str_4991:Int = 2;
        public static var _Str_5430:Int = 3;

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _window:IFrameWindow;
        var _configureContainer:IWindowContainer;
        var _triggerConfs:UserDefinedRoomEventsTriggersCtrl;
        var _actionTypes:ActionTypes;
        var _conditionTypes:UserDefinedRoomEventsConditionsCtrl;
        var _stuffs:ASDictionary<ASAny,ASAny>;
        var _stuffs2:ASDictionary<ASAny,ASAny> = new ASDictionary();
        var _updated:Triggerable;
        var _furniHighLighter:UserDefinedRoomEventsVisualizer;
        var _help:UserDefinedRoomEventsHelp;
        var _delaySlider:SliderWindowController;
        var _dualFurniPickingMode:Bool = false;
        var _activeFurniPicks:Int = 1;

        // Builder-based types render through the Wired 2.0 pipeline; XML-based
        // legacy types retain the compatibility editor path.
        var _wiredStyle:WiredStyle;
        var _presetManager:PresetManager;
        var _builderTriggerHolder:BuilderTypeHolder;
        var _builderActionHolder:BuilderTypeHolder;
        var _builderConditionHolder:BuilderTypeHolder;
        var _builderSelectorHolder:BuilderTypeHolder;
        var _builderAddonHolder:BuilderTypeHolder;
        var _builderVariableHolder:BuilderTypeHolder;
        var _builderHolder:IWiredTypeHolder;
        var _builderElement:IWiredElement;
        var _configurationCache:ASDictionary<ASAny,ASAny> = new ASDictionary();
        var _frame:FramePreset;
        var _headerPreset:HeaderPreset;
        var _selectorOptionsPreset:CheckboxGroupPreset;
        var _furniPicksSectionPreset:SectionPreset;
        var _delayPreset:SliderSection;
        var _advancedSettingsWrapperPreset:AdvancedSettingsWrapperPreset;
        var _conditionQuantifierOptions:RadioGroupPreset;
        var _inputSourcePresets:Array<ASAny>;
        var _footerPreset:FooterPreset;
        var _initialWidth:Int = 0;
        var _builderSaveConfirmed:Bool = false;
        var _builderConfirmationItemId:Int = -1;
        var _builderConfirmationElement:IWiredElement;
        var _wiredClipboard:ASDictionary<ASAny,ASAny> = new ASDictionary();
        var _builderUpdateMode:Int = 0;
        var _builderRequestedUpdateMode:Int = 0;
        var _builderRequestedTargetId:Int = -1;

        public function new(k:HabboUserDefinedRoomEvents)
        {
            this._triggerConfs = new UserDefinedRoomEventsTriggersCtrl();
            this._actionTypes = new ActionTypes();
            this._conditionTypes = new UserDefinedRoomEventsConditionsCtrl();
            this._stuffs = new ASDictionary<ASAny,ASAny>();
            this._roomEvents = k;
            this._furniHighLighter = new UserDefinedRoomEventsVisualizer(k);
            this._help = new UserDefinedRoomEventsHelp(k);
            this._builderTriggerHolder = new BuilderTypeHolder("trigger", function(t:Triggerable):Bool { return Std.downcast(t , TriggerDefinition) != null; });
            this._builderActionHolder = new BuilderTypeHolder("action", function(t:Triggerable):Bool { return Std.downcast(t , ActionDefinition) != null; });
            this._builderConditionHolder = new BuilderTypeHolder("condition", function(t:Triggerable):Bool { return Std.downcast(t , ConditionDefinition) != null; });
            this._builderSelectorHolder = new BuilderTypeHolder("selector", function(t:Triggerable):Bool { return Std.downcast(t , SelectorDefinition) != null; });
            this._builderAddonHolder = new BuilderTypeHolder("addon", function(t:Triggerable):Bool { return Std.downcast(t , AddonDefinition) != null; });
            this._builderVariableHolder = new BuilderTypeHolder("variable", function(t:Triggerable):Bool { return Std.downcast(t , VariableDefinition) != null; });
            this._builderTriggerHolder.register(new AvatarSaysSomethingElement());
            this._builderTriggerHolder.register(new AvatarWalksOnFurniElement());
            this._builderTriggerHolder.register(new AvatarWalksOffFurniElement());
            this._builderTriggerHolder.register(new TriggerOnceElement());
            this._builderTriggerHolder.register(new ToggleFurniElement());
            this._builderTriggerHolder.register(new TriggerPeriodicallyElement());
            this._builderTriggerHolder.register(new AvatarEnterRoomElement());
            this._builderTriggerHolder.register(new GameStartsElement());
            this._builderTriggerHolder.register(new GameEndsElement());
            this._builderTriggerHolder.register(new ScoreAchievedElement());
            this._builderTriggerHolder.register(new CollisionElement());
            this._builderTriggerHolder.register(new TriggerPeriodicallyLongElement());
            this._builderTriggerHolder.register(new BotReachedStuffElement());
            this._builderTriggerHolder.register(new BotReachedAvatarElement());
            this._builderTriggerHolder.register(new ClockReachTimeElement());
            this._builderTriggerHolder.register(new UserPerformsActionElement());
            this._builderTriggerHolder.register(new ReceiveSignalTriggerElement());
            this._builderTriggerHolder.register(new VariableChangedTriggerElement());
            this._builderTriggerHolder.register(new FurniTriggerElement(WiredTriggerType.AVATAR_CLICKS_FURNI));
            this._builderTriggerHolder.register(new PeriodicShortElement());
            this._builderTriggerHolder.register(new StateChangeTriggerElement());
            this._builderTriggerHolder.register(new UserClicksTileElement());
            this._builderTriggerHolder.register(new SimpleTriggerElement(WiredTriggerType.AVATAR_LEAVES_ROOM));
            this._builderTriggerHolder.register(new UserClicksUserElement());
            this._builderTriggerHolder.register(new TransactionCompletedTriggerElement());
            this._builderTriggerHolder.register(new TransactionFailedTriggerElement());
            this._builderActionHolder.register(new ToggleFurniStateElement());
            this._builderActionHolder.register(new SimpleActionElement(ActionTypeCodes.RESET));
            this._builderActionHolder.register(new SetFurniStateToElement());
            this._builderActionHolder.register(new MoveFurniElement());
            this._builderActionHolder.register(new ScoreActionElement(ActionTypeCodes.GIVE_SCORE));
            this._builderActionHolder.register(new ShowMessageActionElement());
            this._builderActionHolder.register(new TeleportActionElement());
            this._builderActionHolder.register(new JoinTeamActionElement());
            this._builderActionHolder.register(new SimpleActionElement(ActionTypeCodes.LEAVE_TEAM));
            this._builderActionHolder.register(new SimpleActionElement(ActionTypeCodes.CHASE));
            this._builderActionHolder.register(new SimpleActionElement(ActionTypeCodes.FLEE));
            this._builderActionHolder.register(new MoveToDirectionElement());
            this._builderActionHolder.register(new ScoreActionElement(ActionTypeCodes.GIVE_SCORE_TO_PREDEFINED_TEAM, true));
            this._builderActionHolder.register(new SimpleActionElement(ActionTypeCodes.TOGGLE_TO_RANDOM_STATE));
            this._builderActionHolder.register(new GiveRewardActionElement());
            this._builderActionHolder.register(new MoveFurniToElement());
            this._builderActionHolder.register(new SimpleActionElement(
                ActionTypeCodes.CALL_ANOTHER_STACK, ActionTypeCodes.NEG_CALL_ANOTHER_STACK));
            this._builderActionHolder.register(new TextActionElement(ActionTypeCodes.KICK_FROM_ROOM, "${wiredfurni.params.message}"));
            this._builderActionHolder.register(new MuteUserElement());
            this._builderActionHolder.register(new BotNameActionElement(ActionTypeCodes.BOT_TELEPORT));
            this._builderActionHolder.register(new BotNameActionElement(ActionTypeCodes.BOT_MOVE));
            this._builderActionHolder.register(new BotMessageActionElement(ActionTypeCodes.BOT_TALK, "${wiredfurni.params.talk}", 0, "${wiredfurni.params.shout}", 1));
            this._builderActionHolder.register(new BotGiveHandItemElement());
            this._builderActionHolder.register(new BotFollowAvatarElement());
            this._builderActionHolder.register(new BotChangeFigureElement());
            this._builderActionHolder.register(new BotMessageActionElement(ActionTypeCodes.BOT_TALK_DIRECT_TO_AVTR, "${wiredfurni.params.whisper}", 1, "${wiredfurni.params.talk}", 0));
            this._builderActionHolder.register(new ControlClockActionElement());
            this._builderActionHolder.register(new SetFurniAltitudeActionElement());
            this._builderActionHolder.register(new SendSignalActionElement());
            this._builderActionHolder.register(new FreezeUserActionElement());
            this._builderActionHolder.register(new SimpleActionElement(ActionTypeCodes.UNFREEZE_USER));
            this._builderActionHolder.register(new RelativeFurniMoveActionElement());
            this._builderActionHolder.register(new MoveFurniToFurniActionElement());
            this._builderActionHolder.register(new MoveFurniToUserActionElement());
            this._builderActionHolder.register(new AdjustClockActionElement());
            this._builderActionHolder.register(new MoveUserActionElement());
            this._builderActionHolder.register(new MoveUserToFurniActionElement());
            this._builderActionHolder.register(new SimpleActionElement(ActionTypeCodes.TELEPORT_TO_ROOM));
            this._builderActionHolder.register(new ProgressAchievementActionElement());
            this._builderActionHolder.register(new GiveEffectActionElement());
            this._builderActionHolder.register(new SetFurniAltitudeActionElement(ActionTypeCodes.OVERRIDE_HEIGHT));
            this._builderActionHolder.register(new SetClickSettingsActionElement());
            this._builderActionHolder.register(new PlaceFurniActionElement());
            this._builderActionHolder.register(new RemoveFurniActionElement());
            this._builderActionHolder.register(new MoveAsGroupActionElement());
            this._builderActionHolder.register(new ProgressRewardTrackActionElement());
            this._builderActionHolder.register(new ResetRewardTrackActionElement());
            this._builderActionHolder.register(new GiveVariableActionElement());
            this._builderActionHolder.register(new RemoveVariableActionElement());
            this._builderActionHolder.register(new ChangeVariableActionElement());
            this._builderActionHolder.register(new GiveCurrencyFromChestActionElement());
            this._builderActionHolder.register(new GiveFurniFromChestActionElement());
            this._builderActionHolder.register(new InitiateTransactionActionElement());
            this._builderActionHolder.register(new CancelTransactionActionElement());
            this._builderActionHolder.register(new WriteToLogsActionElement());
            this._builderConditionHolder.register(new SimpleConditionElement(ConditionCodes.TRIGGERER_IS_ON_FURNI, ConditionCodes.NOT_ACTOR_ON_FURNI));
            this._builderConditionHolder.register(new FurnisHaveAvatarsConditionElement());
            this._builderConditionHolder.register(new MatchSnapshotConditionElement());
            this._builderConditionHolder.register(new TimeElapsedConditionElement(ConditionCodes.TIME_ELAPSED_MORE, "wiredfurni.params.allowafter"));
            this._builderConditionHolder.register(new TimeElapsedConditionElement(ConditionCodes.TIME_ELAPSED_LESS, "wiredfurni.params.allowbefore"));
            this._builderConditionHolder.register(new UserCountInConditionElement());
            this._builderConditionHolder.register(new TeamConditionElement());
            this._builderConditionHolder.register(new StackedFurnisConditionElement(ConditionCodes.HAS_STACKED_FURNIS, -1, "requireall", "requireall"));
            this._builderConditionHolder.register(new FurniTypeMatchesConditionElement());
            this._builderConditionHolder.register(new StuffsInFormationElement());
            this._builderConditionHolder.register(new ActorIsInGroupConditionElement());
            this._builderConditionHolder.register(new StringConditionElement(ConditionCodes.ACTOR_IS_WEARING_BADGE, ConditionCodes.NOT_ACTOR_WEARS_BADGE, "${wiredfurni.params.badgecode}"));
            this._builderConditionHolder.register(new NumberConditionElement(ConditionCodes.ACTOR_IS_WEARING_EFFECT, ConditionCodes.NOT_ACTOR_WEARING_EFFECT, "${wiredfurni.params.effectid}"));
            this._builderConditionHolder.register(new StackedFurnisConditionElement(ConditionCodes.NOT_HAS_STACKED_FURNIS, -1, "not_requireall", "not_requireall"));
            this._builderConditionHolder.register(new DateRangeActiveElement());
            this._builderConditionHolder.register(new ActorHasHandItemConditionElement());
            this._builderConditionHolder.register(new TriggererMatchesConditionElement());
            this._builderConditionHolder.register(new TimeMatchesConditionElement());
            this._builderConditionHolder.register(new DateMatchesConditionElement());
            this._builderConditionHolder.register(new NumberConditionElement(ConditionCodes.NOT_HAS_HANDITEM, -1, "${wiredfurni.params.handitem}"));
            this._builderConditionHolder.register(new TeamIsWinningConditionElement());
            this._builderConditionHolder.register(new PerformingActionConditionElement());
            this._builderConditionHolder.register(new TeamHasScoreConditionElement());
            this._builderConditionHolder.register(new ClockTimeMatchesConditionElement());
            this._builderConditionHolder.register(new FurniHasAltitudeConditionElement());
            this._builderConditionHolder.register(new UserDirectionConditionElement());
            this._builderConditionHolder.register(new InputSourceQuantityConditionElement());
            this._builderConditionHolder.register(new FurniPickingConditionElement(ConditionCodes.CAN_PERFORM_MOVE));
            this._builderConditionHolder.register(new HasVariableConditionElement());
            this._builderConditionHolder.register(new VariableValueConditionElement());
            this._builderConditionHolder.register(new VariableAgeConditionElement());
            this._builderConditionHolder.register(new UserLevelConditionElement());
            this._builderConditionHolder.register(new ChestHasAmountConditionElement());
            this._builderConditionHolder.register(new ChestHasItemTypesConditionElement());
            this._builderSelectorHolder.register(new SelectorElement(SelectorCodes.FURNI_BY_TYPE, SelectorElement.MODE_STATE_MATCH));
            this._builderSelectorHolder.register(new SelectorElement(SelectorCodes.FURNI_CHOOSER, SelectorElement.MODE_NONE, true));
            this._builderSelectorHolder.register(new SelectorElement(SelectorCodes.USERS_BY_TYPE, SelectorElement.MODE_USER_TYPE));
            this._builderSelectorHolder.register(new SelectorElement(SelectorCodes.USERS_IN_TEAM, SelectorElement.MODE_TEAM));
            this._builderSelectorHolder.register(new SelectorElement(SelectorCodes.FURNI_ON_FURNI, SelectorElement.MODE_ON_FURNI, true));
            this._builderSelectorHolder.register(new FurniFromSignalSelectorElement());
            this._builderSelectorHolder.register(new AreaSelectorElement(SelectorCodes.FURNI_IN_AREA));
            this._builderSelectorHolder.register(new SelectorElement(SelectorCodes.USERS_ON_FURNI, SelectorElement.MODE_NONE, true));
            this._builderSelectorHolder.register(new SelectorElement(SelectorCodes.USERS_BY_NAME, SelectorElement.MODE_NAMES));
            this._builderSelectorHolder.register(new AreaSelectorElement(SelectorCodes.USERS_IN_AREA));
            this._builderSelectorHolder.register(new UsersWithHanditemSelectorElement());
            this._builderSelectorHolder.register(new UsersInGroupSelectorElement());
            this._builderSelectorHolder.register(new FurniWithAltitudeSelectorElement());
            this._builderSelectorHolder.register(new UsersByActionSelectorElement());
            this._builderSelectorHolder.register(new UsersFromSignalSelectorElement());
            this._builderSelectorHolder.register(new FurniInNeighborhoodSelectorElement());
            this._builderSelectorHolder.register(new UsersInNeighborhoodSelectorElement());
            this._builderSelectorHolder.register(new FurniWithVariableSelectorElement());
            this._builderSelectorHolder.register(new UsersWithVariableSelectorElement());
            this._builderSelectorHolder.register(new RemoteSelectorElement());
            this._builderAddonHolder.register(new ConditionEvaluationAddonElement());
            this._builderAddonHolder.register(new RandomEffectAddonElement());
            this._builderAddonHolder.register(new UnseenEffectAddonElement());
            this._builderAddonHolder.register(new ExecutionLimitAddonElement());
            this._builderAddonHolder.register(new NoMoveAnimationAddonElement());
            this._builderAddonHolder.register(new MovementPhysicsAddonElement());
            this._builderAddonHolder.register(new CarryUsersAddonElement());
            this._builderAddonHolder.register(new AnimationTimeAddonElement());
            this._builderAddonHolder.register(new FurniSelectorFilterAddonElement());
            this._builderAddonHolder.register(new UserSelectorFilterAddonElement());
            this._builderAddonHolder.register(new FurniVariableFilterAddonElement());
            this._builderAddonHolder.register(new UserVariableFilterAddonElement());
            this._builderAddonHolder.register(new UsernamePlaceholderAddonElement());
            this._builderAddonHolder.register(new VariablePlaceholderAddonElement());
            this._builderAddonHolder.register(new VariableCapturerAddonElement());
            this._builderAddonHolder.register(new ExecuteInOrderAddonElement());
            this._builderAddonHolder.register(new FurniNamePlaceholderAddonElement());
            this._builderAddonHolder.register(new ProjectileAddonElement());
            this._builderAddonHolder.register(new JumpStrengthAddonElement());
            this._builderAddonHolder.register(new VariableTextConverterAddonElement());
            this._builderAddonHolder.register(new VariableLevelUpAddonElement());
            this._builderAddonHolder.register(new VariableTimeUtilityAddonElement());
            this._builderAddonHolder.register(new GlobalPlaceholderAddonElement());
            this._builderAddonHolder.register(new AchievementEnablerAddonElement());
            this._builderAddonHolder.register(new ChestItemTypeScannerAddonElement());
            this._builderAddonHolder.register(new CustomContractAddonElement());
            this._builderVariableHolder.register(new FurniVariableElement());
            this._builderVariableHolder.register(new UserVariableElement());
            this._builderVariableHolder.register(new GlobalVariableElement());
            this._builderVariableHolder.register(new ContextVariableElement());
            this._builderVariableHolder.register(new ReferenceVariableElement());
            this._builderVariableHolder.register(new QuestVariableElement());
            this._builderVariableHolder.register(new QuestChainVariableElement());
            this._builderVariableHolder.register(new EchoVariableElement());
        }

        public var wiredStyle(get,never):WiredStyle;
public function  get_wiredStyle():WiredStyle
        {
            if (this._wiredStyle == null)
            {
                this._wiredStyle = new IlluminaWiredStyle(this._roomEvents);
            }
            return this._wiredStyle;
        }

        public var presetManager(get,never):PresetManager;
public function  get_presetManager():PresetManager
        {
            if (this._presetManager == null)
            {
                this._presetManager = new PresetManager(this._roomEvents);
            }
            return this._presetManager;
        }

        var useCache(get,never):Bool;
function  get_useCache():Bool
        {
            return true;
        }

        public function clearCache()
        {
            var _local_1:WiredConfigurationCache = null;
            final _iter_ = this._configurationCache; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_1  = _tmp_;
                _local_1.frame.dispose();
            }
            this._configurationCache = new ASDictionary<ASAny,ASAny>();
        }

        function getCacheKey(k:IWiredTypeHolder, _arg_2:Triggerable):String
        {
            return ((k.getKey() + "-" + this.wiredStyle.name) + "-" + Std.string(k.getElementByCode(_arg_2.code).code));
        }

        function loadFromCache(k:IWiredTypeHolder, _arg_2:Triggerable):Bool
        {
            var _local_3:WiredConfigurationCache = null;
            var _local_4= this.getCacheKey(k, _arg_2);
            if (this._configurationCache.exists(_local_4 ))
            {
                _local_3 = this._configurationCache[_local_4];
                this._frame = _local_3.frame;
                this._headerPreset = _local_3.headerPreset;
                this._selectorOptionsPreset = _local_3.selectorOptionsPreset;
                this._furniPicksSectionPreset = _local_3.furniPicksSectionPreset;
                this._delayPreset = _local_3.delayPreset;
                this._advancedSettingsWrapperPreset = _local_3.advancedSettingsWrapperPreset;
                this._conditionQuantifierOptions = _local_3.conditionQuantifierOptions;
                this._inputSourcePresets = _local_3.inputSourcePresets;
                this._footerPreset = _local_3.footerPreset;
                this._initialWidth = _local_3.initialWidth;
                return true;
            }
            return false;
        }

        function storeInCache(k:IWiredTypeHolder, _arg_2:Triggerable)
        {
            var _local_4= this.getCacheKey(k, _arg_2);
            var _local_3= new WiredConfigurationCache(this._frame, this._headerPreset, this._selectorOptionsPreset, this._furniPicksSectionPreset, this._delayPreset, this._advancedSettingsWrapperPreset, this._conditionQuantifierOptions, this._inputSourcePresets, this._footerPreset, this._initialWidth);
            this._configurationCache[_local_4] = _local_3;
        }

        function resolveBuilderHolder(k:Triggerable):IWiredTypeHolder
        {
            if (Std.downcast(k , TriggerDefinition) != null)
            {
                return this._builderTriggerHolder;
            }
            if (Std.downcast(k , ActionDefinition) != null)
            {
                return this._builderActionHolder;
            }
            if (Std.downcast(k , ConditionDefinition) != null)
            {
                return this._builderConditionHolder;
            }
            if (Std.downcast(k , SelectorDefinition) != null)
            {
                return this._builderSelectorHolder;
            }
            if (Std.downcast(k , AddonDefinition) != null)
            {
                return this._builderAddonHolder;
            }
            if (Std.downcast(k , VariableDefinition) != null)
            {
                return this._builderVariableHolder;
            }
            return null;
        }

        function isBuilderElementEnabled(k:IWiredElement):Bool
        {
            return (k.requiredCapability == 0) || this._roomEvents.isWiredFeatureEnabled(k.requiredCapability);
        }

        var builderEditorVisible(get,never):Bool;
function  get_builderEditorVisible():Bool
        {
            return (this._frame != null) && (this._frame.window != null) && this._frame.window.visible && (this._frame.window.parent != null);
        }

        function showBuilderFrame()
        {
            var _local_1= this._roomEvents.windowManager.getDesktop(1);
            if (_local_1 != null)
            {
                _local_1.addChild(this._frame.window);
            }
            this._frame.window.center();
            this._frame.window.activate();
        }

        public function resizeFrame()
        {
            if (this._frame != null && this._builderElement != null)
            {
                this._frame.resizeToWidth(Std.int(this._initialWidth * this._builderElement.widthModifier));
            }
        }

        function hideBuilderFrame()
        {
            var _local_1:IDesktopWindow = null;
            if (this._frame != null)
            {
                _local_1 = this._roomEvents.windowManager.getDesktop(1);
                if (_local_1 != null)
                {
                    _local_1.removeChild(this._frame.window);
                }
            }
        }

        function openBuilderEditor(k:Triggerable, _arg_2:IWiredTypeHolder, _arg_3:IWiredElement)
        {
var _local_9 = 0;            var _local_4 = 0;
            if ((this._window != null) && this._window.visible)
            {
                this._window.visible = false;
            }
            if (this._frame != null)
            {
                this.closeBuilder();
            }
            else
            {
                this.hideFurniHighlights();
                if (this._updated != null)
                {
                    this._furniHighLighter.unhighlightActiveWired(this._updated.id);
                }
            }
            this._updated = k;
            this._builderHolder = _arg_2;
            this._builderElement = _arg_3;
            this._dualFurniPickingMode = k.inputSourcesConf.isDualFurniPickingMode();
            this._activeFurniPicks = 1;
            this.createBuilderWindow(_arg_2, _arg_3);
            this._furniHighLighter.highlightActiveWired(this._updated.id);
            this.hideFurniHighlights();
            this._stuffs = new ASDictionary<ASAny,ASAny>();
            this._stuffs2 = new ASDictionary<ASAny,ASAny>();
            final _iter_ = this._updated.selectedItems; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = ASCompat.toInt(_tmp_);
                this._stuffs[_local_4] = "yes";
            }
            final _iter_ = this._updated.selectedItems2; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = ASCompat.toInt(_tmp_);
                this._stuffs2[_local_4] = "yes";
            }
            this._builderElement.onEditStart(k);
            this.showFurniHighlights();
            this._headerPreset.updateName(this._Str_16874(k.spriteId));
            if ((this._delayPreset != null) && (Std.downcast(k , ActionDefinition) != null))
            {
                this._delayPreset.value = cast(k, ActionDefinition).delayInPulses;
            }
            if ((this._selectorOptionsPreset != null) && (Std.downcast(k , SelectorDefinition) != null))
            {
_local_9= 0;
                if (cast(k, SelectorDefinition).isFilter) { _local_9 = _local_9 | 1; }
                if (cast(k, SelectorDefinition).isInvert) { _local_9 = _local_9 | 2; }
                this._selectorOptionsPreset.mask = _local_9;
            }
            if ((this._conditionQuantifierOptions != null) && (Std.downcast(k , ConditionDefinition) != null))
            {
                this._conditionQuantifierOptions.selected = cast(k, ConditionDefinition).quantifierCode;
            }
            this.refreshBuilderPickCount();
            this.refreshAdvancedInputSources();
            this._builderElement.onEditInitialized();
            this._frame.refreshForNewTriggerable();
        }

        function createBuilderWindow(k:IWiredTypeHolder, _arg_2:IWiredElement)
        {
            var _local_4:TextParam = null;
            this.hideBuilderFrame();
            this._frame = null;
            this._headerPreset = null;
            this._selectorOptionsPreset = null;
            this._furniPicksSectionPreset = null;
            this._delayPreset = null;
            this._advancedSettingsWrapperPreset = null;
            this._conditionQuantifierOptions = null;
            this._inputSourcePresets = null;
            this._footerPreset = null;
            if (this.useCache && this.loadFromCache(k, this._updated))
            {
                this.showBuilderFrame();
                return;
            }
            var _local_3= new WiredUIBuilder(this.presetManager, this.closeBuilder, k.getKey(), _arg_2.code, false);
            var headerButtonMode= _arg_2.hasStateSnapshot
                ? HeaderPreset.BUTTON_MODE_APPLY_SNAPSHOT
                : HeaderPreset.BUTTON_MODE_NONE;
            if (Std.is(_arg_2 , WriteToLogsActionElement))
            {
                headerButtonMode = HeaderPreset.BUTTON_MODE_VIEW_LOGS;
            }
            this._headerPreset = this.presetManager.createHeaderPreset(
                this._Str_16874(this._updated.spriteId), k, headerButtonMode,
                this.onBuilderApplySnapshot, null, this.viewWiredLogs);
            _local_3.addElements([this._headerPreset]);
            _arg_2.setRoomEvents(this._roomEvents);
            _arg_2.buildInputs(this.presetManager, this.wiredStyle, _local_3);
            if (Std.downcast(this._updated , SelectorDefinition) != null)
            {
                this._selectorOptionsPreset = this.presetManager.createCheckboxGroup([
                    new CheckboxOptionParam("${wiredfurni.params.selector.filter}", 0),
                    new CheckboxOptionParam("${wiredfurni.params.selector.invert}", 1)
                ]);
                _local_3.addElements([this.presetManager.createSection("${wiredfurni.params.selector.options}", this._selectorOptionsPreset)]);
            }
            if (this.isStuffSelectionMode() && !this._builderElement.forceHidePickFurniInstructions)
            {
                _local_4 = new TextParam(1, false);
                _local_4.textColor = this.wiredStyle.softTextColor;
                this._furniPicksSectionPreset = this.presetManager.createSection("${wiredfurni.pickfurnis.caption}", this.presetManager.createText("${wiredfurni.pickfurnis.desc}", _local_4));
                _local_3.addElements([this._furniPicksSectionPreset]);
            }
            if (Std.downcast(this._updated , ActionDefinition) != null)
            {
                this._delayPreset = this.presetManager.createSliderSection("wiredfurni.params.delay", "seconds", SliderSection.CONVERTER_PULSES, 0, 20, 1, false);
                _local_3.addElements([this._delayPreset]);
            }
            this.createAdvancedSections(this._updated, k, _arg_2, _local_3);
            this._footerPreset = this.presetManager.createFooterPreset(this.saveBuilder, this.closeBuilder);
            _local_3.addElements([this._footerPreset]);
            _local_3.build(_arg_2.widthModifier, _arg_2.allowScrolling);
            this._frame = _local_3.frame;
            this._initialWidth = _local_3.initialWidth;
            _arg_2.onInit(this._roomEvents);
            this.showBuilderFrame();
            if (this.useCache)
            {
                this.storeInCache(k, this._updated);
            }
        }

        function refreshBuilderPickCount()
        {
            var _local_1= this._Str_10656().length;
            var _local_2= this._updated.maximumItemSelectionCount;
            this._roomEvents.localization.registerParameter("wiredfurni.pickfurnis.caption", "count", ("" + Std.string(_local_1)));
            this._roomEvents.localization.registerParameter("wiredfurni.pickfurnis.caption", "limit", ("" + Std.string(_local_2)));
        }

        function showFurniHighlights()
        {
            if (this._dualFurniPickingMode)
            {
                this._furniHighLighter._Str_25313(this._stuffs, true, 1);
                this._furniHighLighter._Str_25313(this._stuffs2, true, 2);
                return;
            }
            this._furniHighLighter._Str_25313(this._stuffs, false, 0);
        }

        function hideFurniHighlights()
        {
            this._furniHighLighter._Str_21701(this._stuffs, true, 1);
            this._furniHighLighter._Str_21701(this._stuffs2, true, 2);
        }

        function createAdvancedSections(k:Triggerable, _arg_2:IWiredTypeHolder, _arg_3:IWiredElement, _arg_4:WiredUIBuilder)
        {
var _local_9:String  = null, _local_10:ASAny  = null, _local_11:ASAny  = null;            var _local_5:Array<ASAny> = null;
            var _local_6:Array<ASAny> = [];
            var _local_7= Std.downcast(k , ConditionDefinition);
            var _local_8= (_local_7 != null) && (_local_7.quantifierType != 0);
            if (!k.advancedMode || ((k.inputSourcesConf.amountFurniSelections == 0) && (k.inputSourcesConf.amountUserSelections == 0) && !_local_8))
            {
                return;
            }
            if (_local_8)
            {
_local_9= this.getQuantifierKey(_local_7);
                this._conditionQuantifierOptions = this.presetManager.createRadioGroup([
                    new RadioButtonParam(0, "${" + _local_9 + "0}"),
                    new RadioButtonParam(1, "${" + _local_9 + "1}")
                ]);
                _local_6.push(this.presetManager.createSection("${wiredfurni.params.quantifier_selection}", this._conditionQuantifierOptions));
            }
            _local_5 = this.createAdvancedInputSources(k, _arg_3);
            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
            {
_local_10 = _tmp_;
                _local_6.push(_local_10);
            }
            if (_arg_3.inputSourcesAlwaysVisible())
            {
                if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                {
_local_11 = _tmp_;
                    _arg_4.addElements([_local_11]);
                }
                return;
            }
            this._advancedSettingsWrapperPreset = this.presetManager.createAdvancedSettingsWrapperPreset(_local_6, _arg_3.advancedAlwaysVisible());
            _arg_4.addElements([this._advancedSettingsWrapperPreset]);
        }

        function getQuantifierKey(k:ConditionDefinition):String
        {
            var _local_1= (k.quantifierType == 1) ? "furni" : ((k.quantifierType == 2) ? "users" : ((k.quantifierType == 3) ? "variables" : ""));
            return "wiredfurni.params.quantifier." + _local_1 + (k.isInvert ? ".neg." : ".");
        }

        function createAdvancedInputSources(k:Triggerable, _arg_2:IWiredElement):Array<ASAny>
        {
var             _local_7 = 0;            var _local_3:Array<ASAny> = null;
            var _local_4:Array<ASAny> = [];
            var _local_5:Array<ASAny> = [];
            var _local_6:Array<ASAny> = [];
            var _local_7 = 0;
            this._inputSourcePresets = [];
            final _iter_ = _arg_2.mergedSelections(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if ((_local_3 != null) && (_local_3.length > 0) && (ASCompat.toInt(_local_3[0]) >= 0))
                {
                    _local_4[ASCompat.toInt(_local_3[0])] = true;
                }
                if ((_local_3 != null) && (_local_3.length > 1) && (ASCompat.toInt(_local_3[1]) >= 0))
                {
                    _local_5[ASCompat.toInt(_local_3[1])] = true;
                }
            }
            _local_7= 0;while (_local_7 < k.inputSourcesConf.amountFurniSelections)
            {
                if (!_local_4[_local_7])
                {
                    _local_6 = k.inputSourcesConf.getAllowedFurniSources(_local_7);
                    if ((_local_6 != null) && (_local_6.length > 0))
                    {
                        this._inputSourcePresets.push(this.presetManager.createInputSourceSection("${" + _arg_2.furniSelectionTitle(_local_7) + "}", WiredInputSourcePicker.FURNI_SOURCE, _local_7, null, false, k.inputSourcesConf.isDualFurniPickingMode()));
                    }
                }
_local_7++;
            }
            _local_7= 0;while (_local_7 < k.inputSourcesConf.amountUserSelections)
            {
                if (!_local_5[_local_7])
                {
                    _local_6 = k.inputSourcesConf.getAllowedUserSources(_local_7);
                    if ((_local_6 != null) && (_local_6.length > 0))
                    {
                        this._inputSourcePresets.push(this.presetManager.createInputSourceSection("${" + _arg_2.userSelectionTitle(_local_7) + "}", WiredInputSourcePicker.USER_SOURCE, _local_7, null, false, k.inputSourcesConf.isDualFurniPickingMode()));
                    }
                }
_local_7++;
            }
            _local_3 = _arg_2.mergedSelections();
            _local_7= 0;while (_local_7 < _local_3.length)
            {
                this._inputSourcePresets.push(this.presetManager.createInputSourceSection("${" + _arg_2.mergedSelectionTitle(_local_7) + "}", WiredInputSourcePicker.MERGED_SOURCE, _local_7, _arg_2.mergedSourceOptions(_local_7), _arg_2.hasCustomTypePicker(_local_7), k.inputSourcesConf.isDualFurniPickingMode()));
_local_7++;
            }
            return this._inputSourcePresets;
        }

        function refreshAdvancedInputSources()
        {
            var k:InputSourceSection = null;
            if (this._inputSourcePresets == null)
            {
                return;
            }
            final _iter_ = this._inputSourcePresets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.refresh(this._updated, this._builderElement);
                if (k.baseSourceType == WiredInputSourcePicker.MERGED_SOURCE)
                {
                    k.sourceType = this._builderElement.getMergedType(k.id);
                }
            }
            if (this._advancedSettingsWrapperPreset != null)
            {
                this._advancedSettingsWrapperPreset.expanded = this.isUsingAdvancedSettings;
            }
        }

        public var isUsingAdvancedSettings(get,never):Bool;
public function  get_isUsingAdvancedSettings():Bool
        {
            return (this._updated != null) && (this._builderElement != null) && (this._updated.usingCustomInputSources || this._builderElement.usingCustomAdvancedSettings);
        }

        public var hidePickFurniInstructions(get,never):Bool;
public function  get_hidePickFurniInstructions():Bool
        {
            if ((this._updated == null) || (this._builderElement == null))
            {
                return false;
            }
            if (this._builderElement.forceHidePickFurniInstructions)
            {
                return true;
            }
            return (!this._updated.inputSourcesConf.isFurniSelectionDefault()) && (!this._builderElement.forceFurniSelection);
        }

        public function getStuffIds():Array<ASAny>
        {
            return this._Str_10656();
        }

        public function getStuffIds2():Array<ASAny>
        {
var _local_2:String  = null;            var _local_2:String = null;
            var k= new Array<ASAny>();
            final _iter_ = this._stuffs2; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_2 = _tmp_;
                k.push(ASCompat.toInt(_local_2));
            }
            return k;
        }

        public function clearStuffPicks()
        {
            this.hideFurniHighlights();
            this._stuffs = new ASDictionary<ASAny,ASAny>();
            this._stuffs2 = new ASDictionary<ASAny,ASAny>();
            this.refreshBuilderPickCount();
            this.refreshAdvancedInputSources();
            if (this._frame != null) { this._frame.updateButtonDisabledStates(); }
        }

        public function resetToDefault()
        {
var             index = 0;            if (this._updated == null || this._builderElement == null) { return; }
            this._updated.intParams = this._updated.defaultIntParams.copy();
            this._updated.stringParam = "";
            var variables:Array<ASAny> = [];
            index= 0;while (index < this._updated.variableIds.length)
            {
                variables.push("");
index++;
            }
            this._updated.variableIds = variables;
            this._updated.stuffIds = [];
            this._updated.stuffIds2 = [];
            this._updated.furniSourceTypes = this._updated.inputSourcesConf.defaultFurniSources.copy();
            this._updated.userSourceTypes = this._updated.inputSourcesConf.defaultUserSources.copy();
            var action= Std.downcast(this._updated , ActionDefinition);
            var condition= Std.downcast(this._updated , ConditionDefinition);
            var selector= Std.downcast(this._updated , SelectorDefinition);
            if (action != null) { action.delayInPulses = 0; }
            if (condition != null) { condition.quantifierCode = 0; }
            if (selector != null) { selector.isFilter = false; selector.isInvert = false; }
            this.reloadCurrentBuilder();
        }

        public function createClipboardCopy()
        {
            if (this._builderHolder == null || this._builderElement == null || this._updated == null) { return; }
            var variableIds= this._builderElement.readVariableIdsFromForm();
            var furniSources= this._builderElement.readFurniSourceTypesFromForm();
            var userSources= this._builderElement.readUserSourceTypesFromForm();
            var stuffIds2= this._builderElement.readFurniIds2FromForm();
            if (variableIds == null) { variableIds = this._updated.variableIds; }
            if (furniSources == null) { furniSources = this._updated.furniSourceTypes; }
            if (userSources == null) { userSources = this._updated.userSourceTypes; }
            if (stuffIds2 == null) { stuffIds2 = this.getStuffIds2(); }
            var entry= new ClipboardWiredEntry(
                this._builderElement.readIntParamsFromForm(),
                this._builderElement.readStringParamFromForm(), variableIds,
                this.getStuffIds(), stuffIds2, furniSources, userSources);
            if (Std.downcast(this._updated , ActionDefinition) != null) { entry.delayInPulses = this.getBuilderDelay(); }
            if (Std.downcast(this._updated , ConditionDefinition) != null) { entry.quantifierCode = this.getBuilderQuantifier(); }
            if (Std.downcast(this._updated , SelectorDefinition) != null && this._selectorOptionsPreset != null)
            {
                entry.isFilter = (this._selectorOptionsPreset.mask & 1) != 0;
                entry.isInvert = (this._selectorOptionsPreset.mask & 2) != 0;
            }
            this._wiredClipboard[this.currentClipboardKey] = entry;
            if (this._frame != null) { this._frame.updateButtonDisabledStates(); }
            this._roomEvents.showWiredNotification("notification.wired.copied");
        }

        public function pasteFromClipboard()
        {
            if (!this.hasCurrentElementInClipboard()) { return; }
            var entry= ASCompat.dynamicAs(this._wiredClipboard[this.currentClipboardKey] , ClipboardWiredEntry);
            this._updated.intParams = entry.intParams.copy();
            this._updated.stringParam = entry.stringParam;
            this._updated.variableIds = entry.variableIds.copy();
            this._updated.stuffIds = entry.stuffIds.copy();
            this._updated.stuffIds2 = entry.stuffIds2.copy();
            this._updated.furniSourceTypes = entry.furniSourceTypes.copy();
            this._updated.userSourceTypes = entry.userSourceTypes.copy();
            var action= Std.downcast(this._updated , ActionDefinition);
            var condition= Std.downcast(this._updated , ConditionDefinition);
            var selector= Std.downcast(this._updated , SelectorDefinition);
            if (action != null) { action.delayInPulses = entry.delayInPulses; }
            if (condition != null) { condition.quantifierCode = entry.quantifierCode; }
            if (selector != null) { selector.isFilter = entry.isFilter; selector.isInvert = entry.isInvert; }
            this.reloadCurrentBuilder();
        }

        public function hasCurrentElementInClipboard():Bool
        {
            return this._builderHolder != null && this._builderElement != null &&
                this._wiredClipboard[this.currentClipboardKey] != null;
        }

        var currentClipboardKey(get,never):String;
function  get_currentClipboardKey():String
        {
            return this._builderHolder.getKey() + "-" + Std.string(this._builderElement.code);
        }

        function reloadCurrentBuilder()
        {
            var definition= this._updated;
            var holder= this._builderHolder;
            var element= this._builderElement;
            var x= this._frame.window.x;
            var y= this._frame.window.y;
            this.openBuilderEditor(definition, holder, element);
            this._frame.window.x = x;
            this._frame.window.y = y;
            this._frame.window.activate();
        }

        
        public var activeFurniPicks(get,set):Int;
public function  set_activeFurniPicks(k:Int):Int        {
            var _local_2:InputSourceSection = null;
            this._activeFurniPicks = k;
            if (this._inputSourcePresets == null)
            {
                return k;
            }
            final _iter_ = this._inputSourcePresets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2.activeFurniPicksChanged();
            }
return k;
        }
public function  get_activeFurniPicks():Int
        {
            return this._activeFurniPicks;
        }

        public function setMergedSourceType(k:Int, _arg_2:Int)
        {
            var _local_3:InputSourceSection = null;
            if (this._inputSourcePresets == null)
            {
                return;
            }
            final _iter_ = this._inputSourcePresets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if ((_local_3.baseSourceType == WiredInputSourcePicker.MERGED_SOURCE) && (_local_3.id == k))
                {
                    _local_3.sourceType = _arg_2;
                    this.refreshAdvancedInputSources();
                    return;
                }
            }
        }

        public function updateSourceContainer(k:Int, _arg_2:Int)
        {
            var _local_3:InputSourceSection = null;
            if (this._inputSourcePresets == null)
            {
                return;
            }
            final _iter_ = this._inputSourcePresets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if ((_local_3.baseSourceType == k) && (_local_3.id == _arg_2))
                {
                    _local_3.refresh(this._updated, this._builderElement);
                }
            }
        }

        function onBuilderApplySnapshot()
        {
            this._roomEvents.send(new ApplySnapshotMessageComposer(this._updated.id));
        }

        function viewWiredLogs()
        {
            this._roomEvents.context.createLinkEvent("wiredmenu/logs");
        }

        function saveBuilder()
        {
var confirmation:ASObject  = null, _local_10 = 0;            if (!this.isBuilderElementEnabled(this._builderElement))
            {
                this.onSaveFailure();
                return;
            }
            if (!this._builderSaveConfirmed)
            {
confirmation= this._builderElement.requireConfirmation;
                if (confirmation != null)
                {
                    this._builderConfirmationItemId = this._updated.id;
                    this._builderConfirmationElement = this._builderElement;
                    this._roomEvents.windowManager.confirm(confirmation.title,
                        confirmation.body, 0, this.onBuilderSaveConfirmation);
                    return;
                }
            }
            this._builderSaveConfirmed = false;
            var _local_1= this._builderElement.validate();
            if (_local_1 != null)
            {
                this._roomEvents.windowManager.alert("${wiredfurni.error.title}", _local_1, 0, null);
                this.onSaveFailure();
                return;
            }
            var _local_2= this._builderElement.readIntParamsFromForm();
            var _local_3= this._builderElement.readStringParamFromForm();
            var _local_4= this._Str_10656();
            var _local_5= this._updated.stuffTypeSelectionEnabled ? this._updated._Str_6040 : 0;
            var _local_6= this._builderElement.readFurniSourceTypesFromForm();
            var _local_7= this._builderElement.readUserSourceTypesFromForm();
            var _local_8= this._builderElement.readVariableIdsFromForm();
            var _local_9= this._builderElement.readFurniIds2FromForm();
            var targetId= (this._builderRequestedTargetId == -1) ? this._updated.id : this._builderRequestedTargetId;
            if (_local_6 == null) { _local_6 = this._updated.furniSourceTypes.copy(); }
            if (_local_7 == null) { _local_7 = this._updated.userSourceTypes.copy(); }
            if (_local_8 == null) { _local_8 = this._updated.variableIds.copy(); }
            if (_local_9 == null) { _local_9 = this._dualFurniPickingMode ? this.getStuffIds2() : this._updated.selectedItems2.copy(); }
            if (Std.downcast(this._updated , TriggerDefinition) != null)
            {
                this._roomEvents.send(new UpdateTriggerMessageComposer(targetId, _local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9));
            }
            else if (Std.downcast(this._updated , ActionDefinition) != null)
            {
                this._roomEvents.send(new UpdateActionMessageComposer(targetId, _local_2, _local_3, _local_4, this.getBuilderDelay(), _local_5, _local_6, _local_7, _local_8, _local_9));
            }
            else if (Std.downcast(this._updated , ConditionDefinition) != null)
            {
                this._roomEvents.send(new UpdateConditionMessageComposer(targetId, _local_2, _local_3, _local_4, this.getBuilderQuantifier(), _local_6, _local_7, _local_8, _local_9));
            }
            else if (Std.downcast(this._updated , SelectorDefinition) != null)
            {
_local_10= (this._selectorOptionsPreset != null) ? this._selectorOptionsPreset.mask : 0;
                this._roomEvents.send(new UpdateSelectorMessageComposer(targetId, _local_2, _local_3, _local_4, ((_local_10 & 1) != 0), ((_local_10 & 2) != 0), _local_6, _local_7, _local_8, _local_9));
            }
            else if (Std.downcast(this._updated , AddonDefinition) != null)
            {
                if (!this._roomEvents.isWiredFeatureEnabled(WiredCapabilityCodes.ADDONS)) { this.onSaveFailure(); return; }
                this._roomEvents.send(new UpdateAddonMessageComposer(targetId, _local_2, _local_8, _local_3, _local_4, _local_9, _local_6, _local_7));
            }
            else if (Std.downcast(this._updated , VariableDefinition) != null)
            {
                if (!this._roomEvents.isWiredFeatureEnabled(WiredCapabilityCodes.VARIABLES)) { this.onSaveFailure(); return; }
                this._roomEvents.send(new UpdateVariableMessageComposer(targetId, _local_2, _local_8, _local_3, _local_4, _local_9, _local_6, _local_7));
            }
            this._builderUpdateMode = this._builderRequestedUpdateMode;
            this._builderRequestedUpdateMode = 0;
            this._builderRequestedTargetId = -1;
        }

        public function saveBuilderFromMenu()
        {
            this._builderRequestedUpdateMode = 1;
            this._builderRequestedTargetId = -1;
            this.saveBuilder();
        }

        function saveBuilderInto(targetId:Int)
        {
            this._builderRequestedUpdateMode = 2;
            this._builderRequestedTargetId = targetId;
            this.saveBuilder();
        }

        public function onSaveFailure()
        {
            this._builderUpdateMode = 0;
            this._builderRequestedUpdateMode = 0;
            this._builderRequestedTargetId = -1;
        }

        public function onSaveSuccess()
        {
            if (this._builderUpdateMode == 0)
            {
                this.close();
            }
            else if (this._builderUpdateMode == 1)
            {
                this._roomEvents.showWiredNotification("notification.wired.saved");
            }
            else if (this._builderUpdateMode == 2)
            {
                this._roomEvents.showWiredNotification("notification.wired.pasted_into");
            }
            this._builderUpdateMode = 0;
        }

        function getBuilderDelay():Int
        {
            if (this._delayPreset == null)
            {
                return 0;
            }
            return this._delayPreset.value;
        }

        function getBuilderQuantifier():Int
        {
            return (this._conditionQuantifierOptions != null) ? this._conditionQuantifierOptions.selected : 0;
        }

        public function onGuildMemberships(k:Array<ASAny>)
        {
            if (this._builderElement != null)
            {
                this._builderElement.onGuildMemberships(k);
            }
        }

        function closeBuilder()
        {
            if (this._updated != null)
            {
                this._furniHighLighter.unhighlightActiveWired(this._updated.id);
                if (this._builderElement != null)
                {
                    this._builderElement.onEditEnd();
                }
                this._updated = null;
                this._builderElement = null;
            }
            this.hideFurniHighlights();
            this._stuffs = new ASDictionary<ASAny,ASAny>();
            this._stuffs2 = new ASDictionary<ASAny,ASAny>();
            this.hideBuilderFrame();
            this._dualFurniPickingMode = false;
            this._activeFurniPicks = 1;
            this._builderHolder = null;
            this._builderElement = null;
            this._updated = null;
            this._builderSaveConfirmed = false;
            this._builderConfirmationItemId = -1;
            this._builderConfirmationElement = null;
        }

        function isStuffSelectionMode():Bool
        {
            return (this._updated != null) && (this._updated.inputSourcesConf.allowFurniSelection() || this._builderElement.forceFurniSelection);
        }

        public function _Str_15677(k:Int, _arg_2:String)
        {
var activeStuffs:ASDictionary<ASAny,ASAny>  = null;            // Wired 2.0 dual mode: builder editor handles its own furni picking.
            if (this.builderEditorVisible)
            {
                if (!this.isStuffSelectionMode())
                {
                    return;
                }
activeStuffs= (this._dualFurniPickingMode && (this._activeFurniPicks == 2)) ? this._stuffs2 : this._stuffs;
                if (activeStuffs[k])
                {
                    activeStuffs.remove(k);
                    this._furniHighLighter.hide(k, this._dualFurniPickingMode, this._activeFurniPicks);
                }
                else if (this.activeStuffIds().length < this._updated.maximumItemSelectionCount)
                {
                    activeStuffs[k] = _arg_2;
                    this._furniHighLighter.show(k, this._dualFurniPickingMode, this._activeFurniPicks);
                }
                this.refreshBuilderPickCount();
                this.refreshAdvancedInputSources();
                return;
            }
            if (((this._window == null) || (!this._window.visible)))
            {
                return;
            }
            if (!this._Str_19885())
            {
                return;
            }
            if (this._stuffs[k])
            {
                this._stuffs.remove(k);
                this._furniHighLighter.hide(k);
            }
            else
            {
                if (this._Str_10656().length < this._updated.maximumItemSelectionCount)
                {
                    this._stuffs[k] = _arg_2;
                    this._furniHighLighter.show(k);
                }
            }
            this.refresh();
        }

        function _Str_19885():Bool
        {
            var k= this._Str_3959();
            return !(k.requiresFurni == _Str_5431);
        }

        function _Str_3959():WiredFurniture
        {
            return this._Str_19071()._Str_15652(this._updated.code);
        }

        function _Str_19071():IUserDefinedRoomEventsCtrl
        {
            if (Std.downcast(this._updated , TriggerDefinition) != null)
            {
                return this._triggerConfs;
            }
            if (Std.downcast(this._updated , ActionDefinition) != null)
            {
                return this._actionTypes;
            }
            if (Std.downcast(this._updated , ConditionDefinition) != null)
            {
                return this._conditionTypes;
            }
            return null;
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._roomEvents.getXmlWindow("ude_main"), IFrameWindow);
            this._configureContainer = cast(this.find(this._window, "configure_container"), IWindowContainer);
            Util._Str_6937(this.find(this._configureContainer, "save_button"), this._Str_24143);
            Util._Str_6937(this.find(this._configureContainer, "cancel_save_button"), this.onWindowClose);
            Util._Str_6937(this.find(this._configureContainer, "helplink"), this._Str_22441);
            Util._Str_6937(this.find(this._configureContainer, "apply_snapshot_txt"), this._Str_23497);
            Util._Str_6937(this.find(this._configureContainer, "dec_stuff_sel_button"), this._Str_23536);
            Util._Str_6937(this.find(this._configureContainer, "inc_stuff_sel_button"), this._Str_24649);
            this.find(this._configureContainer, "helplink").mouseThreshold = 0;
            this.find(this._configureContainer, "apply_snapshot_txt").mouseThreshold = 0;
            this._delaySlider = new SliderWindowController(this._roomEvents, cast(this.find(this._configureContainer, "delay_slider_container"), IWindowContainer), this._roomEvents.assets, 0, 20, 1);
            this._delaySlider.addEventListener(Event.CHANGE, this._Str_25230);
            this._delaySlider.setValue(0);
            this.setIcon("configure_container", "icon_trigger", "trigger_icon_bitmap");
            this.setIcon("configure_container", "icon_action", "action_icon_bitmap");
            this.setIcon("configure_container", "icon_condition", "condition_icon_bitmap");
            var k= this._window.findChildByTag("close");
            k.procedure = this.onWindowClose;
            this._window.center();
        }

        function _Str_25230(k:Event)
        {
            var _local_2:SliderWindowController = null;
            var _local_3 = Math.NaN;
            var _local_4 = 0;
            var _local_5:String = null;
            if (k.type == Event.CHANGE)
            {
                _local_2 = ASCompat.dynamicAs(k.target , SliderWindowController);
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getValue();
                    _local_4 = Std.int(_local_3);
                    _local_5 = TriggerOnce._Str_11919(_local_4);
                    this._roomEvents.localization.registerParameter("wiredfurni.params.delay", "seconds", _local_5);
                }
            }
        }

        function setIcon(k:String, _arg_2:String, _arg_3:String="icon_bitmap")
        {
            var _local_4= cast(this.find(this._window, k), IWindowContainer);
            this._roomEvents.refreshButton(_local_4, _arg_3, true, null, 0, _arg_2);
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.close();
            }
        }

        public function close()
        {
            if (this.builderEditorVisible)
            {
                this.closeBuilder();
            }
            if (this._window != null)
            {
                this._window.visible = false;
                this._furniHighLighter._Str_21701(this._stuffs);
            }
        }

        function find(k:IWindowContainer, _arg_2:String):IWindow
        {
            var _local_3= k.findChildByName(_arg_2);
            if (_local_3 == null)
            {
                throw new ASError((("Window element with name: " + _arg_2) + " cannot be found!"));
            }
            return _local_3;
        }

        public function _Str_18351(k:Triggerable)
        {
var targetHolder:IWiredTypeHolder  = null, targetElement:IWiredElement  = null, pendingDefinition:Triggerable  = null, pendingVariables:AllVariablesInRoom  = null, pendingRoomId = 0;            var _local_3 = 0;
            var _local_4:IWindowContainer = null;
            var _local_5:ActionDefinition = null;
            var _local_6 = 0;
            if (this._frame != null && this._builderElement != null && this._frame.isCopyingIntoMode)
            {
targetHolder= this.resolveBuilderHolder(k);
targetElement= targetHolder != null ? targetHolder.getElementByCode(k.code) : null;
                if (targetElement == this._builderElement)
                {
                    this.saveBuilderInto(k.id);
                }
                else
                {
                    this._roomEvents.showWiredNotification("notification.wired.pasted_into_fail");
                }
                return;
            }
            if ((Std.downcast(k , AddonDefinition) != null) && (!this._roomEvents.isWiredFeatureEnabled(WiredCapabilityCodes.ADDONS)))
            {
                return;
            }
            if ((Std.downcast(k , VariableDefinition) != null) && (!this._roomEvents.isWiredFeatureEnabled(WiredCapabilityCodes.VARIABLES)))
            {
                return;
            }
            if (k.wiredContext != null && k.wiredContext.roomVariablesList != null &&
                k.wiredContext.roomVariablesList.needsSynchronize)
            {
pendingDefinition= k;
pendingVariables= k.wiredContext.roomVariablesList;
pendingRoomId= this._roomEvents.roomId;
                this._roomEvents.variablesSynchronizer.getAllVariables(function(values:Vector<WiredVariable>)
                {
var value:WiredVariable  = null;                    // A room change/disconnect fails queued synchronization with an
                    // empty result. Never resume an editor whose context belonged
                    // to the old room (or was replaced while the request was live).
                    if (_roomEvents.roomId != pendingRoomId ||
                        pendingDefinition.wiredContext == null ||
                        pendingDefinition.wiredContext.roomVariablesList != pendingVariables)
                    {
                        return;
                    }
                    var synchronizedValues:Array<ASAny> = [];
                    if (checkNullIteratee(values)) for (_tmp_ in values) { value = _tmp_;
synchronizedValues.push(value); }
                    pendingVariables.synchronize(synchronizedValues);
                    _Str_18351(pendingDefinition);
                }, true, k.wiredContext.roomVariablesList.hash);
                return;
            }
            // Wired 2.0 dual mode: builder-based types take the wired_setup pipeline.
            var _local_7= this.resolveBuilderHolder(k);
            var _local_8:IWiredElement = (_local_7 != null) ? _local_7.getElementByCode(k.code) : null;
            if ((_local_8 != null) && (!this.isBuilderElementEnabled(_local_8)))
            {
                return;
            }
            if (((Std.downcast(k , AddonDefinition) != null) || (Std.downcast(k , VariableDefinition) != null)) && (_local_8 == null))
            {
                return;
            }
            if ((_local_8 != null) && (_local_8.inputMode == DefaultElement.INPUTS_TYPE_UI_BUILDER))
            {
                this.openBuilderEditor(k, _local_7, _local_8);
                return;
            }
            if (this.builderEditorVisible)
            {
                this.closeBuilder();
            }
            else
            {
                this.hideBuilderFrame();
            }
            this.prepareWindow();
            this._updated = k;
            Logger.log([((("Received: " + this._updated) + ", ") + Std.string(k.code))]);
            var _local_2= this._Str_3959();
            this._furniHighLighter._Str_21701(this._stuffs);
            this._stuffs = new ASDictionary<ASAny,ASAny>();
            final _iter_ = this._updated.selectedItems; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = ASCompat.toInt(_tmp_);
                this._stuffs[_local_3] = "yes";
            }
            _local_4 = (_local_2.hasSpecialInputs ? this._Str_10876() : null);
            _local_2.onEditStart(_local_4, this._updated);
            this._furniHighLighter._Str_25313(this._stuffs);
            if (Std.downcast(this._updated , ActionDefinition) != null)
            {
                _local_5 = cast(this._updated, ActionDefinition);
                _local_6 = _local_5.delayInPulses;
                this._delaySlider.setValue(_local_6);
            }
            this._Str_23934();
            this.refresh();
        }

        function _Str_23934()
        {
            var _local_2:WiredFurniture = null;
            this._Str_17281().visible = false;
            this._Str_21281().visible = false;
            this._Str_21929().visible = false;
            if (this._updated.stuffTypeSelectionEnabled)
            {
                _local_2 = this._Str_3959();
                if (((_local_2.requiresFurni == _Str_4991) || (_local_2.requiresFurni == _Str_5430)))
                {
                    this._Str_21281().visible = true;
                    this._Str_21929().visible = true;
                    this._Str_17281().visible = true;
                    this._Str_17985();
                }
            }
            var k= cast(this._configureContainer.findChildByName("select_furni_container"), IWindowContainer);
            k.height = Util.getLowestPoint(k);
        }

        function _Str_17985()
        {
            var k= this._Str_3959();
            var _local_2= ((ASCompat.reinterpretAs(k , ActionType) != null) ? "effect" : ((Std.downcast(k , WiredTrigger) != null) ? "trigger" : "condition"));
            var _local_3= "wiredfurni.pickfurnis.";
            var _local_4= ((((_local_3 + _local_2) + Std.string(k.code)) + ".") + Std.string(this._updated._Str_6040));
            var _local_5= this._roomEvents.localization.getLocalization(_local_4, "");
            Logger.log([((("Searching with key I: " + _local_4) + " got ") + _local_5)]);
            if (_local_5 == "")
            {
                _local_4 = (((_local_3 + _local_2) + ".") + Std.string(this._updated._Str_6040));
                _local_5 = this._roomEvents.localization.getLocalization(_local_4, _local_4);
                Logger.log([((("Searching with key II: " + _local_4) + " got ") + _local_5)]);
            }
            this._Str_17281().caption = _local_5;
        }

        public function _Str_25654(k:Int)
        {
            // Wired 2.0 dual mode: builder editor branch.
            if (this.builderEditorVisible)
            {
                if (this._updated.id == k)
                {
                    this.closeBuilder();
                    return;
                }
                if (this._stuffs[k])
                {
                    this._stuffs.remove(k);
                    this.refreshBuilderPickCount();
                    this.refreshAdvancedInputSources();
                }
                if (this._stuffs2[k])
                {
                    this._stuffs2.remove(k);
                    this.refreshBuilderPickCount();
                    this.refreshAdvancedInputSources();
                }
                return;
            }
            if (this._window == null)
            {
                return;
            }
            if (!this._window.visible)
            {
                return;
            }
            if (this._updated.id == k)
            {
                this._window.visible = false;
                return;
            }
            if (this._stuffs[k])
            {
                this._stuffs.remove(k);
                this.refresh();
            }
        }

        function onBuilderSaveConfirmation(k:IConfirmDialog, event:WindowEvent)
        {
            k.dispose();
            var matchesEditor= this._builderElement != null &&
                this._builderElement == this._builderConfirmationElement &&
                this._updated != null &&
                this._updated.id == this._builderConfirmationItemId;
            this._builderConfirmationItemId = -1;
            this._builderConfirmationElement = null;
            if (event.type == WindowEvent.WINDOW_EVENT_OK &&
                matchesEditor)
            {
                this._builderSaveConfirmed = true;
                this.saveBuilder();
            }
        }

        function _Str_24143(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            /*if (!this.isOwner(this._updated.id))
            {
                this._roomEvents.windowManager.confirm("${wiredfurni.nonowner.change.confirm.title}", "${wiredfurni.nonowner.change.confirm.body}", 0, this._Str_24497);
            }
            else
            {*/
                this.update();
            //}
        }

        function _Str_24497(k:IConfirmDialog, _arg_2:WindowEvent)
        {
            k.dispose();
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                this.update();
            }
        }

        function update()
        {
            var k= this._Str_3959();
            var _local_2= k.validate((k.hasSpecialInputs ? this._Str_10876() : null), this._roomEvents);
            if (_local_2 != null)
            {
                this._roomEvents.windowManager.alert("Update failed", _local_2, 0, null);
                return;
            }
            if (Std.downcast(this._updated , TriggerDefinition) != null)
            {
                this._roomEvents.send(new UpdateTriggerMessageComposer(this._updated.id, this._Str_18203(), this._Str_18309(), this._Str_10656(), this._Str_18067()));
            }
            else
            {
                if (Std.downcast(this._updated , ActionDefinition) != null)
                {
                    this._roomEvents.send(new UpdateActionMessageComposer(this._updated.id, this._Str_18203(), this._Str_18309(), this._Str_10656(), this._Str_23819(), this._Str_18067()));
                }
                else
                {
                    if (Std.downcast(this._updated , ConditionDefinition) != null)
                    {
                        this._roomEvents.send(new UpdateConditionMessageComposer(this._updated.id, this._Str_18203(), this._Str_18309(), this._Str_10656(), this._Str_18067()));
                    }
                }
            }
        }

        public function _Str_23819():Int
        {
            var k= cast(this._Str_3959(), ActionType);
            return Std.int(k._Str_17249 ? Std.int(this._delaySlider.getValue() ): 0);
        }

        function _Str_22441(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._help.open(((this._window.x + this._window.width) + 5), this._window.y);
        }

        function _Str_23536(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            var _local_3= this._Str_3959();
            this._updated._Str_6040 = ((this._updated._Str_6040 < 1) ? (_local_3.requiresFurni - 1) : (this._updated._Str_6040 - 1));
            this._Str_17985();
        }

        function _Str_24649(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            var _local_3= this._Str_3959();
            this._updated._Str_6040 = ((this._updated._Str_6040 + 1) % _local_3.requiresFurni);
            this._Str_17985();
        }

        function _Str_23497(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._roomEvents.send(new ApplySnapshotMessageComposer(this._updated.id));
        }

        function _Str_18203():Array<ASAny>
        {
            var k= this._Str_3959();
            var _local_2:IWindowContainer = (k.hasSpecialInputs ? this._Str_10876() : null);
            return k.readIntegerParamsFromForm(_local_2);
        }

        function _Str_18309():String
        {
            var k= this._Str_3959();
            var _local_2:IWindowContainer = (k.hasSpecialInputs ? this._Str_10876() : null);
            return k.readStringParamFromForm(_local_2);
        }

        function _Str_18067():Int
        {
            if (!this._updated.stuffTypeSelectionEnabled)
            {
                return 0;
            }
            var k= this._Str_3959();
            if (((k.requiresFurni == _Str_4991) || (k.requiresFurni == _Str_5430)))
            {
                return this._updated._Str_6040;
            }
            return 0;
        }

        public function _Str_10656():Array<ASAny>
        {
var _local_2:String  = null;            var _local_2:String = null;
            var k= new Array<ASAny>();
            final _iter_ = this._stuffs; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_2 = _tmp_;
                k.push(ASCompat.toInt(_local_2));
            }
            return k;
        }

        function activeStuffIds():Array<ASAny>
        {
            return (this._dualFurniPickingMode && (this._activeFurniPicks == 2)) ? this.getStuffIds2() : this._Str_10656();
        }

        public function refresh()
        {
            this._configureContainer.visible = false;
            this._Str_18398(this._triggerConfs);
            this._Str_18398(this._actionTypes);
            this._Str_18398(this._conditionTypes);
            this._window.content.height = Util.getLowestPoint(this._window.content);
            this._window.visible = true;
        }

        function _Str_18398(k:IUserDefinedRoomEventsCtrl)
        {
            if (!k._Str_14545(this._updated))
            {
                this.find(this._configureContainer, (k._Str_1196() + "_icon_bitmap")).visible = false;
                return;
            }
            this._configureContainer.visible = true;
            var _local_2= this._Str_3959();
            this._Str_11540(_local_2, k._Str_1196());
            this._Str_25461();
            this._Str_24875();
            this.find(this._configureContainer, "warning_container").visible = false;
            this._Str_22859();
            this._Str_23045();
            this._Str_25418();
            Util._Str_14509(this._configureContainer, 3, 5);
            this._configureContainer.height = (Util.getLowestPoint(this._configureContainer) + 1);
        }

        function _Str_16874(k:Int):String
        {
            var _local_2= this._roomEvents.sessionDataManager.getFloorItemData(k);
            if (_local_2 == null)
            {
                Logger.log([("COULD NOT FIND FURNIDATA FOR " + Std.string(k))]);
                return "NAME: " + Std.string(k);
            }
            return _local_2.localizedName;
        }

        function _Str_23026(k:Int):String
        {
            var _local_2= this._roomEvents.sessionDataManager.getFloorItemData(k);
            if (_local_2 == null)
            {
                Logger.log([("COULD NOT FIND FURNIDATA FOR " + Std.string(k))]);
                return "NAME: " + Std.string(k);
            }
            return _local_2.description;
        }

        function setText(k:IWindowContainer, _arg_2:String, _arg_3:String)
        {
            var _local_4= cast(this.find(k, _arg_2), ITextWindow);
            _local_4.caption = _arg_3;
            _local_4.height = Std.int(_local_4.textHeight + 6);
        }

        function _Str_11540(k:WiredFurniture, _arg_2:String)
        {
            var _local_3= cast(this.find(this._configureContainer, "header_container"), IWindowContainer);
            this.find(_local_3, (_arg_2 + "_icon_bitmap")).visible = true;
            this.setText(_local_3, "conf_name_txt", this._Str_16874(this._updated.spriteId));
            this.setText(_local_3, "conf_desc_txt", this._Str_23026(this._updated.spriteId));
            var _local_4= this.find(_local_3, "conf_name_txt");
            var _local_5= this.find(_local_3, "conf_desc_txt");
            _local_5.y = (_local_4.y + _local_4.height);
            var _local_6= this._Str_3959();
            var _local_7= this.find(_local_3, "apply_snapshot_txt");
            if (_local_6.hasStateSnapshot)
            {
                _local_7.visible = true;
                _local_7.y = (_local_5.y + _local_5.height);
            }
            else
            {
                _local_7.visible = false;
            }
            _local_3.height = (Util.getLowestPoint(_local_3) + 4);
        }

        function _Str_25418()
        {
            var k= cast(this.find(this._configureContainer, "action_inputs_container"), IWindowContainer);
            if (Std.downcast(this._updated , ActionDefinition) == null)
            {
                k.visible = false;
                return;
            }
            var _local_2= cast(this._Str_3959(), ActionType);
            if (!_local_2._Str_17249)
            {
                k.visible = false;
                return;
            }
            k.visible = true;
        }

        function _Str_22859()
        {
            var _local_4 = 0;
            if (Std.downcast(this._updated , ActionDefinition) == null)
            {
                return;
            }
            var k= cast(this._updated, ActionDefinition);
            if (k.conflictingTriggers.length < 1)
            {
                return;
            }
            var _local_2= "";
            var _local_3= true;
            final _iter_ = k.conflictingTriggers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = ASCompat.toInt(_tmp_);
                _local_2 = (_local_2 + ((((_local_3 ? "" : ", ") + "'") + this._Str_16874(_local_4)) + "'"));
                _local_3 = false;
            }
            this._roomEvents.localization.registerParameter("wiredfurni.conflictingtriggers.text", "triggers", _local_2);
            this._Str_22112(this._roomEvents.localization.getLocalization("wiredfurni.conflictingtriggers.caption"), this._roomEvents.localization.getLocalization("wiredfurni.conflictingtriggers.text"));
        }

        function _Str_23045()
        {
            var _local_4 = 0;
            if (Std.downcast(this._updated , TriggerDefinition) == null)
            {
                return;
            }
            var k= cast(this._updated, TriggerDefinition);
            if (k.conflictingActions.length < 1)
            {
                return;
            }
            var _local_2= "";
            var _local_3= true;
            final _iter_ = k.conflictingActions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = ASCompat.toInt(_tmp_);
                _local_2 = (_local_2 + ((((_local_3 ? "" : ", ") + "'") + this._Str_16874(_local_4)) + "'"));
                _local_3 = false;
            }
            this._roomEvents.localization.registerParameter("wiredfurni.conflictingactions.text", "actions", _local_2);
            this._Str_22112(this._roomEvents.localization.getLocalization("wiredfurni.conflictingactions.caption"), this._roomEvents.localization.getLocalization("wiredfurni.conflictingactions.text"));
        }

        function _Str_22112(k:String, _arg_2:String)
        {
            var _local_3= cast(this.find(this._configureContainer, "warning_container"), IWindowContainer);
            this.setText(_local_3, "caption_txt", k);
            this.setText(_local_3, "desc_txt", _arg_2);
            var _local_4= this.find(_local_3, "caption_txt");
            this.find(_local_3, "desc_txt").y = (_local_4.y + _local_4.height);
            _local_3.height = (Util.getLowestPoint(_local_3) + 4);
            this.find(this._configureContainer, "warning_container").visible = true;
        }

        function _Str_25461()
        {
            var _local_2:IWindowContainer = null;
            var k= cast(this._configureContainer.findChildByName("custom_inputs_container"), IWindowContainer);
            Util.hideChildren(k);
            if (this._Str_3959().hasSpecialInputs)
            {
                _local_2 = this._Str_10876();
                _local_2.visible = true;
            }
            k.height = Util.getLowestPoint(k);
        }

        function _Str_10876():IWindowContainer
        {
            var k= this._Str_19071();
            var _local_2= this._Str_3959();
            var _local_3= cast(this._configureContainer.findChildByName("custom_inputs_container"), IWindowContainer);
            var _local_4= (k._Str_1196() + Std.string(_local_2.code));
            var _local_5= cast(_local_3.getChildByName(_local_4), IWindowContainer);
            if (_local_5 == null)
            {
                _local_5 = cast(this._roomEvents.getXmlWindow(((("ude_" + k._Str_1196()) + "_inputs_") + Std.string(_local_2.code))), IWindowContainer);
                _local_5.name = _local_4;
                _local_3.addChild(_local_5);
                _local_2.onInit(_local_5, this._roomEvents);
            }
            return _local_5;
        }

        function _Str_24875()
        {
            var k= cast(this._configureContainer.findChildByName("select_furni_container"), IWindowContainer);
            if (!this._Str_19885())
            {
                k.visible = false;
                return;
            }
            k.visible = true;
            var _local_2= k.findChildByName("furni_name_txt");
            var _local_3= this._Str_10656().length;
            var _local_4= this._updated.maximumItemSelectionCount;
            this._roomEvents.localization.registerParameter("wiredfurni.pickfurnis.caption", "count", ("" + Std.string(_local_3)));
            this._roomEvents.localization.registerParameter("wiredfurni.pickfurnis.caption", "limit", ("" + Std.string(_local_4)));
        }

        function _Str_21929():IWindow
        {
            return this._configureContainer.findChildByName("dec_stuff_sel_button");
        }

        function _Str_21281():IWindow
        {
            return this._configureContainer.findChildByName("inc_stuff_sel_button");
        }

        function _Str_17281():IWindow
        {
            return this._configureContainer.findChildByName("furni_type_matches_txt");
        }

        function isOwner(k:Int):Bool
        {
            var _local_2= this._roomEvents.roomEngine.getRoomObject(this._roomEvents.roomId, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            if (_local_2 == null)
            {
                return false;
            }
            var _local_3= _local_2.getModel();
            if (_local_3 == null)
            {
                return false;
            }
            var _local_4= _local_2.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_OWNER_ID);
            return _local_4 == this._roomEvents.sessionDataManager.userId;
        }
    }

