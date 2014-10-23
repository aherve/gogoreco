angular.module( 'gogoreco.startpage', [])

.config(['$stateProvider', function config( $stateProvider ) {
  $stateProvider.state( 'startpage', {
    url: '/start',
    views: {
      "main": {
        controller: 'StartpageCtrl',
        templateUrl: 'startpage/startpage.tpl.html'
      }
    },
    data:{ pageTitle: 'Startpage' },
    resolve: {
      authenticatedUser: [ 'security', function( security ){
        return security.requestCurrentUser().then( function( response ){
          return true;
        }, function( err ){
          return true;
        });
      }]
    }
  });
}])

/**
 * And of course we define a controller for our route.
 */
.controller( 'StartpageCtrl', ['$scope', 'security', function StartpageController( $scope, security ) {

  if( security.isAuthenticated() ){
    if( security.currentUser.schools ){
      $scope.nav('/contribute');
    }
  }

  $scope.$on('login success', function(){
    $scope.nav('/contribute');
  });

}]);


