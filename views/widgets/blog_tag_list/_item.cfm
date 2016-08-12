<cfparam name="args.id" />
<cfparam name="args.label" />
<cfparam name="args.post_count" />
<cfparam name="args.blog" />

<!--- TODO: i18n --->
<cfscript>
	tooltip = args.post_count gt 1 ? args.post_count & " posts" : "1 post";
    link = event.buildLink( page=args.blog, querystring="filterAction=add&filterType=tags&filterValue=" & args.id );
</cfscript>
<cfoutput>
	<li title="#tooltip#"><a href="#link#">#args.label#</a></li>
</cfoutput>