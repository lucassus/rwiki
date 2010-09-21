Rwiki.EditorPanel.Editor = function(container) {
  var self = this;

  this.container = container;
  this.enabled = false;

  // hack for FF, clear text area on load
  this.container.val('');

  this.container.bind('keydown', function() {
    return self.enabled;
  });

  var textileSettings = {
    nameSpace: "textile", // Useful to prevent multi-instances CSS conflict
    onShiftEnter: {keepDefault:false, replaceWith:'\n\n'},
    markupSet: [
      {name:'Heading 1', key:'1', openWith:'h1(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
      {name:'Heading 2', key:'2', openWith:'h2(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
      {name:'Heading 3', key:'3', openWith:'h3(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
      {name:'Heading 4', key:'4', openWith:'h4(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
      {name:'Heading 5', key:'5', openWith:'h5(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
      {name:'Heading 6', key:'6', openWith:'h6(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
      {name:'Paragraph', key:'P', openWith:'p(!(([![Class]!]))!). '},
      {separator:'---------------' },
      {name:'Bold', key:'B', closeWith:'*', openWith:'*'},
      {name:'Italic', key:'I', closeWith:'_', openWith:'_'},
      {name:'Stroke through', key:'S', closeWith:'-', openWith:'-'},
      {separator:'---------------' },
      {name:'Bulleted list', openWith:'(!(* |!|*)!)'},
      {name:'Numeric list', openWith:'(!(# |!|#)!)'},
      {separator:'---------------' },
      {name:'Picture', replaceWith:'![![Source:!:http://]!]([![Alternative text]!])!'},
      {name:'Link', openWith:'"', closeWith:'([![Title]!])":[![Link:!:http://]!]', placeHolder:'Your text to link here...' },
      {separator:'---------------' },
      {name:'Quotes', openWith:'bq(!(([![Class]!]))!). '},
      {separator:'---------------' },
      {name:'Code', openWith:'<code>\n', closeWith:'\n</code>'},
      {name:'Ruby Code', openWith:'<code lang="ruby">\n', closeWith:'\n</code>'},
      {name:'JavaScript Code', openWith:'<code lang="javascript">\n', closeWith:'\n</code>'},
      {name:'HTML Code', openWith:'<code lang="html">\n', closeWith:'\n</code>'},
      {name:'Css Code', openWith:'<code lang="css">\n', closeWith:'\n</code>'}
    ],
    resizeHandle: false,
    afterInsert: function() {
      self.container.trigger('contentChanged');
    }
  };

  container.markItUp(textileSettings);

  var timeout = null;
  this.container.bind('keyup', function() {
    if (!self.enabled) {
      return false;
    }

    clearTimeout(timeout);
    timeout = setTimeout(function() {
      self.container.trigger('contentChanged');
    }, 900);
  });
};

Rwiki.EditorPanel.Editor.prototype = {
  clearContent: function() {
    this.container.val('');
    this.disable();
  },

  getContent: function() {
    return this.container.val();
  },

  setContent: function(content) {
    this.container.val(content);
    this.enable();
  },

  enable: function() {
    this.enabled = true;
  },

  disable: function() {
    this.enabled = false;
  }
};
