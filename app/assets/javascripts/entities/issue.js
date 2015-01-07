Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _){
  Entities.Issue = Backbone.Model.extend({
    urlRoot: '/api/'+apiVer+'/issues',
    parse: function(data) {
      data.status = Jarviis.states[data.state];
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
      var url = '/api/'+apiVer+'/issues/'+this.get('id')+'/'+action;
      var self = this;
      $.ajax({url: url, type: "POST"})
        .done(function (data) {
          if(!data.errors)
            self.set(data);
        });
    }
  });
  Entities.IssueCollection = Backbone.Collection.extend({
    model: Jarviis.Entities.Issue,
    url: function() {
      return '/api/'+apiVer+'/issues';
    },
    initialize: function (options) {
      this.options = options;
    }
  });

  var API = {
    getIssueEntity: function(issueId){
      var issue = new Entities.Issue({id: issueId});
      var defer = $.Deferred();
      issue.fetch({
        success: function(data){
          defer.resolve(data);
        },
        error: function(data){
          defer.resolve(undefined);
        }
      });
      return defer.promise();
    },
    getIssuesEntity: function (data) {
      var issues = new Jarviis.Entities.IssueCollection();
      issues.fetch({data: data});
      return issues;
    }
  }

  Jarviis.reqres.setHandler("issue:entity", function(id){
    return API.getIssueEntity(id);
  });

  Jarviis.reqres.setHandler("issues:entity", function (data) {
    return API.getIssuesEntity(data);
  });
});
