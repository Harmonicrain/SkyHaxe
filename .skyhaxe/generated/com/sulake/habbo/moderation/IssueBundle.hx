package com.sulake.habbo.moderation
;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueMessageData;

     class IssueBundle 
    {
        var _id:Int = 0;
        var _issues:Map;
        var _state:Int = 0;
        var _pickerUserId:Int = 0;
        var _pickerName:String = "";
        var _reportedUserId:Int = 0;
        var _groupingId:Int = 0;
        var _messageCount:Int = 0;
        var _issueAgeInMilliseconds:Int = 0;
        var _oldestIssue:IssueMessageData = null;
        var _highestPriorityIssue:IssueMessageData = null;

        public function new(k:Int, _arg_2:IssueMessageData)
        {
            this._id = k;
            this._issues = new Map();
            this._state = _arg_2.state;
            this._pickerUserId = _arg_2._Str_5547;
            this._pickerName = _arg_2._Str_22164;
            this._reportedUserId = _arg_2.reportedUserId;
            this._groupingId = _arg_2._Str_16842;
            this.removeModActionView(_arg_2);
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var issues(get,never):Array<ASAny>;
public function  get_issues():Array<ASAny>
        {
            return this._issues.getValues();
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return this._state;
        }

        public var _Str_5547(get,never):Int;
public function  get__Str_5547():Int
        {
            return this._pickerUserId;
        }

        public var _Str_25343(get,never):String;
public function  get__Str_25343():String
        {
            return this._pickerName;
        }

        public function _Str_12152(k:IssueMessageData, _arg_2:Bool=false):Bool
        {
            if (((this._groupingId == 0) || (k._Str_16842 == 0)))
            {
                return false;
            }
            if (((!(this._groupingId == k._Str_16842)) || (!(this._reportedUserId == k.reportedUserId))))
            {
                return false;
            }
            if (!_arg_2)
            {
                if (this.state != k.state)
                {
                    return false;
                }
                if (this._Str_5547 != k._Str_5547)
                {
                    return false;
                }
            }
            return true;
        }

        public function contains(k:Int):Bool
        {
            if (this._issues == null)
            {
                return false;
            }
            return this._issues.getKeys().indexOf(k) > -1;
        }

        public function addModActionView(k:IssueMessageData)
        {
            this.removeIssue(k._Str_2869);
            this.removeModActionView(k);
        }

        function removeModActionView(k:IssueMessageData)
        {
            this._issues.add(k._Str_2869, k);
            this._issueAgeInMilliseconds = Std.int(k.issueAgeInMilliseconds);
            if (((!(k.message == null)) && (!(k.message == ""))))
            {
                this._messageCount++;
            }
            if (((this._oldestIssue == null) || (k.issueAgeInMilliseconds > this._oldestIssue.issueAgeInMilliseconds)))
            {
                this._oldestIssue = k;
            }
            this._highestPriorityIssue = null;
            this._Str_5216();
        }

        public function removeIssue(k:Int):IssueMessageData
        {
            var _local_2= ASCompat.dynamicAs(this._issues.remove(k) , IssueMessageData);
            if (_local_2 != null)
            {
                if (((!(_local_2.message == null)) && (!(_local_2.message == ""))))
                {
                    this._messageCount--;
                }
                if (this._oldestIssue == _local_2)
                {
                    this._oldestIssue = null;
                }
                if (this._highestPriorityIssue == _local_2)
                {
                    this._highestPriorityIssue = null;
                }
            }
            return _local_2;
        }

        public var highestPriority(get,never):Int;
public function  get_highestPriority():Int
        {
            if (this._highestPriorityIssue == null)
            {
                this._Str_5216();
            }
            if (this._highestPriorityIssue != null)
            {
                return this._highestPriorityIssue.priority;
            }
            return 0;
        }

        public function _Str_5216():IssueMessageData
        {
            var k:IssueMessageData = null;
            var _local_2:IssueMessageData = null;
            var _local_3 = 0;
            var _local_4:IssueMessageData = null;
            var _local_5 = false;
            if (this._highestPriorityIssue == null)
            {
                if (((this._issues == null) || (this._issues.length < 1)))
                {
                    return null;
                }
                _local_3 = 0;
                while ((_local_3 : UInt) < this._issues.length)
                {
                    _local_4 = this._issues.getWithIndex(_local_3);
                    _local_5 = ((_local_4._Str_7437 > 0) && (_local_4._Str_7437 < 100));
                    if (_local_5)
                    {
                        if (((_local_2 == null) || (_local_2.priority > _local_4.priority)))
                        {
                            _local_2 = _local_4;
                        }
                    }
                    else
                    {
                        if (((k == null) || (k.priority > _local_4.priority)))
                        {
                            k = _local_4;
                        }
                    }
                    _local_3++;
                }
                if (_local_2 != null)
                {
                    this._highestPriorityIssue = _local_2;
                }
                else
                {
                    this._highestPriorityIssue = k;
                }
            }
            return this._highestPriorityIssue;
        }

        public function _Str_20055():Int
        {
            if (this._issues == null)
            {
                return 0;
            }
            return ASCompat.toInt(this._issues.length);
        }

        public function _Str_7101():Array<ASAny>
        {
            if (this._issues == null)
            {
                return [];
            }
            return this._issues.getKeys();
        }

        public var reportedUserId(get,never):Int;
public function  get_reportedUserId():Int
        {
            return this._reportedUserId;
        }

        public function _Str_23420():Int
        {
            return this._messageCount;
        }

        public var issueAgeInMilliseconds(get,never):Int;
public function  get_issueAgeInMilliseconds():Int
        {
            return this._issueAgeInMilliseconds;
        }

        public function _Str_15885(k:Int):String
        {
            var _local_3:IssueMessageData = null;
            var _local_2= this._oldestIssue;
            if (_local_2 == null)
            {
                final _iter_ = this._issues; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_3  = _tmp_;
                    if (((_local_2 == null) || (_local_3.issueAgeInMilliseconds > _local_2.issueAgeInMilliseconds)))
                    {
                        _local_2 = _local_3;
                    }
                }
                this._oldestIssue = _local_2;
            }
            if (_local_2 != null)
            {
                return _local_2._Str_15885(k);
            }
            return "";
        }
    }

