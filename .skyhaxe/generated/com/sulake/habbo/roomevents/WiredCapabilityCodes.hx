package com.sulake.habbo.roomevents
;
     class WiredCapabilityCodes
    {
        public static inline final PROTOCOL_REVISION= 1;

        public static final PROTOCOL:Int = 1 << 0;
        public static final ADDONS:Int = 1 << 1;
        public static final VARIABLES:Int = 1 << 2;
        public static final VARIABLE_SYNC:Int = 1 << 3;
        public static final SIGNALS:Int = 1 << 4;
        public static final REMOTE_SELECTOR:Int = 1 << 5;
        public static final WIRED_MENU:Int = 1 << 6;
        public static final MENU_INSPECTION:Int = 1 << 7;
        public static final MENU_LOGS:Int = 1 << 8;
        public static final MENU_SETTINGS:Int = 1 << 9;
        public static final MENU_VARIABLES:Int = 1 << 10;
        public static final MENU_CHESTS:Int = 1 << 11;
        public static final ENVIRONMENT_V2:Int = 1 << 12;
        public static final CLICK_SETTINGS_V2:Int = 1 << 13;
        public static final WIRED_MOVEMENTS:Int = 1 << 14;
        public static final CREATOR_TOOLS:Int = 1 << 15;
        public static final CHESTS:Int = 1 << 16;
        public static final CHEST_WIRED:Int = 1 << 17;
        /** Wired trading contracts require their own server context and item-type catalog. */
        public static final CONTRACTS:Int = 1 << 18;

        public static final ALL:Int = (1 << 19) - 1;

        /*
         * Bits the AIR client can actually render, configure and save today.
         *
         * This is deliberately not a localhost override: WiredCapabilities
         * still intersects this mask with the server response and the current
         * room mask before exposing an editor.  It is only the client's honest
         * side of capability negotiation, so a legacy/no-response server keeps
         * every Wired 2.0 editor unavailable without affecting legacy Wired.
         *
         * Creator tools remain out because July AIR does not expose that
         * subsystem. Chests, chest Wired, contracts and the chest menu are
         * compiled together so their dependency chain cannot be partially
         * advertised.
         */
        public static final COMPILED_MASK:Int = PROTOCOL
            | ADDONS
            | VARIABLES
            | VARIABLE_SYNC
            | SIGNALS
            | REMOTE_SELECTOR
            | WIRED_MENU
            | MENU_INSPECTION
            | MENU_LOGS
            | MENU_SETTINGS
            | MENU_VARIABLES
            | MENU_CHESTS
            | ENVIRONMENT_V2
            | CLICK_SETTINGS_V2
            | WIRED_MOVEMENTS
            | CHESTS
            | CHEST_WIRED
            | CONTRACTS;

        public static inline final PROTOCOL_ENABLED= "wired2.protocol.enabled";
        public static inline final ADDONS_ENABLED= "wired2.addons.enabled";
        public static inline final VARIABLES_ENABLED= "wired2.variables.enabled";
        public static inline final VARIABLE_SYNC_ENABLED= "wired2.variable_sync.enabled";
        public static inline final SIGNALS_ENABLED= "wired2.signals.enabled";
        public static inline final REMOTE_SELECTOR_ENABLED= "wired2.remote_selector.enabled";
        public static inline final WIRED_MENU_ENABLED= "wired2.menu.enabled";
        public static inline final MENU_INSPECTION_ENABLED= "wired2.menu.inspection.enabled";
        public static inline final MENU_LOGS_ENABLED= "wired2.menu.logs.enabled";
        public static inline final MENU_SETTINGS_ENABLED= "wired2.menu.settings.enabled";
        public static inline final MENU_VARIABLES_ENABLED= "wired2.menu.variables.enabled";
        public static inline final MENU_CHESTS_ENABLED= "wired2.menu.chests.enabled";
        public static inline final ENVIRONMENT_V2_ENABLED= "wired2.environment.enabled";
        public static inline final CLICK_SETTINGS_V2_ENABLED= "wired2.click_settings.enabled";
        public static inline final WIRED_MOVEMENTS_ENABLED= "wired2.movements.enabled";
        public static inline final CREATOR_TOOLS_ENABLED= "wired2.creator_tools.enabled";
        public static inline final CHESTS_ENABLED= "wired2.chests.enabled";
        public static inline final CHEST_WIRED_ENABLED= "wired2.chest_wired.enabled";
        public static inline final CONTRACTS_ENABLED= "wired2.contracts.enabled";

	public function new() {}
    }

