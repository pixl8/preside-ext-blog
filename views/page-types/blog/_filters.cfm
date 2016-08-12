<cfparam name="args.blogId" />
<cfparam name="args.authors" />
<cfparam name="args.archives" />
<cfparam name="args.tags" />

<cfif !isEmpty( args.authors ) || !isEmpty( args.archives ) || !isEmpty( args.tags )>
    <cfoutput>
        <div class="filter-tags">
            <!--- TODO: i18n --->
            <span class="filter-tags-label">Showing result for</span>
            <cfloop query="args.authors">
                <cfset link = event.buildLink( page=args.blogId, querystring="filterAction=remove&filterType=authors&filterValue=" & id ) />
                <span class="filter-tags-item">#name# <a href="#link#"><i class="font-icon font-icon-close"></i></a></span>
            </cfloop>
            <cfloop query="args.archives">
                <cfset link = event.buildLink( page=args.blogId, querystring="filterAction=remove&filterType=archives&filterValue=" & key ) />
                <span class="filter-tags-item">#label# <a href="#link#"><i class="font-icon font-icon-close"></i></a></span>
            </cfloop>
            <cfloop query="args.tags">
                <cfset link = event.buildLink( page=args.blogId, querystring="filterAction=remove&filterType=tags&filterValue=" & id ) />
                <span class="filter-tags-item">#label# <a href="#link#"><i class="font-icon font-icon-close"></i></a></span>
            </cfloop>
        </div>
    </cfoutput>
</cfif>