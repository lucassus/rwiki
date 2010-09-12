/**
 * Encapsulates all Ajax requests.
 */
Rwiki.Model = Ext.extend(Ext.util.Observable, {

  // events
  NODE_LOADED: 'nodeLoaded',
  PAGE_CREATED: 'pageCreated',
  DIRECTORY_CREATED: 'directoryCreated',
  NODE_MOVED: 'nodeMoved',
  NODE_RENAMED: 'nodeRenamed',
  NODE_DELETED: 'nodeDeleted',

  constructor: function(options) {
    Rwiki.Model.superclass.constructor.call(this, options);

    // define events
    this.addEvents(
      this.NODE_LOADED,
      this.PAGE_CREATED,
      this.DIRECTORY_CREATED,
      this.NODE_MOVED,
      this.NODE_RENAMED,
      this.NODE_DELETED);
  },

  loadNode: function(pageName) {
    var self = this;

    $.ajax({
      type: 'GET',
      url: '/node/content',
      dataType: 'json',
      data: {
        pageName: pageName
      },
      success: function(data) {
        self.fireEvent(self.NODE_LOADED, pageName, data);
      }
    });
  },

  createNode: function(parentFolderName, nodeBaseName, isDirectory) {
    var self = this;

    $.ajax({
      type: 'POST',
      url: '/node/create',
      dataType: 'json',
      data: {
        parentDirectoryName: parentFolderName,
        nodeBaseName: nodeBaseName,
        isDirectory: isDirectory
      },
      success: function(data) {
        var eventName = isDirectory ? self.DIRECTORY_CREATED : self.PAGE_CREATED;
        self.fireEvent(eventName, data.parentFolderName, data.newNodeName);
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
        var newNodeName = data.id;
        self.fireEvent(self.NODE_RENAMED, oldNodeName, newNodeName);
      }
    });
  },

  moveNode: function(nodeName, destDirName) {
    var self = this;
    $.ajax({
      type: 'POST',
      url: '/node/move',
      dataType: 'json',
      data: {
        nodeName: nodeName,
        destDirName: destDirName
      },
      success: function(data) {
        self.fireEvent(self.NODE_MOVED, nodeName, destDirName);
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
        self.fireEvent(self.NODE_DELETED, nodeName);
      }
    });
  }
});
