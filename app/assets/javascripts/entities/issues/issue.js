Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _){

  var states = [
    'Open',
    'Resolved',
    'Closed',
    'Wontfix'
  ];

  Entities.Issue = Backbone.Model.extend({
    urlRoot: '/api/'+apiVer+'/issues',

    parse: function(data) {
      data.status = states[data.state];
      return data;
    },

    resolve: function () {
      this.changeState('resolve');
    },

    open: function() {
      this.changeState('open');
    },

    close: function() {
      this.changeState('close');
    },

    changeState: function (action) {
      var url = '/api/'+apiVer+'/issues/'+this.get('id')+'/'+action,
          self = this;

      $.ajax({url: url, type: "POST"})
       .done(function (data) {
         if(!data.errors)
           self.set(data);
       });
    }
  });

  var API = {
    getIssueEntity: function(issueId){
      var issue = new Entities.Issue({id: issueId}),
          defer = $.Deferred();

      issue.fetch({
        success: function(data){
          defer.resolve(data);
        },
        error: function(){
          defer.resolve(undefined);
        }
      });

      return defer.promise();
    },
  };

  Jarviis.reqres.setHandler("issue:entity", function(id){
    return API.getIssueEntity(id);
  });
});
