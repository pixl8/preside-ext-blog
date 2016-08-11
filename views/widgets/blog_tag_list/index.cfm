<cfparam name="args.title" default="" />
<cfparam name="args.blog" default="" />

<cfif !isEmpty( args.tags )>
	<cfoutput>
		<div class="widget widget-tags">
			<cfif args.title.len()>
				<h3 class="widget-title">#args.title#</h3>
			</cfif>

			<div class="widget-content">
				<ul class="tags">
					<cfloop query="args.tags">
						#renderView( view='widgets/blog_tag_list/_item', args={
							  id 		= id
							, label 	= label
							, post_count = post_count
							, blog	    = args.blog
						} )#
					</cfloop>					
				</ul>
			</div>
		</div>
	</cfoutput>
</cfif>