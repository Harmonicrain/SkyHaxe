package com.sulake.habbo.friendbar.talent
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.talent.TalentLevelUpEvent;
    import com.sulake.habbo.session.talent.TalentEnum;
    import com.sulake.habbo.communication.messages.parser.talent.TalentTrackRewardPerk;
    import com.sulake.habbo.communication.messages.parser.talent.TalentTrackRewardProduct;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.talent.GetTalentTrackMessageComposer;
    import com.sulake.core.window.events.WindowEvent;

     class TalentLevelUpController implements IDisposable 
    {
        var _habboTalent:HabboTalent;
        var _disposed:Bool = false;
        var _window:IWindowContainer;
        var _track:String;
        var _rewardProductTemplate:IWindow;
        var _rewardVipTemplate:IWindow;
        var _rewardPerkTemplate:IWindow;

        public function new(k:HabboTalent)
        {
            this._habboTalent = k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._rewardPerkTemplate != null)
                {
                    this._rewardPerkTemplate.dispose();
                    this._rewardPerkTemplate = null;
                }
                if (this._rewardProductTemplate != null)
                {
                    this._rewardProductTemplate.dispose();
                    this._rewardProductTemplate = null;
                }
                if (this._rewardVipTemplate != null)
                {
                    this._rewardVipTemplate.dispose();
                    this._rewardVipTemplate = null;
                }
                this.closeWindow();
                this._habboTalent = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function initialize()
        {
            this._habboTalent.communicationManager.addHabboConnectionMessageEvent(new TalentLevelUpEvent(this._Str_16796));
        }

        function _Str_16796(k:TalentLevelUpEvent)
        {
            var _local_2= k.getParser();
            if ((((_local_2.level == 1) && (_local_2.talentTrackName == TalentEnum.HELPER)) && this._habboTalent._Str_9968))
            {
                return;
            }
            this.showWindow(_local_2.talentTrackName, _local_2.level, _local_2._Str_8893, _local_2._Str_7068);
        }

        public function showWindow(k:String, _arg_2:Int, _arg_3:Vector<TalentTrackRewardPerk>, _arg_4:Vector<TalentTrackRewardProduct>)
        {
            var _local_8:TalentTrackRewardPerk = null;
            var _local_9:TalentTrackRewardProduct = null;
            this.closeWindow();
            this._track = k;
            this._window = Std.downcast(this._habboTalent.getXmlWindow("level_up") , IWindowContainer);
            this._window.center();
            this._window.procedure = this.onWindowEvent;
            cast(this._window.findChildByName("level_decoration"), IStaticBitmapWrapperWindow).assetUri = (((("${image.library.url}talent/" + k) + "_levelup_") + Std.string(_arg_2)) + ".png");
            this._window.findChildByName("level_up_message").caption = (("${talent.track." + k) + ".levelup.message}");
            this._window.findChildByName("level_title").caption = (((("${talent.track." + k) + ".level.") + Std.string(_arg_2)) + ".title}");
            this._window.findChildByName("level_description").caption = (((("${talent.track." + k) + ".level.") + Std.string(_arg_2)) + ".description}");
            var _local_5= cast(this._window.findChildByName("reward_list"), IItemListWindow);
            var _local_6= _local_5.removeListItem(_local_5.getListItemByName("plus_template"));
            this._rewardProductTemplate = _local_5.removeListItem(_local_5.getListItemByName("reward_product_template"));
            this._rewardVipTemplate = _local_5.removeListItem(_local_5.getListItemByName("reward_vip_template"));
            this._rewardPerkTemplate = _local_5.removeListItem(_local_5.getListItemByName("reward_perk_template"));
            var _local_7 = false;
            if (checkNullIteratee(_arg_3)) for (_tmp_ in _arg_3)
            {
_local_8  = _tmp_;
                if (_local_7)
                {
                    _local_5.addListItem(_local_6.clone());
                }
                _local_5.addListItem(this.createRewardPerk(_local_8));
                _local_7 = true;
            }
            if (checkNullIteratee(_arg_4)) for (_tmp_ in _arg_4)
            {
_local_9  = _tmp_;
                if (_local_7)
                {
                    _local_5.addListItem(_local_6.clone());
                }
                _local_5.addListItem(this.createRewardProduct(_local_9));
                _local_7 = true;
            }
            if (_local_5.numListItems < 1)
            {
                this._window.findChildByName("level_rewards").visible = false;
                cast(this._window.findChildByName("level_up_layout"), IItemListWindow).arrangeListItems();
            }
        }

        function createRewardPerk(k:TalentTrackRewardPerk):IWindow
        {
            var _local_2= Std.downcast(this._rewardPerkTemplate.clone() , IWindowContainer);
            cast(cast(_local_2.findChildByName("perk_image"), IWidgetWindow).widget, IBadgeImageWidget).badgeId = k._Str_10964;
            _local_2.findChildByName("perk_name").caption = (("${perk." + k._Str_10964) + ".name}");
            return _local_2;
        }

        function createRewardProduct(k:TalentTrackRewardProduct):IWindow
        {
            var _local_2:IWindow = null;
            if (k._Str_13965 == 0)
            {
                _local_2 = this._rewardProductTemplate.clone();
                cast(_local_2, IStaticBitmapWrapperWindow).assetUri = (("${image.library.url}talent/reward_product_" + ASCompat.stringReplace(k.productCode.toLowerCase(), " ", "_")) + ".png");
            }
            else
            {
                _local_2 = this._rewardVipTemplate.clone();
                cast(_local_2, IWindowContainer).findChildByName("vip_length").caption = this._habboTalent.localizationManager.getLocalizationWithParams("catalog.vip.item.header.days", "", ["num_days", k._Str_13965]);
            }
            return _local_2;
        }

        function closeWindow()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function onWindowEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this._window == null) || this._window.disposed) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close"
                   | "close_button":
                    this.closeWindow();
                    return;
                case "talent_button":
                    this.closeWindow();
                    this._habboTalent.tracking.trackTalentTrackOpen(this._track, "levelup");
                    this._habboTalent.send(new GetTalentTrackMessageComposer(this._track));
                    return;
            }
        }
    }

