/**
 * Encapsulates all Ajax requests.
 */
Rwiki.Model = Ext.extend(Ext.util.Observable, {

  constructor: function(options) {
    Rwiki.Model.superclass.constructor.call(this, options);
  },

  loadPage: function(pageName, callback) {
    var self = this;

    $.ajax({
      type: 'GET',
      url: '/node/content',
      dataType: 'json',
      data: {
        pageName: pageName
      },
      success: function(data) {
        callback.apply(self, data);
      }
    });
  },

  createNode: function(parentFolderName, nodeBaseName, isFolder, callback) {
    var self = this;

    $.ajax({
      type: 'POST',
      url: '/node/create',
      dataType: 'json',
      data: {
        parentFolderName: parentFolderName,
        nodeBaseName: nodeBaseName,
        isFolder: isFolder
      },
      success: function(data) {
        callback.apply(self, data);
      }
    });
  },

  updatePage: function(pageName, content) {
    var self = this;

    $.ajax({
      type: 'POST',
      url: '/node/update',
      dataType: 'json',
      data: {
        pageName: pageName,
        content: content
      },
      success: function(data) {
        callback.apply(self, data);
      }
    });
  },

  renameNode: function(oldNodeName, newBaseName) {
    var self = this;
    
    $.ajax({
      type: 'POST',
      url: '/node/rename',
      dataType: 'json',
      data: {
        oldNodeName: oldNodeName,
        newBaseName: newBaseName
      },
      success: function(data) {
        callback.apply(self, data);
      }
    });
  },

  moveNode: function(nodeName, destFolderName) {
    var self = this;
    $.ajax({
      type: 'POST',
      url: '/node/move',
      dataType: 'json',
      data: {
        nodeName: nodeName,
        destFolderName: destFolderName
      },
      success: function(data) {
        callback.apply(self, data);
      }
    });
  },

  deleteNode: function(nodeName) {
    var self = this;
    
    $.ajax({
      type: 'POST',
      url: '/node/destroy',
      dataType: 'json',
      data: {
        nodeName: nodeName
      },
      success: function(data) {
        callback.apply(self, data);
      }
    });
  }
});
