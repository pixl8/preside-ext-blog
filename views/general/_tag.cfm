<cfparam name="args.id" default="" />
<cfparam name="args.label" default="" />
<cfoutput>
	<cfif !IsEmpty( args.label )>
		<!--- TODO: link (to filtered blog listing) --->
		<li><a href="##">#args.label#</a></li>
	</cfif>
</cfoutput>