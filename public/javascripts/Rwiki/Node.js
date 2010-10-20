Ext.ns('Rwiki');

Rwiki.Node = Ext.extend(Ext.util.Observable, {
  constructor: function() {
    if (Rwiki.Node.caller != Rwiki.Node.getInstance) {
      throw new Error("There is no public constructor for Rwiki.Node");
    }

    this.initEvents();
  },

  initEvents: function() {
    this.addEvents('loadPage', 'pageLoaded', 'lastPageClosed');
    this.on('loadPage', this.loadPage);

    this.addEvents('createFolder', 'folderCreated');
    this.on('createFolder', this.createFolder);

    this.addEvents('createPage', 'pageCreated');
    this.on('createPage', this.createPage);

    this.addEvents('savePage', 'pageSaved');
    this.on('savePage', this.savePage);

    this.addEvents('renameNode', 'nodeRenamed');
    this.on('renameNode', this.renameNode);

    this.addEvents('deleteNode', 'nodeDeleted');
    this.on('deleteNode', this.deleteNode);

    this.addEvents('moveNode');
    this.on('moveNode', this.moveNode);
  },

  loadPage: function(path) {
    var self = this;
    
    $.ajax({
      type: 'GET',
      url: '/node',
      dataType: 'json',
      data: {
        path: path
      },
      success: function(data) {
        self.fireEvent('pageLoaded', data);
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
        self.fireEvent('folderCreated', data);
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
        self.fireEvent('pageCreated', data);
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
        self.fireEvent('pageSaved', data);
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
        self.fireEvent('nodeRenamed', data);
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
        self.fireEvent('nodeDeleted', data);
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
        self.fireEvent('nodeRenamed', data);
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

Rwiki.Node._instance = null;

Rwiki.Node.getInstance = function() {
  if (this._instance == null) {
    this._instance = new Rwiki.Node();
  }

  return this._instance;
};
