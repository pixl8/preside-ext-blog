<cfparam name="args.title" default="" />
<cfparam name="args.featured" default="" />

<!--- TODO: maybe display featured flag + title in placeholder --->
<cfoutput>#translateResource( uri='widgets.blog_tag_list:title' )#</cfoutput>