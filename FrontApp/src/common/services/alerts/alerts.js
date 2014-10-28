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
    Alerts.getAlerts().splice( Alerts.getAlerts().indexOf( alert ), 1 );
  };
}])

.factory('Alerts', [function(){
  var alerts = [];

  var Alerts = {

    clear: function(){
      alerts = [];
    },

    getAlerts: function(){
      return alerts;
    },

    setAlertFromErr: function( err ){
      alerts = Object.keys( err.data.errors ).map( function( value, index ){
        return {
          msg: value + ': ' + err.data.errors[value],
          type: 'danger'
        };
      });
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
