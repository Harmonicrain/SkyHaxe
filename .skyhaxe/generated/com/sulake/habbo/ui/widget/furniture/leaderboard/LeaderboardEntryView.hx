package com.sulake.habbo.ui.widget.furniture.leaderboard
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;

     class LeaderboardEntryView
    {
        static inline final SCORE_ICON= "badge_rarity_badges_emblem_unique";
        static final RANK_COLORS:Array<ASAny> = [0x00D4AF37, 0x00C0C0C0, 0x00CD7F32, 0x006382AA];

        var _window:IWindowContainer;
        var _assets:IAssetLibrary;

        public function new(window:IWindowContainer, assets:IAssetLibrary)
        {
            this._window = window;
            this._assets = assets;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public var profileRegion(get,never):IRegionWindow;
public function  get_profileRegion():IRegionWindow
        {
            return this._window == null ? null : Std.downcast(this._window.findChildByName("region_profile") , IRegionWindow);
        }

        public var profileCanvas(get,never):IBitmapWrapperWindow;
public function  get_profileCanvas():IBitmapWrapperWindow
        {
            return this._window == null ? null : Std.downcast(this._window.findChildByName("canvas") , IBitmapWrapperWindow);
        }

        public function setData(entry:LeaderboardEntry, even:Bool)
        {
            if (this._window == null || entry == null)
            {
                return;
            }

            this._window.visible = true;
            this.setVisible("entry_bg_even", !entry.own && even);
            this.setVisible("entry_bg_uneven", !entry.own && !even);
            this.setVisible("own_bg", entry.own);
            this.setText("rank_number", entry.rankCaption);
            this.setText("rank_own", entry.rankCaption);
            this.setText("username_txt", entry.username);
            this.setText("score_txt", Std.string(entry.score));
            this.setScoreIcon();
            this.clearFaceBitmap();
            this.applyRankColor(entry);
        }

        public function hide()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        public function dispose()
        {
            this.clearFaceBitmap();
            this._window = null;
            this._assets = null;
        }

        public function setFaceBitmap(bitmap:BitmapData)
        {
            var canvas= this.profileCanvas;
            if (canvas == null || bitmap == null)
            {
                return;
            }
            this.clearFaceBitmap();
            canvas.bitmap = bitmap;
            canvas.width = bitmap.width;
            canvas.height = bitmap.height;
            canvas.invalidate();
        }

        public function clearFaceBitmap()
        {
            var canvas= this.profileCanvas;
            if (canvas == null)
            {
                return;
            }
            if (canvas.bitmap != null)
            {
                canvas.bitmap.dispose();
                canvas.bitmap = null;
            }
            canvas.invalidate();
        }

        function setText(name:String, value:String)
        {
            var text= Std.downcast(this._window.findChildByName(name) , ITextWindow);
            if (text != null)
            {
                text.text = value == null ? "" : value;
                text.caption = text.text;
            }
        }

        function setVisible(name:String, visible:Bool)
        {
            var window= this._window.findChildByName(name);
            if (window != null)
            {
                window.visible = visible;
            }
        }

        function setScoreIcon()
        {
            var icon= Std.downcast(this._window.findChildByName("rank_type_img") , IStaticBitmapWrapperWindow);
            if (icon != null)
            {
                icon.assetUri = SCORE_ICON;
            }
        }

        function applyRankColor(entry:LeaderboardEntry)
        {
            var border= this._window.findChildByName("rank_border");
            if (border == null || entry.own)
            {
                return;
            }
            var rank= entry.rank;
            if (rank >= 1 && rank <= 3)
            {
                border.color = ASCompat.toUInt(RANK_COLORS[rank - 1]);
            }
            else
            {
                border.color = ASCompat.toUInt(RANK_COLORS[3]);
            }
        }
    }

