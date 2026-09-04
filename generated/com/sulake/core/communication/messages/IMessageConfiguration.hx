package com.sulake.core.communication.messages
;
    import com.sulake.core.utils.Map;

     interface IMessageConfiguration 
    {
        var events(get,never):Map;
        var composers(get,never):Map;
    }

