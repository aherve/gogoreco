angular.module('services.analytics', [])

.factory('Analytics', [function(){
  var Analytics = {
    identify: function( user ){

      mixpanel.identify( user.id );
      mixpanel.people.set({
        "id": user.id,
        "$first_name": user.firstname || null,
        "$email": user.email || null,
        "$last_name": user.lastname || null
      });

      /*
      mixpanel.people.set_once({
      });

      // data passed with every event sent
      mixpanel.register({
      });
      */
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
    },

    createItem: function( item ){
      mixpanel.track("Create Item", {
        item_id: item.id,
        item_name: item.name,
        school: item.schools ? item.schools[0].name : null
      });
    },

    tagItem: function( item ){
      mixpanel.track("Tag Item", {
        item_id: item.id,
        item_name: item.name
      });
    },

    evalItem: function( item, score ){
      mixpanel.track("Evaluate Item", {
        item_name: item.name,
        item_id: item.id,
        score: score
      });
    }

  };
  return Analytics;
}]);

