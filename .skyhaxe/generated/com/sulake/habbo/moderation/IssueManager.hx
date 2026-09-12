package com.sulake.habbo.moderation
;
    import com.sulake.core.utils.Map;
    import flash.utils.Timer;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpCategoryData;
    import flash.events.TimerEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueMessageData;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ReleaseIssuesMessageComposer;
    import com.sulake.habbo.sound.HabboSoundTypesEnum;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ModToolSanctionComposer;
    import com.sulake.habbo.utils.StringUtil;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CfhSanctionTypeData;
    import com.sulake.habbo.communication.messages.outgoing.moderator.CloseIssuesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.PickIssuesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.CloseIssueDefaultActionMessageComposer;

     class IssueManager 
    {
        public static inline final ISSUE_BUNDLE_OPEN= "issue_bundle_open";
        public static inline final ISSUE_BUNDLE_MY= "issue_bundle_my";
        public static inline final ISSUE_BUNDLE_PICKED= "issue_bundle_picked";
        public static inline final PRIORITY_UPDATE_INTERVAL_MS= 15000;
        public static inline final RESOLUTION_USELESS= 1;
        public static inline final RESOLUTION_RESOLVED= 3;

        var _moderationManager:ModerationManager;
        var _issueBrowser:IssueBrowser;
        var _issues:Map;
        var _bundles:Map;
        var _bundleIds:Map;
        var _handleQueue:Array<ASAny>;
        var _releaseQueue:Array<ASAny>;
        var _issueHandlers:Map;
        var _modActionViews:Map;
        var _nextBundleId:Int = 1;
        var _priorityFactor:Int = 0;
        var _priorityUpdater:Timer;
        var _issueListLimit:Int = 0;
        var _windowX:Int = 0;
        var _windowY:Int = 0;
        var _windowWidth:Int = 0;
        var _windowHeight:Int = 0;
        var _cfhtopics:Vector<CallForHelpCategoryData>;

        public function new(k:ModerationManager)
        {
            this._moderationManager = k;
            this._issues = new Map();
            this._bundles = new Map();
            this._bundleIds = new Map();
            this._issueBrowser = new IssueBrowser(this, this._moderationManager.windowManager, this._moderationManager.assets);
            this._handleQueue = [];
            this._releaseQueue = [];
            this._issueHandlers = new Map();
            this._modActionViews = new Map();
            this._priorityFactor = this._moderationManager.getInteger("chf.score.updatefactor", 60);
            this._issueListLimit = this._moderationManager.getInteger("max.call_for_help.results", 200);
            this._priorityUpdater = new Timer(PRIORITY_UPDATE_INTERVAL_MS, 0);
            this._priorityUpdater.addEventListener(TimerEvent.TIMER, (this._Str_19194 : ASAny));
            this._priorityUpdater.start();
        }

        public var issueListLimit(get,never):Int;
public function  get_issueListLimit():Int
        {
            return this._issueListLimit;
        }

        public function init()
        {
            this._issueBrowser.show();
        }

        public function pickBundle(k:Int, _arg_2:String, _arg_3:Bool=false, _arg_4:Int=0)
        {
            var _local_5= ASCompat.dynamicAs(this._bundles.getValue(k) , IssueBundle);
            if (_local_5 == null)
            {
                return;
            }
            this.sendPick(_local_5._Str_7101(), _arg_3, _arg_4, _arg_2);
            this._handleQueue = this._handleQueue.concat(_local_5._Str_7101());
        }

        public function autoPick(k:String, _arg_2:Bool=false, _arg_3:Int=0)
        {
            var _local_5:IssueBundle = null;
            var _local_6:IssueBundle = null;
            var _local_4= this._bundles.getValues();
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_6  = _tmp_;
                if (((_local_6.state == IssueMessageData._Str_5035) && ((_local_5 == null) || this.isBundleHigherPriorityOrOlder(_local_6, _local_5))))
                {
                    _local_5 = _local_6;
                }
            }
            if (_local_5 == null)
            {
                return;
            }
            this.pickBundle(_local_5.id, k, _arg_2, _arg_3);
        }

        function isBundleHigherPriorityOrOlder(k:IssueBundle, _arg_2:IssueBundle):Bool
        {
            if (k.highestPriority < _arg_2.highestPriority)
            {
                return true;
            }
            return (k.highestPriority == _arg_2.highestPriority) && (k.issueAgeInMilliseconds < _arg_2.issueAgeInMilliseconds);
        }

        public function releaseAll()
        {
            var _local_3:IssueBundle = null;
            if (this._bundles == null)
            {
                return;
            }
            var k= this._moderationManager.sessionDataManager.userId;
            var _local_2:Array<ASAny> = [];
            final _iter_ = this._bundles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_3  = _tmp_;
                if (((_local_3.state == IssueMessageData._Str_8056) && (_local_3._Str_5547 == k)))
                {
                    _local_2 = _local_2.concat(_local_3._Str_7101());
                }
            }
            this.sendRelease(_local_2);
        }

        public function releaseBundle(k:Int)
        {
            if (this._bundles == null)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(this._bundles.getValue(k) , IssueBundle);
            if (_local_2 == null)
            {
                return;
            }
            this.sendRelease(_local_2._Str_7101());
        }

        function sendRelease(k:Array<ASAny>)
        {
            if (((((k == null) || (k.length == 0)) || (this._moderationManager == null)) || (this._moderationManager.connection == null)))
            {
                return;
            }
            this._moderationManager.connection.send(new ReleaseIssuesMessageComposer(k));
            this._releaseQueue = this._releaseQueue.concat(k);
        }

        public function playSound(k:IssueMessageData)
        {
            if (this._issues.getValue(k._Str_2869)!= null)
            {
                return;
            }
            if (((this._issueBrowser == null) || (!this._issueBrowser.isOpen())))
            {
                this._moderationManager.soundManager.playSound(HabboSoundTypesEnum.CALL_FOR_HELP);
            }
        }

        public function addModActionView(k:IssueMessageData)
        {
            var _local_3:IssueBundle = null;
            var _local_4:IssueBundle = null;
            var _local_5 = 0;
            var _local_6:Array<ASAny> = null;
            var _local_7 = false;
            var _local_8:IssueBundle = null;
            var _local_9 = 0;
            if (k == null)
            {
                return;
            }
            this._issues.remove(k._Str_2869);
            this._issues.add(k._Str_2869, k);
            var _local_2= ASCompat.toInt(this._bundleIds.getValue(k._Str_2869));
            if (_local_2 != 0)
            {
                _local_3 = ASCompat.dynamicAs(this._bundles.getValue(_local_2) , IssueBundle);
                if (_local_3 != null)
                {
                    if (_local_3._Str_12152(k))
                    {
                        _local_3.addModActionView(k);
                    }
                    else
                    {
                        _local_3.removeIssue(k._Str_2869);
                        if (_local_3._Str_20055() == 0)
                        {
                            this._bundles.remove(_local_3.id);
                            this._Str_17098(_local_3.id);
                        }
                        this._bundleIds.remove(k._Str_2869);
                        _local_3 = null;
                    }
                }
            }
            if (k.state == IssueMessageData._Str_17136)
            {
                this._issues.remove(k._Str_2869);
                return;
            }
            if (_local_3 == null)
            {
                final _iter_ = this._bundles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_4  = _tmp_;
                    if (_local_4._Str_12152(k))
                    {
                        _local_3 = _local_4;
                        _local_3.addModActionView(k);
                        this._bundleIds.add(k._Str_2869, _local_3.id);
                        break;
                    }
                }
            }
            if (_local_3 == null)
            {
                _local_2 = this._nextBundleId++;
                _local_3 = new IssueBundle(_local_2, k);
                this._bundleIds.add(k._Str_2869, _local_2);
                this._bundles.add(_local_2, _local_3);
            }
            if (_local_3 == null)
            {
                return;
            }
            if (this._handleQueue.indexOf(k._Str_2869) != -1)
            {
                this.handleBundle(_local_3.id);
                _local_5 = this._moderationManager.sessionDataManager.userId;
                if (_local_5 != k._Str_5547)
                {
                    if (k.state == IssueMessageData._Str_8056)
                    {
                        this.unhandleBundle(_local_3.id);
                    }
                }
            }
            if (k.state == IssueMessageData._Str_5035)
            {
                _local_6 = this.getBundles(ISSUE_BUNDLE_MY);
                _local_7 = false;
                if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                {
_local_8  = _tmp_;
                    if (_local_8._Str_12152(k, true))
                    {
                        _local_7 = true;
                        break;
                    }
                }
                _local_9 = this._releaseQueue.indexOf(k._Str_2869);
                if (((_local_9 == -1) && _local_7))
                {
                    this.sendPick([k._Str_2869], false, 0, ("matches bundle with issue: " + Std.string(_local_8._Str_5216()._Str_2869)));
                }
                else
                {
                    this._releaseQueue.splice(_local_9, 1);
                }
            }
            this._Str_23968(_local_3.id);
            this._issueBrowser.update();
        }

        public function _Str_19194(k:Event=null)
        {
            if (this._moderationManager == null)
            {
                return;
            }
            if (this._issueBrowser != null)
            {
                this._issueBrowser.update();
            }
        }

        function _Str_23968(k:Int)
        {
            var _local_2:IIssueHandler = this._issueHandlers.getValue(k);
            if (_local_2 != null)
            {
                _local_2._Str_21978();
            }
        }

        public function _Str_17098(k:Int)
        {
            var _local_2:IIssueHandler = this._issueHandlers.remove(k);
            if (_local_2 != null)
            {
                _local_2.dispose();
                _local_2 = null;
            }
        }

        public function _Str_24021(k:Int, _arg_2:ModActionCtrl)
        {
            this._modActionViews.add(k, _arg_2);
        }

        public function _Str_23349(k:Int)
        {
            this._modActionViews.remove(k);
        }

        public function removeIssue(k:Int)
        {
            var _local_3:IssueBundle = null;
            if (this._issues == null)
            {
                return;
            }
            var _local_2= ASCompat.toInt(this._bundleIds.getValue(k));
            if (_local_2 != 0)
            {
                _local_3 = ASCompat.dynamicAs(this._bundles.getValue(_local_2) , IssueBundle);
                if (_local_3 != null)
                {
                    _local_3.removeIssue(k);
                    if (_local_3._Str_20055() == 0)
                    {
                        this._bundles.remove(_local_3.id);
                    }
                }
            }
            this._issues.remove(k);
            this._issueBrowser.update();
        }

        public function getBundles(k:String):Array<ASAny>
        {
            var _local_4:IssueBundle = null;
            if (this._bundles == null)
            {
                return [];
            }
            var _local_2:Array<ASAny> = [];
            var _local_3= this._moderationManager.sessionDataManager.userId;
            final _iter_ = this._bundles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_4  = _tmp_;
                switch (k)
                {
                    case ISSUE_BUNDLE_OPEN:
                        if (_local_4.state == IssueMessageData._Str_5035)
                        {
                            _local_2.push(_local_4);
                        }
                        
                    case ISSUE_BUNDLE_MY:
                        if (((_local_4.state == IssueMessageData._Str_8056) && (_local_4._Str_5547 == _local_3)))
                        {
                            _local_2.push(_local_4);
                        }
                        
                    case ISSUE_BUNDLE_PICKED:
                        if (((_local_4.state == IssueMessageData._Str_8056) && (!(_local_4._Str_5547 == _local_3))))
                        {
                            _local_2.push(_local_4);
                        }
                        
                }
            }
            return _local_2;
        }

        public function handleBundle(k:Int)
        {
            var _local_5 = 0;
            var _local_2= ASCompat.dynamicAs(this._bundles.getValue(k) , IssueBundle);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3:IIssueHandler = new IssueHandler(this._moderationManager, _local_2, this._cfhtopics, this._windowX, this._windowY, this._windowWidth, this._windowHeight);
            this._moderationManager.windowTracker.show(ASCompat.reinterpretAs(_local_3 , ITrackedWindow), null, false, false, false, true, this._windowX, this._windowY, this._windowWidth, this._windowHeight);
            this._Str_17098(k);
            this._issueHandlers.add(k, _local_3);
            var _local_4:Array<ASAny> = [];
            final _iter_ = this._handleQueue; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = ASCompat.toInt(_tmp_);
                if (!_local_2.contains(_local_5))
                {
                    _local_4 = _local_4.concat((cast [_local_5]));
                }
            }
            this._handleQueue = _local_4;
        }

        public function unhandleBundle(k:Int)
        {
            var _local_2= ASCompat.dynamicAs(this._bundles.getValue(k) , IssueBundle);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3:ITrackedWindow = this._issueHandlers.remove(k);
            if (_local_3 != null)
            {
                _local_3.dispose();
            }
        }

        public function closeBundle(k:Int, _arg_2:Int)
        {
            var _local_3= ASCompat.dynamicAs(this._bundles.getValue(k) , IssueBundle);
            if (_local_3 == null)
            {
                return;
            }
            this.sendClose(_local_3._Str_7101(), _arg_2);
        }

        public function closeDefaultAction(k:Int, _arg_2:Int)
        {
            var _local_6 = 0;
            var _local_3= ASCompat.dynamicAs(this._bundles.getValue(k) , IssueBundle);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4:ASAny = _local_3._Str_5216()._Str_2869;
            var _local_5:ASAny = new Array<ASAny>();
            final _iter_ = _local_3._Str_7101(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6  = ASCompat.toInt(_tmp_);
                if (_local_6 != _local_4)
                {
                    _local_5.push(_local_6);
                }
            }
            this.sendCloseDefaultAction(ASCompat.toInt(_local_4), _local_5, _arg_2);
        }

        public function requestSanctionData(k:Int, _arg_2:Int)
        {
            var _local_3= ASCompat.dynamicAs(this._bundles.getValue(k) , IssueBundle);
            if (_local_3 == null)
            {
                return;
            }
            if (_local_3._Str_5216() != null)
            {
                this._moderationManager.connection.send(new ModToolSanctionComposer(_local_3._Str_5216()._Str_2869, -1, _arg_2));
            }
        }

        public function requestSanctionDataForAccount(k:Int, _arg_2:Int)
        {
            this._moderationManager.connection.send(new ModToolSanctionComposer(-1, k, _arg_2));
        }

        public function updateSanctionData(k:Int, _arg_2:Int, _arg_3:CfhSanctionTypeData)
        {
            var _local_5:IssueBundle = null;
            var _local_6:IIssueHandler = null;
            var _local_7:ModActionCtrl = null;
            var _local_4= (_arg_3.name + (_arg_3.avatarOnly ? " (avatar) " : " "));
            if (_arg_3.sanctionLengthInHours > 24)
            {
                _local_4 = (_local_4 + (Std.string(_arg_3.sanctionLengthInHours / 24) + " days"));
            }
            else
            {
                _local_4 = (_local_4 + (Std.string(_arg_3.sanctionLengthInHours) + "h"));
            }
            if (!StringUtil.isEmpty(_arg_3.tradeLockInfo))
            {
                _local_4 = (_local_4 + (" & " + _arg_3.tradeLockInfo));
            }
            if (!StringUtil.isEmpty(_arg_3.machineBanInfo))
            {
                _local_4 = (_local_4 + (" & " + _arg_3.machineBanInfo));
            }
            if (k > 0)
            {
                final _iter_ = this._bundles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_5  = _tmp_;
                    if (_local_5.contains(k))
                    {
                        _local_6 = this._issueHandlers.getValue(_local_5.id);
                        if (_local_6 != null)
                        {
                            _local_6._Str_13994(_arg_2, _local_4);
                        }
                    }
                }
            }
            else
            {
                _local_7 = this._modActionViews.getValue(_arg_2);
                if (_local_7 != null)
                {
                    _local_7._Str_13994(_arg_2, _local_4);
                }
            }
        }

        function sendClose(k:Array<ASAny>, _arg_2:Int)
        {
            if ((((k == null) || (this._moderationManager == null)) || (this._moderationManager.connection == null)))
            {
                return;
            }
            this._moderationManager.connection.send(new CloseIssuesMessageComposer(k, _arg_2));
        }

        function sendPick(k:Array<ASAny>, _arg_2:Bool, _arg_3:Int, _arg_4:String)
        {
            if ((((k == null) || (this._moderationManager == null)) || (this._moderationManager.connection == null)))
            {
                return;
            }
            this._moderationManager.connection.send(new PickIssuesMessageComposer(k, _arg_2, _arg_3, _arg_4));
        }

        function sendCloseDefaultAction(k:Int, _arg_2:Array<ASAny>, _arg_3:Int)
        {
            this._moderationManager.connection.send(new CloseIssueDefaultActionMessageComposer(k, _arg_2, _arg_3));
        }

        public function autoHandle(k:Int)
        {
            var _local_3:IssueBundle = null;
            var _local_5:IssueBundle = null;
            var _local_2= this._bundles.getValues();
            var _local_4= this._moderationManager.sessionDataManager.userId;
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_5  = _tmp_;
                if (((((_local_5.state == IssueMessageData._Str_8056) && (_local_5._Str_5547 == _local_4)) && (!(_local_5.id == k))) && ((_local_3 == null) || (_local_5.highestPriority < _local_3.highestPriority))))
                {
                    _local_3 = _local_5;
                }
            }
            if (_local_3 == null)
            {
                this.autoPick("issue manager pick next");
                return;
            }
            this.handleBundle(_local_3.id);
        }

        public function issuePickFailed(k:Array<ASAny>):Bool
        {
            var _local_4:IssueMessageData = null;
            var _local_5 = 0;
            var _local_6:String = null;
            var _local_7 = 0;
            var _local_8:IssueBundle = null;
            var _local_9:IssueBundle = null;
            var _local_10:Array<ASAny> = null;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13:IIssueHandler = null;
            if (k == null)
            {
                return false;
            }
            var _local_2 = false;
            var _local_3= this._moderationManager.sessionDataManager.userId;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = _tmp_;
                _local_5 = _local_4._Str_2869;
                _local_6 = _local_4._Str_22164;
                _local_7 = _local_4._Str_5547;
                if (((!(_local_7 == -1)) && (!(_local_7 == _local_3))))
                {
                    _local_2 = true;
                }
                _local_8 = null;
                final _iter_ = this._bundles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_9  = _tmp_;
                    _local_10 = _local_9._Str_7101();
                    if (_local_10 != null)
                    {
                        if (checkNullIteratee(_local_10)) for (_tmp_ in _local_10)
                        {
_local_11  = ASCompat.toInt(_tmp_);
                            if (_local_5 == _local_11)
                            {
                                _local_8 = _local_9;
                                break;
                            }
                        }
                    }
                }
                if (_local_8 != null)
                {
                    _local_12 = _local_8.id;
                    _local_13 = this._issueHandlers.getValue(_local_12);
                    if (_local_13 != null)
                    {
                        _local_13.dispose();
                    }
                    this.releaseBundle(_local_12);
                }
            }
            return _local_2;
        }

        public function setToolPreferences(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            this._windowX = k;
            this._windowY = _arg_2;
            this._windowHeight = _arg_3;
            this._windowWidth = _arg_4;
        }

        public function setCfhTopics(k:Vector<CallForHelpCategoryData>)
        {
            this._cfhtopics = k;
        }

        public function getCfhTopics():Vector<CallForHelpCategoryData>
        {
            return this._cfhtopics;
        }
    }

