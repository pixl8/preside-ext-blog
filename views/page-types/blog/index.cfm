<cf_presideparam name="args.title" type="string" field="page.title" editable="true" />
<cf_presideparam name="args.sidebar_content" type="string" field="blog.sidebar_content" editable="true" />

<cfoutput>
    <div class="contents">
        <div class="main-content">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12 col-md-8">

                        <div class="heading-border">
                            <h2 class="heading-border-title">#args.title#</h2>
                        </div>

                        #renderView( view="page-types/blog/_tagFilters", args={ tags=prc.filterTags, blog=event.getCurrentPageId() } )#

                        <div class="articles mod-listing">

                            <cfloop query="prc.blogPosts">
                                #renderView(
                                    view='page-types/blog/_item',
                                    args={
                                        id=id,
                                        title=title,
                                        publish_date=publish_date,
                                        post_author=postAuthor,
                                        teaser=teaser,
                                        main_image=main_image,
                                        mainImageDerivative="blogMainImageTeaser"
                                    }
                                )#
                            </cfloop>

                        </div>

                        #renderView( view="page-types/blog/_moreLink", args={ hasMore=prc.hasMore, maxRows=rc.maxRows ?: prc.presidePage.initial_max_rows } )#
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