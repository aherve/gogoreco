angular.module('resources.school', [
  'restangular'
])

.factory( 'School', ['Restangular', function( Restangular ){

  var School = {

    index: function(){
      var params = {
        entities: {
          school: {
            name: true,
            index: true,
            image: true
          }
        }
      };
      return Restangular.all('schools').customPOST( params, 'index' );
    },

    typeahead: function( search, nmax ){
      var params = {
        search: search,
        nmax: nmax,
        entities: {
          school: {
            name: true
          }
        }
      };
      return Restangular.all('schools').customPOST( params, 'typeahead');
    },

    get: function( id ){
      var params = {
        entities: {
          school: {
            name: true
          }
        }
      };
      return Restangular.one('schools', id ).customPOST( params );
    }

  };

  return School;

}]);
