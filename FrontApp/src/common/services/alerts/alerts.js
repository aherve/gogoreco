angular.module('services.alerts', [])

.directive('grAlert', [function(){
  return {
    restrict: 'A',
    controller: 'AlertCtrl', 
    templateUrl: 'services/alerts/alert.tpl.html'
  };
}])

.controller('AlertCtrl', ['$scope', 'Alerts', function( $scope, Alerts ){
  $scope.Alerts = Alerts;
  $scope.removeAlert = function( alert ){
    Alerts.messages.splice( Alerts.messages.indexOf( alert ), 1 );
  };
}])

.factory('Alerts', [function(){
  var alerts = [
  ];

  var Alerts = {
    getAlerts: function(){
      return alerts;
    },

    setAlert: function( type, msg ){
      alerts = [{
        type: type,
        msg: msg
      }];
    }
  };
  return Alerts;
}]);
