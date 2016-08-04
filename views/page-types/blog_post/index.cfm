<cf_presideparam name="args.title"        	   field="page.title"        		   editable="true"  />
<cf_presideparam name="args.main_content"      field="page.main_content" 		   editable="true"  />
<cf_presideparam name="args.main_image"    	   field="page.main_image" 			   editable="false" />
<cf_presideparam name="args.publish_date"      field="blog_post.publish_date" 	   editable="true"  />
<cf_presideparam name="args.allow_comments"    field="blog_post.allow_comments"    editable="false" />
<cf_presideparam name="args.authorName" 	   field="postAuthor.name" 		  	   editable="false" />
<cf_presideparam name="args.authorDescription" field="postAuthor.description" 	   editable="false" />
<cf_presideparam name="args.authorPicture" 	   field="postAuthor.picture" 		   editable="false" />
<cf_presideparam name="args.tags"       	   field="group_concat( distinct tags.id )" default="" />

<cfscript>
	bannerImageSource = len(args.main_image) ? event.buildLink( assetId=args.main_image, derivative= "blogPostBanner"  ) : "";

	event.include( "/css/specific/blog-post/" )
		 .include( assetId="jq-parallax" );
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

						<cfif listLen(args.tags) gt 0>
							<div class="tag-list">
								<p>#translateResource( uri='page-types.blog_post:post.tag_hint' )#</p>
								<ul class="tags">
									<cfloop list="#args.tags#" index="tagID">
										#renderView( presideobject="blog_tag", view="/general/_tag", filter={ id=tagID } )#
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