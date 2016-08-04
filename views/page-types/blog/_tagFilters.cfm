<cfif !isEmpty( args.tags )>
    <cfoutput>
        <div class="filter-tags">
            <!--- TODO: i18n --->
            <span class="filter-tags-label">Showing result for</span>
            <cfloop query="args.tags">
                <cfset link = event.buildLink( page=args.blog, querystring="remove_tag_filter=" & id ) />
                <span class="filter-tags-item">#label# <a href="#link#"><i class="font-icon font-icon-close"></i></a></span>
            </cfloop>
        </div>
    </cfoutput>
</cfif>