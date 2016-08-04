<cfparam name="args.title" default="" />
<cfparam name="args.collapse_on_mobile" default="false" />

<cfif args.blogPosts.recordCount gt 0>
	<cfsilent>
		<cfset cssClass = "widget widget-list" />
		<cfif isBoolean( args.collapse_on_mobile ) && args.collapse_on_mobile>
			<cfset cssClass &= " mod-mobile-collapse" />
		</cfif>
	</cfsilent>
	<cfoutput>
		<div class="#cssClass#">
			<cfif args.title.len()>
				<h3 class="widget-title">#args.title#</h3>
			</cfif>

			<div class="widget-content">
				<ul>
					<cfloop query="args.blogPosts">	
						<li>
							<h4><a href="#event.buildLink( page=id )#">#title#</a></h4>
							<cfif subline.len()>
								<p>#subline#</p>
							</cfif>
						</li>
					</cfloop>
				</ul>
			</div>
		</div>
	</cfoutput>
</cfif>