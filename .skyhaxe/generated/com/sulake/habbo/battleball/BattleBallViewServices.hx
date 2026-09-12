package com.sulake.habbo.battleball
;
    /**
     * The handful of facade-owned behaviours the renderers need, gathered in one place.
     *
     * Renderers used to take these as individual constructor arguments, which grew a new parameter
     * every time a screen needed one more -- the arena window ended up with eleven. Passing one
     * services object keeps the dependency narrow and, more importantly, keeps it *stable*: adding a
     * shared behaviour no longer changes every renderer's signature.
     *
     * Deliberately behaviour only. Shared *values* live in BattleBallViewState.
     */
     class BattleBallViewServices
    {
        /** Raise a view event to the controller. */
        public var emit:ASFunction;
        /** Localised text by key. */
        public var text:ASFunction;
        /** Display name of an arena/map id. */
        public var arenaName:ASFunction;
        /** Player name, trimmed for the space it is drawn in. */
        public var playerDisplayName:ASFunction;
        /** Current score for a team in a model. */
        public var teamScore:ASFunction;
        /** The local user's id. */
        public var localUserId:ASFunction;
        /** Open the ticket shop. */
        public var openTickets:ASFunction;
        /** Open the creation form. */
        public var showCreate:ASFunction;
        /** Re-render the current screen locally, with no network round trip. */
        public var redraw:ASFunction;
        /** Join a game from a list row. */
        public var joinGame:ASFunction;
        /** Put every BattleBall window away. */
        public var hide:ASFunction;
        /** Remove a player from the game (owner only). */
        public var kickPlayer:ASFunction;

        /**
         * Fail loudly if anything was left unwired.
         *
         * These are late-bound function references, so the compiler cannot tell a missing assignment
         * from a valid one -- the symptom is a button that silently does nothing at runtime. Checking
         * once at construction turns that into an immediate, obvious failure.
         *
         * This is also the cap on the object: it holds twelve behaviours, which is already past the
         * limit of what belongs in one bag. Anything more should be split into role interfaces rather
         * than added here.
         */
        public function assertWired()
        {
            var missing= "";
            if (this.emit == null) missing += "emit ";
            if (this.text == null) missing += "text ";
            if (this.arenaName == null) missing += "arenaName ";
            if (this.playerDisplayName == null) missing += "playerDisplayName ";
            if (this.teamScore == null) missing += "teamScore ";
            if (this.localUserId == null) missing += "localUserId ";
            if (this.openTickets == null) missing += "openTickets ";
            if (this.showCreate == null) missing += "showCreate ";
            if (this.redraw == null) missing += "redraw ";
            if (this.joinGame == null) missing += "joinGame ";
            if (this.hide == null) missing += "hide ";
            if (this.kickPlayer == null) missing += "kickPlayer ";
            if (missing != "") throw new ASError("BattleBallViewServices is not fully wired: " + missing);
        }
public function new(){}
    }

