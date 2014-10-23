angular.module('resources.item', [
  'restangular'
])

.run(['Restangular', function( Restangular ){

  /**
   * Defines some cool function for item
   **/

  var addTags = function( tag_names ){
    var item = this;
    var params = {
      tag_names: tag_names
    };
    return Restangular.one('items', this.id).customPOST( params, 'tags' );
  };

  var removeTags = function( tag_names ){
    var item = this;
    var params = {
      tag_names: tag_names
    };
    return Restangular.one('items', this.id).customDELETE( params, 'tags' );
  };

  var setTags = function( tag_names ){
    var item = this;
    var params = {
      tag_names: tag_names
    };
    return Restangular.one('items', this.id).customPUT( params, 'tags' );
  };

  var commentItem = function( content ){
    var item = this;
    var params = {
      content: content
    };
    return Restangular.one('items', item.id).all('comments').customPOST( params, 'create' );
  };

  var evalItem = function( score ){
    var item = this;
    var params = {
      content: score
    };
    return Restangular.one('items', item.id).customPOST( params, 'evals' );
  };

  /**
   * Extends the item model 
   **/

  var extendItem = function(item) {
    return angular.extend(item, {
      addTags: addTags,
      removeTags: removeTags,
      setTags: setTags,
      commentItem: commentItem
    });
  };

  Restangular.extendModel('items', function (item) {
    return extendItem(item);
  });

}])

.factory('Item', ['Restangular', function( Restangular ){

  /**
   * Adds methods to Item object 
   **/

  var Item = {
    typeahead: function( search, nmax, tag_ids, school_ids ){
      var params = {
        search: search,
        nmax: nmax,
        tag_ids: tag_ids,
        school_ids: school_ids,
        entities: {
          item: {
            name: true
          }
        }
      };
      return Restangular.all('items').customPOST( params, 'typeahead' ).then( function( response ){
        return response.items || [];
      });
    },

    create: function( school_names, item_name, tag_names, eval_score, comment_content ){
      var params = {
        school_names: school_names,
        item_name: item_name,
        tag_names: tag_names,
        eval_score: eval_score,
        comment_content: comment_content,
        entities: {
          item: {
            "comments": true,
            "comments_count": true,
            "current_user_commented": true,
            "current_user_score": true,
            "id": true,
            "likers_count": true,
            "lovers_count": true,
            "haters_count": true,
            "mehers_count": true,
            "name": true,
            "tags": true
          }
        }
      };
      return Restangular.all('items').customPOST( params, 'create' );
    },

    get: function( id ){
      var params = {
        entities: {
          item: {
            "comments": true,
            "comments_count": true,
            "current_user_commented": true,
            "current_user_score": true,
            "id": true,
            "likers_count": true,
            "lovers_count": true,
            "haters_count": true,
            "mehers_count": true,
            "name": true,
            "tags": true
          }
        }
      };
      return Restangular.one('items', id).post();
    },

    addTagsById: function( tag_names, id ){
      var params = {
        tag_names: tag_names
      };
      return Restangular.one('items', id).customPOST( params, 'tags' );
    },


    latest_evaluated: function( nmax ){
      var params = {
        entities: {
          nmax: nmax || 10,
          item: {
            "comments": true,
            "comments_count": true,
            "current_user_commented": false,
            "current_user_score": false,
            "id": true,
            "likers_count": true,
            "lovers_count": true,
            "haters_count": true,
            "mehers_count": true,
            "name": true,
            "tags": true
          },
          comment: {
            content: true
          },
          tag: {
            name: true
          }
        }
      };
      return Restangular.all( 'items' ).customPOST( params, 'latest_evaluated' );
    }

  };
  return Item;
}]);
