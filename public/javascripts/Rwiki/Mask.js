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

