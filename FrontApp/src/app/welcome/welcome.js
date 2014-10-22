angular.module( 'gogoreco.welcome', [])

.config(['securityAuthorizationProvider', '$stateProvider', function config( securityAuthorizationProvider, $stateProvider ) {
  $stateProvider.state( 'welcome', {
    url: '/welcome',
    views: {
      "main": {
        controller: 'WelcomeCtrl',
        templateUrl: 'welcome/welcome.tpl.html'
      }
    },
    data:{ pageTitle: 'Welcome' },
    resolve: {
      authenticatedUser: securityAuthorizationProvider.requireAuthenticatedUser
    }
  });
}])

/**
 * And of course we define a controller for our route.
 */
.controller( 'WelcomeCtrl', ['$scope', function WelcomeController( $scope ) {
  $scope.step = 0;

  $scope.next = function(){
    $scope.$step = $scope.step < 5 ? $scope.step + 1 : $scope.step;
  };

  $scope.previous = function(){
    $scope.$step = $scope.step > 0 ? $scope.step - 1 : $scope.step;
  };

  $scope.navToStep = function( step ){
    $scope.step = step;
  };

}]);


