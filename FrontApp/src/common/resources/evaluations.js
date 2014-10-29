angular.module('resources.evaluation', [
  'restangular'
])

.factory( 'Evaluation', ['Restangular', function( Restangular ){

  var Evaluation = {

    getLatest: function( nmax, school_ids ){

      var params = {
        nmax: nmax,
        school_ids: school_ids,
        entities: {
          evaluation: {
          "author": true,
          "created_at": true,
          "id": true,
          "item": true,
          "related_comments": true,
          "schools": true,
          "score": true,
          "updated_at": true
          },
          item: {
            name: true
          },
          author: {
            name: true
          },
          comment: {
            content: true
          }
        }
      };

      return Restangular.all('evaluations').customPOST( params, 'latest' );
    }

  };

  return Evaluation;

}]);

