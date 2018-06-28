/**
 * @dataManagerGroup blog
 * @labelfield name
 * @datamanagergridfields name,description,datecreated,datemodified
 */
component {
	property name="name" type="string" dbtype="varchar" required=true;
	property name="description" type="string" dbtype="varchar";
	property name="picture" relationship="many-to-one" relatedto="asset" allowedTypes="images";
}