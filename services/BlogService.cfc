 /**
  * @singleton true
  */
 component {

// CONSTRUCTOR
    /**
     * @blogPostDao.inject             presidecms:object:blog_post
     * @extensionManagerService.inject extensionManagerService
     */
    public any function init( required any blogPostDao, required any extensionManagerService ) {
        _setBlogPostDao( arguments.blogPostDao );
        _setExtensionManagerService( arguments.extensionManagerService );

        return this;
    }

// PUBLIC API METHODS
    public query function getFilteredBlogPosts(
          string  parentPage              = ""
        , array   tags                    = []
        , array   postAuthors             = []
        , array   archives                = [] // this is an array of strings that looks like e.g. [ "2016_8", "2015_1" ]
        , numeric maxRows                 = 10
        , numeric startRow                = 1
        , boolean topPostsOnly            = false
        , boolean mostViewed              = false
        , boolean includeTotalRecordCount = false
    ) {
        var filter                 = "1 = 1";
        var params                 = {};
        var isPageViewCountEnabled = _isPageViewCountEnabled();
        var selectFields           = [ "distinct page.id", "page.main_image", "page.title", "blog_post.publish_date", "blog_author.name as postAuthor", "page.teaser" ];
        var orderBy                = arguments.mostViewed && isPageViewCountEnabled ? "page.page_views DESC, blog_post.publish_date DESC" : "blog_post.publish_date DESC";

        if ( isPageViewCountEnabled ) {
            selectFields.append( "page.page_views" );
        }

        if ( arguments.parentPage.len() ) {
            filter &= " and page.parent_page = :parentPage";
            params["parentPage"] = { value=arguments.parentPage, type="varchar" };
        }
        if ( arguments.tags.len() ) {
            filter &= " and tags.id in (:blog_tag.id)";
            params[ "blog_tag.id" ] = arguments.tags;
        }

        if ( arguments.postAuthors.len() ) {
            filter &= " and blog_author.id in (:blog_author.id)";
            params[ "blog_author.id" ] = arguments.postAuthors;
        }

        if ( arguments.archives.len() ) {
            
            var archiveFilterDetails = [];

            for ( var archiveKey in arguments.archives ) {
                var monthNumber = listLast( archiveKey, "_" );
                var yearNumber = listFirst( archiveKey, "_" );
                var firstDate = createDate( yearNumber, monthNumber, 1);
                var lastDate = dateAdd( "d", -1, dateAdd( "m", 1, firstDate ) ); // plus 1 month minus 1 day ==> last day of current month

                firstDate = dateFormat( firstDate, "yyyy-mm-dd" );
                lastDate = dateFormat( lastDate, "yyyy-mm-dd" );

                archiveFilterDetails.append( "( blog_post.publish_date >= '#firstDate#' and blog_post.publish_date <= '#lastDate#' )" );
            }

            filter &= " and ( " & archiveFilterDetails.toList( " or " ) & " )";
        }

        if ( arguments.topPostsOnly ) {
            filter &= " and blog_post.top_post = '1'";
        }

        var args = {
              selectFields = selectFields
            , filter       = filter
            , filterParams = params
            , savedFilters = [ "livePages" ]
            , orderBy      = orderBy
        };

        if ( arguments.maxRows > 0 ) {
            args.maxRows = arguments.maxRows;
        }

        if ( arguments.startRow > 1 ) {
            args.startRow = arguments.startRow;
        }

        var q = _getBlogPostDao().selectData( argumentCollection=args );

        if ( arguments.includeTotalRecordCount ) {

            // cache buster
            q = duplicate( q );

            q.addColumn( "_totalrecordcount", "integer", [] );
            var totalRecordCount = _getBlogPostDao().selectData(
                  selectFields = [ "count(distinct page.id) as rowcount" ]
                , filter       = filter
                , filterParams = params
                , savedFilters = [ "livePages" ]
            );
            loop query="q" {
                q.setCell("_totalrecordcount", totalRecordCount.rowcount, currentrow);
            }
        }

        return q;
    }

    public query function getBlogPostTags( string parentPage = "", boolean featuredOnly=false, array tags=[] ) {

        // workaround to be able to use the saved filter, otherwise page table is not joined at all
        var filter = "page.active = '1'";
        var params = {};

        if ( arguments.parentPage.len() ) {
            filter &= " and page.parent_page = :parentPage";
            params.parentPage = { value=arguments.parentPage, type="varchar" };
        }

        if ( arguments.featuredOnly ) {
            filter &= " and blog_tag.featured = '1'"
        }

        if ( arguments.tags.len() ) {
            filter &= " and tags.id in (:blog_tag.id)";
            params[ "blog_tag.id" ] = arguments.tags;
        }

        return _getBlogPostDao().selectData(
              selectFields = [ "distinct blog_tag.id", "blog_tag.label", "count(*) as post_count" ]
            , filter       = filter
            , filterParams = params
            , savedFilters = [ "livePages" ]
            , groupBy      = "blog_tag.id, blog_tag.label"
            , orderBy      = "blog_tag.label"
        );
    }

    public query function getBlogPostAuthors( string parentPage = "", array authors=[] ) {

        // workaround to be able to use the saved filter, otherwise page table is not joined at all
        var filter = "page.active = '1'";
        var params = {};

        if ( arguments.parentPage.len() ) {
            filter &= " and page.parent_page = :parentPage";
            params.parentPage = { value=arguments.parentPage, type="varchar" };
        }

        if ( arguments.authors.len() ) {
            filter &= " and postAuthor in (:postAuthor)";
            params[ "postAuthor" ] = arguments.authors;
        }

        return _getBlogPostDao().selectData(
              selectFields = [ "distinct postAuthor.id", "postAuthor.name", "count(*) as post_count" ]
            , filter       = filter
            , filterParams = params
            , savedFilters = [ "livePages" ]
            , groupBy      = "postAuthor.id, postAuthor.name"
            , orderBy      = "postAuthor.name"
        );
    }

    public array function getBlogPostArchive( string parentPage = "" ) {

        // workaround to be able to use the saved filter, otherwise page table is not joined at all
        var filter = "page.active = '1'";
        var params = {};

        if ( arguments.parentPage.len() ) {
            filter &= " and page.parent_page = :parentPage";
            params.parentPage = { value=arguments.parentPage, type="varchar" };
        }

        var blogPosts = _getBlogPostDao().selectData(
              selectFields = [ "blog_post.id", "blog_post.publish_date" ]
            , filter       = filter
            , filterParams = params
            , savedFilters = [ "livePages" ]
            , orderBy      = "publish_date desc"
        );

        var result = [];

        if ( !isEmpty( blogPosts ) ) {

            var postCounts = {};

            // build helper struct to determine number of posts per year and month
            loop query="blogPosts" {
                var currentYear = year( publish_date );
                var currentMonth = month( publish_date );

                if ( !postCounts.keyExists( currentYear ) ) {
                    postCounts[ currentYear ] = {};
                }

                if ( !postCounts[ currentYear ].keyExists( currentMonth ) ) {
                    postCounts[ currentYear ][ currentMonth ] = 0;
                }
                postCounts[ currentYear ][ currentMonth ]++;
            }

            // sort it (years descending, months ascending)
            var years = postCounts.keyArray();

            arraySort( years, "numeric", "desc" );

            for ( var currentYear in years ) {
                var months = postCounts[ currentYear ].keyArray();
                arraySort( months, "numeric", "asc" );
                var monthlyPostCount = [];
                for ( var currentMonth in months ) {
                    monthlyPostCount.append( { month=currentMonth, postCount=postCounts[ currentYear ][ currentMonth ] } );
                }
                result.append( { year=currentYear, months=monthlyPostCount });
            }
        }

        return result;
    }

// PRIVATE HELPER METHODS
    private boolean function _isPageViewCountEnabled() {
        // check to see if the google analytics import extension is available which add page view count columns to the page object

        var activeExtensions = _getExtensionManagerService().listExtensions( activeOnly=true );

        for ( var activeExtension in activeExtensions ) {
            if ( activeExtension.name eq "preside-ext-analytics-import" ) {
                return true;
            }
        }
        return false;
    }

// GETTERS AND SETTERS
    private any function _getBlogPostDao() {
        return _blogPostDao;
    }
    private void function _setBlogPostDao( required any blogPostDao ) {
        _blogPostDao = arguments.blogPostDao;
    }

    private any function _getExtensionManagerService() {
        return _extensionManagerService;
    }
    private void function _setExtensionManagerService( required any extensionManagerService ) {
        _extensionManagerService = arguments.extensionManagerService;
    }
}