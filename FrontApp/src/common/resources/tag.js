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
    },

    popular: function( school_id, nmax ){
      var params = {
        school_id: school_id,
        nmax: nmax,
        entities: {
          tag: {
            name: true
          }
        }
      };
      return Restangular.all('tags').customPOST( params, 'popular' );
    }
  };

  return Tag;

}]);
