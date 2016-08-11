<cfparam name="args.blog"                  default="" />
<cfparam name="args.showAuthorFilter"      default="false" />
<cfparam name="args.showArchiveFilter"     default="false" />
<cfparam name="args.showTagFilter"         default="false" />

<cfparam name="args.authorFilterExpanded"  default="false" />
<cfparam name="args.archiveFilterExpanded" default="false" />
<cfparam name="args.tagFilterExpanded"     default="false" />

<cfparam name="args.blogPostAuthors"       default="" />
<cfparam name="args.blogPostArchive"       default="" />
<cfparam name="args.blogPostTags"          default="" />

<cfparam name="args.author_filter_title"   default="" />
<cfparam name="args.archive_filter_title"  default="" />
<cfparam name="args.tag_filter_title"      default="" />

<cfif args.showAuthorFilter || args.showArchiveFilter || args.showTagFilter>
    <cfoutput>
        <div class="widget widget-filter">
            <div class="collapsible arrow-on-right">
                <cfif args.showAuthorFilter>
                    #renderView( view="widgets/blog_filters/_authorFilter", args={ blog=args.blog, title=args.author_filter_title, expanded=args.authorFilterExpanded, data=args.blogPostAuthors } )#
                </cfif>

                <cfif args.showArchiveFilter>
                    #renderView( view="widgets/blog_filters/_archiveFilter", args={ blog=args.blog, title=args.archive_filter_title, expanded=args.archiveFilterExpanded, data=args.blogPostArchive } )#
                </cfif>

                <cfif args.showTagFilter>
                    #renderView( view="widgets/blog_filters/_tagFilter", args={ blog=args.blog, title=args.tag_filter_title, expanded=args.tagFilterExpanded, data=args.blogPostTags } )#
                </cfif>
            </div> <!-- /.collapsible -->
        </div>
    </cfoutput>
</cfif>