<cfparam name="args.enabled" default="false" />
<cfparam name="args.addThisId" default="" />

<cfif args.enabled && args.addThisId.len()>
    <cfoutput>
        <script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js##pubid=#args.addThisId#"></script>
    </cfoutput>
</cfif>