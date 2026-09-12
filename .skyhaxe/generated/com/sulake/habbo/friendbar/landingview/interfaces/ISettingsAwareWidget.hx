package com.sulake.habbo.friendbar.landingview.interfaces
;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;

     interface ISettingsAwareWidget 
    {
        var settings(never,set):CommonWidgetSettings;
    }

