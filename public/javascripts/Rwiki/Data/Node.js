Ext.ns('Rwiki.Data');

Rwiki.Data.Node = function(data) {
  this._data = data;
};

Rwiki.Data.Node.prototype = {

  getData: function() {
    return this._data;
  },

  getHtmlContent: function() {
    return this._data.htmlContent;
  },

  getRawContent: function() {
    return this._data.rawContent;
  },

  getPath: function() {
    return this._data.path;
  },

  // TODO get parent path from the path
  getParentPath: function() {
    return this._data.parentPath;
  },

  getBaseName: function() {
    return this.getPath().split('/').pop();
  },

  getTitle: function() {
    return this.getBaseName().replace(new RegExp('\.txt$'), '');
  }

};
