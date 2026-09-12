package com.sulake.habbo.moderation
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;

     class OpenIssuesView implements IIssueBrowserView 
    {
        var _issueManager:IssueManager;
        var _issueBrowser:IssueBrowser;
        var _window:IWindowContainer;
        var _issueListView:IssueListView;

        public function new(k:IssueManager, _arg_2:IssueBrowser, _arg_3:IWindowContainer)
        {
            this._issueManager = k;
            this._issueBrowser = _arg_2;
            this._window = _arg_3;
            this._window.visible = false;
            var _local_4= Std.downcast(this._window.findChildByName("issue_list") , IItemListWindow);
            this._issueListView = new IssueListView(k, _arg_2, _local_4);
        }

        public var view(get,never):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._window;
        }

        public var visible(never,set):Bool;
public function  set_visible(k:Bool):Bool        {
            return this._window.visible = k;
        }

        public function update()
        {
            var k= this._issueManager.getBundles(IssueManager.ISSUE_BUNDLE_OPEN);
            this._issueListView.update(k);
        }
    }

