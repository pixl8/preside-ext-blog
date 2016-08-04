<cfparam name="args.title" default="" />
<cfparam name="args.top_posts_only" default="" />
<cfparam name="args.most_viewed" default="" />
<cfparam name="args.max_items" default="" />

<!--- TODO: maybe display config options + title in placeholder --->
<cfoutput>#translateResource( uri='widgets.blog_post_list:title' )#</cfoutput>