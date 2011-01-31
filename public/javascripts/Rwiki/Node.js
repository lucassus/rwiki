Ext.ns('Rwiki');

Rwiki.Node = function(data) {
  this._data = data;
};

Rwiki.Node.prototype = {

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
