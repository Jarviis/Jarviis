Jarviis.module("Issues.New", function(New, Jarviis, Backbone, Marionette, $, _){

  New.Upload = Marionette.ItemView.extend({
    template: "#new-upload",

    ui: {
      content: '.modal-content',
      minimized: '.modal-minimized'
    },

    events: {
      'click #close': 'exit',
      'click #minimize': 'minimize',
      'click #maximize': 'maximize',
      'click .upload': 'upload'
    },

    initialize: function () {
      this.r = new Flow({
        target: this.url,
      });

      this.collection = new Backbone.Collection();

      this.collection.on('add', this.renderList, this);
      this.listenTo(this.r, 'filesAdded', _.bind(this.fileAdded, this))
    },

    url: function () {
      var id = Backbone.history.fragment.split('/')[1];
      return '/api/v1/issues/' + id + '/attachments';
    },

    maximize: function () {
      this.ui.minimized.hide();
      this.ui.content.slideDown(100);
    },

    minimize: function () {
      var that = this;
      this.ui.content.slideUp(100, function () {
        that.ui.minimized.show();
      });
    },

    upload: function () {
      if (this.collection.length) {
        $('#controls').hide();

        this.collection.each(function (file) {
          $.ajax({
            url: this.url(),
            data: {
              file: file.get('file'),
              filename: file.get('name')
            },
            contentType: false,
            processData: false,
            type: 'POST'
          });
        }, this);
      } else {
        alertify.log('Please choose some files to upload.')
      }
    },

    fileSuccess: function () {
      console.log(arguments);
    },

    fileProgress: function (progress) {
      $('.progress-bar').css('width', progress + "%");
    },

    fileAdded: function (files) {
      $('.upload-files').show();

      this.collection.add(files);
    },

    renderList: function (model) {
      model.set({status: "waiting"});

      var html = "";
      var template = _.template('<a href="#" class="list-group-item list-group-item-success">' +
                     '<span class="badge alert-success pull-right"><%- status %></span><%- name %></a>');

      this.collection.each(function (file) {
        html += template({
          name: file.get('name'),
          status: file.get('status')
        });
      });

      $('#processed-files').html(html);
    },

    exit: function () {
      Jarviis.modalRegion.reset();
    },

    onDomRefresh: function () {
      this.r.assignDrop(this.$('#drop-zone'));
    }
  });
});

