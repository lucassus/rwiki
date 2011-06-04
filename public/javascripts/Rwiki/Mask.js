Ext.ns('Rwiki');

/**
 * Usage:
 *
 * Rwiki.mask = new Rwiki.Mask(Ext.getBody());
 *
 * Rwiki.mask.on(container).loadingPage(path);
 * Rwiki.mask.savingPage(path);
 * Rwiki.mask.hide();
 */
Rwiki.Mask = function(defaultContainer) {
  this._defaultContainer = defaultContainer;
  this._container = this._defaultContainer;
};

Rwiki.Mask.prototype = {
  on: function(container) {
    this._container = container;
    return this;
  },

  /**
   * Displays loading page mask.
   */
  loadingPage: function(path) {
    this._mask('Loading page: ' + path);
  },

  /**
   * Displays saving page mask.
   */
  savingPage: function(path) {
    this._mask('Saving page: ' + path);
  },

  /**
   * Displays creating page mask.
   */
  creatingPage: function(parentPath, name) {
    this._mask('Creating page: ' + parentPath + '/' + name);
  },

  /**
   * Displays deleting page mask.
   */
  deletingPage: function(path) {
    this._mask('Deleting page:' + path);
  },

  /**
   * Displays renaming page mask.
   */
  renamingPage: function(oldPath, newName) {
    this._mask('Renaming page: ' + oldPath + ' to: ' + newName);
  },

  /**
   * Displays moving page mask.
   */
  movingPage: function(path, newParentPath) {
    this._mask('Moving page: ' + path + ' to: ' + newParentPath);
  },

  /**
   * Hides the mask and sets the container to default value;
   */
  hide: function() {
    this._container.unmask();
    this._container = this._defaultContainer;
  },

  // private functions

  _mask: function(message) {
    this._container.mask(message);
  }
};

