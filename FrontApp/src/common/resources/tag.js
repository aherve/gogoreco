angular.module('resources.tag', [])

.factory('Tag', ['Restangular', function( Restangular ){

  var Tag = {
    typeahead: function( search, school_id ){
      var params = {
        search: search,
        school_id: school_id,
        entities: {
          tag: {
            name: true
          }
        }
      };
      return Restangular.all( 'tags' ).customPOST( params, 'typeahead' );
    }
  };

  return Tag;

}]);
