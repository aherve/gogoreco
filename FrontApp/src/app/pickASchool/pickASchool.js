angular.module( 'gogoreco.pickASchool', [])

.config(['securityAuthorizationProvider', '$stateProvider', function config( securityAuthorizationProvider, $stateProvider ) {
  $stateProvider.state( 'pickASchool', {
    url: '/pickASchool',
    views: {
      "main": {
        controller: 'PickASchoolCtrl',
        templateUrl: 'pickASchool/pickASchool.tpl.html'
      }
    },
    data:{ pageTitle: 'PickASchool' },
    resolve: {
      schools: ['School', function( School ){
        return School.index();
      }],
      authenticatedUser: securityAuthorizationProvider.requireAuthenticatedUser
    }
  });
}])

/**
 * And of course we define a controller for our route.
 */
.controller( 'PickASchoolCtrl', ['$scope', 'schools', 'Analytics', '$rootScope', function PickASchoolController( $scope, schools, Analytics, $rootScope ) {

  $scope.addingMode = false;
  Analytics.pickASchool();
  $scope.schools = schools.schools;

  $scope.selectSchool = function( school ){
    $rootScope.school = school;
    $scope.nav( '/contribute' );
  };

}]);

