angular.module( 'gogoreco.header', [
  'services.appText'
])

.directive('grHeader', [function(){
  return {
    restrict: 'A',
    controller: 'HeaderCtrl',
    templateUrl: 'header/header.tpl.html'
  };
}])

.controller( 'HeaderCtrl', ['$scope', 'Alerts', 'AppText', 'headerDict', '$state', 'security', function ContribtueController( $scope, Alerts, AppText, headerDict, $state, security ){
  $scope.Alerts = Alerts;
  $scope.$state = $state;
  $scope.security = security;
  $scope.translate = function( string ){
    return AppText.translate( headerDict, string );
  };
}])

.constant('headerDict', {
  'contribute': {
    en: 'Contribute',
    fr: 'Contribuer'
  },
  'recommendations': {
    en: 'Recommendations',
    fr: 'Recommandations'
  },
  'search': {
    en: 'Search',
    fr: 'Rechercher'
  }
});


