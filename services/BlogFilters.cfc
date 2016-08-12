 /**
  * @singleton true
  */
 component {

// CONSTRUCTOR
    /**
     * @blogService.inject    blogService
     * @sessionStorage.inject coldbox:plugin:sessionStorage
     */
    public any function init( required any blogService, required any sessionStorage ) {

        _setBlogService( arguments.blogService );
        _setSessionStorage( arguments.sessionStorage );

        _setValidFilterActions( [ "add", "remove" ] );
        _setValidFilterTypes( [ "tags", "authors", "archives" ] );

        return this;
    }

// PUBLIC API METHODS
    public void function manage(
          required string blogId
        , required string action
        , required string type
        , required string value
    ) {

        if ( !_isValidFilterAction( arguments.action ) || !_isValidFilterType( arguments.type ) || !len( arguments.value ) ) {
            return;
        }

        var filters = _getStoredFilters( arguments.blogId );

        if ( arguments.action == "add" && !filters[ arguments.type ].containsNoCase( arguments.value ) ) {
            filters[ arguments.type ].append( arguments.value );
        }
        else if ( arguments.action == "remove" ) {
            var i = filters[ arguments.type ].findNoCase( arguments.value );
            if ( i > 0 ) {
                filters[ arguments.type ].deleteAt( i );
            }
        }

        _setStoredFilters( arguments.blogId, filters );
    }

    public array function getTagFilterIds( required string blogId ) {
        return _getStoredFilters( arguments.blogId ).tags;
    }

    public array function getAuthorFilterIds( required string blogId ) {
        return _getStoredFilters( arguments.blogId ).authors;   
    }

    public array function getArchiveFilterKeys( required string blogId ) {
        return _getStoredFilters( arguments.blogId ).archives;   
    }

    public query function getTagFilters( required string blogId ) {

        var tagFilterIds = getTagFilterIds( arguments.blogId );

        if ( isEmpty( tagFilterIds ) ) {
            return queryNew( "dummy" );
        }

        return _getBlogService().getBlogPostTags( parentPage=arguments.blogId, tags=tagFilterIds );
    }

    public query function getAuthorFilters( required string blogId ) {

        var authorFilterIds = getAuthorFilterIds( arguments.blogId );

        if ( isEmpty( authorFilterIds ) ) {
            return queryNew( "dummy" );
        }

        return _getBlogService().getBlogPostAuthors( parentPage=arguments.blogId, authors=authorFilterIds );
    }

    public query function getArchiveFilters( required string blogId ) {

        var archiveFilterKeys = getArchiveFilterKeys( arguments.blogId );

        if ( isEmpty( archiveFilterKeys ) ) {
            return queryNew( "dummy" );
        }

        var result = queryNew( "key,label", "varchar,varchar" );

        for ( var archiveFilterKey in archiveFilterKeys ) {
            result.addRow();
            result.setCell( "key", archiveFilterKey );
            result.setCell( "label", numberFormat( listLast( archiveFilterKey, "_"), "00" ) & "/" & listFirst( archiveFilterKey, "_") );
        }

        return result;
    }

// PRIVATE HELPER METHODS
    private boolean function _isValidFilterAction( required string filterAction ) {
        return _getValidFilterActions().containsNoCase( arguments.filterAction );
    }

    private boolean function _isValidFilterType( required string filterType ) {
        return _getValidFilterTypes().containsNoCase( arguments.filterType );
    }

    private struct function _getStoredFilters( required string blogId ) {
        var filterKey = _getFilterKey( arguments.blogId );

        return _getSessionStorage().exists( filterKey ) ? _getSessionStorage().getVar( filterKey ) : { tags=[], archives=[], authors=[] };
    }

    private void function _setStoredFilters( required string blogId, required struct filters ) {
        _getSessionStorage().setVar( _getFilterKey( arguments.blogId ), arguments.filters );
    }

    private string function _getFilterKey( required string blogId ) {
        return "blog_filters_" & arguments.blogId;
    }

// GETTERS AND SETTERS
    private any function _getBlogService() {
        return _blogService;
    }
    private void function _setBlogService( required any blogService ) {
        _blogService = arguments.blogService;
    }

    private any function _getSessionStorage() {
        return _sessionStorage;
    }
    private void function _setSessionStorage( required any sessionStorage ) {
        _sessionStorage = arguments.sessionStorage;
    }

    private array function _getValidFilterActions() {
        return _validFilterActions;
    }
    private void function _setValidFilterActions( required array validFilterActions ) {
        _validFilterActions = arguments.validFilterActions;
    }

    private array function _getValidFilterTypes() {
        return _validFilterTypes;
    }
    private void function _setValidFilterTypes( required array validFilterTypes ) {
        _validFilterTypes = arguments.validFilterTypes;
    }
}