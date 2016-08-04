<cfif args.hasMore>
    <cfset link = event.buildLink( page=event.getCurrentPageId(), querystring="maxrows=" & ( args.maxRows + 10 ) ) />
    <cfoutput>
        <p class="load-more u-aligned-center">
            <!--- TODO: i18n --->
            <a href="#link#"><span class="icon icon-load"></span> Show more...</a>
        </p>
    </cfoutput>
</cfif>