<cfparam name="args.blog"     default="" />
<cfparam name="args.title"    default="" />
<cfparam name="args.expanded" default="false" />
<cfparam name="args.data"     default="" />

<cfscript>
    collapsibleItemClass = args.expanded ? "collapsible-item is-open" : "collapsible-item";
</cfscript>

<cfif isArray( args.data ) && !isEmpty( args.data )>
    <cfoutput>
        <div class="#collapsibleItemClass#">
            <h4 class="collapsible-item-header"><a>Archive</a></h4>
            <div class="collapsible-item-content">
                <div class="collapsible arrow-on-right">

                    <cfloop array="#args.data#" index="currentYear">
                        <div class="#collapsibleItemClass#">
                            <h4 class="collapsible-item-header"><a>#currentYear.year#</a></h4>
                            <div class="collapsible-item-content">
                                <div class="date">
                                    <cfloop array="#currentYear.months#" index="currentMonth">
                                        <cfset monthLabel = lsDateFormat( createDate( currentYear.year, currentMonth.month, 1 ), "mmm" ) />
                                        <!--- TODO: i18n --->
                                        <cfset tooltip = currentMonth.postCount gt 1 ? currentMonth.postCount & " posts" : "1 post" />
                                        <cfset link = event.buildLink( page=args.blog, querystring="filterAction=add&filterType=archives&filterValue=" & currentYear.year & "_" & currentMonth.month ) />
                                        <a href="#link#" title="#tooltip#">#monthLabel#</a>
                                    </cfloop>
                                </div>
                            </div>
                        </div>
                    </cfloop>

                </div>
            </div>
        </div>
    </cfoutput>
</cfif>