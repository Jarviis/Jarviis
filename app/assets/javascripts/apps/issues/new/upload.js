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
      'click .upload': 'upload',
      'paste #url': 'paste',
      'drop #drop-zone': 'drop',
      'dragenter #drop-zone': 'highDropZone',
      'dragleave #drop-zone': 'unhighDropZone',
      'dragover #drop-zone': 'dragOver'
    },

    initialize: function () {
      this.collection = new Backbone.Collection();

      this.collection.on('add', this.renderList, this);
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

    highDropZone: function (ev) {
      ev.preventDefault();
    },

    dragOver: function (ev) { ev.preventDefault(); },

    unhighDropZone: function(ev) {
      ev.preventDefault();
    },

    drop: function (ev) {
      var e = null,
          picture = null;

      ev.preventDefault();
      ev.stopPropagation();

      e = ev.originalEvent;
      e.dataTransfer.dropEffect = 'copy';

      file = e.dataTransfer.files[0];

      this.addFiles({
        name: file.name,
        file: file
      });

    },

    paste: function (ev) {
      var self = this;
      var $el = this.$(ev.currentTarget);

      setTimeout(function () {
        var url = $el.val();
        var file = _.last(url.split('/'));
        self.addFiles({
          name: url,
          file: file,
          remote_image_url: true
        });
      }, 0);
    },

    addFiles: function (attributes) {
      console.log(attributes);
      this.collection.add(attributes);
    },

    upload: function () {
      var url = this.url();

      if (this.collection.length) {
        this.collection.each(function (model) {
          var formData = new FormData();
          if (model.get('remote_image_url')) {
            formData.append('remote_image_url', model.get('name'));
            formData.append('attachment[filename]', model.get('file'));
          } else {
            formData.append('attachment[filename]', model.get('file'));
          }

          $.ajax({
            url: url,
            type: 'POST',
            contentType: false,
            processData: false,
            data: formData
          })
          .done(function () {
          })
          .fail(function() {
            console.log(arguments)
          });
        }, this);

      } else {
        alertify.log("Please add a file to the upload queue.")
      }
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
      this.$('.upload-files').show();
    },

    exit: function () {
      Jarviis.modalRegion.reset();
    }

  });
});

