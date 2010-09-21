/**
 * Encapsulates all Ajax requests.
 */
Rwiki.Model = Ext.extend(Ext.util.Observable, {

  constructor: function(options) {
    Rwiki.Model.superclass.constructor.call(this, options);
  },

  loadPage: function(path, callback) {
    var self = this;

    $.ajax({
      type: 'GET',
      url: '/node',
      dataType: 'json',
      data: {
        path: path
      },
      success: function(data) {
        callback.call(self, data);
      }
    });
  },

  createNode: function(parentPath, name, isFolder, callback) {
    var self = this;

    $.ajax({
      type: 'POST',
      url: '/node',
      dataType: 'json',
      data: {
        parentPath: parentPath,
        name: name,
        isFolder: isFolder
      },
      success: function(data) {
        callback.call(self, data);
      }
    });
  },

  updatePage: function(path, rawContent, callback) {
    var self = this;

    $.ajax({
      type: 'PUT',
      url: '/node',
      dataType: 'json',
      data: {
        path: path,
        rawContent: rawContent
      },
      success: function(data) {
        callback.call(self, data);
      }
    });
  },

  renameNode: function(oldNodeName, newBaseName, callback) {
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
        callback.call(self, data);
      }
    });
  },

  moveNode: function(nodeName, destFolderName, callback) {
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
        callback.call(self, data);
      }
    });
  },

  deleteNode: function(nodeName, callback) {
    var self = this;
    
    $.ajax({
      type: 'POST',
      url: '/node/destroy',
      dataType: 'json',
      data: {
        nodeName: nodeName
      },
      success: function(data) {
        callback.call(self, data);
      }
    });
  }
});
