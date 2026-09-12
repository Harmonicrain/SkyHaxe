package com.sulake.habbo.quest.rewardtrack.view
;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackPrize;

     class RewardTrackPrizeLayout
    {
        static inline final PAGE_BOUNDARY_EPSILON= 0.0001;

        var _visibleWidth:Int = 0;
        var _prizeWidth:Int = 0;
        var _spacing:Int = 0;
        var _edgePadding:Float = Math.NaN;
        var _zeroOffset:Float = Math.NaN;
        var _pagePointSpan:Int = 1;
        var _distancePerPoint:Float = 1;
        var _pageCount:Int = 1;
        var _minRequiredPoints:Int = 0;

        public function rebuild(track:RewardTrack, visibleWidth:Int, prizeWidth:Int, spacing:Int)
        {
            this._visibleWidth = visibleWidth;
            this._prizeWidth = prizeWidth;
            this._spacing = spacing;
            this._edgePadding = ((this._prizeWidth / 2) + this._spacing);
            this._minRequiredPoints = this.findMinRequiredPoints(track.prizes);
            var minimumGap= this.findMinimumGap(track.prizes);
            var maxPoints= this.findMaxRequiredPoints(track.prizes);
            if (minimumGap <= 0)
            {
                minimumGap = Std.int(Math.max(1, maxPoints));
            }
            this._distancePerPoint = ((this._prizeWidth + this._spacing) / minimumGap);
            if (this._distancePerPoint <= 0)
            {
                this._distancePerPoint = 1;
            }
            this._pagePointSpan = this.calculatePagePointSpan(this._distancePerPoint, minimumGap);
            if (maxPoints > 0)
            {
                this._pagePointSpan = Std.int(Math.min(this._pagePointSpan, Math.max(minimumGap, (Std.int(Math.fceil(maxPoints / minimumGap)) * minimumGap))));
            }
            this._distancePerPoint = this.findMaxDistancePerPoint(this._distancePerPoint, this._pagePointSpan);
            this._zeroOffset = this.zeroOffsetFor(this._distancePerPoint);
            this._pageCount = this.calculatePageCount(track.prizes);
        }

        public function xForPoints(points:Int, page:Int):Float
        {
            var pageStart= Std.int(Math.max(0, (page * this._pagePointSpan)));
            return (this._zeroOffset + ((points - pageStart) * this._distancePerPoint));
        }

        public function pageForPoints(points:Int):Int
        {
            var page= this.pageForPointSpan(points, this._pagePointSpan);
            return Std.int(Math.max(0, Math.min((this._pageCount - 1), page)));
        }

        public var pageCount(get,never):Int;
public function  get_pageCount():Int
        {
            return this._pageCount;
        }

        public var distancePerPoint(get,never):Float;
public function  get_distancePerPoint():Float
        {
            return this._distancePerPoint;
        }

        function calculatePageCount(prizes:Array<ASAny>):Int
        {
            var prize:RewardTrackPrize = null;
            var maxPage = 0;
            if (checkNullIteratee(prizes)) for (_tmp_ in prizes)
            {
prize  = _tmp_;
                maxPage = Std.int(Math.max(maxPage, this.pageForPointSpan(prize.requiredPoints, this._pagePointSpan)));
            }
            return Std.int(Math.max(1, (maxPage + 1)));
        }

        function pageForPointSpan(points:Int, span:Int):Int
        {
            if (points <= 0)
            {
                return 0;
            }
            return Std.int(Math.max(0, (Std.int(Math.fceil(((points - PAGE_BOUNDARY_EPSILON) / span))) - 1)));
        }

        function zeroOffsetFor(distancePerPoint:Float):Float
        {
            return Math.max(0, (this._edgePadding - (this._minRequiredPoints * distancePerPoint)));
        }

        function usableWidthFor(distancePerPoint:Float):Float
        {
            return Math.max(1, ((this._visibleWidth - this._edgePadding) - this.zeroOffsetFor(distancePerPoint)));
        }

        function calculatePagePointSpan(distancePerPoint:Float, minimumGap:Int):Int
        {
            var gapsPerPage= Std.int(Math.max(1, Std.int(Math.ffloor(((this.usableWidthFor(distancePerPoint) / distancePerPoint) / minimumGap)))));
            return Std.int(Math.max(1, (gapsPerPage * minimumGap)));
        }

        function findMaxDistancePerPoint(distancePerPoint:Float, pagePointSpan:Int):Float
        {
            var i = 0;
            var middle = Math.NaN;
            var fits= distancePerPoint;
            var overflows= distancePerPoint;
            i = 0;
            while (i < 32)
            {
                overflows = (overflows * 2);
                if (!this.pagePointSpanFits(overflows, pagePointSpan))
                {
                    break;
                }
                fits = overflows;
                i++;
            }
            i = 0;
            while (i < 24)
            {
                middle = ((fits + overflows) / 2);
                if (this.pagePointSpanFits(middle, pagePointSpan))
                {
                    fits = middle;
                }
                else
                {
                    overflows = middle;
                }
                i++;
            }
            return fits;
        }

        function pagePointSpanFits(distancePerPoint:Float, pagePointSpan:Int):Bool
        {
            return ((pagePointSpan * distancePerPoint) <= (this.usableWidthFor(distancePerPoint) + PAGE_BOUNDARY_EPSILON));
        }

        function findMinimumGap(prizes:Array<ASAny>):Int
        {
            var freeGap= this.findMinimumGapForPremium(prizes, false);
            var premiumGap= this.findMinimumGapForPremium(prizes, true);
            if (freeGap <= 0)
            {
                return premiumGap;
            }
            if (premiumGap <= 0)
            {
                return freeGap;
            }
            return Std.int(Math.min(freeGap, premiumGap));
        }

        function findMinimumGapForPremium(prizes:Array<ASAny>, premium:Bool):Int
        {
            var prize:RewardTrackPrize = null;
            var points:Array<ASAny> = [];
            var gap = 0;
            var minimumGap = 0;
            var i = 0;
            if (checkNullIteratee(prizes)) for (_tmp_ in prizes)
            {
prize  = _tmp_;
                if (prize.premium == premium)
                {
                    points.push(prize.requiredPoints);
                }
            }
            ASCompat.ASArray.sortWithOptions(points, ASCompat.ASArray.NUMERIC);
            i = 1;while (i < points.length)
            {
                gap = (ASCompat.toInt(points[i]) - ASCompat.toInt(points[(i - 1)]));
                if (((gap > 0) && ((minimumGap == 0) || (gap < minimumGap))))
                {
                    minimumGap = gap;
                }
i++;
            }
            return minimumGap;
        }

        function findMinRequiredPoints(prizes:Array<ASAny>):Int
        {
            var prize:RewardTrackPrize = null;
            var minimum= -1;
            if (checkNullIteratee(prizes)) for (_tmp_ in prizes)
            {
prize  = _tmp_;
                if (((minimum == -1) || (prize.requiredPoints < minimum)))
                {
                    minimum = prize.requiredPoints;
                }
            }
            return Std.int(Math.max(0, minimum));
        }

        function findMaxRequiredPoints(prizes:Array<ASAny>):Int
        {
            var prize:RewardTrackPrize = null;
            var maximum = 0;
            if (checkNullIteratee(prizes)) for (_tmp_ in prizes)
            {
prize  = _tmp_;
                maximum = Std.int(Math.max(maximum, prize.requiredPoints));
            }
            return maximum;
        }
public function new(){}
    }

