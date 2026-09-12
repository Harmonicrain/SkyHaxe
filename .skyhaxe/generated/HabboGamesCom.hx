 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboGameManagerBootstrap;
    import com.sulake.iid.IIDHabboGameManager;
	import snowwar.assets.images.*;
    import snowwar.assets.binaryData.*;

     class HabboGamesCom extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var game_center_view_generic_xml:Class<Dynamic>;
        public static var game_center_leaderboard_view_xml:Class<Dynamic>;
        public static var game_center_teaser_view_xml:Class<Dynamic>;
        public static var game_center_waiting_game_view_xml:Class<Dynamic>;
        public static var game_achievement_entry_xml:Class<Dynamic>;
        public static var game_leaderboard_entry_xml:Class<Dynamic>;
        public static var game_leaderboard_entry_small_xml:Class<Dynamic>;
        public static var game_center_icon_selected:Class<Dynamic>;
        public static var game_center_speech_bubble:Class<Dynamic>;
        public static var game_center_reward_star:Class<Dynamic>;
        public static var game_center_lucky_loser_entry_xml:Class<Dynamic>;
        public static var bb_glist_xml:Class<Dynamic>;
        public static var bb_gcreate_xml:Class<Dynamic>;
        public static var bb_ginfo2t_xml:Class<Dynamic>;
        public static var bb_ginfo3t_xml:Class<Dynamic>;
        public static var bb_ginfo4t_xml:Class<Dynamic>;
        public static var bb_ginfo_more_xml:Class<Dynamic>;
        public static var bb_score_big_2t_xml:Class<Dynamic>;
        public static var bb_score_big_3t_xml:Class<Dynamic>;
        public static var bb_score_big_4t_xml:Class<Dynamic>;
        public static var bb_score_tiny_xml:Class<Dynamic>;
        public static var bb_scores_xml:Class<Dynamic>;
        public static var bb_tickets_xml:Class<Dynamic>;
        public static var ss_glist_xml:Class<Dynamic>;
        public static var ss_gcreate_xml:Class<Dynamic>;
        public static var ss_ginfo1t_xml:Class<Dynamic>;
        public static var ss_ginfo2t_xml:Class<Dynamic>;
        public static var ss_ginfo3t_xml:Class<Dynamic>;
        public static var ss_ginfo4t_xml:Class<Dynamic>;
        public static var ss_gl_slots_xml:Class<Dynamic>;
        public static var ss_gi_specs_xml:Class<Dynamic>;
        public static var ss_gi_teams2_xml:Class<Dynamic>;
        public static var ss_gi_teams3_xml:Class<Dynamic>;
        public static var ss_gi_teams4_xml:Class<Dynamic>;
        public static var ss_score_tiny_xml:Class<Dynamic>;
        public static var ss_score_big_1t_xml:Class<Dynamic>;
        public static var ss_score_big_2t_xml:Class<Dynamic>;
        public static var ss_score_big_3t_xml:Class<Dynamic>;
        public static var ss_score_big_4t_xml:Class<Dynamic>;
        public static var ss_sc_2t_xml:Class<Dynamic>;
        public static var ss_sc_3t_xml:Class<Dynamic>;
        public static var ss_sc_4t_xml:Class<Dynamic>;
        public static var ss_cdown_xml:Class<Dynamic>;
        public static var ss_arena_hud_xml:Class<Dynamic>;
        public static var ss_timeleft_xml:Class<Dynamic>;
        public static var ss_personal_stats_xml:Class<Dynamic>;
        public static var ss_team_stats_xml:Class<Dynamic>;
        public static var avatar_info_widget:Class<Dynamic>;
	
		
		/**
		 * Snowstorm
		 */
        public static final explosion0001:Class<Dynamic> = HabboGamesCom_explosion0001;
        public static final explosion0002:Class<Dynamic> = HabboGamesCom_explosion0002;
        public static final explosion0003:Class<Dynamic> = HabboGamesCom_explosion0003;
        public static final explosion0004:Class<Dynamic> = HabboGamesCom_explosion0004;
        public static final explosion0005:Class<Dynamic> = HabboGamesCom_explosion0005;
        public static final explosion0006:Class<Dynamic> = HabboGamesCom_explosion0006;
        public static final explosion0007:Class<Dynamic> = HabboGamesCom_explosion0007;
        public static final explosion0008:Class<Dynamic> = HabboGamesCom_explosion0008;
        public static final explosion0009:Class<Dynamic> = HabboGamesCom_explosion0009;
        public static final explosion0010:Class<Dynamic> = HabboGamesCom_explosion0010;
        public static final explosion0011:Class<Dynamic> = HabboGamesCom_explosion0011;
        public static final explosion0012:Class<Dynamic> = HabboGamesCom_explosion0012;
		
        public static final games_main:Class<Dynamic> = HabboGamesCom_games_main;
        public static final instructions_list_item:Class<Dynamic> = HabboGamesCom_instructions_list_item;
        public static final counter:Class<Dynamic> = HabboGamesCom_counter;
        public static final figure:Class<Dynamic> = HabboGamesCom_figure;
        public static final snowwar_ending:Class<Dynamic> = HabboGamesCom_snowwar_ending;
        public static final snowwar_exit:Class<Dynamic> = HabboGamesCom_snowwar_exit;
        public static final snowwar_lobby_player:Class<Dynamic> = HabboGamesCom_snowwar_lobby_player;
        public static final snowwar_lobby_player_team_1:Class<Dynamic> = HabboGamesCom_snowwar_lobby_player_team_1;
        public static final snowwar_lobby_player_team_2:Class<Dynamic> = HabboGamesCom_snowwar_lobby_player_team_2;
        public static final snowwar_results_player_team_1:Class<Dynamic> = HabboGamesCom_snowwar_results_player_team_1;
        public static final snowwar_results_player_team_2:Class<Dynamic> = HabboGamesCom_snowwar_results_player_team_2;
        public static final snowwar_own_stats:Class<Dynamic> = HabboGamesCom_snowwar_own_stats;
        public static final snowwar_snowballs:Class<Dynamic> = HabboGamesCom_snowwar_snowballs;
        public static final snowwar_team_scores:Class<Dynamic> = HabboGamesCom_snowwar_team_scores;
        public static final snowwar_timer:Class<Dynamic> = HabboGamesCom_snowwar_timer;
        public static var snowwar_loading_background_xml:Class<Dynamic> = HabboGamesCom_snowwar_loading_background;
        public static var snowwar_exit_confirmation:Class<Dynamic> = HabboGamesCom_snowwar_exit_confirmation;
        public static var snowwar_leaderboard:Class<Dynamic> = HabboGamesCom_snowwar_leaderboard;
        public static var snowwar_leaderboard_entry:Class<Dynamic> = HabboGamesCom_snowwar_leaderboard_entry;
		
        static var _logEnabled:Bool = true;
        public static var requiredClasses:Array<ASAny> = [HabboGameManagerBootstrap, IIDHabboGameManager];

        
        public static var logEnabled(get,set):Bool;
public static function  set_logEnabled(k:Bool):Bool        {
            return _logEnabled = k;
        }
public static function  get_logEnabled():Bool
        {
            return true;
        }

        public static function log( k:Array<ASAny> = null)
        {
if (k == null) k = [];
			trace(k);
        }

	public function new() { super(); }
    }

