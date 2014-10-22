angular.module('gogoreco.usersConfirmation', [])

.config(function config( $stateProvider ) {
  $stateProvider.state( 'usersConfirmation', {
    url: '/users/confirmation',
    views: {
      "main": {
        controller: 'UsersConfirmationCtrl',
        templateUrl: 'usersConfirmation/usersConfirmation.tpl.html',
        title: "Confirmation de l'utilisateur"
      }
    },
    data:{ pageTitle: "UsersConfirmation" }
  });
})

.controller('UsersConfirmationCtrl', ['$scope', '$location', 'security', function($scope, $location, security){
  activationKey = $location.search().confirmation_token;
  if (!!activationKey) {
    security.activateUser(activationKey);
  }
  else {
    $location.url("/start");
  }
}]);

