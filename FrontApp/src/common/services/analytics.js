angular.module('services.analytics', [])

.factory('Analytics', [function(){
  var Analytics = {
    showLogin: function(){
    },

    identify: function(){
    },
    
    signupSuccess: function(){
    },

    confirmationMailSent: function(){
    },

    forgotPassword: function(){
    },

    successChangePassword: function(){
    },
    
    cancelForgotPassword: function(){
    }
  };
  return Analytics;
}]);

