angular.module( 'gogoreco.cursus', [])

.config(function config( $stateProvider ) {
  $stateProvider.state( 'cursus', {
    url: '/cursus',
    views: {
      "main": {
        controller: 'CursusCtrl',
        templateUrl: 'cursus/cursus.tpl.html'
      }
    },
    data:{ pageTitle: 'Cursus' }
  });
})

/**
 * And of course we define a controller for our route.
 */
.controller( 'CursusCtrl', ['$scope', function CursusController( $scope ) {
}]);


