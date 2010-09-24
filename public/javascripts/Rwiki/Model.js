Ext.ns('Rwiki');

/**
 * Encapsulates all Ajax requests.
 * @deprecated
 */
Rwiki.Model = Ext.extend(Ext.util.Observable, {

  constructor: function(options) {
    Rwiki.Model.superclass.constructor.call(this, options);
  },

  renameNode: function(oldPath, newPath, callback) {
    var self = this;
    
    $.ajax({
      type: 'POST',
      url: '/node/rename',
      dataType: 'json',
      data: {
        oldPath: oldPath,
        newPath: newPath
      },
      success: function(data) {
        callback.call(self, data);
      }
    });
  },

  moveNode: function(path, destFolderPath, callback) {
    var self = this;
    $.ajax({
      type: 'POST',
      url: '/node/move',
      dataType: 'json',
      data: {
        path: path,
        destFolderPath: destFolderPath
      },
      success: function(data) {
        callback.call(self, data);
      }
    });
  }
  
});
