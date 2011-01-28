Ext.ns('Rwiki');

Rwiki.NodeManager = Ext.extend(Ext.util.Observable, {
  constructor: function() {
    if (Rwiki.NodeManager.caller != Rwiki.NodeManager.getInstance) {
      throw new Error("There is no public constructor for Rwiki.NodeManager");
    }

    this.store = new Ext.data.JsonStore({
      restful: true,
      url: '/node',
      root: 'pages',
      idProperty: 'path',
      fields: ['path', 'baseName', 'rawContent', 'htmlContent']
    });

    var self = this;
    this.store.on('load', function(store, records) {
      self.fireEvent('rwiki:pageLoaded', records[0].data);
    });

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
    this.fireEvent('rwiki:beforePageLoad', path);
    this.store.load({params: {path: path}});
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
        self.fireEvent('rwiki:pageCreated', data);
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
        self.fireEvent('rwiki:pageSaved', data);
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
        self.fireEvent('rwiki:nodeRenamed', data);
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
        self.fireEvent('rwiki:nodeRenamed', data);
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
