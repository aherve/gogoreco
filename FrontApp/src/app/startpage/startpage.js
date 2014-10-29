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
.controller( 'StartpageCtrl', ['$scope', 'security', '$rootScope', function StartpageController( $scope, security, $rootScope ) {

  if( security.isAuthenticated() ){
    if( !!$rootScope.school ){
      $scope.nav('/home');
    }
    else {
      $scope.nav('/pickASchool');
    }
  }

  $scope.$on('login success', function(){
    if( !!$rootScope.school ){
      $scope.nav('/home');
    }
    else {
      $scope.nav('/pickASchool');
    }
  });

}]);


