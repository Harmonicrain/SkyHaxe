package com.hurlant.crypto.tls
;
     class TLSError extends ASError 
    {
        public static inline final close_notify:UInt = 0;
        public static inline final unexpected_message:UInt = 10;
        public static inline final bad_record_mac:UInt = 20;
        public static inline final decryption_failed:UInt = 21;
        public static inline final record_overflow:UInt = 22;
        public static inline final decompression_failure:UInt = 30;
        public static inline final handshake_failure:UInt = 40;
        public static inline final bad_certificate:UInt = 42;
        public static inline final unsupported_certificate:UInt = 43;
        public static inline final certificate_revoked:UInt = 44;
        public static inline final certificate_expired:UInt = 45;
        public static inline final certificate_unknown:UInt = 46;
        public static inline final illegal_parameter:UInt = 47;
        public static inline final unknown_ca:UInt = 48;
        public static inline final access_denied:UInt = 49;
        public static inline final decode_error:UInt = 50;
        public static inline final decrypt_error:UInt = 51;
        public static inline final protocol_version:UInt = 70;
        public static inline final insufficient_security:UInt = 71;
        public static inline final internal_error:UInt = 80;
        public static inline final user_canceled:UInt = 90;
        public static inline final no_renegotiation:UInt = 100;

        public function new(k:String, _arg_2:Int)
        {
            super(k, _arg_2);
        }
	}

