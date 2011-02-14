Ext.ns('Rwiki.Data');

/**
 * Transfer object used in Rwiki events handlers
 * @param data
 */
Rwiki.Data.Page = function(data) {
  this._data = data;
};

Rwiki.Data.Page.prototype = {

  /**
   * Returns data binded by ajax event handler 
   */
  getData: function() {
    return this._data;
  },

  /**
   * Returns node's html content
   */
  getHtmlContent: function() {
    return this._data.htmlContent;
  },

  /**
   * Returns node's raw content
   */
  getRawContent: function() {
    return this._data.rawContent;
  },

  /**
   * Return node's path
   */
  getPath: function() {
    return this._data.path;
  },

  /**
   * Returns node's parent path
   */
  getParentPath: function() {
    var paths = this.getPath().split('/');
    paths.pop();
    
    return paths.join('/');
  },

  /**
   * Returns node's file name
   */
  getBaseName: function() {
    return this.getPath().split('/').pop();
  },

  /**
   * Returns node's title displayed on tree panel or tab panel
   */
  getTitle: function() {
    return this.getBaseName().replace(new RegExp('\.txt$'), '');
  }

};
