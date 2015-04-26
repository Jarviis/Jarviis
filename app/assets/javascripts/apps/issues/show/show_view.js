Jarviis.module("Issues.Show", function(Show, Jarviis, Backbone, Marionette, $, _){

  Show.Layout = Marionette.LayoutView.extend({
    template: "#show-issue-template",
    regions: {
      breadcrumbs: "#breadcrumbs",
      details: "#issue-details",
      comments: "#comments"
    }
  });

  Show.MissingIssue = Marionette.ItemView.extend({
    template: "#missing-issue-template"
  });

  Show.Issue = Marionette.ItemView.extend({
    template: "#issue-details-template",
    className: "row",
    events: {
      'click button#upload': 'upload',
      'click button#resolve': 'resolveIssue',
      'click button#open': 'openIssue',
      'click button#close': 'closeIssue',
      'click #description': 'editDescription'
    },
    modelEvents: {
      "change": "onModelChange"
    },
    editDescription: function (ev) {
      ev.stopPropagation();

      this.$('#description').toggle();
      this.$('#edit-description').toggle();
      this.$('#edit-description').editable('toggle');
    },
    hideDescription: function() {
      console.log('lala');
      this.$('#edit-description').toggle();
    },
    upload: function () {
      Jarviis.modalRegion.show(new Jarviis.Issues.New.Upload({model: this.model}));
    },
    resolveIssue: function () {
      this.model.resolve();
    },
    openIssue: function() {
      this.model.open();
    },
    closeIssue: function() {
      this.model.close();
    },
    onModelChange: function () {
      this.render();
    },
    onRender: function () {
      var self = this;
      this.$(".editable").editable({
        mode: "inline",
        type: 'text',
        emptytext: "Empty Field",
        showbuttons: "bottom",
        success: function(response, newValue) {
          self.model.save($(this).data('name'), newValue); //update backbone model
        }
      });

      var self = this;
      this.$('#edit-description').on('hidden', function () {
        $(this).toggle();
        self.$('#description').toggle();
      });
    }
  });
});

