<cf_presideparam name="args.title"        	   field="page.title"        		   editable="true"  />
<cf_presideparam name="args.main_content"      field="page.main_content" 		   editable="true"  />
<cf_presideparam name="args.main_image"    	   field="page.main_image" 			   editable="false" />
<cf_presideparam name="args.publish_date"      field="blog_post.publish_date" 	   editable="true"  />
<cf_presideparam name="args.allow_comments"    field="blog_post.allow_comments"    editable="false" />
<cf_presideparam name="args.authorName" 	   field="postAuthor.name" 		  	   editable="false" />
<cf_presideparam name="args.authorDescription" field="postAuthor.description" 	   editable="false" />
<cf_presideparam name="args.authorPicture" 	   field="postAuthor.picture" 		   editable="false" />

<cfscript>
	bannerImageSource = len( args.main_image ) ? event.buildLink( assetId=args.main_image, derivative= "blogPostBanner"  ) : "";
	// TODO: check if we should integrate that in the extension or have it in the skeleton
	event.include( assetId="/css/specific/blog-post/", throwOnMissing=false )
		 .include( assetId="jq-parallax", throwOnMissing=false );
</cfscript>

<cfoutput>
	<div class="contents" >

		<cfif len( bannerImageSource )>
			<div class="page-banner">
				<div class="page-banner-item" >
					<div class="page-banner-item-image" data-parallax="scroll" data-speed="0.5" data-image-src="#bannerImageSource#"></div>
				</div>
			</div>
		</cfif>

		<div class="main-content">
			<div class="container">
				<div class="row">
					<div class="col-xs-12 col-md-8 col-md-offset-2">
						<h1>#args.title#</h1>

						<ul class="list-details">
							<li>#args.publish_date#</li>
							<li>#args.authorName#</li>
						</ul>

						#args.main_content#

						<cfif prc.tags.recordCount>
							<div class="tag-list">
								<p>#translateResource( uri='page-types.blog_post:post.tag_hint' )#</p>
								<ul class="tags">
									<cfloop query="prc.tags">
										<li><a href="#event.buildLink( page=prc.presidePage.parent_page, queryString='filterAction=add&filterType=tags&filterValue=#prc.tags.id#' )#">#prc.tags.label#</a></li>
									</cfloop>
								</ul>
							</div>
						</cfif>

						#renderView( view="/general/_social_sharing" )#

						<div class="author">

							<h4>#translateResource( uri='page-types.blog_post:post.author' )#</h4>

							<div class="author-image">
								<!--- TODO: implement link to where? (maybe the blog list filtered by author) --->
								<a href="##">
									#renderAsset( assetId=args.authorPicture, args={ derivative="blogPostAuthor" } )#
								</a>
							</div>

							<div class="author-details">
								<!--- TODO: implement link to where? (maybe the blog list filtered by author) --->
								<h5><a href="##">#args.authorName#</a></h5>
								<cfif len( args.authorDescription )>
									<p>#args.authorDescription#</p>
								</cfif>
							</div>

						</div>

						<cfif args.allow_comments>
							<div class="disqus-thread-wrapper"><div id="disqus_thread"></div></div>
						</cfif>

					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>