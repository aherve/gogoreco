angular.module('security.login.form', [])

// The LoginFormController provides the behaviour behind a reusable form to allow users to authenticate.
// This controller and its template (login/form.tpl.html) are used in a modal dialog box by the security service.
.controller('LoginCtrl', ['$modalInstance', '$scope', 'security', 'localStorageService', '$location', '$window', function( $modalInstance, $scope, security, localStorageService, $location, $window) {
  // The model for this form 
  $scope.close = $modalInstance.close;
  $scope.loginUser = {};
  $scope.signupUser = {};
  $scope.state = {
    initialMode: true,
    emailSignupMode: false
  };

  $scope.facebookConnect = function(){
    localStorageService.set('back url', $location.url());
    $window.location.href = "/api/users/auth/facebook";
  };

  $scope.signup = function(){
    $scope.pendingRequest = true;
    security.signup($scope.signupUser.email, $scope.signupUser.password, $scope.signupUser.firstname, $scope.signupUser.lastname).then(function(data){
      $scope.pendingRequest = false;
    });
  };

  $scope.login = function() {
    return security.login($scope.loginUser.email, $scope.loginUser.password);
  };

  $scope.clearForm = function() {
    $scope.loginUser = {};
    $scope.signupUser = {};
  };

  $scope.cancelLogin = function() {
    security.cancelLogin();
  };

  $scope.showForgotPassword = function() {
    security.showForgotPassword();
  };
}]);
