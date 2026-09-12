package com.sulake.habbo.ui.widget.furniture.gamehall
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormatAlign;

     class GamehallGameViewBase implements GamehallGameView
    {
        static inline final SCREEN_WIDTH= 270;
        static inline final SCREEN_HEIGHT= 264;
        static inline final BOARD_COLUMNS= 13;
        static inline final BOARD_ROWS= 12;
        static inline final CELL_SIZE= 19;
        static inline final BOARD_OFFSET_X= 4;
        static inline final BOARD_HIT_X= 11;
        static inline final BOARD_HIT_Y= 5;
        static inline final BOARD_HIT_WIDTH= 248;
        static inline final BOARD_HIT_HEIGHT= 229;

        var _sendMove:ASFunction;
        var _invalidate:ASFunction;
        var _panel:Sprite;
        var _assets:GamehallAssetLibrary;
        var _localSeat:Int = 0;
        var _seatCount:Int = 0;
        var _status:String = "";
        var _mode:String = "start";

        public function new(sendMove:ASFunction, invalidate:ASFunction)
        {
            this._sendMove = sendMove;
            this._invalidate = invalidate;
        }

        public function reset(localSeat:Int, seatCount:Int)
        {
            this._localSeat = localSeat;
            this._seatCount = seatCount;
            this._status = "";
            this._mode = "start";
        }

        public function applyUpdate(verb:String="", args:Array<ASAny>=null, reason:String="")
        {
            if (reason != "")
            {
                this._status = reason;
            }
            else if (verb != "")
            {
                this._status = verb;
                if (args != null && args.length > 0)
                {
                    this._status += " " + args.join(" ");
                }
            }
        }

        public function render(panel:Sprite, assets:GamehallAssetLibrary)
        {
            this._panel = panel;
            this._assets = assets;
            if (this._mode == "board")
            {
                this.drawBoard();
            }
            else
            {
                this.drawStart();
            }
            this.drawPanelText();
        }

        public function handleWindowEvent(event:WindowEvent, window:IWindow)
        {
        }

        public function dispose()
        {
            this._panel = null;
            this._assets = null;
            this._sendMove = null;
            this._invalidate = null;
        }

        function drawStart()
        {
            this.drawClassicGameScreen();
        }

        function drawBoard()
        {
            this.drawClassicGameScreen();
        }

        function drawPanelText()
        {
            if (this._mode != "board")
            {
                return;
            }
            this._panel.addChild(this.createPanelText(this._status, 10, 250, 135, 14, 9, 0x00CC00, TextFormatAlign.LEFT, false));
            this._panel.addChild(this.createPanelText(GamehallUpdates.TURN, 150, 250, 100, 14, 9, 0x00CC00, TextFormatAlign.RIGHT, true, true));
        }

        function sendMove(verb:String, args:Array<ASAny>)
        {
            if (this._sendMove != null)
            {
                this._sendMove(verb, args);
            }
        }

        function invalidate()
        {
            if (this._invalidate != null)
            {
                this._invalidate();
            }
        }

        function pointInRect(px:Float, py:Float, x:Int, y:Int, width:Int, height:Int):Bool
        {
            return px >= x && px < x + width && py >= y && py < y + height;
        }

        function turnStatus():String
        {
            return this._status;
        }

        function drawClassicGameScreen()
        {
            var top= this.assetDisplay("hh_games_game_screen_bup");
            var mid= this.assetDisplay("hh_games_game_screen_midg");
            var bottom= this.assetDisplay("hh_games_game_screen_downer");
            if (top != null && mid != null && bottom != null)
            {
                top.x = 0;
                this._panel.addChild(top);
                mid.x = 0;
                mid.y = 10;
                mid.height = SCREEN_HEIGHT - Std.int(top.height) - Std.int(bottom.height);
                this._panel.addChild(mid);
                bottom.x = 0;
                bottom.y = SCREEN_HEIGHT - Std.int(bottom.height);
                this._panel.addChild(bottom);
                return;
            }
            this.drawGameScreenFallback();
        }

        function drawGameScreenFallback()
        {
            var g:ASAny = this._panel.graphics;
            g.beginFill(0x000000);
            g.drawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            g.endFill();
            g.lineStyle(1, 0x66CC00);
            g.drawRect(1, 1, SCREEN_WIDTH - 2, SCREEN_HEIGHT - 2);
        }

        function drawBoardFallback()
        {
var column = 0, row = 0;            this.drawGameScreenFallback();
            var g:ASAny = this._panel.graphics;
            g.lineStyle(1, 0x66CC00, 1);
            for (_tmp_ in 0...BOARD_COLUMNS + 1)
            {
column= _tmp_;
                g.moveTo(BOARD_HIT_X + column * CELL_SIZE, BOARD_HIT_Y);
                g.lineTo(BOARD_HIT_X + column * CELL_SIZE, BOARD_HIT_Y + BOARD_ROWS * CELL_SIZE);
            }
            for (_tmp_ in 0...BOARD_ROWS + 1)
            {
row= _tmp_;
                g.moveTo(BOARD_HIT_X, BOARD_HIT_Y + row * CELL_SIZE);
                g.lineTo(BOARD_HIT_X + BOARD_COLUMNS * CELL_SIZE, BOARD_HIT_Y + row * CELL_SIZE);
            }
        }

        function addAsset(name:String, x:Int, y:Int)
        {
            var display= this.assetDisplay(name);
            if (display == null)
            {
                return;
            }
            display.x = x;
            display.y = y;
            this._panel.addChild(display);
        }

        function assetDisplay(name:String):DisplayObject
        {
            return this._assets == null ? null : this._assets.assetDisplay(name);
        }

        function hasReadyAsset(name:String):Bool
        {
            return this._assets != null && this._assets.hasAsset(name);
        }

        function createPanelText(caption:String, x:Int, y:Int, width:Int, height:Int, size:Int, color:UInt, align:String, underline:Bool, bold:Bool = false):TextField
        {
            return GamehallFonts.createPanelText(caption, x, y, width, height, size, color, align, underline, bold);
        }
    }

