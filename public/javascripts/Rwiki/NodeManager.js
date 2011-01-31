Ext.ns('Rwiki');

Rwiki.NodeManager = Ext.extend(Ext.util.Observable, {
  constructor: function() {
    if (Rwiki.NodeManager.caller != Rwiki.NodeManager.getInstance) {
      throw new Error("There is no public constructor for Rwiki.NodeManager");
    }

    this.initEvents();
  },

  initEvents: function() {
    this.addEvents(
      'rwiki:beforePageLoad',
      'rwiki:pageLoaded',
      'rwiki:nodeDeleted',
      'rwiki:folderCreated',
      'rwiki:pageCreated',
      'rwiki:pageSaved',
      'rwiki:nodeRenamed',
      'rwiki:lastPageClosed'
    );
  },

loadPage: function(path) {
    var self = this;

    var page = new Rwiki.Node({ path: path });
    self.fireEvent('rwiki:beforePageLoad', page);
        
    $.ajax({
      type: 'GET',
      url: '/node',
      dataType: 'json',
      data: {
        path: path
      },
      success: function(data) {
        page = new Rwiki.Node(data);
        self.fireEvent('rwiki:pageLoaded', page);
      }
    });
  },

  createFolder: function(parentPath, name) {
    var self = this;

    $.ajax({
      type: 'POST',
      url: '/node',
      dataType: 'json',
      data: {
        parentPath: parentPath,
        name: name,
        isFolder: true
      },
      success: function(data) {
        self.fireEvent('rwiki:folderCreated', data);
      }
    });
  },
  
  createPage: function(parentPath, name) {
    var self = this;
    
    $.ajax({
      type: 'POST',
      url: '/node',
      dataType: 'json',
      data: {
        parentPath: parentPath,
        name: name,
        isFolder: false
      },
      success: function(data) {
        var page = new Rwiki.Node(data);
        self.fireEvent('rwiki:pageCreated', page);
      }
    });
  },

  savePage: function(path, rawContent) {
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
        var page = new Rwiki.Node(data);
        self.fireEvent('rwiki:pageSaved', page);
      }
    });
  },

  renameNode: function(oldPath, newName) {
    var self = this;

    $.ajax({
      type: 'POST',
      url: '/node/rename',
      dataType: 'json',
      data: {
        path: oldPath,
        newName: newName
      },
      success: function(data) {
        var page = new Rwiki.Node(data);
        self.fireEvent('rwiki:nodeRenamed', page);
      }
    });
  },

  deleteNode: function(path) {
    var self = this;
    
    $.ajax({
      type: 'DELETE',
      url: '/node?path=' + path,
      dataType: 'json',
      success: function(data) {
        self.fireEvent('rwiki:nodeDeleted', data);
      }
    });
  },

  moveNode: function(path, newParentPath) {
    var self = this;

    var result = $.ajax({
      type: 'PUT',
      url: '/node/move',
      dataType: 'json',
      async: false,
      data: {
        path: path,
        newParentPath: newParentPath
      },
      success: function(data) {
        var page = new Rwiki.Node(data);
        self.fireEvent('rwiki:nodeRenamed', page);
      }
    });

    return Ext.util.JSON.decode(result.responseText);
  },

  isParent: function(parentPath, path) {
    var parentParts = parentPath.split('/');
    var pathParts = path.split('/');

    var result = true;
    var n = Math.min(parentParts.length, pathParts.length);
    for (var i = 0; i < n; i++) {
      if (parentParts[i] != pathParts[i]) {
        result = false;
        break;
      }
    }

    return result;
  }
});

Rwiki.NodeManager._instance = null;

Rwiki.NodeManager.getInstance = function() {
  if (this._instance == null) {
    this._instance = new Rwiki.NodeManager();
  }

  return this._instance;
};
