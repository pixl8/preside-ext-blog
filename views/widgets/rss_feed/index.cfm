<cfparam name="args.blog" default="" />

<cfset link = event.buildLink( linkTo="page-types/blog/rss", queryString="blogId=#args.blog#" ) />

<cfoutput>
    <div class="widget widget-feed">
        <a href="#link#"><span class="font-icon font-icon-feed"></span> RSS Feed</a>
    </div>
</cfoutput>