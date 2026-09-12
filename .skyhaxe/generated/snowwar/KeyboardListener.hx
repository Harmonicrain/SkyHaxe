package snowwar
;
	import com.sulake.core.runtime.IDisposable;
	import flash.display.Stage;
    import snowwar._str_254.Direction8;
    import flash.events.KeyboardEvent;

     class KeyboardListener implements IDisposable
	{
        static inline final NUMBER_0:UInt = 48;
        static inline final NUMBER_1:UInt = 49;
        static inline final NUMBER_2:UInt = 50;
        static inline final NUMBER_3:UInt = 51;
        static inline final NUMBER_4:UInt = 52;
        static inline final NUMBER_5:UInt = 53;
        static inline final NUMBER_6:UInt = 54;
        static inline final NUMBER_7:UInt = 55;
        static inline final NUMBER_8:UInt = 56;
        static inline final NUMBER_9:UInt = 57;
        static inline final A:UInt = 65;
        static inline final B:UInt = 66;
        static inline final C:UInt = 67;
        static inline final D:UInt = 68;
        static inline final E:UInt = 69;
        static inline final F:UInt = 70;
        static inline final G:UInt = 71;
        static inline final H:UInt = 72;
        static inline final I:UInt = 73;
        static inline final J:UInt = 74;
        static inline final K:UInt = 75;
        static inline final L:UInt = 76;
        static inline final M:UInt = 77;
        static inline final N:UInt = 78;
        static inline final O:UInt = 79;
        static inline final P:UInt = 80;
        static inline final Q:UInt = 81;
        static inline final R:UInt = 82;
        static inline final S:UInt = 83;
        static inline final T:UInt = 84;
        static inline final U:UInt = 85;
        static inline final V:UInt = 86;
        static inline final W:UInt = 87;
        static inline final X:UInt = 88;
        static inline final Y:UInt = 89;
        static inline final Z:UInt = 90;
        static inline final SEMI_COLON:UInt = 186;
        static inline final EQUAL_SIGN:UInt = 187;
        static inline final COMMA:UInt = 188;
        static inline final DASH:UInt = 189;
        static inline final PERIOD:UInt = 190;
        static inline final FORWARD_SLASH:UInt = 191;
        static inline final GRAVE_ACCENT:UInt = 192;
        static inline final LEFT_BRACKET:UInt = 219;
        static inline final BACKSLASH:UInt = 220;
        static inline final CLOSE_BRACKET:UInt = 221;
        static inline final SINGLE_QUOTE:UInt = 222;
        static inline final ALT:UInt = 18;
        static inline final BACKSPACE:UInt = 8;
        static inline final CAPS_LOCK:UInt = 20;
        static inline final _SafeStr_22147:UInt = 15;
        static inline final CTRL:UInt = 17;
        static inline final DELETE:UInt = 46;
        static inline final DOWN:UInt = 40;
        static inline final END:UInt = 35;
        static inline final ENTER:UInt = 13;
        static inline final ESCAPE:UInt = 27;
        static inline final F1:UInt = 112;
        static inline final F2:UInt = 113;
        static inline final F3:UInt = 114;
        static inline final F4:UInt = 115;
        static inline final F5:UInt = 116;
        static inline final F6:UInt = 117;
        static inline final F7:UInt = 118;
        static inline final F8:UInt = 119;
        static inline final F9:UInt = 120;
        static inline final F10:UInt = 121;
        static inline final F11:UInt = 122;
        static inline final F12:UInt = 123;
        static inline final F13:UInt = 124;
        static inline final F14:UInt = 125;
        static inline final F15:UInt = 126;
        static inline final HOME:UInt = 36;
        static inline final INSERT:UInt = 45;
        static inline final LEFT:UInt = 37;
        static inline final _SafeStr_22152:UInt = 21;
        static inline final NUMPAD_0:UInt = 96;
        static inline final NUMPAD_1:UInt = 97;
        static inline final NUMPAD_2:UInt = 98;
        static inline final NUMPAD_3:UInt = 99;
        static inline final NUMPAD_4:UInt = 100;
        static inline final NUMPAD_5:UInt = 101;
        static inline final NUMPAD_6:UInt = 102;
        static inline final NUMPAD_7:UInt = 103;
        static inline final NUMPAD_8:UInt = 104;
        static inline final NUMPAD_9:UInt = 105;
        static inline final ADD:UInt = 107;
        static inline final DECIMAL_POINT:UInt = 110;
        static inline final DIVIDE:UInt = 111;
        static inline final _SafeStr_22156:UInt = 108;
        static inline final MULTIPLY:UInt = 106;
        static inline final SUBTRACT:UInt = 109;
        static inline final PAGE_DOWN:UInt = 34;
        static inline final PAGE_UP:UInt = 33;
        static inline final RIGHT:UInt = 39;
        static inline final SHIFT:UInt = 16;
        static inline final SPACE:UInt = 32;
        static inline final TAB:UInt = 9;
        static inline final UP:UInt = 38;

        var _stage:Stage;
        var _charCodes:Array<ASAny>;
        var _SafeStr_9514:Direction8;

        public function new(k:Stage)
        {
            this._charCodes = [];
            this._stage = k;
            k.addEventListener(KeyboardEvent.KEY_DOWN, (this.onKeyPressedEvent : ASAny));
            k.addEventListener(KeyboardEvent.KEY_UP, (this.onKeyPressedEvent : ASAny));
        }

        public function dispose()
        {
            this._stage.removeEventListener(KeyboardEvent.KEY_DOWN, (this.onKeyPressedEvent : ASAny));
            this._stage.removeEventListener(KeyboardEvent.KEY_UP, (this.onKeyPressedEvent : ASAny));
            this._stage = null;
            this._SafeStr_9514 = null;
            this._charCodes = [];
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }

        function onKeyPressedEvent(k:KeyboardEvent)
        {
            var _local_2= this._charCodes.indexOf(k.keyCode);
            switch (k.type)
            {
                case KeyboardEvent.KEY_DOWN:
                    if (_local_2 == -1)
                    {
                        this._charCodes.push(k.keyCode);
                    }
                    
                case KeyboardEvent.KEY_UP:
                    if (_local_2 > -1)
                    {
                        this._charCodes.splice(_local_2, 1);
                    }
                    
            }
            this._SafeStr_9514 = null;
            if (this._charCodes.length == 0)
            {
                return;
            }
            if (this._charCodes.length >= 2)
            {
                if ((this._SafeStr_22163(ASCompat.toInt(UP)) && this._SafeStr_22163(ASCompat.toInt(LEFT))))
                {
                    this._SafeStr_9514 = Direction8.W;
                }
                else
                {
                    if ((this._SafeStr_22163(ASCompat.toInt(UP)) && this._SafeStr_22163(ASCompat.toInt(RIGHT))))
                    {
                        this._SafeStr_9514 = Direction8.N;
                    }
                    else
                    {
                        if ((this._SafeStr_22163(ASCompat.toInt(DOWN)) && this._SafeStr_22163(ASCompat.toInt(LEFT))))
                        {
                            this._SafeStr_9514 = Direction8.S;
                        }
                        else
                        {
                            if ((this._SafeStr_22163(ASCompat.toInt(DOWN)) && this._SafeStr_22163(ASCompat.toInt(RIGHT))))
                            {
                                this._SafeStr_9514 = Direction8.E;
                            }
                        }
                    }
                }
            }
            else
            {
                if (this._SafeStr_22163(ASCompat.toInt(UP)))
                {
                    this._SafeStr_9514 = Direction8.NW;
                }
                else
                {
                    if (this._SafeStr_22163(ASCompat.toInt(DOWN)))
                    {
                        this._SafeStr_9514 = Direction8.SE;
                    }
                    else
                    {
                        if (this._SafeStr_22163(ASCompat.toInt(LEFT)))
                        {
                            this._SafeStr_9514 = Direction8.SW;
                        }
                        else
                        {
                            if (this._SafeStr_22163(ASCompat.toInt(RIGHT)))
                            {
                                this._SafeStr_9514 = Direction8.NE;
                            }
                            else
                            {
                                if (this._SafeStr_22163(ASCompat.toInt(Q)))
                                {
                                    this._SafeStr_9514 = Direction8.W;
                                }
                                else
                                {
                                    if (this._SafeStr_22163(ASCompat.toInt(W)))
                                    {
                                        this._SafeStr_9514 = Direction8.NW;
                                    }
                                    else
                                    {
                                        if (this._SafeStr_22163(ASCompat.toInt(E)))
                                        {
                                            this._SafeStr_9514 = Direction8.N;
                                        }
                                        else
                                        {
                                            if (this._SafeStr_22163(ASCompat.toInt(A)))
                                            {
                                                this._SafeStr_9514 = Direction8.SW;
                                            }
                                            else
                                            {
                                                if (this._SafeStr_22163(ASCompat.toInt(D)))
                                                {
                                                    this._SafeStr_9514 = Direction8.NE;
                                                }
                                                else
                                                {
                                                    if (this._SafeStr_22163(ASCompat.toInt(Z)))
                                                    {
                                                        this._SafeStr_9514 = Direction8.S;
                                                    }
                                                    else
                                                    {
                                                        if (this._SafeStr_22163(ASCompat.toInt(X)))
                                                        {
                                                            this._SafeStr_9514 = Direction8.SE;
                                                        }
                                                        else
                                                        {
                                                            if (this._SafeStr_22163(ASCompat.toInt(C)))
                                                            {
                                                                this._SafeStr_9514 = Direction8.E;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        function _SafeStr_22163(k:Int):Bool
        {
            return this._charCodes.indexOf(k) > -1;
        }

        public var direction(get,never):Direction8;
public function  get_direction():Direction8
        {
            return this._SafeStr_9514;
        }
    }

