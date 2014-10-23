angular.module('resources.school', [
  'restangular'
])

.factory( 'School', ['Restangular', function( Restangular ){

  var School = {

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
    }

  };

  return School;

}]);
