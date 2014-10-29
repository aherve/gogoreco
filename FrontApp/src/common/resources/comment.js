angular.module('resources.comment', [
  'restangular'
])

.factory('Comment', ['Restangular', function(Restangular){

  var Comment = {
    get: function( id ){
      var params = {
        entities: {
          comment: {
            "author": true,
            "content": true,
            "id": true,
            "related_evaluation": true
          },
          user: {
            name: true,
            image: true
          }
        }
      };
      return Restangular.one('comments', id ).customPOST( params );
    }
  };

  return Comment;

}]);
