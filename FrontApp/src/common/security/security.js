// Based loosely around work by Witold Szczerba - https://github.com/witoldsz/angular-http-auth
angular.module('security.service', [
  'security.retryQueue',    // Keeps track of failed requests that need to be retried once the user logs in
  'security.forgotPassword',
  'security.login'         // Contains the login form template and controller
])

.factory('security', ['Analytics', 'Restangular', '$q', '$location', 'securityRetryQueue', '$modal', '$rootScope', function(Analytics, Restangular, $q, $location, queue, $modal, $rootScope) {

  // Redirect to the given url (defaults to '/')
  function redirect(url) {
    url = url || '/start';
    $location.path( url );
  }

  // Login form dialog stuff
  var loginModal = null;
  function openLoginModal() {
    if ( loginModal ) {
      throw new Error('Trying to open a modal that is already open!');
    }
    loginModal = $modal.open({
      templateUrl: 'security/login/login.tpl.html',
      controller : 'LoginCtrl',
      windowClass : 'show'
    });

    loginModal.result.then(function(success){
      onLoginModalClose(success);
    }, function(error){
      loginModal = null;
      queue.cancelAll();
      redirect();
    });
  }

  function closeEmailLoginModal(success) {
    if (loginModal) {
      loginModal.close(success);
    }
  }

  function onLoginModalClose(success) {
    loginModal = null;
    if ( success ) {
      $rootScope.$broadcast('login success');
      queue.retryAll();
      Analytics.loginSuccess();
    } else {
      queue.cancelAll();
      redirect();
    }
  }

  // forgot password dialog stuff
  var forgotPasswordModal = null;
  function openForgotPasswordModal () {
    if ( forgotPasswordModal ) {
      throw new Error('Trying to open a modal that is already open!');
    }
    forgotPasswordModal = $modal.open({
      templateUrl: 'security/forgotPassword/forgotPassword.tpl.html',
      controller : 'ForgotPasswordFormController',
      windowClass : 'show'
    });

    forgotPasswordModal.result.then(function(success){
      onForgotPasswordModalClose(success);
    }, function(error){
      forgotPasswordModal = null;
      queue.cancelAll();
    });
  }


  function closeForgotPasswordModal(success) {
    if (forgotPasswordModal) {
      forgotPasswordModal.close(success);
    }
  }

  function onForgotPasswordModalClose(success) {
    forgotPasswordModal = null;
    if ( success ) {
      Analytics.changePasswordMailSent();
    } else {
      queue.cancelAll();
    }
  }

  // Register a handler for when an item is added to the retry queue
  queue.onItemAddedCallbacks.push(function(retryItem) {
    if ( queue.hasMore() ) {
      service.showLogin();
    }
  });

  // The public API of the service
  var service = {

    // Get the first reason for needing a login
    getLoginReason: function() {
      return queue.retryReason();
    },

    signup: function(email, password, firstname, lastname){
      var user = {
        email: email,
        password: password,
        password_confirmation: password,
        firstname: firstname,
        lastname: lastname
      };
      return Restangular.all('users').post({user: user}).then(function(response) {
        service.currentUser = response.user;
        try {
          Analytics.identify( response.user );
        }
        catch( err ){
          console.log( err );
        }

        Analytics.signupSuccess();
        Analytics.confirmationMailSent();

        closeEmailLoginModal(true);
        redirect('/confirmationSent');

        return {success: true};
      });
    },

    //Activate the user
    activateUser: function(activationToken) {
      return Restangular.all('users')
      .customGET('confirmation', {"confirmation_token": activationToken})
      .then(function(response) {
        redirect("/start");
      }, function(error) {
        redirect("/start");
      });
    },

    // Show the modal login dialog
    showLogin: function() {
      openLoginModal();
      Analytics.showLogin();
    },

    // open forgot password modal
    showForgotPassword: function(){
      openForgotPasswordModal();
      Analytics.forgotPassword();
    },

    cancelForgotPassword: function(){
      closeForgotPasswordModal(false);
      Analytics.cancelForgotPassword();
    },

    closeForgotPasswordModalService: function(){
      closeForgotPasswordModal(true);
    },

    // Attempt to authenticate a user by the given email and password
    login: function(email, password) {
      var params = {
        entities: {
          user: {
            firstname: true,
            lastname: true
          }
        }
      };
      var user = {email: email, password: password};
      Restangular.all('users').all('sign_in').post({user: user}).then(function(response) {
        return Restangular.all('users').customPOST(params, 'me').then( function( response ){
          service.currentUser = response.user;
          if ( service.isAuthenticated() ) {
            $rootScope.$broadcast('login success');
            closeEmailLoginModal(true);
            Analytics.loginSuccess();
          }
          return service.isAuthenticated();
        });
      });
    },

    // Give up trying to login and clear the retry queue
    cancelLogin: function() {
      closeEmailLoginModal(false);
      redirect();
    },

    // Logout the current user and redirect
    logout: function(redirectTo) {
      return Restangular.all('users').customGET('sign_out').then(function() {
        $rootScope.$broadcast('logout');
        service.currentUser = null;
        Analytics.logout();
        redirect(redirectTo);
      });
    },

    // Ask the backend to see if a user is already authenticated - this may be from a previous session.
    requestCurrentUser: function() {
      if ( service.isAuthenticated() ) {
        Analytics.identify( service.currentUser );
        return $q.when(service.currentUser);
      } else {
        var params = {
          entities: {
            user: {
              firstname: true,
              lastname: true
            }
          }
        };
        return Restangular.all('users').customPOST(params, 'me' ).then(function(response) {
          service.currentUser = response.user;
          Analytics.identify( response.user );
          return service.currentUser;
        }, function( err ){
          return null;
        });
      }
    },

    forgotPassword: function(email){
      return Restangular.all('users').all("password").post({user: {email:email}}).then(function(response) {
        service.closeForgotPasswordModalService();
        Analytics.successChangePassword();
        return response;
      }, function(x){
        return {success: false};
      });
    },

    // Information about the current user
    currentUser: null,

    // Is the current user authenticated?
    isAuthenticated: function(){
      return !!service.currentUser;
    },

    // Is the current user an adminstrator?
    isAdmin: function() {
      return !!(service.currentUser && service.currentUser.admin);
    }
  };

  return service;
}]);
