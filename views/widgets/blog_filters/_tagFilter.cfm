<cfparam name="args.blog"     default="" />
<cfparam name="args.title"    default="" />
<cfparam name="args.expanded" default="false" />
<cfparam name="args.data"     default="" />

<cfscript>
    collapsibleItemClass = args.expanded ? "collapsible-item is-open" : "collapsible-item";
</cfscript>

<cfif !isEmpty( args.data )>
    <cfoutput>
        <div class="#collapsibleItemClass#">
            <h4 class="collapsible-item-header"><a>#args.title#</a></h4>
            <div class="collapsible-item-content">
                <ul>
                    <cfloop query="args.data">
                        <li><a href="#event.buildLink( page=args.blog, querystring='filterAction=add&filterType=tags&filterValue=' & id )#">#label# <span class="count">#post_count#</span></a></li>
                    </cfloop>
                </ul>
            </div>
        </div>
    </cfoutput>
</cfif>