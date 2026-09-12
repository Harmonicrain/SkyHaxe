package com.sulake.habbo.quest.rewardtrack.view.premium
;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.habbo.quest.rewardtrack.RewardTrackController;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

     class RewardTrackPremiumPurchaseConfirmationView implements IDisposable
    {
        static inline final RETRY_ENABLE_DELAY_MS= 500;

        var _controller:RewardTrackController;
        var _track:RewardTrack;
        var _window:IFrameWindow;
        var _retryTimer:Timer;
        var _pending:Bool = false;
        var _disposed:Bool = false;

        public function new(controller:RewardTrackController, track:RewardTrack)
        {
            this._controller = controller;
            this._track = track;
            this.createWindow();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function show()
        {
            if (this._window == null || this._disposed)
            {
                return;
            }
            this._window.visible = true;
            this._window.center();
            this._window.activate();
        }

        public function purchaseFailed()
        {
            if (this._retryTimer != null)
            {
                this._retryTimer.stop();
                this._retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onRetryTimerComplete : ASAny));
            }
            this._retryTimer = new Timer(RETRY_ENABLE_DELAY_MS, 1);
            this._retryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onRetryTimerComplete : ASAny));
            this._retryTimer.start();
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._retryTimer != null)
            {
                this._retryTimer.stop();
                this._retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onRetryTimerComplete : ASAny));
                this._retryTimer = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._controller = null;
            this._track = null;
        }

        function createWindow()
        {
            var assets:IAssetLibrary = this._controller != null ? this._controller.assets : null;
            var asset:IAsset = assets != null ? assets.getAssetByName("reward_track_premium_purchase_confirmation_xml") : null;
            if (asset == null || this._controller.windowManager == null)
            {
                return;
            }
            this._window = Std.downcast(this._controller.windowManager.buildFromXML((asset.content : com.sulake.core.utils.xml.XML) , 1) , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            this._window.procedure = this.onWindowEvent;
            this.initializeUI();
        }

        function initializeUI()
        {
            var benefitText:ITextWindow = null;
            if (this._track == null || this._window == null)
            {
                return;
            }

            benefitText = this.findText("benefit_boost_txt");
            if (benefitText != null)
            {
                benefitText.caption = this.textWithParam("reward_track.premium.confirm.benefit.boost", "%percent%% faster progression", "percent", Math.fround((this._track.taskPointsBoost - 1) * 100));
            }
            benefitText = this.findText("benefit_instant_points_txt");
            if (benefitText != null)
            {
                benefitText.caption = this.textWithParam("reward_track.premium.confirm.benefit.instant_points", "%points% instant points", "points", this._track.instantPoints);
            }

            this.setVisible("benefit_boost_row", this._track.taskPointsBoost > 1);
            this.setVisible("benefit_rewards_row", this._track.hasPremiumPrizes);
            this.setVisible("benefit_instant_points_row", this._track.instantPoints > 0);
            this.setVisible("benefit_tasks_row", this._track.hasPremiumTasks);
            this.setVisible("benefit_levels_row", this._track.hasPremiumLevels);

            this.setText("price_credits", Std.string(this._track.costCredits));
            this.setText("price_diamonds", Std.string(this._track.costPoints));
            this.setVisible("price_credits", this._track.costCredits > 0);
            this.setVisible("credits_icon", this._track.costCredits > 0);
            this.setVisible("price_diamonds", this._track.costPoints > 0);
            this.setVisible("diamonds_icon", this._track.costPoints > 0);
            this.setPointsIconStyle();
            this.setVisible("plus_txt", this._track.costCredits > 0 && this._track.costPoints > 0);

            this.arrangeBenefits();
        }

        function onWindowEvent(event:WindowEvent, window:IWindow)
        {
            if (event.type != WindowMouseEvent.CLICK || window == null)
            {
                return;
            }
            if (window.name == "confirm_button")
            {
                this.onConfirmClicked();
                return;
            }
            if (window.name == "cancel_button" || window.name == "header_button_close")
            {
                this.onWindowClose();
            }
        }

        function onConfirmClicked()
        {
            if (this._pending || this._controller == null || this._track == null)
            {
                return;
            }
            this.setPending(true);
            this._controller.purchasePremium(this._track.id);
        }

        function onWindowClose()
        {
            if (this._pending || this._controller == null)
            {
                return;
            }
            this._controller.closePremiumPurchaseConfirmation();
        }

        function onRetryTimerComplete(event:TimerEvent)
        {
            if (this._retryTimer != null)
            {
                this._retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onRetryTimerComplete : ASAny));
                this._retryTimer = null;
            }
            this.setPending(false);
        }

        function setPending(value:Bool)
        {
            this._pending = value;
            this.setEnabled("confirm_button", !value);
            this.setEnabled("cancel_button", !value);
            this.setEnabled("header_button_close", !value);
        }

        function arrangeBenefits()
        {
            var list:IItemListWindow = this._window != null ? Std.downcast(this._window.findChildByName("benefits") , IItemListWindow) : null;
            if (list != null)
            {
                list.arrangeListItems();
            }
        }

        function setPointsIconStyle()
        {
            var icon:IIconWindow = this._window != null ? Std.downcast(this._window.findChildByName("diamonds_icon") , IIconWindow) : null;
            if (icon != null && this._controller != null && this._controller.configuration != null)
            {
                icon.style = ActivityPointTypeEnum.getIconStyleFor(this._track.costPointsType, this._controller.configuration, true);
            }
        }

        function setText(name:String, value:String)
        {
            var text= this.findText(name);
            if (text != null)
            {
                text.caption = value != null ? value : "";
            }
        }

        function findText(name:String):ITextWindow
        {
            return this._window != null ? Std.downcast(this._window.findChildByName(name) , ITextWindow) : null;
        }

        function setVisible(name:String, visible:Bool)
        {
            var window:IWindow = this._window != null ? this._window.findChildByName(name) : null;
            if (window != null)
            {
                window.visible = visible;
            }
        }

        function setEnabled(name:String, enabled:Bool)
        {
            var window:IWindow = this._window != null ? this._window.findChildByName(name) : null;
            if (window == null)
            {
                return;
            }
            if (enabled)
            {
                window.enable();
            }
            else
            {
                window.disable();
            }
        }

        var localization(get,never):IHabboLocalizationManager;
function  get_localization():IHabboLocalizationManager
        {
            return this._controller != null ? this._controller.localization : null;
        }

        function textWithParam(key:String, fallback:String, parameter:String, value:ASObject):String
        {
            return this.localization != null ? this.localization.getLocalizationWithParams(key, fallback, [parameter, value]) : fallback.split("%" + parameter + "%").join(ASCompat.toString(value));
        }
    }

