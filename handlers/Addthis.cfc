component {
    public string function social( event, rc, prc, args={} ) {
        return renderView(
            view="general/_addthis",
            args={
                  addThisId=getSystemSetting( "addthis", "addthis_id", "" )
                , enabled=prc.includeAddThis ?: false
            }
        );
    }
}