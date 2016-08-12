<cf_presideparam name="args.title" type="string" field="page.title" editable="true" />
<cf_presideparam name="args.sidebar_content" type="string" field="blog.sidebar_content" editable="true" />

<cfscript>
    // TODO: check if we should integrate that in the extension or have it in the skeleton
    event.include( assetId="/css/specific/blog-post/", throwOnMissing=false )
</cfscript>
<cfoutput>
    <div class="contents">
        <div class="main-content">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12 col-md-8">

                        <div class="heading-border">
                            <h2 class="heading-border-title">#args.title#</h2>
                        </div>

                        #renderView( view="page-types/blog/_filters", args={ tags=prc.tagFilters, authors=prc.authorFilters, archives=prc.archiveFilters, blogId=event.getCurrentPageId() } )#

                        <div class="articles">

                            <cfloop query="prc.blogPosts" group="_row">
                                <div class="row">
                                    <cfloop group="id">
                                        <div class="col-xs-12 col-sm-6">
                                            #renderView(
                                                view='page-types/blog/_item',
                                                args={
                                                    id=id,
                                                    title=title,
                                                    publish_date=publish_date,
                                                    post_author=postAuthor,
                                                    teaser=teaser,
                                                    main_image=main_image,
                                                    mainImageDerivative="blogMainImageTeaserSmall"
                                                }
                                            )#
                                        </div>
                                    </cfloop>
                                </div>
                            </cfloop>

                        </div>
                    </div>

                    <aside class="sidebar col-xs-12 col-md-4 hidden-xs">
                        <div class="sidebar-contents">
                            #args.sidebar_content#
                        </div>
                    </aside>
                </div>

            </div>
        </div>
    </div>
</cfoutput>