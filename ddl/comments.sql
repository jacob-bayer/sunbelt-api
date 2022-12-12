DROP SCHEMA "comments" CASCADE;

CREATE SCHEMA "comments" AUTHORIZATION mainuser;


-- "comments"."comments" definition

-- Drop table

-- DROP TABLE "comments"."comments";

CREATE TABLE "comments"."comments" (
	zen_comment_id int8 PRIMARY KEY NOT NULL,
	zen_post_id int8 NULL REFERENCES posts.posts(zen_post_id),
	zen_subreddit_id int8 NULL REFERENCES subreddits.subreddits(zen_subreddit_id),
	reddit_comment_id TEXT NOT NULL,
	reddit_account_id TEXT NULL,
	reddit_parent_id TEXT NOT NULL,
	reddit_post_id TEXT NOT NULL,
	reddit_subreddit_id TEXT NOT NULL,
	zen_modified_at timestamP NOT NULL,
	zen_created_at timestamp NOT NULL DEFAULT now(),
	subreddit_name_prefixed TEXT NOT NULL,
	controversiality int8 NULL,
	ups int8 NULL,
	downs int8 NULL,
	created_utc numeric NULL,
	score int8 NULL,
	"depth" int8 NULL,
	body text NULL,
	edited text NULL,
	permalink text NULL,
	author_cakeday bool NULL,
	approved_at_utc text NULL,
	author_is_blocked bool NULL,
	comment_type text NULL,
	mod_reason_by text NULL,
	banned_by text NULL,
	author_flair_type text NULL,
	total_awards_received int8 NULL,
	author_flair_template_id text NULL,
	likes text NULL,
	saved bool NULL,
	banned_at_utc text NULL,
	mod_reason_title text NULL,
	gilded int8 NULL,
	archived bool NULL,
	collapsed_reason_code text NULL,
	no_follow bool NULL,
	can_mod_post bool NULL,
	send_replies bool NULL,
	approved_by text NULL,
	mod_note text NULL,
	collapsed bool NULL,
	top_awarded_type text NULL,
	author_flair_css_class text NULL,
	is_submitter bool NULL,
	author_patreon_flair bool NULL,
	body_html text NULL,
	removal_reason text NULL,
	collapsed_reason text NULL,
	distinguished text NULL,
	associated_award text NULL,
	stickied bool NULL,
	author_premium bool NULL,
	can_gild bool NULL,
	unrepliable_reason text NULL,
	author_flair_text_color text NULL,
	score_hidden bool NULL,
	subreddit_type text NULL,
	"locked" bool NULL,
	report_reasons text NULL,
	created numeric NULL,
	author_flair_text text NULL,
	author_flair_background_color text NULL,
	collapsed_because_crowd_control text NULL,
	num_reports text NULL
);
CREATE INDEX ix_comments_comments_zen_comment_id ON comments.comments USING btree (zen_comment_id);



-- "comments".all_awardings definition

-- Drop table

-- DROP TABLE "comments".all_awardings;

CREATE TABLE "comments".all_awardings (
	zen_awarding_id int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	zen_comment_id int8 NOT NULL REFERENCES comments.comments(zen_comment_id),
	reddit_subreddit_id text NOT NULL,
	zen_modified_at timestamp NOT NULL,
	zen_created_at timestamp NOT NULL DEFAULT now(),
	giver_coin_reward text NULL,
	is_new bool NULL,
	days_of_drip_extension text NULL,
	coin_price int8 NULL,
	penny_donate text NULL,
	coin_reward int8 NULL,
	icon_url text NULL,
	days_of_premium numeric NULL,
	icon_height int8 NULL,
	icon_width int8 NULL,
	static_icon_width int8 NULL,
	start_date numeric NULL,
	is_enabled bool NULL,
	awardings_required_to_grant_benefits numeric NULL,
	description text NULL,
	end_date text NULL,
	sticky_duration_seconds text NULL,
	subreddit_coin_reward int8 NULL,
	count int8 NULL,
	static_icon_height int8 NULL,
	"name" text NULL,
	icon_format text NULL,
	award_sub_type text NULL,
	penny_price NUMERIC NULL,
	award_type text NULL,
	static_icon_url text NULL
);
CREATE INDEX ix_comments_all_awardings_zen_awarding_id ON comments.all_awardings USING btree (zen_awarding_id);



-- "comments".gildings definition

-- Drop table

-- DROP TABLE "comments".gildings;

CREATE TABLE "comments".gildings (
	zen_gilding_id int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	zen_comment_id int8 NOT NULL REFERENCES comments.comments(zen_comment_id),
	reddit_gid text NULL,
	value numeric NULL,
	zen_modified_at timestamp NOT NULL,
    zen_created_at timestamp NOT NULL DEFAULT now()
);
CREATE INDEX ix_comments_gildings_zen_gilding_id ON comments.gildings USING btree (zen_gilding_id);


