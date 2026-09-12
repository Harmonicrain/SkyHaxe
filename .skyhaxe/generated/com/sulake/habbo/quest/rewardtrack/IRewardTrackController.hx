package com.sulake.habbo.quest.rewardtrack
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;

     interface IRewardTrackController extends IDisposable
    {
        var enabled(get,never):Bool;
        function open(trackId:String):Void;
        function claimReward(trackId:String, rewardId:String):Void;
        function purchasePremium(trackId:String):Void;
        function openPremiumPurchaseConfirmation(track:RewardTrack):Void;
        function openTaskHintLink(link:String):Void;
    }

