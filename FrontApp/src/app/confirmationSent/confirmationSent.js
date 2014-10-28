angular.module( 'gogoreco.confirmationSent', [
  'services.analytics'
])

.config(['$stateProvider', function config( $stateProvider ) {
  $stateProvider.state( 'confirmationSent', {
    url: '/confirmationSent',
    views: {
      "main": {
        controller: 'ConfirmationSentCtrl',
        templateUrl: 'confirmationSent/confirmationSent.tpl.html'
      }
    },
    data:{ pageTitle: 'ConfirmationSent' }
  });
}])


.controller('ConfirmationSentCtrl', ['$scope', function( $scope ){
}]);

