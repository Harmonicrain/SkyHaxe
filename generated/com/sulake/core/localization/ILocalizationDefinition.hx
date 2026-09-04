package com.sulake.core.localization
;
     interface ILocalizationDefinition 
    {
        var id(get,never):String;
        var languageCode(get,never):String;
        var countryCode(get,never):String;
        var encoding(get,never):String;
        var name(get,never):String;
        var url(get,never):String;
    }

