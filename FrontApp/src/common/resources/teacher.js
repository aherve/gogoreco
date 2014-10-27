angular.module('resources.teacher', [])

.factory('Teacher', ['Restangular', function( Restangular ){

  var Teacher = {
    typeahead: function( search, school_id ){
      var params = {
        search: search,
        school_id: school_id,
        entities: {
          teacher: {
            name: true
          }
        }
      };
      return Restangular.all( 'teachers' ).customPOST( params, 'typeahead' );
    },

    popular: function( school_id, nmax ){
      var params = {
        school_id: school_id,
        nmax: nmax,
        entities: {
          teacher: {
            name: true
          }
        }
      };
      return Restangular.all('teachers').customPOST( params, 'popular' );
    }
  };

  return Teacher;

}]);

