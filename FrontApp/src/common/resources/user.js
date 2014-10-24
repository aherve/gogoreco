angular.module('resources.user', [])

.factory('User', ['Restangular', function( Restangular ){
  var User = {

    should_like: function(){
      var params = {
        entities: {
          item: {
            name: true
          }
        }
      };
      return Restangular.one('users', 'me').customPOST( params, 'should_like_items');
    }
  };

  return User;
}]);
