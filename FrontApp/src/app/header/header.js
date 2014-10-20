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

.controller( 'HeaderCtrl', ['$scope', 'Alerts', 'AppText', 'headerDict', '$state', function ContribtueController( $scope, Alerts, AppText, headerDict, $state ){
  $scope.Alerts = Alerts;
  $scope.$state = $state;
  $scope.translate = function( string ){
    return AppText.translate( headerDict, string );
  };
}])

.constant('headerDict', {
  'contribute': {
    en: 'contribute',
    fr: 'contribuer'
  },
  'my_classes': {
    en: 'My classes',
    fr: 'Mes cours'
  },
  'search': {
    en: 'Search',
    fr: 'Rechercher'
  }
});


