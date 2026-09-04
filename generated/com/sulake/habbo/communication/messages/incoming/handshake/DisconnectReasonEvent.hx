package com.sulake.habbo.communication.messages.incoming.handshake
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.handshake.DisconnectReasonParser;

     class DisconnectReasonEvent extends MessageEvent implements IMessageEvent 
    {
        public static inline final LOGOUT= 0;
        public static inline final JUST_BANNED= 1;
        public static inline final CONCURRENT_LOGIN= 2;
        public static inline final CONNECTION_LOST_TO_PEER= 3;
        public static inline final AVATAR_IDENTITY_CHANGE= 4;
        public static inline final REMOVE_FURNITURE_TOOL= 5;
        public static inline final STILL_BANNED= 10;
        public static inline final DUAL_LOGIN_BY_USERID= 11;
        public static inline final HOTEL_CLOSED= 12;
        public static inline final DUAL_LOGIN_BY_IP= 13;
        public static inline final PEER_CONNECTION_MISSING= 16;
        public static inline final NO_LOGIN_PERMISSION= 17;
        public static inline final DUPLICATE_CONNECTION= 18;
        public static inline final HOTEL_CLOSING= 19;
        public static inline final INCORRECT_PASSWORD= 20;
        public static inline final INVALID_LOGIN_TICKET= 22;
        public static inline final VERSION_CHECK_URL= 23;
        public static inline final VERSION_CHECK_PROPERTY= 24;
        public static inline final VERSION_CHECK_MACHINE_ID= 25;
        public static inline final NO_MESSENGER_SESSION= 26;
        public static inline final USER_NOT_FOUND= 27;
        public static inline final CRYPTO_NOT_INITIALIZED= 28;
        public static inline final DEV_CRYPTO_NOT_ALLOWED= 29;
        public static inline final DUPLICATE_UUID_DETECTED= 100;
        public static inline final OLD_SESSION_IN_PROXY= 101;
        public static inline final PUBLIC_KEY_NOT_NUMERIC= 102;
        public static inline final PUBLIC_KEY_TOO_SHORT= 103;
        public static inline final SOCKET_READ_GENERIC= 104;
        public static inline final SOCKET_READ_FIRST_BYTE= 105;
        public static inline final SOCKET_READ_LENGTH= 106;
        public static inline final SOCKET_READ_BODY= 107;
        public static inline final SOCKET_READ_POLICY= 108;
        public static inline final SOCKET_IO_EXCEPTION= 109;
        public static inline final SOCKET_WRONG_CRYPTO= 110;
        public static inline final PROXY_RUNTIME_EXCEPTION= 111;
        public static inline final IDLE_CONNECTION= 112;
        public static inline final PONG_TIMEOUT= 113;
        public static inline final IDLE_CONNECTION_NOT_AUTH= 114;
        public static inline final IDLE_CONNECTION_NO_USER_ID= 115;
        public static inline final WRITE_CLOSED_CHANNEL= 116;
        public static inline final SOCKET_WRITE_EXCEPTION_1= 117;
        public static inline final SOCKET_WRITE_EXCEPTION_2= 118;
        public static inline final SOCKET_WRITE_EXCEPTION_3= 119;

        public function new(k:ASFunction)
        {
            super(k, DisconnectReasonParser);
        }

        public var reason(get,never):Int;
function  get_reason():Int
        {
            return Std.downcast(this._parser , DisconnectReasonParser).reason;
        }

        public var reasonString(get,never):String;
function  get_reasonString():String
        {
            switch (this.reason)
            {
                case JUST_BANNED
                   | STILL_BANNED:
                    return "banned";
                case CONCURRENT_LOGIN:
                    return "concurrentlogin";
                case INCORRECT_PASSWORD:
                    return "incorrectpassword";
                default:
                    return "logout";
            }
        }
    }

