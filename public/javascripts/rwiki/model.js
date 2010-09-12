/**
 * Encapsulates all Ajax requests.
 */
Rwiki.Model = Ext.extend(Ext.util.Observable, {

  // events
  PAGE_LOADED: 'pageLoaded',
  PAGE_CREATED: 'pageCreated',
  FOLDER_CREATED: 'folderCreated',
  NODE_MOVED: 'nodeMoved',
  NODE_RENAMED: 'nodeRenamed',
  NODE_DELETED: 'nodeDeleted',

  constructor: function(options) {
    Rwiki.Model.superclass.constructor.call(this, options);

    // define events
    this.addEvents(
      this.PAGE_LOADED,
      this.PAGE_CREATED,
      this.FOLDER_CREATED,
      this.NODE_MOVED,
      this.NODE_RENAMED,
      this.NODE_DELETED);
  },

  loadPage: function(pageName) {
    var self = this;

    $.ajax({
      type: 'GET',
      url: '/node/content',
      dataType: 'json',
      data: {
        pageName: pageName
      },
      success: function(data) {
        self.fireEvent(self.PAGE_LOADED, data);
      }
    });
  },

  createNode: function(parentFolderName, nodeBaseName, isFolder) {
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
        var eventName = isFolder ? self.FOLDER_CREATED : self.PAGE_CREATED;
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
        self.fireEvent(self.NODE_RENAMED, data);
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
        self.fireEvent(self.NODE_MOVED, nodeName, destFolderName);
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
