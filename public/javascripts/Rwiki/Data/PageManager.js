Ext.ns('Rwiki.Data');

Rwiki.Data.PageManager = Ext.extend(Ext.util.Observable, {
  constructor: function() {
    if (Rwiki.Data.PageManager.caller !== Rwiki.Data.PageManager.getInstance) {
      throw new Error("There is no public constructor for Rwiki.Data.PageManager");
    }

    this.timeout = 10000;
    this.initEvents();
  },

  initEvents: function() {
    this.addEvents(
      'rwiki:beforePageLoad',
      'rwiki:pageLoaded',
      'rwiki:pageNotFound',

      'rwiki:beforePageSave',
      'rwiki:pageSaved',

      'rwiki:pageDeleted',
      'rwiki:pageCreated',
      'rwiki:pageRenamed'
    );
  },

  _onFailure: function(response, opts) {
    Rwiki.mask.hide();

    var window = new Rwiki.ExceptionWindow();
    window.showResponse(response);
  },

  loadPage: function(path) {
    var page = new Rwiki.Data.Page({ path: path });
    this.fireEvent('rwiki:beforePageLoad', page);

    Ext.Ajax.request({
      url: '/node',
      method: 'GET',
      params: { path: path },
      scope: this,
      timeout: this.timeout,
      success: function(response) {
        var data = Ext.decode(response.responseText);
        if (data.success) {
          var page = new Rwiki.Data.Page(data);
          this.fireEvent('rwiki:pageLoaded', page);
        } else {
          this.fireEvent('rwiki:pageNotFound', data.message);
        }
      },
      failure: this._onFailure
    });
  },

  createPage: function(parentPath, name) {
    Rwiki.mask.creatingPage(parentPath, name);

    Ext.Ajax.request({
      url: '/node',
      type: 'POST',
      params: {
        parentPath: parentPath,
        name: name
      },
      scope: this,
      timeout: this.timeout,
      success: function(response) {
        var data = Ext.decode(response.responseText);
        var node = new Rwiki.Data.Page(data);

        this.fireEvent('rwiki:pageCreated', node);
      },
      failure: this._onFailure
    });
  },

  savePage: function(path, rawContent) {
    var page = new Rwiki.Data.Page({ path: path });
    this.fireEvent('rwiki:beforePageSave', page);

    Ext.Ajax.request({
      url: '/node',
      method: 'PUT',
      params: {
        path: path,
        rawContent: rawContent
      },
      scope: this,
      timeout: this.timeout,
      success: function(response) {
        var data = Ext.decode(response.responseText);
        var page = new Rwiki.Data.Page(data);
        this.fireEvent('rwiki:pageSaved', page);
      },
      failure: this._onFailure
    });
  },

  renameNode: function(oldPath, newName) {
    Rwiki.mask.renamingPage(oldPath, newName);

    Ext.Ajax.request({
      url: '/node/rename',
      method: 'POST',
      params: {
        path: oldPath,
        newName: newName
      },
      scope: this,
      timeout: this.timeout,
      success: function(response) {
        var data = Ext.decode(response.responseText);
        var page = new Rwiki.Data.Page(data);

        this.fireEvent('rwiki:pageRenamed', page);
      },
      failure: this._onFailure
    });
  },

  deleteNode: function(path) {
    Rwiki.mask.deletingPage(path);

    Ext.Ajax.request({
      url: '/node',
      method: 'DELETE',
      params: { path: path },
      scope: this,
      timeout: this.timeout,
      success: function(response) {
        var data = Ext.decode(response.responseText);
        var page = new Rwiki.Data.Page(data);

        this.fireEvent('rwiki:pageDeleted', page);
      },
      failure: this._onFailure
    });
  },

  moveNode: function(path, newParentPath) {
    Rwiki.mask.movingPage(path, newParentPath);

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
      timeout: this.timeout,
      success: function(data) {
        var page = new Rwiki.Data.Page(data);

        Rwiki.mask.hide();
        self.fireEvent('rwiki:pageRenamed', page);
      },
      failure: this._onFailure
    });

    return Ext.util.JSON.decode(result.responseText);
  },

  isParent: function(parentPath, path) {
    var parentParts = parentPath.split('/');
    var pathParts = path.split('/');

    var result = true;
    var n = Math.min(parentParts.length, pathParts.length);
    var i;
    for (i = 0; i < n; i++) {
      if (parentParts[i] !== pathParts[i]) {
        result = false;
        break;
      }
    }

    return result;
  }
});

Rwiki.Data.PageManager._instance = null;

Rwiki.Data.PageManager.getInstance = function() {
  if (this._instance === null) {
    this._instance = new Rwiki.Data.PageManager();
  }

  return this._instance;
};
