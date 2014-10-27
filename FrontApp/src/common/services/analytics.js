angular.module('services.analytics', [])

.factory('Analytics', [function(){
  var Analytics = {
    identify: function( user ){

      mixpanel.people.set_once({
        "$email": user.email
      });

      mixpanel.people.set({
        "id": user.id,
        "$first_name": user.firstname || null,
        "$last_name": user.lastname || null
      });

      // data passed with every event sent
      mixpanel.register({
      });
    },

    showLogin: function(){
      mixpanel.track("Show Login");
    },

    loginSuccess: function(){
      mixpanel.track("Login Success");
    },

    signupSuccess: function(){
      mixpanel.track("Signup Success");
    },

    confirmationMailSent: function(){
      mixpanel.track("Confirmation Mail Sent");
    },

    forgotPassword: function(){
      mixpanel.track("Show Forgot Password");
    },

    successChangePassword: function(){
      mixpanel.track("Success Change Password");
    },

    changePasswordMailSent: function(){
      mixpanel.track("Change Password Mail Sent");
    },

    cancelForgotPassword: function(){
      mixpanel.track("Cancel Forgot Password");
    },

    logout: function(){
      mixpanel.track("Logout");
    },

    home: function(){
      mixpanel.track("Home");
    },

    browse: function(){
      mixpanel.track("Browse");
    },

    selectSchool: function( school ){
      mixpanel.track("Select School", {
        school: school.name
      });
    },

    searchItem: function( item ){
      mixpanel.track("Search Item", {
        item: item.name
      });
    },

    searchTag: function( tagId ){
      mixpanel.track("Search Tag", {
        tag: tagId
      });
    },

    contribute: function(){
      mixpanel.track("Contribute");
    }


  };
  return Analytics;
}]);

